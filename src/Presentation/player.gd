extends CharacterBody2D

## Arcade-style movement (GAMEPLAY_SPEC.md #Movement) + charge/release lasso throw.
## Presentation layer: owns transform/input, delegates gameplay rules to BullController via signal.
##
## Lasso feel: hold throw_lasso to charge (the rope visibly extends toward aim_direction);
## release to drop it at the current charged distance. Landing point is what CaptureResolver
## checks against — overshoot or undershoot both miss (GAMEPLAY_SPEC.md #Capture).

signal lasso_thrown(throw_origin: Vector2, landing_point: Vector2)
## Double tap on the aim stick: the player wants to drop a captured bull (D038). Level0 decides which.
signal lasso_released
signal stunned
signal release_requested
signal prey_captured(prey)
## The player tried to throw with every lasso slot occupied (Ant, 4-nov: no lanzar sin hueco).
## Level0 surfaces it as a HUD hint; the throw itself is simply refused.
signal throw_blocked
signal dodge_drawing_started
signal dodge_drawing_finished
signal dodge_started
signal dodge_finished
signal jump_started
signal jump_finished
var can_jump:bool=false
var _jump_time:float=0.0
var _jump_direction:Vector2=Vector2.RIGHT
var _jump_mask:int=0
var _jump_from:Vector2
var _jump_sprite_base:Vector2
var _jump_cooldown:float=0.0

var jump_recovery_multiplier:float=1.0

## The dodge/regate lives in the shared DodgeController (same component the open
## world uses); these forwards keep the existing names/tests working.
const DODGE_RECHARGE_SECONDS: float = 2.5  # provisional feel setting, preview before APK
const DODGE_SECONDS: float = DodgeController.DODGE_SECONDS
const DODGE_SPEED_FACTOR: float = DodgeController.DODGE_SPEED_FACTOR
const DODGE_COAST_SECONDS: float = DodgeController.DODGE_COAST_SECONDS
const DODGE_COAST_SPEED_FACTOR: float = DodgeController.DODGE_COAST_SPEED_FACTOR
const MOVE_REPRESS_WINDOW_SECONDS: float = DodgeController.MOVE_REPRESS_WINDOW_SECONDS
const DRAW_TIME_SCALE: float = DodgeController.DRAW_TIME_SCALE
const DRAW_EDGE_MARGIN: float = DodgeController.DRAW_EDGE_MARGIN
const DRAW_EDGE_SPEED: float = DodgeController.DRAW_EDGE_SPEED
const DRAW_EDGE_DWELL: float = DodgeController.DRAW_EDGE_DWELL
var dodge: DodgeController = null
var dodge_recharge_seconds: float:
	get: return 2.5 if dodge == null else dodge.recharge_seconds
	set(v): if dodge != null: dodge.recharge_seconds = v
var dodge_available: bool:
	get: return true if dodge == null else dodge.available
	set(v): if dodge != null: dodge.available = v
var dodge_path_limit: float:
	get: return 260.0 if dodge == null else dodge.path_limit
	set(v): if dodge != null: dodge.path_limit = v
var _dodge_cooldown: float:
	get: return 0.0 if dodge == null else dodge.cooldown
	set(v): if dodge != null: dodge.cooldown = v
var _dodge_coast_remaining: float:
	get: return 0.0 if dodge == null else dodge.coast_remaining
	set(v): if dodge != null: dodge.coast_remaining = v
var _drawing_dodge: bool:
	get: return false if dodge == null else dodge.drawing
	set(v): if dodge != null: dodge.drawing = v
var _drawing_real_started: float:
	get: return 0.0 if dodge == null else dodge.drawing_real_started
	set(v): if dodge != null: dodge.drawing_real_started = v
var _draw_points: PackedVector2Array:
	get: return PackedVector2Array() if dodge == null else dodge.draw_points
	set(v): if dodge != null: dodge.draw_points = v
var _dodge_path: Array[Vector2]:
	get: return [] if dodge == null else dodge.path
	set(v): if dodge != null: dodge.path = v
var _dodge_remaining: float:
	get: return 0.0 if dodge == null else dodge.remaining
	set(v): if dodge != null: dodge.remaining = v
var _dodge_direction: Vector2:
	get: return Vector2.ZERO if dodge == null else dodge.direction
	set(v): if dodge != null: dodge.direction = v
var _run_after_dodge: Vector2:
	get: return Vector2.ZERO if dodge == null else dodge.run_after_dodge
	set(v): if dodge != null: dodge.run_after_dodge = v
var _skid_trail: Array[Vector2]:
	get: return [] if dodge == null else dodge.skid_trail
	set(v): if dodge != null: dodge.skid_trail = v
