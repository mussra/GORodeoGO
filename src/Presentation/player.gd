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
## The player tried to throw with every lasso slot occupied (Ant, 4-nov: no lanzar sin hueco).
## Level0 surfaces it as a HUD hint; the throw itself is simply refused.
signal throw_blocked
signal dodge_drawing_started
signal dodge_drawing_finished
signal dodge_started
signal dodge_finished

const DODGE_RECHARGE_SECONDS: float = 2.5  # provisional feel setting, preview before APK
var _dodge_cooldown: float = 0.0

const DODGE_SECONDS: float = .18
const DODGE_SPEED_FACTOR: float = 2.2
const DODGE_COAST_SECONDS: float = .18  # short soft stop, preview tuning
const DODGE_COAST_SPEED_FACTOR: float = .8
var _dodge_coast_remaining: float = 0.0
var _move_tap: DoubleTapDetector = DoubleTapDetector.new(.3)
const DRAW_TIME_SCALE: float = .24
var _run_after_dodge: Vector2 = Vector2.ZERO
var dodge_available: bool = true
var dodge_path_limit: float = 260.0
var _drawing_real_started: float = 0.0
var _drawing_dodge: bool = false
var _draw_screen_start: Vector2 = Vector2.ZERO
var _draw_pointer_previous:Vector2=Vector2.ZERO
var _draw_virtual:Vector2=Vector2.ZERO
var _draw_heading:Vector2=Vector2.ZERO
const DRAW_EDGE_MARGIN:float=28.0
const DRAW_EDGE_SPEED:float=300.0
const DRAW_EDGE_DWELL:float=.18
var _draw_edge_elapsed:float=0.0
var _draw_edge_active:bool=false
var _last_touch_index: int = -1
var _draw_touch_index: int = -1
var _skid_trail: Array[Vector2] = []
var _trail_fade: float = 0.0
var _last_pointer: Vector2 = Vector2.ZERO
var _draw_points: PackedVector2Array = PackedVector2Array()
var _dodge_path: Array[Vector2] = []
var _move_pressed_at: float = 0.0
var _dodge_remaining: float = 0.0
var _dodge_direction: Vector2 = Vector2.ZERO

const ART_ROOT: String = "res://art/player/"
const ANIM_NAMES: Array = ["idle", "walk_side", "walk_up", "walk_down", "walk_diag_down", "walk_diag_up", "stunned"]

@export var max_speed: float = 260.0
@export var acceleration: float = 900.0
@export var friction: float = 700.0
@export var max_throw_distance: float = 220.0
@export var charge_speed: float = 300.0  # units/sec the lasso reaches out while charging (keyboard fallback)
@export var lasso_travel_time: float = .8  # seconds between release and actual capture resolution
@export var stun_resistance_multiplier: float = 1.0  # applied to incoming stun duration; upgrade lowers this
@export var dual_capture_speed_multiplier: float = 0.6  # applied to max_speed while towing 2+ bulls at once (Level 10 unlock)
@export var capture_area_visual_radius: float = 58.0  # visual only — roughly matches a bull's hit_radius + capture_tolerance defaults; not read from any specific bull, since which bull (if any) gets hit isn't known until resolution

var aim_direction: Vector2 = Vector2.RIGHT
var world_bounds: Rect2 = Rect2(-480, -270, 960, 540)
var _stun_time_remaining: float = 0.0
var _is_charging: bool = false
var _lasso_in_flight: bool = false
var _flight_generation: int = 0
var _flight_line: Node2D = null
var _flight_tween: Tween = null
var _aim_pressed_at_seconds: float = 0.0
var _double_tap: DoubleTapDetector = DoubleTapDetector.new(LassoAim.DOUBLE_TAP_WINDOW_SECONDS)
var _charge_distance: float = 0.0
var _charge_visual: Line2D = null
var _sprite_swap: SpriteSwap
var _active_capture_count: int = 0
var _max_captures: int = 1
var _touch_aim_active: bool = false

