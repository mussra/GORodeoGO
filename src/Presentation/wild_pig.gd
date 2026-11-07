extends Node2D
## A wild pig in the frontier. Code-drawn cartoon art (round, pink, silly), the
## same placeholder spirit as the wild horses until final art exists.

var pen: Dictionary = {}
var state: Dictionary = {}
## Seconds left roped by the rider's lasso; while > 0 the pig cannot flee.
var held: float = 0.0
var home: Vector2 = Vector2.ZERO
var flip_h: bool = false
var _bob: float = 0.0

func setup(p_pen: Dictionary) -> void:
	pen = p_pen
	state = WorldPigs.new_state()
	home = pen.get("pos", Vector2.ZERO)

func _ready() -> void:
	position = home

func _process(delta: float) -> void:
	_bob += delta
	queue_redraw()

func flee_from(from: Vector2, delta: float) -> void:
	var away: Vector2 = position - from
	if away.length() < 1.0:
		away = Vector2.RIGHT
	var target: Vector2 = position + away.normalized() * 170.0 * delta
	if home.distance_to(target) < WorldPigs.FLEE_LEASH:
		position = target
	flip_h = away.x < 0.0

func face_towards(point: Vector2) -> void:
	flip_h = point.x < position.x

func _draw() -> void:
	var bounce: float = sin(_bob * 5.0) * 2.0
	var d: float = -1.0 if flip_h else 1.0
	# body
	draw_set_transform(Vector2(0, bounce), 0.0, Vector2(1.25, 1.0))
	draw_circle(Vector2.ZERO, 22.0, Color("f2a7b8"))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# head + snout
	draw_circle(Vector2(20 * d, -6 + bounce), 13.0, Color("f2a7b8"))
	draw_circle(Vector2(30 * d, -3 + bounce), 6.5, Color("e3899d"))
	draw_circle(Vector2(28 * d, -3 + bounce), 1.6, Color("7c4356"))
	draw_circle(Vector2(32 * d, -3 + bounce), 1.6, Color("7c4356"))
	# ears
	draw_colored_polygon(PackedVector2Array([Vector2(12 * d, -16 + bounce), Vector2(18 * d, -26 + bounce), Vector2(22 * d, -14 + bounce)]), Color("e3899d"))
	# eye
	draw_circle(Vector2(22 * d, -10 + bounce), 2.2, Color("2b2024"))
	# legs
	for lx in [-12, 8]:
		draw_rect(Rect2(lx - 3, 14 + bounce * 0.4, 7, 12), Color("e3899d"))
	# curly tail
	draw_arc(Vector2(-24 * d, -6 + bounce), 6.0, 0.0, PI * 1.6, 10, Color("e3899d"), 3.0)

## Same capture rule as the corral bulls (Ant: mismo codigo): the LassoController
## resolves nearest-first and each prey accepts landings within body + tolerance.
func try_capture(landing_point: Vector2) -> bool:
	if held > 0.0:
		return false
	return global_position.distance_to(landing_point) <= LassoController.PREY_HIT_RADIUS + LassoController.PREY_CAPTURE_TOLERANCE