var _trail_fade: float:
	get: return 0.0 if dodge == null else dodge.trail_fade
	set(v): if dodge != null: dodge.trail_fade = v
var _draw_screen_start: Vector2:
	get: return Vector2.ZERO if dodge == null else dodge.draw_screen_start
	set(v): if dodge != null: dodge.draw_screen_start = v
var _draw_virtual: Vector2:
	get: return Vector2.ZERO if dodge == null else dodge.draw_virtual
	set(v): if dodge != null: dodge.draw_virtual = v
var _draw_heading: Vector2:
	get: return Vector2.ZERO if dodge == null else dodge.draw_heading
	set(v): if dodge != null: dodge.draw_heading = v
var _draw_edge_elapsed: float:
	get: return 0.0 if dodge == null else dodge.draw_edge_elapsed
	set(v): if dodge != null: dodge.draw_edge_elapsed = v
var _draw_edge_active: bool:
	get: return false if dodge == null else dodge.draw_edge_active
	set(v): if dodge != null: dodge.draw_edge_active = v
var _draw_pointer_previous: Vector2:
	get: return Vector2.ZERO if dodge == null else dodge.draw_pointer_previous
	set(v): if dodge != null: dodge.draw_pointer_previous = v
var _last_pointer: Vector2:
	get: return Vector2.ZERO if dodge == null else dodge.last_pointer
	set(v): if dodge != null: dodge.last_pointer = v
var _last_touch_index: int:
	get: return -1 if dodge == null else dodge.last_touch_index
	set(v): if dodge != null: dodge.last_touch_index = v
var _move_pressed_at: float:
	get: return 0.0 if dodge == null else dodge.move_pressed_at
	set(v): if dodge != null: dodge.move_pressed_at = v
var _running_release_at: float:
	get: return -INF if dodge == null else dodge.running_release_at
	set(v): if dodge != null: dodge.running_release_at = v

const ART_ROOT: String = "res://art/player/"
const ANIM_NAMES: Array = ["idle", "walk_side", "walk_up", "walk_down", "walk_diag_down", "walk_diag_up", "stunned", "jump_side", "jump_up", "jump_down", "jump_diag_down", "jump_diag_up"]

@export var max_speed: float = 260.0
@export var acceleration: float = 900.0
@export var friction: float = 700.0
@export var max_throw_distance: float = 220.0:
	set(v):
		max_throw_distance = v
		if lasso != null: lasso.max_throw_distance = v
@export var charge_speed: float = 300.0:  # units/sec the lasso reaches out while charging (keyboard fallback)
	set(v):
		charge_speed = v
		if lasso != null: lasso.charge_speed = v
@export var lasso_travel_time: float = .8:  # seconds between release and actual capture resolution
	set(v):
		lasso_travel_time = v
		if lasso != null: lasso.lasso_travel_time = v
@export var stun_resistance_multiplier: float = 1.0  # applied to incoming stun duration; upgrade lowers this
@export var dual_capture_speed_multiplier: float = 0.6  # applied to max_speed while towing 2+ bulls at once (Level 10 unlock)
@export var capture_area_visual_radius: float = 58.0:  # visual only — roughly matches a bull's hit_radius + capture_tolerance defaults; not read from any specific bull, since which bull (if any) gets hit isn't known until resolution
	set(v):
		capture_area_visual_radius = v
		if lasso != null: lasso.capture_area_visual_radius = v

var lasso: LassoController = null
var aim_direction: Vector2 = Vector2.RIGHT:
	set(v):
		aim_direction = v
		if lasso != null: lasso.aim_direction = v
var world_bounds: Rect2 = Rect2(-480, -270, 960, 540)
var _stun_time_remaining: float = 0.0
var _sprite_swap: SpriteSwap
var _active_capture_count: int = 0
var _max_captures: int = 1