func _ready() -> void:
	_sprite_swap = SpriteSwap.new(self, $Polygon2D, HatAppearance.art_root(SaveData.hat_color), ANIM_NAMES)
	if _sprite_swap.has_sprite():
		var horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
		if not horse.is_empty():HorseAppearance.apply(_sprite_swap._frames,horse.traits)
	var cue_layer:=CanvasLayer.new()
	cue_layer.layer=16
	add_child(cue_layer)
	var cue:=DodgeEdgeCue.new()
	cue.player=self
	cue_layer.add_child(cue)

## Called every frame by Level0 — how many bulls this player currently has captured/calming/
## controlled, so movement speed can be penalized while towing more than one (per design:
## a stronger horse trades speed for pulling two at once).
func set_active_capture_count(count: int) -> void:
	_active_capture_count = count

## Called once by Level0 after applying unlocks: how many bulls may be held at once —
## 1 normally, 2 with the dual lasso (PlayerUpgrades.max_simultaneous_captures).
func set_max_captures(value: int) -> void:
	_max_captures = maxi(1, value)

## A throw is only possible with a free slot: full hands mean releasing first
## (double tap on the aim stick, D038) before throwing again.
func _has_free_lasso_slot() -> bool:
	return _active_capture_count < _max_captures

## Wires the aim/throw stick (Godot 4.7 native VirtualJoystick, JOYSTICK_FOLLOWING mode —
## appears where touched and its base follows the finger, so you never have to drag back
## from far away to shorten the throw or change direction; D037). Movement needs no wiring at all: the
## movement VirtualJoystick feeds the same move_left/right/up/down actions keyboard
## already uses, so Input.get_vector picks it up automatically either way.
func set_aim_joystick(aim_joystick: VirtualJoystick) -> void:
	aim_joystick.pressed.connect(_on_aim_pressed)
	aim_joystick.released.connect(_on_aim_released)

## Movement and lasso gestures have independent detectors.
func set_move_joystick(stick: VirtualJoystick) -> void:
	stick.pressed.connect(_on_move_pressed)
	stick.released.connect(_on_move_released)

func _on_move_pressed() -> void:
	_move_pressed_at = _now_seconds()
	if dodge_available and _move_tap.register_tap(_move_pressed_at) and _dodge_cooldown <= 0.0 and _stun_time_remaining <= 0.0:
		_drawing_dodge = true
		_drawing_real_started = _now_seconds()
		Engine.time_scale = DRAW_TIME_SCALE
		dodge_drawing_started.emit()
		_draw_touch_index = _last_touch_index
		_draw_screen_start = _last_pointer
		_draw_pointer_previous=_last_pointer
		_draw_virtual=Vector2.ZERO
		_draw_heading=Vector2.ZERO
		_draw_edge_elapsed=0.0
		_draw_edge_active=false
		_draw_points = PackedVector2Array([Vector2.ZERO])
		velocity = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		_last_pointer = event.position
		_last_touch_index = event.index
	elif event is InputEventScreenDrag:
		if _drawing_dodge and event.index == _draw_touch_index:
			_last_pointer=event.position
			var zoom:float=get_viewport().get_camera_2d().zoom.x if get_viewport().get_camera_2d()!=null else 1.0
			var delta:Vector2=event.position-_draw_pointer_previous
			_draw_pointer_previous=event.position
			if delta.length()>1:_draw_heading=delta.normalized()
			_draw_virtual+=delta/zoom
			_append_draw_point()

func _append_draw_point()->void:
	if _draw_points.is_empty():return
	if _draw_points[-1].distance_to(_draw_virtual)>5 and _draw_points.size()<120:
		_draw_points.append(_draw_virtual)
	queue_redraw()

