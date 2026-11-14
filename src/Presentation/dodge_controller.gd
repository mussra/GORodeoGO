class_name DodgeController
extends Node

## The dodge/regate subsystem shared by the corral levels (player.gd) and the
## open world (world_player.gd) — one gesture, one bullet-time, one trail, one
## execution (Ant's unification rule: same code, no copies).
##
## Gesture: double-press (or running re-press) of the move stick arms a
## freehand draw in bullet-time; releasing the stick executes the traced path.
## While drawing, dragging past the screen edge keeps extending the trace.
##
## State lives here; the owner (player scene) drives it from its own
## _physics_process and forwards rendering cues. Scene-specific rules (jump,
## stun, tow speed penalty, endpoint resume) arrive as callables.

signal drawing_started
signal drawing_finished
signal dodge_started
signal dodge_finished

const DODGE_SECONDS: float = .18
const DODGE_SPEED_FACTOR: float = 2.2
const DODGE_COAST_SECONDS: float = .18  # short soft stop, preview tuning
const DODGE_COAST_SPEED_FACTOR: float = .8
const MOVE_REPRESS_WINDOW_SECONDS: float = .3
const DRAW_TIME_SCALE: float = .24
const DRAW_EDGE_MARGIN: float = 28.0
const DRAW_EDGE_SPEED: float = 300.0
const DRAW_EDGE_DWELL: float = .18
const DRAW_MAX_REAL_SECONDS: float = 2.0

var recharge_seconds: float = 2.5
var available: bool = true
var path_limit: float = 260.0

var cooldown: float = 0.0
var coast_remaining: float = 0.0
var skid_trail: Array[Vector2] = []
var trail_fade: float = 0.0
var run_after_dodge: Vector2 = Vector2.ZERO
var drawing: bool = false
var drawing_real_started: float = 0.0
var draw_points: PackedVector2Array = PackedVector2Array()
var path: Array[Vector2] = []
var remaining: float = 0.0  # dash time left (simple dash); 1.0 sentinel while a traced path runs
var direction: Vector2 = Vector2.ZERO
var draw_screen_start: Vector2 = Vector2.ZERO
var draw_virtual: Vector2 = Vector2.ZERO
var draw_heading: Vector2 = Vector2.ZERO
var draw_edge_elapsed: float = 0.0
var draw_edge_active: bool = false
var draw_pointer_previous: Vector2 = Vector2.ZERO
var last_pointer: Vector2 = Vector2.ZERO
var last_touch_index: int = -1
var move_pressed_at: float = 0.0

var owner_body: CharacterBody2D = null
## Scene hooks — the owner decides the rules:
var can_start: Callable = func() -> bool: return true  # corral: not jumping, not stunned
var speed_scale: Callable = func() -> float: return 1.0  # corral: dual-capture tow penalty
var moving_with_input: Callable = func() -> bool: return false  # running-hold detection
var resumed: Callable = func(_dir: Vector2) -> void: pass  # endpoint: ordinary running takes over
var on_moved: Callable = func() -> void: pass  # owner sprite facing + redraw after each step
var world_bounds: Rect2 = Rect2()  # clamp after movement when it has an area

var _move_tap := DoubleTapDetector.new(MOVE_REPRESS_WINDOW_SECONDS)
var running_release_at: float = -INF
var _draw_touch_index: int = -1

func _now_seconds() -> float:
	return Time.get_ticks_msec() / 1000.0

## Movement and lasso gestures have independent detectors.
func set_move_joystick(stick) -> void:
	stick.pressed.connect(on_move_pressed)
	stick.released.connect(on_move_released)

func on_move_pressed() -> void:
	move_pressed_at = _now_seconds()
	var running_repress: bool = move_pressed_at - running_release_at <= MOVE_REPRESS_WINDOW_SECONDS
	running_release_at = -INF
	var double_press: bool = _move_tap.register_tap(move_pressed_at)
	if available and (running_repress or double_press) and cooldown <= 0.0 and can_start.call():
		_move_tap.reset()
		drawing = true
		drawing_real_started = _now_seconds()
		Engine.time_scale = DRAW_TIME_SCALE
		drawing_started.emit()
		_draw_touch_index = last_touch_index
		draw_screen_start = last_pointer
		draw_pointer_previous = last_pointer
		draw_virtual = Vector2.ZERO
		draw_heading = Vector2.ZERO
		draw_edge_elapsed = 0.0
		draw_edge_active = false
		draw_points = PackedVector2Array([Vector2.ZERO])
		owner_body.velocity = Vector2.ZERO

