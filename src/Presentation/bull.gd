extends CharacterBody2D

## Presentation layer: owns transform, delegates all state/nerves rules to BullController (Application).

@export var tuning: BullTuning
@export var flee_speed: float = 180.0
@export var hit_radius: float = 28.0  # actual body size, used for stun/contact detection only
@export var capture_tolerance: float = 30.0  # extra lasso forgiveness, capture-only — independent of hit_radius
@export var boundary_avoid_margin: float = 30.0  # was 70 — too wide combined with the 1.5x steer weight meant bulls never really reached the perimeter, so a player chasing along the edge could never corner one
var world_bounds: Rect2 = Rect2(-480, -270, 960, 540)
var obstacles: Array = []  # Array of Rect2, set by Level0 — this level's obstacle layout
var pen_rect: Rect2 = Rect2()  # set by Level0 — steered around the same way as obstacles while wild
var chase_probability: float = 0.1  # set by Level0 from LevelData — see RandomChaseRoller
var capture_held: bool = false  # set by Level0 every frame — true while the player holds ≥1 capture

const PLAYER_TOUCH_RADIUS: float = 18.0
## Floor on the nerves->speed factor (see _compute_flee_speed_for_nerves) so a bull let go
## at ~0 nerves still visibly creeps away rather than freezing solid (CONTROLLED forced to
## ESCAPED via _release_any_held_peer is the one path that can hit exactly 0). Tune to 0.0
## for a literal stop instead, if that reads better in playtesting.
const CHASER_BLOCKED_SECONDS: float = 1.0  # stuck this long -> pass the baton (D036)
const CHASER_BLOCKED_PROGRESS_RATIO: float = 0.25  # moving < 25% of the intended step counts as blocked
const RELEASE_TOUCH_GRACE_SECONDS: float = 1.0
const MIN_FLEE_SPEED_FACTOR: float = 0.15
const ART_ROOT: String = "res://art/bull/"
const ANIM_NAMES: Array = ["idle", "flee_side", "flee_up", "flee_down", "flee_diag_down", "flee_diag_up", "captured", "calming", "controlled"]

var controller: BullController
var _player: Node2D = null
var _touching_player: bool = false
var _touch_grace_remaining: float = 0.0

## Set by Level0 when this bull is captured: higher = captured more recently (D038).
var capture_order: int = 0
var _peers: Array = []
var _is_chaser: bool = false
var _random_chase: RandomChaseRoller = RandomChaseRoller.new()
var _blocked_detector: BlockedDetector = BlockedDetector.new(CHASER_BLOCKED_SECONDS, CHASER_BLOCKED_PROGRESS_RATIO)
var _delivered: bool = false  # returned to the pen: passive, like a held bull (D036)
var _last_state: BullState.State = BullState.State.SAFE

## Emitted when the designated chaser has been unable to advance for CHASER_BLOCKED_SECONDS
## (stuck behind an obstacle/bull/corner). Level0 then passes the baton to another bull (D036).
signal chaser_blocked(bull: Node2D)
var _effective_flee_speed: float = 0.0  ## real value set on entering ESCAPED, before first use — see _on_state_changed
var _sprite_swap: SpriteSwap
var _facing: SpriteFacing = SpriteFacing.new()  # stable sprite direction: no flicker near fences/corners

func set_peers(peers: Array) -> void:
	_peers = peers

## "Tag" chaser designation — set externally by Level0, which guarantees exactly one wild
## bull chases the player at a time (not each bull rolling its own chance independently,
## which could leave 0 or several chasing at once with many bulls on screen).
func set_is_chaser(value: bool) -> void:
	_is_chaser = value