func _extend_drawing_at_edge(real_delta:float)->void:
	var size:Vector2=get_viewport_rect().size
	var outward:bool=(_last_pointer.x<DRAW_EDGE_MARGIN and _draw_heading.x<-.1) or (_last_pointer.x>size.x-DRAW_EDGE_MARGIN and _draw_heading.x>.1) or (_last_pointer.y<DRAW_EDGE_MARGIN and _draw_heading.y<-.1) or (_last_pointer.y>size.y-DRAW_EDGE_MARGIN and _draw_heading.y>.1)
	if not outward or _draw_heading.is_zero_approx():
		_draw_edge_elapsed=0.0
		_draw_edge_active=false
		return
	_draw_edge_elapsed+=minf(real_delta,.05)
	_draw_edge_active=_draw_edge_elapsed>=DRAW_EDGE_DWELL
	if not _draw_edge_active:return
	var zoom:float=get_viewport().get_camera_2d().zoom.x if get_viewport().get_camera_2d()!=null else 1.0
	# Preserve full latest heading, including diagonals at a single edge/corner.
	# Inward drag stops continuation without snapping accumulated virtual offset.
	_draw_virtual+=_draw_heading*DRAW_EDGE_SPEED*minf(real_delta,.05)/zoom
	_append_draw_point()

func _on_move_released(_direction: Vector2) -> void:
	_run_after_dodge = Vector2.ZERO
	if _drawing_dodge:
		_drawing_dodge = false
		Engine.time_scale = 1.0
		dodge_drawing_finished.emit()
		request_dodge_path(_draw_points)
		_draw_points = PackedVector2Array()
		_move_tap.reset()
	elif _now_seconds() - _move_pressed_at > .22:
		_move_tap.reset()

func request_dodge_path(points: PackedVector2Array) -> bool:
	if not dodge_available or _stun_time_remaining > 0.0 or _dodge_cooldown > 0.0 or points.size() < 2:
		return false
	var preview: PackedVector2Array = dodge_preview_points(points)
	if preview.size()<2: return false
	_dodge_path.clear()
	_run_after_dodge = Vector2.ZERO
	_dodge_coast_remaining = 0.0
	_skid_trail.clear()
	_skid_trail.append(global_position)
	_trail_fade = .7
	for i in range(1, preview.size()):
		_dodge_path.append(global_position + preview[i])
	_dodge_cooldown = DODGE_RECHARGE_SECONDS
	_dodge_remaining = 1.0
	dodge_started.emit()
	return true

func request_dodge(direction: Vector2) -> bool:
	if not dodge_available or _stun_time_remaining > 0.0 or _dodge_remaining > 0.0 or _dodge_cooldown > 0.0 or direction.length() < .2 or not is_physics_processing():
		return false
	_dodge_direction = direction.normalized()
	_dodge_remaining = DODGE_SECONDS
	_dodge_cooldown = DODGE_RECHARGE_SECONDS
	return true

func _on_aim_pressed() -> void:
	if _stun_time_remaining > 0.0 or not is_physics_processing():
		return
	_touch_aim_active = true
	_aim_pressed_at_seconds = _now_seconds()
	if not _is_charging and not _lasso_in_flight:
		if _has_free_lasso_slot():
			_start_charging()
		else:
			throw_blocked.emit()

## Two quick taps (press+release near the centre) emit release_requested instead (D038).
## Releasing with the stick (almost) back at its centre CANCELS the throw instead of dropping
## the lasso at the player's feet (D037, LassoAim.is_cancel).
##
## input_vector is the joystick's own final drag vector at the exact moment of release —
## using it directly (instead of the last value polled in _physics_process) avoids a
## one-frame staleness that was making the landing point slightly off from where you
## actually released, especially noticeable on fast drags.
func _on_aim_released(input_vector: Vector2) -> void:
	if not _touch_aim_active:
		return
	_touch_aim_active = false
	var now: float = _now_seconds()
	if LassoAim.is_tap(input_vector, now - _aim_pressed_at_seconds):
		if _double_tap.register_tap(now):
			release_requested.emit()
	else:
		_double_tap.reset()
	if not _is_charging:
		return
	if LassoAim.is_cancel(input_vector):
		_cancel_charge()
	else:
		_release_throw(input_vector)

