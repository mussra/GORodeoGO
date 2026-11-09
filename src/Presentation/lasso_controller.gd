class_name LassoController
extends Node2D

## The ONE lasso implementation — shared by the corral (player.gd) and the open
## world (frontier_world.gd) (Ant 7-nov 20:02: "Quiero que se use el mismo
## código"). Owns: aim-stick + keyboard charging, the throw, the rope flight
## (LassoRope), capture resolution (nearest prey within its own capture
## radius), the landing flash, slots and the double-tap release gesture.
##
## Mode rules enter through callables:
## - throw_guard: extra "can throw right now" check (corral: no jump/stun).
## - prey_provider: candidate animals (each with try_capture(landing) -> bool).
## - can_capture: consulted at resolution time (corral: free capture slot).
## - rope_parent: node the flight rope and landing flash are added to.

## Capture rule shared by every prey (bulls keep it as @exports with these same
## defaults): the landing must fall within body radius + forgiveness tolerance.
const PREY_HIT_RADIUS: float = 28.0
const PREY_CAPTURE_TOLERANCE: float = 30.0

signal lasso_released
signal lasso_thrown(throw_origin: Vector2, landing_point: Vector2)
signal prey_captured(prey: Node2D)
signal landing_resolved(landing_point:Vector2,prey:Node2D)
signal throw_blocked
signal release_requested

@export var max_throw_distance: float = 220.0
@export var charge_speed: float = 300.0  # units/sec the lasso reaches out while charging (keyboard fallback)
@export var lasso_travel_time: float = .8  # seconds between release and actual capture resolution
@export var capture_area_visual_radius: float = 58.0

var aim_direction: Vector2 = Vector2.RIGHT
var throw_guard: Callable = func() -> bool: return true
var prey_provider: Callable = func() -> Array: return []
var can_capture: Callable = func() -> bool: return true
var rope_parent: Callable = func() -> Node: return get_parent()

var _is_charging: bool = false
var _charge_distance: float = 0.0
var _charge_visual: Line2D = null
var _lasso_in_flight: bool = false
var _flight_generation: int = 0
var _flight_line: Node2D = null
var _flight_tween: Tween = null
var _touch_aim_active: bool = false
var _active_capture_count: int = 0
var _max_captures: int = 1
var _lasso_gesture: LassoGesture = LassoGesture.new()

func _ready() -> void:
	set_process(false)

## Called every frame by the level/world — how many animals this rider currently
## has captured/calming/controlled (speed penalties, slot bookkeeping).
func set_active_capture_count(count: int) -> void:
	_active_capture_count = count

## How many animals may be held at once — 1 normally, 2 with the dual lasso.
func set_max_captures(value: int) -> void:
	_max_captures = maxi(1, value)

## A throw is only possible with a free slot: full hands mean releasing first
## (double tap on the aim stick, D038) before throwing again.
func has_free_lasso_slot() -> bool:
	return _active_capture_count < _max_captures

func is_charging() -> bool:
	return _is_charging

func is_in_flight() -> bool:
	return _lasso_in_flight

func charge_distance() -> float:
	return _charge_distance

func set_aim_joystick(aim_joystick: VirtualJoystick) -> void:
	aim_joystick.pressed.connect(_on_aim_pressed)
	aim_joystick.released.connect(_on_aim_released)

func _on_aim_pressed() -> void:
	if not throw_guard.call():
		return
	_touch_aim_active = true
	_lasso_gesture.press(_now_seconds())
	if not _is_charging and not _lasso_in_flight:
		if has_free_lasso_slot():
			_start_charging()
		else:
			throw_blocked.emit()

## Shared gesture machine (src/Application/lasso_gesture.gd): tap vs drag,
## cancel near the centre (D037), double tap drops a capture (D038).
func _on_aim_released(input_vector: Vector2) -> void:
	if not _touch_aim_active:
		return
	_touch_aim_active = false
	var decision: Dictionary = _lasso_gesture.release(input_vector, _now_seconds(), _is_charging, max_throw_distance)
	if decision.double_tap:
		release_requested.emit()
	if not _is_charging:
		return
	if decision.action == LassoGesture.Action.CANCEL:
		_cancel_charge()
	elif decision.action == LassoGesture.Action.THROW:
		_release_throw(input_vector)

## Keyboard/mouse path: aim_* actions steer, throw_lasso charges and releases.
func process_throw_input(delta: float) -> void:
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
		if has_free_lasso_slot():
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

