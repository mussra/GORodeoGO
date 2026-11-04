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

const CHASE_LOOKAHEAD_SECONDS: float = .24
const CHASE_REACTION_SECONDS: float = .22
const CHASE_TURN_RATE: float = 4.0
var _chase_reaction: float = 0.0
var _chase_heading: Vector2 = Vector2.ZERO
var _chase_target: Vector2 = Vector2.ZERO
var _chase_skidding: bool = false

const PLAYER_TOUCH_RADIUS: float = 18.0
## Floor on the nerves->speed factor (see _compute_flee_speed_for_nerves) so a bull let go
## at ~0 nerves still visibly creeps away rather than freezing solid (CONTROLLED forced to
## ESCAPED via _release_any_held_peer is the one path that can hit exactly 0). Tune to 0.0
## for a literal stop instead, if that reads better in playtesting.
const CHASER_BLOCKED_SECONDS: float = 1.0  # stuck this long -> pass the baton (D036)
const CHASER_BLOCKED_PROGRESS_RATIO: float = 0.25  # moving < 25% of the intended step counts as blocked
const RELEASE_TOUCH_GRACE_SECONDS: float = 1.0
const MIN_FLEE_SPEED_FACTOR: float = 0.15
const TOW_CATCHUP_MARGIN: float = 80.0  # extra speed over the player's own while closing the leash gap
const ART_ROOT: String = "res://art/bull/"
const ANIM_NAMES: Array = ["idle", "flee_side", "flee_up", "flee_down", "flee_diag_down", "flee_diag_up", "captured", "calming", "controlled", "drinking"]

var controller: BullController
var _distraction: BullDistraction = BullDistraction.new()
var _stations: Array = []
var _distraction_target: Vector2 = Vector2.ZERO
var _release_gate: Vector2 = Vector2.ZERO
var _release_inward: float = 0.0
var _leaving_corral: bool = false
var _release_alignment_done: bool = false
var _release_delay: float = 0.0
var _player: Node2D = null
var _touching_player: bool = false
var _touch_grace_remaining: float = 0.0

## Set by Level0 when this bull is captured: higher = captured more recently (D038).
var _tow_path: Array[Vector2] = []
var _tow_last_sample: Vector2 = Vector2.ZERO

var capture_order: int = 0
var pen_number: int = 0
var _peers: Array = []
var _is_chaser: bool = false
var _random_chase: RandomChaseRoller = RandomChaseRoller.new()
var _blocked_detector: BlockedDetector = BlockedDetector.new(CHASER_BLOCKED_SECONDS, CHASER_BLOCKED_PROGRESS_RATIO)
var _delivered: bool = false  # returned to the pen: passive, like a held bull (D036)
var _last_state: BullState.State = BullState.State.SAFE

## Emitted when the designated chaser has been unable to advance for CHASER_BLOCKED_SECONDS
## (stuck behind an obstacle/bull/corner). Level0 then passes the baton to another bull (D036).
signal chaser_blocked(bull: Node2D)
signal courier_arrived(bull: Node2D)
signal courier_interrupted(bull: Node2D)
var _courier_path: Array[Vector2] = []
var _courier_active: bool = false
var _courier_blocked: float = 0.0
var _courier_best_distance: float = INF
var _effective_flee_speed: float = 0.0  ## real value set on entering ESCAPED, before first use — see _on_state_changed
var _sprite_swap: SpriteSwap
var _facing: SpriteFacing = SpriteFacing.new()  # stable sprite direction: no flicker near fences/corners

func guide_out_of_corral(gate: Vector2, inward: float, delay: float = 0.0) -> void:
	_release_delay = delay
	_release_gate = gate
	_release_inward = inward
	_leaving_corral = true
	_release_alignment_done = false

