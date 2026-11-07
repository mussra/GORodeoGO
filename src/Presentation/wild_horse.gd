extends Node2D
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
	_art = Art.new()
	_art.traits = herd.get("traits", {})
	add_child(_art)
	if wander:
		_pick_wander_target()

func _process(delta: float) -> void:
	_bob += delta
	if wander:
		_wander(delta)
	else:
		_graze_timer -= delta
		if _graze_timer <= 0.0:
			_graze_timer = randf_range(2.0, 5.0)
			_art.grazing = not _art.grazing
	_art.position.y = sin(_bob * 1.6) * 1.5

func _wander(delta: float) -> void:
	if _wander_pause > 0.0:
		_wander_pause -= delta
		_art.grazing = true
		if _wander_pause <= 0.0:
			_pick_wander_target()
		return
	_art.grazing = false
	var to: Vector2 = _wander_target - position
	if to.length() < 6.0:
		_wander_pause = randf_range(1.6, 3.6)
		return
	var step: Vector2 = to.normalized() * wander_speed * delta
	position += step
	_art.flip_h = step.x < 0.0
	_art.set_walk_direction(step)

func _pick_wander_target() -> void:
	var a: float = randf() * TAU
	var r: float = randf_range(wander_radius * 0.35, wander_radius)
	_wander_target = home + Vector2(cos(a), sin(a)) * r

func flee_from(from: Vector2, delta: float) -> void:
	var away: Vector2 = position - from
	if away.length() < 1.0:
		away = Vector2.RIGHT
	var target: Vector2 = position + away.normalized() * 230.0 * delta
	if home.distance_to(target) < WorldTaming.FLEE_LEASH:
		position = target
	_art.flip_h = away.x < 0.0
	_art.grazing = false

func face_towards(point: Vector2) -> void:
	_art.flip_h = point.x < position.x
