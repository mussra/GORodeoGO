extends CharacterBody2D

## Arcade-style movement (GAMEPLAY_SPEC.md #Movement) + charge/release lasso throw.
## Presentation layer: owns transform/input, delegates gameplay rules to BullController via signal.
##
## Lasso feel: hold throw_lasso to charge (the rope visibly extends toward aim_direction);
## release to drop it at the current charged distance. Landing point is what CaptureResolver
## checks against — overshoot or undershoot both miss (GAMEPLAY_SPEC.md #Capture).

signal lasso_thrown(throw_origin: Vector2, landing_point: Vector2)
## Double tap on the aim stick: the player wants to drop a captured bull (D038). Level0 decides which.
signal release_requested

const ART_ROOT: String = "res://art/player/"
const ANIM_NAMES: Array = ["idle", "walk_side", "walk_up", "walk_down", "walk_diag_down", "walk_diag_up", "stunned"]

@export var max_speed: float = 260.0
@export var acceleration: float = 900.0
@export var friction: float = 700.0
@export var max_throw_distance: float = 220.0
@export var charge_speed: float = 300.0  # units/sec the lasso reaches out while charging (keyboard fallback)
@export var lasso_travel_time: float = 1.0  # seconds between release and actual capture resolution
@export var stun_resistance_multiplier: float = 1.0  # applied to incoming stun duration; upgrade lowers this
@export var dual_capture_speed_multiplier: float = 0.6  # applied to max_speed while towing 2+ bulls at once (Level 10 unlock)
@export var capture_area_visual_radius: float = 58.0  # visual only — roughly matches a bull's hit_radius + capture_tolerance defaults; not read from any specific bull, since which bull (if any) gets hit isn't known until resolution

var aim_direction: Vector2 = Vector2.RIGHT
var world_bounds: Rect2 = Rect2(-480, -270, 960, 540)
var _stun_time_remaining: float = 0.0
var _is_charging: bool = false
var _lasso_in_flight: bool = false
var _aim_pressed_at_seconds: float = 0.0
var _double_tap: DoubleTapDetector = DoubleTapDetector.new(LassoAim.DOUBLE_TAP_WINDOW_SECONDS)
var _charge_distance: float = 0.0
var _charge_visual: Line2D = null
var _sprite_swap: SpriteSwap
var _active_capture_count: int = 0

func _ready() -> void:
	_sprite_swap = SpriteSwap.new(self, $Polygon2D, ART_ROOT, ANIM_NAMES)

## Called every frame by Level0 — how many bulls this player currently has captured/calming/
## controlled, so movement speed can be penalized while towing more than one (per design:
## a stronger horse trades speed for pulling two at once).
func set_active_capture_count(count: int) -> void:
	_active_capture_count = count

## Wires the aim/throw stick (Godot 4.7 native VirtualJoystick, JOYSTICK_FOLLOWING mode —
## appears where touched and its base follows the finger, so you never have to drag back
## from far away to shorten the throw or change direction; D037). Movement needs no wiring at all: the
## movement VirtualJoystick feeds the same move_left/right/up/down actions keyboard
## already uses, so Input.get_vector picks it up automatically either way.
func set_aim_joystick(aim_joystick: VirtualJoystick) -> void:
	aim_joystick.pressed.connect(_on_aim_pressed)
	aim_joystick.released.connect(_on_aim_released)

func _on_aim_pressed() -> void:
	_aim_pressed_at_seconds = _now_seconds()
	if not _is_charging and not _lasso_in_flight:
		_start_charging()

## Two quick taps (press+release near the centre) emit release_requested instead (D038).
## Releasing with the stick (almost) back at its centre CANCELS the throw instead of dropping
## the lasso at the player's feet (D037, LassoAim.is_cancel).
##
## input_vector is the joystick's own final drag vector at the exact moment of release —
## using it directly (instead of the last value polled in _physics_process) avoids a
## one-frame staleness that was making the landing point slightly off from where you
## actually released, especially noticeable on fast drags.
func _on_aim_released(input_vector: Vector2) -> void:
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
	_stun_time_remaining = max(_stun_time_remaining, duration * stun_resistance_multiplier)
	if not _sprite_swap.play("stunned"):
		modulate = Color(1.0, 0.5, 0.5, 1.0)  # no art yet: fall back to a red tint
	_cancel_charge()

func _physics_process(delta: float) -> void:
	if _stun_time_remaining > 0.0:
		_stun_time_remaining -= delta
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		move_and_slide()
		global_position = global_position.clamp(world_bounds.position, world_bounds.end)
		if _stun_time_remaining <= 0.0:
			modulate = Color.WHITE
		return

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
	global_position = global_position.clamp(world_bounds.position, world_bounds.end)

	_process_throw_input(delta)

func _process_throw_input(delta: float) -> void:
	if _is_charging:
		var aim_vec: Vector2 = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		if aim_vec.length() > 0.0:
			aim_direction = aim_vec.normalized()
		_charge_distance = LassoAim.throw_distance(aim_vec, max_throw_distance)
		_update_charge_visual()
		if Input.is_action_just_released("throw_lasso"):
			_release_throw()
		return

	if not _lasso_in_flight and Input.is_action_just_pressed("throw_lasso"):
		_start_charging()

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

## [param final_vector]: when the aim stick provides its exact release vector, use it
## directly (fixes the one-frame staleness noted above). Empty/zero means "use whatever
## aim_direction/_charge_distance were last set" — the keyboard/mouse fallback path.
func _release_throw(final_vector: Vector2 = Vector2.ZERO) -> void:
	if final_vector.length() > 0.0:
		aim_direction = final_vector.normalized()
		_charge_distance = LassoAim.throw_distance(final_vector, max_throw_distance)

	var landing_point: Vector2 = global_position + aim_direction * _charge_distance
	var throw_origin: Vector2 = global_position
	_cancel_charge()

	# Simulated flight time (GAMEPLAY_SPEC.md #Lanzamiento: "sensación de altura" — the rope
	# travels before landing; the bull can move away in the meantime). The line animates in
	# world space (not parented to the player) since the player keeps moving during the throw.
	_lasso_in_flight = true
	_animate_lasso_flight(throw_origin, landing_point)
	await get_tree().create_timer(lasso_travel_time, false).timeout  # process_always=false: no landing while paused
	_lasso_in_flight = false

	lasso_thrown.emit(throw_origin, landing_point)
	_flash_landing_area(landing_point)

func _cancel_charge() -> void:
	if _charge_visual != null:
		_charge_visual.queue_free()
		_charge_visual = null
	_is_charging = false
	_charge_distance = 0.0

## Animates a line from throw_origin to landing_point over lasso_travel_time, in world
## space (parented to the level, not the player, so it stays put even as the player moves).
func _animate_lasso_flight(throw_origin: Vector2, landing_point: Vector2) -> void:
	var line := Line2D.new()
	line.width = 3.0
	line.default_color = Color(0.85, 0.65, 0.2, 1.0)
	get_parent().add_child(line)  # the level; unlike current_scene it also works when the level is instanced inside another tree (tests)
	line.points = PackedVector2Array([throw_origin, throw_origin])

	var tween: Tween = create_tween()
	tween.tween_method(
		func(t: float): line.points = PackedVector2Array([throw_origin, throw_origin.lerp(landing_point, t)]),
		0.0, 1.0, lasso_travel_time
	)
	tween.tween_callback(line.queue_free)

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