func set_distraction_stations(stations: Array) -> void:
	_stations = stations

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
	queue_redraw()
	_distraction.update(delta)
	_touch_grace_remaining = maxf(_touch_grace_remaining - delta, 0.0)
	if _player == null:
		return

	if _courier_active and controller.is_wild():
		_move_courier(delta)
		return
	match controller.current_state():
		BullState.State.ESCAPED, BullState.State.PURSUED:
			_random_chase.update(delta, _is_chaser, capture_held, chase_probability)
			if not _distraction.active():
				for station in _stations:
					if global_position.distance_to(station.global_position) <= DistractionStation.TRIGGER_RADIUS:
						if _distraction.try_start(controller.is_wild(), _is_chaser or _random_chase.is_active(), station.kind):
							_sprite_swap.set_flip_h(station.global_position.x < global_position.x)
							var side: float = 1.0 if station.global_position.x < global_position.x else -1.0
							_distraction_target = station.global_position + Vector2(side * 24, -36)
							break
			if _distraction.active():
				var offset: Vector2 = _distraction_target - global_position
				velocity = offset.normalized() * minf(80.0, offset.length() / delta) if offset.length() > 1 else Vector2.ZERO
				move_and_slide()
				_blocked_detector.reset()
				_sprite_swap.play("drinking")
				return
			if _leaving_corral and _release_delay > 0:
				_release_delay -= delta
				velocity = Vector2.ZERO
				return
			var flee_direction: Vector2 = _compute_flee_direction()
			_chase_skidding = false
			if not _leaving_corral and (_is_chaser or _random_chase.is_active()):
				_chase_reaction -= delta
				if _chase_reaction <= 0.0:
					var player_velocity: Vector2 = _player.velocity if _player is CharacterBody2D else Vector2.ZERO
					_chase_target = _player.global_position + player_velocity * CHASE_LOOKAHEAD_SECONDS
					_chase_reaction = CHASE_REACTION_SECONDS
				var desired: Vector2 = FleeSteering.compute_direction(global_position, _chase_target, true, world_bounds, obstacles, pen_rect, boundary_avoid_margin)
				if _chase_heading.is_zero_approx():
					_chase_heading = desired
				_chase_skidding = _chase_heading.dot(desired) < .75
				_chase_heading = _chase_heading.rotated(clampf(_chase_heading.angle_to(desired), -CHASE_TURN_RATE * delta, CHASE_TURN_RATE * delta))
				flee_direction = _chase_heading
			else:
				_chase_heading = Vector2.ZERO
				_chase_reaction = 0.0
			velocity = flee_direction * _effective_flee_speed
			var position_before: Vector2 = global_position
			move_and_slide()
			global_position = global_position.clamp(world_bounds.position, world_bounds.end)
			_watch_for_blocked_chaser(delta, position_before)
			_check_player_contact()
			_update_flee_animation(flee_direction, delta)
			_sprite_swap.set_motion_speed(velocity.length(), flee_speed)
		BullState.State.CAPTURED, BullState.State.CALMING:
			_apply_tow_movement()
			var disturbance: float = _compute_disturbance()
			controller.update_hold(delta, global_position.distance_to(_player.global_position), disturbance)
			_update_hold_visual()
		BullState.State.CONTROLLED:
			_apply_tow_movement()
			_update_hold_visual()
		_:
			velocity = Vector2.ZERO

## Follow the rider's travelled path, leaving a spatial leash behind, rather
## than copying velocity at an arbitrary side/front offset or cutting corners.
func _apply_tow_movement() -> void:
	var delta: float = get_physics_process_delta_time()
	var player_position: Vector2 = _player.global_position
	if _tow_path.is_empty():
		_tow_path.append(player_position)
		_tow_last_sample = player_position
	elif player_position.distance_to(_tow_last_sample) > .5:
		_tow_path.append(player_position)
		_tow_last_sample = player_position
	var remaining: float = global_position.distance_to(_tow_path[0])
	for i in range(1,_tow_path.size()):
		remaining += _tow_path[i-1].distance_to(_tow_path[i])
	var excess: float = maxf(0.0,remaining-controller.tuning().leash_distance)
	var player_speed: float = _player.velocity.length() if _player is CharacterBody2D else 0.0
	var speed: float = player_speed + minf(TOW_CATCHUP_MARGIN,excess*4)
	if player_speed < 1.0: speed = minf(controller.tuning().tow_speed,excess*8)
	var budget: float = minf(excess,speed*delta)
	var before: Vector2 = global_position
	while budget > .01 and not _tow_path.is_empty():
		var offset: Vector2 = _tow_path[0]-global_position
		if offset.length() < .1:
			if _tow_path.size() == 1: break
			_tow_path.pop_front()
			continue
		var step: Vector2 = offset.limit_length(budget)
		var collision: KinematicCollision2D = move_and_collide(step)
		budget -= step.length()
		if collision != null: break
		if offset.length() <= step.length()+.1 and _tow_path.size()>1:
			_tow_path.pop_front()
	velocity = (global_position-before)/delta