func _ready() -> void:
	_sprite_swap = SpriteSwap.new(self, $Polygon2D, HatAppearance.art_root(SaveData.hat_color), ANIM_NAMES)
	if _sprite_swap.has_sprite():
		var horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
		if not horse.is_empty():HorseAppearance.apply(_sprite_swap._frames,horse.traits)
		PixelLabTrial.apply(_sprite_swap._frames,"rider","walk_side",horse.get("traits",{}))
	var cue_layer:=CanvasLayer.new()
	cue_layer.layer=16
	add_child(cue_layer)
	lasso = LassoController.new()
	lasso.max_throw_distance = max_throw_distance
	lasso.charge_speed = charge_speed
	lasso.lasso_travel_time = lasso_travel_time
	lasso.capture_area_visual_radius = capture_area_visual_radius
	lasso.aim_direction = aim_direction
	lasso.throw_guard = func() -> bool: return _jump_time <= 0 and _stun_time_remaining <= 0.0 and is_physics_processing()
	lasso.rope_parent = func() -> Node: return get_parent()
	lasso.lasso_released.connect(func(): lasso_released.emit())
	lasso.lasso_thrown.connect(func(o: Vector2, l: Vector2): lasso_thrown.emit(o, l))
	lasso.prey_captured.connect(func(prey: Node2D): prey_captured.emit(prey))
	lasso.throw_blocked.connect(func(): throw_blocked.emit())
	lasso.release_requested.connect(func(): release_requested.emit())
	dodge = DodgeController.new()
	dodge.owner_body = self
	dodge.can_start = func() -> bool: return _jump_time <= 0 and _stun_time_remaining <= 0.0
	dodge.speed_scale = func() -> float: return dual_capture_speed_multiplier if _active_capture_count >= 2 else 1.0
	dodge.moving_with_input = func() -> bool: return velocity.length() > 1.0 and _stun_time_remaining <= 0.0
	dodge.resumed = func(dir: Vector2) -> void: _resume_running_after_dodge(dir)
	dodge.on_moved = func() -> void: _on_dodge_moved()
	dodge.drawing_started.connect(func(): dodge_drawing_started.emit())
	dodge.drawing_finished.connect(func(): dodge_drawing_finished.emit())
	dodge.dodge_started.connect(func(): dodge_started.emit())
	dodge.dodge_finished.connect(func(): dodge_finished.emit())
	add_child(dodge)
	add_child(lasso)
	var cue:=DodgeEdgeCue.new()
	cue.player=self
	cue_layer.add_child(cue)

## Called every frame by Level0 — how many bulls this player currently has captured/calming/
## controlled, so movement speed can be penalized while towing more than one (per design:
## a stronger horse trades speed for pulling two at once).
func set_active_capture_count(count: int) -> void:
	_active_capture_count = count
	if lasso != null: lasso.set_active_capture_count(count)

## Called once by Level0 after applying unlocks: how many bulls may be held at once —
## 1 normally, 2 with the dual lasso (PlayerUpgrades.max_simultaneous_captures).
func set_max_captures(value: int) -> void:
	_max_captures = maxi(1, value)
	if lasso != null: lasso.set_max_captures(value)

## A throw is only possible with a free slot: full hands mean releasing first
## (double tap on the aim stick, D038) before throwing again.
func _has_free_lasso_slot() -> bool:
	return lasso.has_free_lasso_slot()

## Wires the aim/throw stick (Godot 4.7 native VirtualJoystick, JOYSTICK_FOLLOWING mode —
## appears where touched and its base follows the finger, so you never have to drag back
## from far away to shorten the throw or change direction; D037). Movement needs no wiring at all: the
## movement VirtualJoystick feeds the same move_left/right/up/down actions keyboard
## already uses, so Input.get_vector picks it up automatically either way.
func set_aim_joystick(aim_joystick: VirtualJoystick) -> void:
	lasso.set_aim_joystick(aim_joystick)

## Movement and lasso gestures have independent detectors.
func set_move_joystick(stick: VirtualJoystick) -> void:
	dodge.set_move_joystick(stick)

func _on_move_pressed() -> void:
	dodge.on_move_pressed()

func _input(event: InputEvent) -> void:
	dodge.handle_input(event)

func _append_draw_point() -> void:
	dodge.append_draw_point()

func _extend_drawing_at_edge(real_delta: float) -> void:
	dodge.extend_drawing_at_edge(real_delta)

func _on_move_released(direction: Vector2) -> void:
	dodge.on_move_released(direction)

func request_dodge_path(points: PackedVector2Array) -> bool:
	return dodge.request_path(points)

func request_dodge(direction: Vector2) -> bool:
	return dodge.request_dash(direction)


## Two quick taps (press+release near the centre) emit release_requested instead (D038).
## Releasing with the stick (almost) back at its centre CANCELS the throw instead of dropping
## the lasso at the player's feet (D037, LassoAim.is_cancel).
##
## input_vector is the joystick's own final drag vector at the exact moment of release —
## using it directly (instead of the last value polled in _physics_process) avoids a
## one-frame staleness that was making the landing point slightly off from where you
## actually released, especially noticeable on fast drags.

## Called by an unroped, nervous bull on contact (GAMEPLAY_SPEC.md #Failure feedback).
func stun(duration: float) -> void:
	if _jump_time>0:_finish_jump(true)
	if _stun_time_remaining <= 0.0:
		stunned.emit()
	_stun_time_remaining = max(_stun_time_remaining, duration * stun_resistance_multiplier)
	if not _sprite_swap.play("stunned"):
		modulate = Color(1.0, 0.5, 0.5, 1.0)  # no art yet: fall back to a red tint
	cancel_input()