func _ready() -> void:
	_sprite_swap = SpriteSwap.new(self, $Polygon2D, ART_ROOT, ANIM_NAMES)

	controller = BullController.new(BullState.State.SAFE, tuning)
	controller.state_changed.connect(_on_state_changed)
	_update_collision(BullState.State.SAFE)  # correct mask from frame 1, before any transition fires _on_state_changed
	# Scripted intro is no longer auto-run here. Level0 calls begin_active() explicitly:
	# immediately for every bull on non-puzzle levels (preserves old behaviour exactly),
	# or once a pen's door opens for puzzle levels (GAMEPLAY_SPEC.md pen-puzzle mode,
	# levels 11+). A bull left un-called simply stays SAFE — inert, no fence-avoidance,
	# no threat — which is exactly the "penned" look with zero extra state needed.

## Takes a bull out of the level entirely (levels use fewer than the 10 bulls in the scene).
## Hiding is not enough: since D029 every bull collides with other bulls, so an invisible
## leftover would stay a solid wall. Layer/mask 0 makes it inert for every other body.
func deactivate() -> void:
	visible = false
	set_physics_process(false)
	collision_layer = 0
	collision_mask = 0

## Brings a SAFE bull to ESCAPED so it becomes wild. Called by Level0.
func begin_active() -> void:
	controller.go_calm()
	controller.go_alert()
	if not controller.go_escaped():
		push_warning("Bull failed to reach ESCAPED at start; check BullStateMachine transitions.")

func set_player(player: Node2D) -> void:
	_player = player

func _physics_process(delta: float) -> void:
	_touch_grace_remaining = maxf(_touch_grace_remaining - delta, 0.0)
	if _player == null:
		return

	match controller.current_state():
		BullState.State.ESCAPED, BullState.State.PURSUED:
			_random_chase.update(delta, _is_chaser, capture_held, chase_probability)
			var flee_direction: Vector2 = _compute_flee_direction()
			velocity = flee_direction * _effective_flee_speed
			var position_before: Vector2 = global_position
			move_and_slide()
			global_position = global_position.clamp(world_bounds.position, world_bounds.end)
			_watch_for_blocked_chaser(delta, position_before)
			_check_player_contact()
			_update_flee_animation(flee_direction, delta)
		BullState.State.CAPTURED, BullState.State.CALMING:
			_apply_tow_movement()
			var disturbance: float = _compute_disturbance()
			controller.update_hold(delta, global_position.distance_to(_player.global_position), disturbance)
			_update_hold_visual()
		BullState.State.CONTROLLED:
			_apply_tow_movement()
		_:
			velocity = Vector2.ZERO

## The lasso tows the bull: it follows the player at leash_distance rather than being pushed.
## Rope-break (rope_distance > max_rope_distance) is still enforced inside BullController.update_hold.
func _apply_tow_movement() -> void:
	var to_player: Vector2 = _player.global_position - global_position
	var distance: float = to_player.length()
	var leash: float = controller.tuning().leash_distance

	if distance > leash:
		velocity = to_player.normalized() * controller.tuning().tow_speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

## Direction is computed by FleeSteering (Application, unit tested): away from the player,
## or toward it while this bull is the designated chaser or won its secondary chase roll.
func _compute_flee_direction() -> Vector2:
	return FleeSteering.compute_direction(
		global_position, _player.global_position,
		_is_chaser or _random_chase.is_active(),
		world_bounds, obstacles, pen_rect, boundary_avoid_margin
	)

## "Controlled chaos" (PROMPT MAESTRO #5): a nearby wild bull raises nerves of one being calmed.
## Requires actual body overlap (hit_radius + peer's hit_radius), not just proximity — with
## many bulls on screen (up to 10), a generous radius made calming nearly impossible since
## several wild bulls were almost always "in range" at once. Direct contact is much rarer.
func _compute_disturbance() -> float:
	var count: int = 0
	for peer in _peers:
		if peer == self or not is_instance_valid(peer):
			continue
		var peer_controller: BullController = peer.controller
		if peer_controller == null:
			continue
		var contact_range: float = hit_radius + peer.hit_radius
		if peer_controller.is_wild() and global_position.distance_to(peer.global_position) <= contact_range:
			count += 1
	return float(count)