## Called by an unroped, nervous bull on contact (GAMEPLAY_SPEC.md #Failure feedback).
func stun(duration: float) -> void:
	if _stun_time_remaining <= 0.0:
		stunned.emit()
	_stun_time_remaining = max(_stun_time_remaining, duration * stun_resistance_multiplier)
	if not _sprite_swap.play("stunned"):
		modulate = Color(1.0, 0.5, 0.5, 1.0)  # no art yet: fall back to a red tint
	cancel_input()

func _physics_process(delta: float) -> void:
	_dodge_cooldown = maxf(0.0, _dodge_cooldown - delta)
	if _dodge_path.is_empty():
		_trail_fade = maxf(0.0, _trail_fade - delta)
	if _stun_time_remaining > 0.0:
		_stun_time_remaining -= delta
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		move_and_slide()
		global_position = global_position.clamp(world_bounds.position, world_bounds.end)
		if _stun_time_remaining <= 0.0:
			modulate = Color.WHITE
		return

	if _drawing_dodge:
		_extend_drawing_at_edge(delta/maxf(Engine.time_scale,.01))
		if _now_seconds()-_drawing_real_started > 2.0:
			_on_move_released(Vector2.ZERO)
		velocity = Vector2.ZERO
		queue_redraw()
		return
	if not _dodge_path.is_empty():
		var distance_left:float=global_position.distance_to(_dodge_path[0])
		for i in range(1,_dodge_path.size()): distance_left+=_dodge_path[i-1].distance_to(_dodge_path[i])
		# Ease to running speed, not to a standstill, at the traced endpoint.
		var budget: float = minf(max_speed*DODGE_SPEED_FACTOR,maxf(max_speed,distance_left*14.0))*delta
		if _active_capture_count >= 2:
			budget *= dual_capture_speed_multiplier
		var collision_free: bool = true
		while budget > .01 and not _dodge_path.is_empty():
			var offset: Vector2 = _dodge_path[0] - global_position
			var step: Vector2 = offset.limit_length(budget)
			if not offset.is_zero_approx(): _dodge_direction = offset.normalized()
			var collision: KinematicCollision2D = move_and_collide(step)
			_skid_trail.append(global_position)
			budget -= step.length()
			if collision != null:
				collision_free = false
				_dodge_path.clear()
				break
			if offset.length() <= step.length() + .1:
				_dodge_path.pop_front()
		# The special trace ends here; ordinary running immediately takes over.
		if _dodge_path.is_empty():
			dodge_finished.emit()
			_dodge_coast_remaining = 0.0
			if collision_free:
				_resume_running_after_dodge()
			else:
				_run_after_dodge = Vector2.ZERO
				velocity = Vector2.ZERO
		else:
			velocity = _dodge_direction * max_speed * DODGE_SPEED_FACTOR
		var facing: Array = SpriteSwap.direction_suffix(velocity if not velocity.is_zero_approx() else _dodge_direction)
		_sprite_swap.play("walk_" + facing[0])
		_sprite_swap.set_flip_h(facing[1])
		_sprite_swap.set_motion_speed(velocity.length(), 260.0)
		global_position = global_position.clamp(world_bounds.position, world_bounds.end)
		_dodge_remaining = 0.0 if _dodge_path.is_empty() else 1.0
		queue_redraw()
		return
	if _dodge_coast_remaining > 0.0:
		if not Input.get_vector("move_left", "move_right", "move_up", "move_down").is_zero_approx():
			_dodge_coast_remaining = 0.0
			velocity = Vector2.ZERO  # fresh input takes control without automatic coast
		else:
			var coast_step: float = minf(delta, _dodge_coast_remaining)
			var next_remaining: float = maxf(0.0, _dodge_coast_remaining - coast_step)
			var average_speed: float = max_speed * DODGE_COAST_SPEED_FACTOR * (_dodge_coast_remaining + next_remaining) / (2.0 * DODGE_COAST_SECONDS)
			var hit: KinematicCollision2D = move_and_collide(_dodge_direction * average_speed * coast_step)
			_dodge_coast_remaining = next_remaining if hit == null else 0.0
			velocity = _dodge_direction * max_speed * DODGE_COAST_SPEED_FACTOR * _dodge_coast_remaining / DODGE_COAST_SECONDS
			global_position = global_position.clamp(world_bounds.position, world_bounds.end)
			queue_redraw()
			return
	if _dodge_remaining > 0.0:
		_dodge_remaining = maxf(0.0, _dodge_remaining - delta)
		var speed: float = max_speed * DODGE_SPEED_FACTOR
		if _active_capture_count >= 2:
			speed *= dual_capture_speed_multiplier
		velocity = _dodge_direction * speed
		move_and_slide()
		global_position = global_position.clamp(world_bounds.position, world_bounds.end)
		if _dodge_remaining <= 0.0: _resume_running_after_dodge()
		var direction: Array = SpriteSwap.direction_suffix(_dodge_direction)
		_sprite_swap.play("walk_" + direction[0])
		_sprite_swap.set_flip_h(direction[1])
		_sprite_swap.set_motion_speed(velocity.length(), 260.0)
		queue_redraw()
		return
	queue_redraw()
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var is_moving: bool = input_dir.length() > 0.0

	if is_moving:
		var target_speed: float = max_speed
		if _active_capture_count >= 2:
			target_speed *= dual_capture_speed_multiplier
		velocity = velocity.move_toward(input_dir.normalized() * target_speed, acceleration * delta)
		if not _is_charging:
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