func _physics_process(delta: float) -> void:
	dodge.world_bounds = world_bounds
	# Ground trail keeps fading even while jump/stun branches return early.
	if dodge.fade_trail(delta):
		queue_redraw()
	_jump_cooldown=maxf(0,_jump_cooldown-delta)
	if _jump_time>0:
		_process_jump(delta);return
	if can_jump and velocity.length()>60 and _try_fence_ahead():return
	_dodge_cooldown = maxf(0.0, _dodge_cooldown - delta)
	if _stun_time_remaining > 0.0:
		_stun_time_remaining -= delta
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		move_and_slide()
		global_position = global_position.clamp(world_bounds.position, world_bounds.end)
		if _stun_time_remaining <= 0.0:
			modulate = Color.WHITE
		return

	# Dodge branches run in the shared DodgeController (same code as the world).
	if dodge.drawing:
		dodge.process_drawing(delta/maxf(Engine.time_scale,.01))
		return
	if dodge.step_path(max_speed, delta):
		return
	if dodge.step_coast(max_speed, delta):
		return
	if dodge.step_dash(max_speed, delta):
		return

	queue_redraw()
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var is_moving: bool = input_dir.length() > 0.0

	if is_moving:
		var target_speed: float = max_speed
		if _active_capture_count >= 2:
			target_speed *= dual_capture_speed_multiplier
		velocity = velocity.move_toward(input_dir.normalized() * target_speed, acceleration * delta)
		if not lasso.is_charging():
			aim_direction = input_dir.normalized()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	if is_moving:
		var dir_info: Array = SpriteSwap.direction_suffix(input_dir)
		_sprite_swap.play("walk_" + dir_info[0])
		_sprite_swap.set_flip_h(dir_info[1])
	else:
		_sprite_swap.play("idle")

	move_and_slide()
	_sprite_swap.set_motion_speed(velocity.length(), 260.0)
	global_position = global_position.clamp(world_bounds.position, world_bounds.end)

	if Input.is_action_just_pressed("release_capture"):
		release_requested.emit()
	_process_throw_input(delta)

## Called by the DodgeController when a traced path or dash ends cleanly
## (no argument = keep the controller's current dodge direction).
func _resume_running_after_dodge(dir: Vector2 = Vector2.INF) -> void:
	if dir == Vector2.INF:
		dir = dodge.direction
	# Keep the endpoint tangent, never replace it with fresh input or automatic cruise.
	# Normal acceleration/friction controls braking and turning from the next frame.
	_run_after_dodge = Vector2.ZERO
	var speed: float = max_speed * (dual_capture_speed_multiplier if _active_capture_count >= 2 else 1.0)
	velocity = dir * speed

## Called by the DodgeController after each dodge step: sprite facing + redraw.
func _on_dodge_moved() -> void:
	var facing: Array = SpriteSwap.direction_suffix(velocity if not velocity.is_zero_approx() else dodge.direction)
	_sprite_swap.play("walk_" + facing[0])
	_sprite_swap.set_flip_h(facing[1])
	_sprite_swap.set_motion_speed(velocity.length(), 260.0)
	queue_redraw()

func _process_throw_input(delta: float) -> void:
	lasso.process_throw_input(delta)

func _now_seconds() -> float:
	return Time.get_ticks_msec() / 1000.0



## [param final_vector]: when the aim stick provides its exact release vector, use it
## directly (fixes the one-frame staleness noted above). Empty/zero means "use whatever
## aim_direction/_charge_distance were last set" — the keyboard/mouse fallback path.

func cancel_all_actions() -> void:
	if _jump_time>0:_finish_jump(true)
	cancel_input()
	lasso.cancel_all_actions()

func cancel_input() -> void:
	dodge.cancel()
	lasso.cancel_input()
	velocity = Vector2.ZERO

## Animates a line from throw_origin to landing_point over lasso_travel_time, in world
## space: landing stays fixed, rope origin follows the moving rider.

## Shows the lasso's effective capture area as a translucent circle where it lands, fading out.


