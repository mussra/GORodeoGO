extends CharacterBody2D
## A wild horse in the frontier: real riderless sprites (art/world/wild_base),
## deterministic traits from WorldMap, taming driven by WorldTaming. Herd horses
## graze in place; showcase horses (test zone, Ant 7-nov-2026) set wander=true
## to amble around home so the walk gait is visible.

const Art := preload("res://src/Presentation/wild_horse_art.gd")

var herd: Dictionary = {}
var state: Dictionary = {}
var home: Vector2 = Vector2.ZERO
var wander: bool = false
var wander_radius: float = 70.0
var wander_speed: float = 55.0
## Seconds left roped by the rider's lasso; while > 0 the horse cannot flee or wander.
var held: float = 0.0
var _art: Node2D
var _bob: float = 0.0
var _graze_timer: float = 0.0
var _wander_target: Vector2 = Vector2.ZERO
var _wander_pause: float = 0.0

func setup(p_herd: Dictionary) -> void:
	herd = p_herd
	state = WorldTaming.new_state()
	home = herd.get("pos", Vector2.ZERO)

func _ready() -> void:
	position = home
	var feet := CollisionShape2D.new()
	var fr := RectangleShape2D.new()
	fr.size = Vector2(24, 12)
	feet.shape = fr
	feet.position = Vector2(0, -2)
	add_child(feet)
	_art = Art.new()
	_art.traits = herd.get("traits", {})
	add_child(_art)
	if wander:
		_pick_wander_target()

func _physics_process(delta: float) -> void:
	_bob += delta
	if held > 0.0:
		held -= delta
		velocity = Vector2.ZERO
		_flee = Vector2.ZERO
		_art.grazing = false
		move_and_slide()
		_art.position.y = sin(_bob * 1.6) * 1.5
		return
	if _flee.length() > 0.0:
		var target: Vector2 = position + _flee * delta
		if home.distance_to(target) < WorldTaming.FLEE_LEASH:
			velocity = _flee
		else:
			velocity = Vector2.ZERO
		_flee = Vector2.ZERO
	elif wander:
		velocity = _wander_vel(delta)
	else:
		velocity = Vector2.ZERO
		_graze_timer -= delta
		if _graze_timer <= 0.0:
			_graze_timer = randf_range(2.0, 5.0)
			_art.grazing = not _art.grazing
	move_and_slide()
	_art.position.y = sin(_bob * 1.6) * 1.5

func _wander_vel(delta: float) -> Vector2:
	if _wander_pause > 0.0:
		_wander_pause -= delta
		_art.grazing = true
		if _wander_pause <= 0.0:
			_pick_wander_target()
		return Vector2.ZERO
	_art.grazing = false
	var to: Vector2 = _wander_target - position
	if to.length() < 6.0:
		_wander_pause = randf_range(1.6, 3.6)
		return Vector2.ZERO
	var step: Vector2 = to.normalized() * wander_speed
	_art.flip_h = step.x < 0.0
	_art.set_walk_direction(step)
	return step

func _pick_wander_target() -> void:
	var a: float = randf() * TAU
	var r: float = randf_range(wander_radius * 0.35, wander_radius)
	_wander_target = home + Vector2(cos(a), sin(a)) * r

var _flee: Vector2 = Vector2.ZERO

func flee_from(from: Vector2, _delta: float) -> void:
	var away: Vector2 = position - from
	if away.length() < 1.0:
		away = Vector2.RIGHT
	_flee = away.normalized() * 230.0
	_art.flip_h = away.x < 0.0
	_art.grazing = false

func face_towards(point: Vector2) -> void:
	_art.flip_h = point.x < position.x

## Same capture rule as the corral bulls (Ant: mismo codigo): the LassoController
## resolves nearest-first and each prey accepts landings within body + tolerance.
func try_capture(landing_point: Vector2) -> bool:
	if held > 0.0:
		return false
	return global_position.distance_to(landing_point) <= LassoController.PREY_HIT_RADIUS + LassoController.PREY_CAPTURE_TOLERANCE