func _resume_running_after_dodge() -> void:
	# Keep the endpoint tangent, never replace it with fresh input or automatic cruise.
	# Normal acceleration/friction controls braking and turning from the next frame.
	_run_after_dodge = Vector2.ZERO
	var speed: float = max_speed * (dual_capture_speed_multiplier if _active_capture_count >= 2 else 1.0)
	velocity = _dodge_direction * speed

func _process_throw_input(delta: float) -> void:
	if _is_charging:
		var aim_vec: Vector2 = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		if aim_vec.length() > 0.0:
			aim_direction = aim_vec.normalized()
		if _touch_aim_active:
			_charge_distance = LassoAim.throw_distance(aim_vec, max_throw_distance)
		else:
			_charge_distance = minf(max_throw_distance, _charge_distance + charge_speed * delta)
		_update_charge_visual()
		if Input.is_action_just_released("throw_lasso"):
			_release_throw()
		return

	if not _lasso_in_flight and Input.is_action_just_pressed("throw_lasso"):
		if _has_free_lasso_slot():
			_start_charging()
		else:
			throw_blocked.emit()

func _now_seconds() -> float:
	return Time.get_ticks_msec() / 1000.0

func _start_charging() -> void:
	_is_charging = true
	_charge_distance = 0.0
	_charge_visual = Line2D.new()
	_charge_visual.width = 3.0
	_charge_visual.default_color = Color(0.85, 0.65, 0.2, 1.0)
	add_child(_charge_visual)

func _update_charge_visual() -> void:
	if _charge_visual != null:
		_charge_visual.points = PackedVector2Array([Vector2.ZERO, aim_direction * _charge_distance])
	queue_redraw()

