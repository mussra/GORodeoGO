extends Node2D
## A wild horse grazing in the frontier. Code-drawn art (no riderless adult sprite
## exists), deterministic traits from WorldMap, taming driven by WorldTaming.

const Art := preload("res://src/Presentation/wild_horse_art.gd")

var herd: Dictionary = {}
var state: Dictionary = {}
var home: Vector2 = Vector2.ZERO
var _art: Node2D
var _bob: float = 0.0
var _graze_timer: float = 0.0

func setup(p_herd: Dictionary) -> void:
	herd = p_herd
	state = WorldTaming.new_state()
	home = herd.get("pos", Vector2.ZERO)

func _ready() -> void:
	position = home
	_art = Art.new()
	_art.traits = herd.get("traits", {})
	add_child(_art)

func _process(delta: float) -> void:
	_bob += delta
	_graze_timer -= delta
	if _graze_timer <= 0.0:
		_graze_timer = randf_range(2.0, 5.0)
		_art.grazing = not _art.grazing
	_art.position.y = sin(_bob * 1.6) * 1.5

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