## An unroped, nervous bull stuns the player on contact (GAMEPLAY_SPEC.md #Failure feedback).
## Distance-based, independent of physics collision layers (Player/Bull never physically block
## each other — see level_0.tscn collision_layer/mask — so this is the only contact signal).
func _check_player_contact() -> void:
	if _touch_grace_remaining > 0.0:
		return  # just dropped on purpose: must not stun the player who released it (D038)
	var distance: float = global_position.distance_to(_player.global_position)
	var touch_range: float = hit_radius + PLAYER_TOUCH_RADIUS

	if distance <= touch_range:
		if not _touching_player:
			_touching_player = true
			if _player.has_method("stun"):
				_player.stun(controller.tuning().stun_duration_seconds)
			_release_any_held_peer()
	else:
		_touching_player = false

## Colliding with a wild bull makes the player drop whatever they were towing.
func _release_any_held_peer() -> void:
	for peer in _peers:
		if peer == self or not is_instance_valid(peer):
			continue
		var peer_controller: BullController = peer.controller
		if peer_controller == null:
			continue
		if peer_controller.is_held():
			peer_controller.force_escape()

## The player deliberately drops this bull (double tap on the aim stick, D038). Same transition as
## being forced to drop it (back to ESCAPED, keeping its nerves — D027), plus a short grace so the
## bull, which is only a leash length away, can't stun the player who just let it go.
func release_by_player() -> bool:
	if not controller.force_escape():
		return false
	_touch_grace_remaining = RELEASE_TOUCH_GRACE_SECONDS
	return true

## Called by Level0 in response to Player's lasso_thrown(landing_point).
## Capture uses hit_radius + capture_tolerance (lasso forgiveness) — deliberately larger
## than hit_radius alone, which is reserved for stun/contact detection (_check_player_contact).
func try_capture(landing_point: Vector2) -> bool:
	var attempt := CaptureAttempt.new(landing_point, global_position, hit_radius + capture_tolerance)
	return controller.attempt_capture(attempt)

## Nerves change every physics frame while CALMING (BullController.update_hold), so the
## gradual-color requirement needs a per-frame refresh here too, not just on state_changed —
## otherwise the color would only ever update at the CAPTURED->CALMING->CONTROLLED
## boundaries, which is exactly the "indistinguishable until fully done" problem this
## feature exists to fix.
func _update_hold_visual() -> void:
	var anim_name: String = _animation_name_for_state(controller.current_state())
	if _sprite_swap.play(anim_name):
		modulate = Color.WHITE
	else:
		modulate = _color_for_nerves(controller.current_state())

## Flee direction changes continuously while still in the same ESCAPED/PURSUED state, so
## this runs every physics frame rather than only reacting to state_changed.
##
## Fed with the INTENDED flee direction (not the post-move_and_slide velocity, which the fence
## bends every frame) and filtered by SpriteFacing (hysteresis + minimum hold), so a bull
## pinned against a wall or corner no longer flickers between direction animations.
func _update_flee_animation(flee_direction: Vector2, delta: float) -> void:
	if flee_direction == Vector2.ZERO:
		return
	var dir_info: Array = SpriteSwap.direction_suffix(_facing.update(flee_direction, delta))
	if _sprite_swap.play("flee_" + dir_info[0]):
		_sprite_swap.set_flip_h(dir_info[1])
		modulate = Color.WHITE
	else:
		modulate = _color_for_nerves(controller.current_state())

## Requirement: a bull that broke free at low nerves (almost calm, or fully CONTROLLED —
## see _release_any_held_peer's force_escape) should flee slower, so it's easier to tell
## apart from a fresh, fully wild bull and easier to recapture. At full nerves (the normal
## first-release case, and the only case before this feature existed) this is exactly
## flee_speed — unchanged max speed, as required. MIN_FLEE_SPEED_FACTOR floors it above
## zero so a ~0-nerves escapee still visibly creeps rather than freezing solid.
func _compute_flee_speed_for_nerves() -> float:
	var nerves_fraction: float = controller.current_nerves() / NervesValue.MAX_VALUE
	return flee_speed * max(nerves_fraction, MIN_FLEE_SPEED_FACTOR)