## [param final_vector]: when the aim stick provides its exact release vector, use it
## directly (fixes the one-frame staleness noted above). Empty/zero means "use whatever
## aim_direction/_charge_distance were last set" — the keyboard/mouse fallback path.
func _release_throw(final_vector: Vector2 = Vector2.ZERO) -> void:
	if not _has_free_lasso_slot():
		_cancel_charge()
		throw_blocked.emit()
		return
	if final_vector.length() > 0.0:
		aim_direction = final_vector.normalized()
		_charge_distance = LassoAim.throw_distance(final_vector, max_throw_distance)

	var landing_point: Vector2 = global_position + aim_direction * _charge_distance
	var throw_origin: Vector2 = global_position
	_cancel_charge()

	# Simulated flight time (GAMEPLAY_SPEC.md #Lanzamiento: "sensación de altura" — the rope
	# travels before landing; the bull can move away in the meantime). The line animates in
	# world space: destination stays fixed but the rope origin follows the rider.
	lasso_released.emit()
	_lasso_in_flight = true
	_flight_generation += 1
	var generation: int = _flight_generation
	_animate_lasso_flight(throw_origin, landing_point)
	await get_tree().create_timer(lasso_travel_time, false).timeout  # process_always=false: no landing while paused
	if generation != _flight_generation:
		return
	_lasso_in_flight = false

	lasso_thrown.emit(throw_origin, landing_point)
	_flash_landing_area(landing_point)
	# A second touch can begin before first flight lands. Keep held aim usable.
	if _touch_aim_active and not _is_charging and _has_free_lasso_slot() and _stun_time_remaining<=0:
		_start_charging()

func cancel_all_actions() -> void:
	cancel_input()
	_flight_generation += 1
	_lasso_in_flight = false
	if is_instance_valid(_flight_tween):
		_flight_tween.kill()
	if is_instance_valid(_flight_line):
		_flight_line.queue_free()
	_flight_line = null
	_flight_tween = null

func cancel_input() -> void:
	_run_after_dodge = Vector2.ZERO
	if _drawing_dodge: dodge_drawing_finished.emit()
	Engine.time_scale = 1.0
	_dodge_coast_remaining = 0.0
	_dodge_remaining = 0.0
	_dodge_path.clear()
	_drawing_dodge = false
	_draw_points = PackedVector2Array()
	_move_tap.reset()
	_touch_aim_active = false
	_double_tap.reset()
	_cancel_charge()
	velocity = Vector2.ZERO

func _cancel_charge() -> void:
	if _charge_visual != null:
		_charge_visual.queue_free()
		_charge_visual = null
	_is_charging = false
	_charge_distance = 0.0
	queue_redraw()

## Animates a line from throw_origin to landing_point over lasso_travel_time, in world
## space: landing stays fixed, rope origin follows the moving rider.
func _animate_lasso_flight(throw_origin: Vector2, landing_point: Vector2) -> void:
	var rope:=LassoRope.new()
	_flight_line=rope
	rope.rider=self
	rope.start=throw_origin
	rope.landing=landing_point
	rope.landing_radius=capture_area_visual_radius
	get_parent().add_child(rope)
	var tween:Tween=create_tween()
	_flight_tween=tween
	tween.tween_property(rope,"progress",1.0,lasso_travel_time)
	tween.tween_callback(rope.queue_free)

## Shows the lasso's effective capture area as a translucent circle where it lands, fading out.
func _flash_landing_area(landing_point: Vector2) -> void:
	var marker := Polygon2D.new()
	marker.polygon = _circle_points(capture_area_visual_radius, 24)
	marker.color = Color(0.85, 0.65, 0.2, 0.35)
	get_parent().add_child(marker)
	marker.global_position = landing_point
	var tween: Tween = create_tween()
	tween.tween_property(marker, "modulate:a", 0.0, 0.4)
	tween.tween_callback(marker.queue_free)