## Ring matches the forgiving capture area, not the bull's collision shape.
func _draw() -> void:
	# Dodge visuals are the shared DodgeVisuals (same drawing as the world rider).
	DodgeVisuals.draw_trail(self, _skid_trail, _trail_fade)
	if _drawing_dodge:
		DodgeVisuals.draw_drawing(self, dodge_preview_points(_draw_points))
	if dodge_available:
		DodgeVisuals.draw_recharge(self, _overhead_bar_anchor(), 1.0 - _dodge_cooldown / dodge_recharge_seconds)
	if _dodge_remaining > 0.0:
		DodgeVisuals.draw_dash_dust(self, _dodge_direction)
	draw_set_transform(Vector2(0, 33), 0.0, Vector2(1.0, 0.3))
	draw_circle(Vector2.ZERO, 27, Color(0.15, 0.12, 0.08, 0.2))
	draw_set_transform(Vector2.ZERO)
	# Charge-aim circle: shared with the world rider (LassoController).
	lasso.draw_charge_aim(self)

func _exit_tree() -> void:
	Engine.time_scale = 1.0

## One projection shared by drawing and execution: never show unscaled reach.
func dodge_preview_points(points: PackedVector2Array) -> PackedVector2Array:
	return dodge.preview_points(points)

# Auto-jump only over explicitly marked internal fences. Perimeter and rocks stay solid.
func _try_fence_ahead()->bool:
	if _jump_cooldown>0 or _stun_time_remaining>0 or _drawing_dodge:return false
	var direction:Vector2=velocity.normalized()
	var ray:=PhysicsRayQueryParameters2D.create(global_position,global_position+direction*62,32,[get_rid()])
	var hit:Dictionary=get_world_2d().direct_space_state.intersect_ray(ray)
	if hit.is_empty():return false
	return request_jump(direction)
func request_jump(direction:Vector2)->bool:
	if not can_jump or _jump_time>0 or _jump_cooldown>0 or _stun_time_remaining>0 or direction.length()<.2:return false
	var landing:Vector2=global_position+direction.normalized()*HorseJump.DISTANCE
	if not world_bounds.grow(-28).has_point(landing):return false
	var query:=PhysicsShapeQueryParameters2D.new();query.shape=$CollisionShape2D.shape;query.collision_mask=collision_mask;query.exclude=[get_rid()];query.transform=Transform2D(0,landing)
	if not get_world_2d().direct_space_state.intersect_shape(query,1).is_empty():return false
	# The whole corridor must be clear of solid non-jumpable objects.
	query.collision_mask=collision_mask & ~32
	for i in range(1,9):
		query.transform=Transform2D(0,global_position.lerp(landing,float(i)/8))
		if not get_world_2d().direct_space_state.intersect_shape(query,1).is_empty():return false
	_jump_direction=direction.normalized();_jump_from=global_position;_jump_time=HorseJump.DURATION;_jump_mask=collision_mask;collision_mask&=~32;_jump_cooldown=1.2*jump_recovery_multiplier
	cancel_input();_jump_time=HorseJump.DURATION
	if _sprite_swap.has_sprite():_jump_sprite_base=_sprite_swap._sprite.position
	jump_started.emit();return true
func _overhead_bar_anchor()->Vector2:
	var lift:float=0.0
	if _jump_time>0 and _sprite_swap.has_sprite():lift=_sprite_swap._sprite.position.y-_jump_sprite_base.y
	return Vector2(0,-59+lift)
func _process_jump(delta:float)->void:
	_jump_time=maxf(0,_jump_time-delta);var t:float=1-_jump_time/HorseJump.DURATION
	velocity=_jump_direction*HorseJump.DISTANCE/HorseJump.DURATION
	var hit:=move_and_collide(velocity*delta)
	var info:Array=SpriteSwap.direction_suffix(_jump_direction)
	if _sprite_swap.has_sprite():
		_sprite_swap.play("jump_"+info[0]);_sprite_swap.set_flip_h(info[1])
		_sprite_swap._sprite.pause();_sprite_swap._sprite.frame=mini(7,int(t*8))
		# Frame animation keeps the gallop articulate. Separate squash, suspension and landing.
		var sprite:AnimatedSprite2D=_sprite_swap._sprite
		sprite.position=_jump_sprite_base+Vector2(0,-HorseJump.arc(t));sprite.scale=Vector2(1+.08*sin(PI*t),1-.08*sin(PI*t))
	queue_redraw()
	if hit!=null:_jump_time=0
	if _jump_time<=0:
		_finish_jump(false)
func _finish_jump(interrupted:bool)->void:
	_jump_time=0
	collision_mask=_jump_mask
	if interrupted or test_move(global_transform,Vector2.ZERO):global_position=_jump_from
	if _sprite_swap.has_sprite():
		_sprite_swap._sprite.position=_jump_sprite_base
		_sprite_swap._sprite.scale=Vector2.ONE
	velocity=Vector2.ZERO
	jump_finished.emit()
	queue_redraw()