## Direction is computed by FleeSteering (Application, unit tested): away from the player,
## or toward it while this bull is the designated chaser or won its secondary chase roll.
func _compute_flee_direction() -> Vector2:
	if _leaving_corral:
		var clearance_y: float = _release_gate.y + _release_inward * 30
		if (global_position.y - _release_gate.y) * _release_inward >= 28:
			# Keep early escapees moving along the clear aisle, not back into the
			# next bull exiting. Stay above/below the goal's physical wild barrier.
			if absf(global_position.x) < 95:
				_leaving_corral = false
			else:
				return (Vector2(0, clearance_y) - global_position).normalized()
		else:
			if absf(global_position.x - _release_gate.x) < 30:
				_release_alignment_done = true
			if not _release_alignment_done:
				return Vector2(signf(_release_gate.x - global_position.x), 0)
			return Vector2(0, _release_inward)
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
		if peer_controller.is_wild() and not peer._distraction.active() and global_position.distance_to(peer.global_position) <= contact_range:
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
	if velocity.length() > 5.0:
		var direction: Array = SpriteSwap.direction_suffix(velocity)
		if _sprite_swap.play("flee_" + direction[0]):
			_sprite_swap.set_flip_h(direction[1])
			_sprite_swap.set_motion_speed(velocity.length(), flee_speed)
			modulate = Color.WHITE
			return
	var anim_name: String = _animation_name_for_state(controller.current_state())
	if _sprite_swap.play(anim_name):
		_sprite_swap.set_motion_speed(0.0, flee_speed)
		modulate = Color.WHITE
	else:
		_sprite_swap.stop_on_idle()
		modulate = Color.WHITE if _sprite_swap.has_sprite() else _color_for_nerves(controller.current_state())

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
		_sprite_swap.set_motion_speed(0.0, flee_speed)
		modulate = Color.WHITE
	else:
		_sprite_swap.stop_on_idle()
		modulate = Color.WHITE if _sprite_swap.has_sprite() else _color_for_nerves(controller.current_state())

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
	_distraction.cancel()
	if new_state == BullState.State.CAPTURED or not controller.is_held():
		_tow_path.clear()
	if controller.is_held():
		if _courier_active:
			courier_interrupted.emit(self)
		_courier_active = false
		_courier_path.clear()
		_leaving_corral = false
		_chase_heading = Vector2.ZERO
		_chase_reaction = 0.0
		_chase_skidding = false
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
		_sprite_swap.stop_on_idle()
		modulate = Color.WHITE if _sprite_swap.has_sprite() else _color_for_nerves(new_state)

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