func _circle_points(radius: float, segments: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in range(segments):
		var angle: float = TAU * i / segments
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	return points

## Ring matches the forgiving capture area, not the bull's collision shape.
func _draw() -> void:
	if _skid_trail.size() > 1 and _trail_fade > 0.0:
		var local_trail := PackedVector2Array()
		for point in _skid_trail:
			local_trail.append(to_local(point) + Vector2(0, 27))
		_draw_flash_path(local_trail, _trail_fade / .7)
	if _drawing_dodge and _draw_points.size() > 1:
		_draw_flash_path(dodge_preview_points(_draw_points), 1.0)
		draw_string(ThemeDB.fallback_font,Vector2(-64,-78),"TIEMPO BALA",HORIZONTAL_ALIGNMENT_LEFT,150,15,Color("a7fff0"))
	var recharge: float = 1.0 - _dodge_cooldown / DODGE_RECHARGE_SECONDS
	if dodge_available: draw_line(Vector2(-22, -59), Vector2(22, -59), Color("263747"), 5.0)
	if dodge_available: draw_line(Vector2(-22, -59), Vector2(-22 + 44 * recharge, -59), Color("77dbd5") if recharge < 1 else Color("efb950"), 4.0)
	if _dodge_remaining > 0.0:
		var back: Vector2 = -_dodge_direction
		var side: Vector2 = _dodge_direction.orthogonal()
		for i in range(4):
			var dust: Vector2 = back * (24.0 + i * 13.0) + Vector2(0, 28)
			draw_circle(dust + side * (8 if i % 2 else -8), 9.0 - i, Color(.85, .69, .42, .55 - i * .1))
		for side_sign in [-1, 1]:
			draw_line(back * 12 + side * side_sign * 13 + Vector2(0, 28), back * 54 + side * side_sign * 13 + Vector2(0, 28), Color(.35, .24, .13, .6), 3.0, true)
	draw_set_transform(Vector2(0, 33), 0.0, Vector2(1.0, 0.3))
	draw_circle(Vector2.ZERO, 27, Color(0.15, 0.12, 0.08, 0.2))
	draw_set_transform(Vector2.ZERO)
	if _is_charging and _charge_distance > 1.0:
		var target: Vector2 = aim_direction * _charge_distance
		draw_circle(target, capture_area_visual_radius, Color(1.0, 0.84, 0.38, 0.12))
		draw_arc(target, capture_area_visual_radius, 0.0, TAU, 48, Color(1.0, 0.86, 0.44, 0.85), 2.0, true)
		draw_circle(target, 3.0, Color(1.0, 0.92, 0.7))

## Layered light ribbon with moving star glints, never a plain solid line.
func _draw_flash_path(points: PackedVector2Array, alpha: float) -> void:
	if points.size() < 2: return
	draw_polyline(points, Color(.15,.95,.92,.07*alpha), 22.0, true)
	draw_polyline(points, Color(.25,1.0,.95,.16*alpha), 12.0, true)
	draw_polyline(points, Color(.50,1.0,.95,.55*alpha), 5.0, true)
	draw_polyline(points, Color(.94,1.0,.85,.95*alpha), 1.7, true)
	var clock: float = Time.get_ticks_msec()/1000.0
	var distance: float = 0.0
	for segment in range(1,points.size()):
		var a: Vector2 = points[segment-1]
		var b: Vector2 = points[segment]
		var direction: Vector2 = (b-a).normalized()
		var side: Vector2 = direction.orthogonal()
		var length: float = a.distance_to(b)
		var steps: int = maxi(1,int(length/13.0))
		for j in range(steps):
			var p: Vector2 = a.lerp(b,float(j)/steps)
			var pulse: float = .5+.5*sin(clock*18.0+distance*.11)
			var spread: float = 2.0+pulse*5.0
			var shard: Vector2 = p+side*spread*(1.0 if j%2==0 else -1.0)
			draw_line(shard-direction*3,shard+direction*(4+pulse*5),Color(.7,1.0,.94,alpha*pulse*.8),1.3,true)
			if j%4==0:
				draw_circle(p,2+pulse*2,Color(.96,1.0,.84,alpha*.8))
			distance += length/steps

func _exit_tree() -> void:
	Engine.time_scale = 1.0

## One projection shared by drawing and execution: never show unscaled reach.
func dodge_preview_points(points: PackedVector2Array) -> PackedVector2Array:
	var length: float=0.0
	for i in range(1,points.size()): length+=points[i].distance_to(points[i-1])
	if length<15.0: return PackedVector2Array()
	var factor: float=minf(1.0,dodge_path_limit/length)
	var result:=PackedVector2Array()
	for p in points: result.append((p-points[0])*factor)
	return result