func _on_state_changed(new_state: BullState.State) -> void:
	_delivered = new_state == BullState.State.SAFE and _last_state == BullState.State.CONTROLLED
	_last_state = new_state
	if new_state == BullState.State.ESCAPED:
		_random_chase.reset()
		_facing.reset()
		_effective_flee_speed = _compute_flee_speed_for_nerves()
	_update_collision(new_state)
	var anim_name: String = _animation_name_for_state(new_state)
	if _sprite_swap.play(anim_name):
		modulate = Color.WHITE  # real art is showing the state, no need to color-code too
	else:
		modulate = _color_for_nerves(new_state)  # no art yet: fall back to the colored box

## Collision setup per state. A wild bull physically can't enter/cross the pen (it used to
## cut through and steal the player's bull via _release_any_held_peer — D013), so wild bulls
## get the PEN_BARRIER bit; held bulls need to reach the pen, so they don't.
## D036: a bull that is held, or already delivered to the pen, lives on BULL_PASSIVE and
## ignores other bulls entirely — otherwise delivered bulls filled the pen and later bulls
## could not get in (level 20 became impossible). Every other bull (SAFE-at-start, wild)
## stays on BULL and keeps D029's "bulls never overlap".
func _update_collision(state: BullState.State) -> void:
	if controller.is_held() or _delivered:
		collision_layer = CollisionLayers.BULL_PASSIVE
		collision_mask = CollisionLayers.FENCE
		return
	collision_layer = CollisionLayers.BULL
	var mask: int = CollisionLayers.FENCE | CollisionLayers.BULL
	if state != BullState.State.SAFE:
		mask |= CollisionLayers.PEN_BARRIER
	collision_mask = mask

## Reports chaser_blocked once the designated chaser has made (almost) no progress for a while.
## Only the designated chaser is watched: a fleeing bull stuck in a corner is not a problem.
func _watch_for_blocked_chaser(delta: float, position_before: Vector2) -> void:
	if not _is_chaser:
		_blocked_detector.reset()
		return
	var moved: float = global_position.distance_to(position_before)
	if _blocked_detector.update(delta, _effective_flee_speed * delta, moved):
		chaser_blocked.emit(self)

func _animation_name_for_state(state: BullState.State) -> String:
	match state:
		BullState.State.CAPTURED:
			return "captured"
		BullState.State.CALMING:
			return "calming"
		BullState.State.CONTROLLED:
			return "controlled"
		_:
			return "idle"  # ESCAPED/PURSUED handled per-frame by _update_flee_animation instead

## Requirement: color must show HOW nervous a bull currently is, gradually, not just which
## discrete state it's in — a bull released at low nerves (see _compute_flee_speed_for_nerves)
## must look visibly calmer than a fresh, fully wild one, not just "indistinguishable orange"
## like every other loose bull. Only SAFE is special-cased (never released yet, no meaningful
## nerves reading yet); every other state uses the gradient. CALM/ALERT aren't special-cased
## but are never actually rendered — begin_active() steps through them synchronously in one
## call, before any frame draws, so only their eventual ESCAPED color is ever visible.
## Endpoints reuse the project's existing thematic colors: LIGHT_GREEN was CONTROLLED's fixed
## color, ORANGE_RED was ESCAPED's — same look at nerves 0 / 100 as before, gradual between.
const CALM_TINT: Color = Color.LIGHT_GREEN
const AGITATED_TINT: Color = Color.ORANGE_RED

func _color_for_nerves(state: BullState.State) -> Color:
	if state == BullState.State.SAFE:
		return Color.WHITE
	var nerves_fraction: float = controller.current_nerves() / NervesValue.MAX_VALUE
	return CALM_TINT.lerp(AGITATED_TINT, nerves_fraction)