## Readable state cues do not recolor the entire character or depend on missing art.
func _draw() -> void:
	if _courier_active:
		draw_circle(Vector2(0,-65),10,Color("b98a40"))
		draw_arc(Vector2(-2,-67),3,0,TAU,12,Color("fff2be"),2,true)
		draw_line(Vector2(0,-65),Vector2(5,-60),Color("fff2be"),2,true)
		draw_line(Vector2(3,-62),Vector2(6,-65),Color("fff2be"),2,true)
	if _chase_skidding and controller != null and controller.is_wild():
		for i in range(3):
			draw_circle(-_chase_heading * (26 + i * 12) + Vector2(0, 25), 7 - i, Color(.72, .57, .32, .45 - i * .1))
	if controller == null:
		return
	draw_set_transform(Vector2(0, 32), 0.0, Vector2(1.0, 0.32))
	draw_circle(Vector2.ZERO, 26, Color(0.15, 0.12, 0.08, 0.18))
	draw_set_transform(Vector2.ZERO)
	if controller.current_state() == BullState.State.SAFE and not _delivered and pen_number > 0:
		draw_circle(Vector2(0, -48), 10, Color("244b40"))
		draw_string(ThemeDB.fallback_font, Vector2(-7, -43), str(pen_number), HORIZONTAL_ALIGNMENT_CENTER, 14, 13, Color("fff2d2"))
	if controller.is_held() and is_instance_valid(_player):
		var color: Color = Color("74c9a0") if controller.current_state() == BullState.State.CONTROLLED else Color("eec879")
		draw_line(Vector2(0, 12), to_local(_player.global_position) + Vector2(0, 12), Color("86613e"), 3.0, true)
		draw_arc(Vector2(0, 25), 29, 0, TAU, 40, color, 2.5, true)
		if controller.current_state() != BullState.State.CONTROLLED:
			var amount: float = controller.current_nerves() / NervesValue.MAX_VALUE
			draw_line(Vector2(-25, -48), Vector2(25, -48), Color("554335"), 6, true)
			draw_line(Vector2(-25, -48), Vector2(-25 + 50 * (1.0 - amount), -48), Color("84d5a5"), 6, true)
		else:
			draw_polyline(PackedVector2Array([Vector2(-7, -47), Vector2(-1, -41), Vector2(10, -54)]), color, 3, true)
	elif _distraction.active():
		var label: String = "Bebiendo..." if _distraction.kind == "water" else "Comiendo..."
		draw_style_box(RanchTheme.box(Color("244b40"), Color("9dd5af"), 6), Rect2(-50, -73, 100, 25))
		draw_string(ThemeDB.fallback_font, Vector2(-45, -55), label, HORIZONTAL_ALIGNMENT_CENTER, 90, 13, Color("fff1d2"))
	elif _is_chaser or _random_chase.is_active():
		draw_circle(Vector2(0, -54), 10, Color("aa4535"))
		draw_line(Vector2(0, -59), Vector2(0, -54), Color("fff1d2"), 2)
		draw_circle(Vector2(0, -50), 1.5, Color("fff1d2"))

func follow_corral_track(points: PackedVector2Array) -> void:
	_courier_path.assign(points)
	_courier_best_distance=INF
	_courier_blocked=0.0
	_leaving_corral = false
	_courier_active = not _courier_path.is_empty()

func _move_courier(delta: float) -> void:
	if _release_delay > 0:
		_release_delay = maxf(0.0,_release_delay-delta)
		return
	if _courier_path.is_empty():
		_courier_active = false
		courier_arrived.emit(self)
		return
	var offset: Vector2 = _courier_path[0]-global_position
	velocity = offset.normalized()*minf(flee_speed,offset.length()/delta)
	move_and_slide()
	var remaining: float = global_position.distance_to(_courier_path[0])
	if remaining < _courier_best_distance-2.0:
		_courier_best_distance=remaining
		_courier_blocked=0.0
	else:
		_courier_blocked+=delta
	if _courier_blocked > .8:
		var detour: PackedVector2Array = _courier_detour(_courier_path[0])
		for i in range(detour.size()-1,-1,-1): _courier_path.push_front(detour[i])
		_courier_blocked=0.0
		_courier_best_distance=INF
	_update_flee_animation(offset.normalized(),delta)
	_sprite_swap.set_motion_speed(velocity.length(),flee_speed)
	if global_position.distance_to(_courier_path[0])<8:
		_courier_path.pop_front()
		_courier_best_distance=INF
	_check_player_contact()

## Small local grid detour around real walls and nearby herd bodies. It never
## changes collision masks or moves the body directly.
func _courier_detour(target: Vector2) -> PackedVector2Array:
	var grid := AStarGrid2D.new()
	grid.region=Rect2i(-30,-16,61,33)
	grid.cell_size=Vector2(16,16)
	grid.diagonal_mode=AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	grid.update()
	var start := Vector2i(roundi(global_position.x/16),roundi(global_position.y/16))
	var finish := Vector2i(roundi(target.x/16),roundi(target.y/16))
	for y in range(-16,17):
		for x in range(-30,31):
			var cell:=Vector2i(x,y)
			var at:=Vector2(cell)*16
			if cell==start or cell==finish: continue
			var query:=PhysicsShapeQueryParameters2D.new()
			query.shape=$CollisionShape2D.shape
			query.transform=Transform2D(0,at)
			query.collision_mask=collision_mask
			query.exclude=[get_rid()]
			if not get_world_2d().direct_space_state.intersect_shape(query,1).is_empty():
				grid.set_point_solid(cell,true)
	if not grid.is_in_boundsv(start) or not grid.is_in_boundsv(finish): return PackedVector2Array()
	var result: PackedVector2Array=grid.get_point_path(start,finish)
	if not result.is_empty(): result.remove_at(0)
	return result