## The owner forwards its _input events here.
func handle_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		last_pointer = event.position
		last_touch_index = event.index
	elif event is InputEventScreenDrag:
		if drawing and event.index == _draw_touch_index:
			last_pointer = event.position
			var zoom: float = owner_body.get_viewport().get_camera_2d().zoom.x if owner_body.get_viewport().get_camera_2d() != null else 1.0
			var delta: Vector2 = event.position - draw_pointer_previous
			draw_pointer_previous = event.position
			if delta.length() > 1:
				draw_heading = delta.normalized()
			draw_virtual += delta / zoom
			append_draw_point()

func append_draw_point() -> void:
	if draw_points.is_empty():
		return
	if draw_points[-1].distance_to(draw_virtual) > 5 and draw_points.size() < 120:
		draw_points.append(draw_virtual)
	owner_body.queue_redraw()

## While drawing: keep extending the trace past the screen edge; cap the
## bullet-time at DRAW_MAX_REAL_SECONDS. The owner zeroes velocity and redraws.
func process_drawing(real_delta: float) -> void:
	extend_drawing_at_edge(real_delta)
	if _now_seconds() - drawing_real_started > DRAW_MAX_REAL_SECONDS:
		on_move_released(Vector2.ZERO)
	owner_body.velocity = Vector2.ZERO
	owner_body.queue_redraw()

func extend_drawing_at_edge(real_delta: float) -> void:
	var size: Vector2 = owner_body.get_viewport_rect().size
	var outward: bool = (last_pointer.x < DRAW_EDGE_MARGIN and draw_heading.x < -.1) or (last_pointer.x > size.x - DRAW_EDGE_MARGIN and draw_heading.x > .1) or (last_pointer.y < DRAW_EDGE_MARGIN and draw_heading.y < -.1) or (last_pointer.y > size.y - DRAW_EDGE_MARGIN and draw_heading.y > .1)
	if not outward or draw_heading.is_zero_approx():
		draw_edge_elapsed = 0.0
		draw_edge_active = false
		return
	draw_edge_elapsed += minf(real_delta, .05)
	draw_edge_active = draw_edge_elapsed >= DRAW_EDGE_DWELL
	if not draw_edge_active:
		return
	var zoom: float = owner_body.get_viewport().get_camera_2d().zoom.x if owner_body.get_viewport().get_camera_2d() != null else 1.0
	# Preserve full latest heading, including diagonals at a single edge/corner.
	# Inward drag stops continuation without snapping accumulated virtual offset.
	draw_virtual += draw_heading * DRAW_EDGE_SPEED * minf(real_delta, .05) / zoom
	append_draw_point()

func on_move_released(_direction: Vector2) -> void:
	running_release_at = -INF
	run_after_dodge = Vector2.ZERO
	if drawing:
		drawing = false
		Engine.time_scale = 1.0
		drawing_finished.emit()
		request_path(draw_points)
		draw_points = PackedVector2Array()
		_move_tap.reset()
	elif not _direction.is_zero_approx() and moving_with_input.call() and path.is_empty():
		# A running hold is the first press. Only the gap after release is timed.
		running_release_at = _now_seconds()
		_move_tap.reset()
	elif _now_seconds() - move_pressed_at > .22:
		_move_tap.reset()

## One projection shared by drawing and execution: never show unscaled reach.
func preview_points(points: PackedVector2Array) -> PackedVector2Array:
	return DodgeCurve.smooth(points, path_limit)

func request_path(points: PackedVector2Array) -> bool:
	if not available or cooldown > 0.0 or not can_start.call() or points.size() < 2:
		return false
	var preview: PackedVector2Array = preview_points(points)
	if preview.size() < 2:
		return false
	path.clear()
	run_after_dodge = Vector2.ZERO
	coast_remaining = 0.0
	skid_trail.clear()
	skid_trail.append(owner_body.global_position)
	trail_fade = .7
	for i in range(1, preview.size()):
		path.append(owner_body.global_position + preview[i])
	cooldown = recharge_seconds
	remaining = 1.0
	dodge_started.emit()
	return true

## Simple straight dash (the corral's request_dodge; also what the world used
## before adopting the full gesture).
func request_dash(dir: Vector2) -> bool:
	if not available or cooldown > 0.0 or remaining > 0.0 or not can_start.call() or dir.length() < .2 or not owner_body.is_physics_processing():
		return false
	direction = dir.normalized()
	remaining = DODGE_SECONDS
	cooldown = recharge_seconds
	dodge_started.emit()
	return true