## The charge-aim target circle, drawn identically by the corral rider and the
## world rider (Ant 21:47: "El círculo de apuntar el lazo no aparece" — the
## world was missing it). Call from the rider's _draw.
func draw_charge_aim(canvas: Node2D) -> void:
	if not is_charging() or charge_distance() <= 1.0:
		return
	# Draw exactly at the charge rope's endpoint (Ant 22:23, "el círculo de
	# apuntar se separa"): circle and rope can never drift apart.
	var target: Vector2 = aim_direction * charge_distance()
	if _charge_visual != null and _charge_visual.points.size() == 2:
		target = _charge_visual.points[1]
	canvas.draw_circle(target, capture_area_visual_radius, Color(1.0, 0.84, 0.38, 0.12))
	canvas.draw_arc(target, capture_area_visual_radius, 0.0, TAU, 48, Color(1.0, 0.86, 0.44, 0.85), 2.0, true)
	canvas.draw_circle(target, 3.0, Color(1.0, 0.92, 0.7))

func cancel_input() -> void:
	_touch_aim_active = false
	_lasso_gesture.reset()
	_cancel_charge()

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

func _cancel_charge() -> void:
	if _charge_visual != null:
		_charge_visual.queue_free()
		_charge_visual = null
	_is_charging = false
	_charge_distance = 0.0

## [param final_vector]: the aim stick's exact release vector when present
## (avoids one-frame staleness); zero means keyboard/mouse fallback.
func _release_throw(final_vector: Vector2 = Vector2.ZERO) -> void:
	if not has_free_lasso_slot():
		_cancel_charge()
		throw_blocked.emit()
		return
	if final_vector.length() > 0.0:
		aim_direction = final_vector.normalized()
		_charge_distance = LassoAim.throw_distance(final_vector, max_throw_distance)

	var landing_point: Vector2 = get_parent().global_position + aim_direction * _charge_distance
	var throw_origin: Vector2 = get_parent().global_position
	_cancel_charge()

	# Simulated flight time (GAMEPLAY_SPEC.md #Lanzamiento: "sensación de altura" — the rope
	# travels before landing; the prey can move away in the meantime). The line animates in
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
	var captured:Node2D=resolve_capture(landing_point)
	landing_resolved.emit(landing_point,captured)
	_flash_landing_area(landing_point)
	# A second touch can begin before first flight lands. Keep held aim usable.
	if _touch_aim_active and not _is_charging and has_free_lasso_slot() and throw_guard.call():
		_start_charging()

## Capture resolution, ONE implementation for both modes: nearest candidate to
## the landing point first; the first prey whose own capture rule accepts the
## landing gets roped. Emits prey_captured; modes do their own bookkeeping
## (capture order, counters) on that signal.
func resolve_capture(landing_point: Vector2) -> Node2D:
	if not can_capture.call():
		return null
	# COPY before sorting (Ant 22:22, "modo de los toros estropeado"): the corral's
	# prey_provider returns the live _active_bulls array; sorting it in place
	# reordered bulls, breaking pen door bull_indices, courier targets and the
	# chaser index (bulls frozen, unlassable, counter stuck at 0).
	var candidates: Array = prey_provider.call().duplicate()
	candidates.sort_custom(func(a, b): return landing_point.distance_to(a.global_position) < landing_point.distance_to(b.global_position))
	for prey in candidates:
		if prey.try_capture(landing_point):
			prey_captured.emit(prey)
			return prey
	return null

## Animates a line from throw_origin to landing_point over lasso_travel_time, in world
## space: landing stays fixed, rope origin follows the moving rider.
func _animate_lasso_flight(throw_origin: Vector2, landing_point: Vector2) -> void:
	var rope:=LassoRope.new()
	_flight_line=rope
	rope.rider=get_parent()
	rope.start=throw_origin
	rope.landing=landing_point
	rope.landing_radius=capture_area_visual_radius
	rope_parent.call().add_child(rope)
	var tween:Tween=create_tween()
	_flight_tween=tween
	tween.tween_property(rope,"progress",1.0,lasso_travel_time)
	tween.tween_callback(rope.queue_free)

## Shows the lasso's effective capture area as a translucent circle where it lands, fading out.
func _flash_landing_area(landing_point: Vector2) -> void:
	var marker := Polygon2D.new()
	marker.polygon = _circle_points(capture_area_visual_radius, 24)
	marker.color = Color(0.85, 0.65, 0.2, 0.35)
	rope_parent.call().add_child(marker)
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