## Ground trail housekeeping: keeps fading even while other branches run.
## Returns true when the owner should queue_redraw.
func fade_trail(delta: float) -> bool:
	if path.is_empty() and trail_fade > 0:
		trail_fade = maxf(0.0, trail_fade - delta)
		if trail_fade <= 0:
			skid_trail.clear()
		return true
	return false

## Traced-path execution. Returns true while it consumes the physics frame.
func step_path(max_speed: float, delta: float) -> bool:
	if path.is_empty():
		return false
	var distance_left: float = owner_body.global_position.distance_to(path[0])
	for i in range(1, path.size()):
		distance_left += path[i - 1].distance_to(path[i])
	# Ease to running speed, not to a standstill, at the traced endpoint.
	var budget: float = minf(max_speed * DODGE_SPEED_FACTOR, maxf(max_speed, distance_left * 14.0)) * delta * speed_scale.call()
	var collision_free: bool = true
	while budget > .01 and not path.is_empty():
		var offset: Vector2 = path[0] - owner_body.global_position
		var step: Vector2 = offset.limit_length(budget)
		if not offset.is_zero_approx():
			direction = offset.normalized()
		var collision: KinematicCollision2D = owner_body.move_and_collide(step)
		skid_trail.append(owner_body.global_position)
		budget -= step.length()
		if collision != null:
			collision_free = false
			path.clear()
			break
		if offset.length() <= step.length() + .1:
			path.pop_front()
	# The special trace ends here; ordinary running immediately takes over.
	if path.is_empty():
		dodge_finished.emit()
		coast_remaining = 0.0
		if collision_free:
			resumed.call(direction)
		else:
			run_after_dodge = Vector2.ZERO
			owner_body.velocity = Vector2.ZERO
	else:
		owner_body.velocity = direction * max_speed * DODGE_SPEED_FACTOR
	_clamp_to_bounds()
	remaining = 0.0 if path.is_empty() else 1.0
	on_moved.call()
	return true

## The short soft stop after a simple dash. Returns true while coasting
## consumes the frame; fresh input hands control back immediately.
func step_coast(max_speed: float, delta: float) -> bool:
	if coast_remaining <= 0.0:
		return false
	if not Input.get_vector("move_left", "move_right", "move_up", "move_down").is_zero_approx():
		coast_remaining = 0.0
		owner_body.velocity = Vector2.ZERO  # fresh input takes control without automatic coast
		return false
	var coast_step: float = minf(delta, coast_remaining)
	var next_remaining: float = maxf(0.0, coast_remaining - coast_step)
	var average_speed: float = max_speed * DODGE_COAST_SPEED_FACTOR * (coast_remaining + next_remaining) / (2.0 * DODGE_COAST_SECONDS)
	var hit: KinematicCollision2D = owner_body.move_and_collide(direction * average_speed * coast_step)
	coast_remaining = next_remaining if hit == null else 0.0
	owner_body.velocity = direction * max_speed * DODGE_COAST_SPEED_FACTOR * coast_remaining / DODGE_COAST_SECONDS
	_clamp_to_bounds()
	owner_body.queue_redraw()
	return true

## Simple straight dash execution. Returns true while it consumes the frame.
func step_dash(max_speed: float, delta: float) -> bool:
	if remaining <= 0.0:
		return false
	remaining = maxf(0.0, remaining - delta)
	owner_body.velocity = direction * max_speed * DODGE_SPEED_FACTOR * speed_scale.call()
	owner_body.move_and_slide()
	_clamp_to_bounds()
	if remaining <= 0.0:
		resumed.call(direction)
	on_moved.call()
	return true

func cancel() -> void:
	running_release_at = -INF
	run_after_dodge = Vector2.ZERO
	if drawing:
		drawing_finished.emit()
	Engine.time_scale = 1.0
	coast_remaining = 0.0
	remaining = 0.0
	path.clear()
	drawing = false
	draw_points = PackedVector2Array()
	_move_tap.reset()

func _clamp_to_bounds() -> void:
	if world_bounds.has_area():
		owner_body.global_position = owner_body.global_position.clamp(world_bounds.position, world_bounds.end)

## A scene's non-collision boundary can clip movement after step_path returns.
## Release an unreachable trace without refunding cooldown or forcing a new direction.
func stop_clipped_path()->void:
	if path.is_empty():return
	path.clear();remaining=0.;coast_remaining=0.;run_after_dodge=Vector2.ZERO
	owner_body.velocity=Vector2.ZERO;dodge_finished.emit();on_moved.call()
