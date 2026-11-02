class_name PuzzleCorral
extends Node2D

var layout: Dictionary
var number: int = 0
var opened: bool = false
var _gate_body: StaticBody2D
func _ready() -> void:
	z_index = -3
	var rect: Rect2 = layout["rect"]
	var gate: Vector2 = layout["gate"]
	var front_y: float = gate.y
	var back_y: float = rect.position.y if layout["inward"] > 0 else rect.end.y
	_wall(Rect2(rect.position.x - 4, rect.position.y - 4, 8, rect.size.y + 8))
	_wall(Rect2(rect.end.x - 4, rect.position.y - 4, 8, rect.size.y + 8))
	_wall(Rect2(rect.position.x, back_y - 4, rect.size.x, 8))
	_wall(Rect2(rect.position.x, front_y - 4, rect.size.x / 2 - 35, 8))
	_wall(Rect2(gate.x + 35, front_y - 4, rect.size.x / 2 - 35, 8))
	_gate_body = _wall(Rect2(gate.x - 35, front_y - 4, 70, 8))
func _wall(rect: Rect2) -> StaticBody2D:
	var body := StaticBody2D.new()
	body.collision_layer = CollisionLayers.FENCE
	body.collision_mask = 0
	body.position = rect.get_center()
	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = rect.size
	shape.shape = box
	body.add_child(shape)
	add_child(body)
	return body
func open_gate() -> void:
	if opened: return
	opened = true
	_gate_body.collision_layer = 0
	queue_redraw()
func _draw() -> void:
	var rect: Rect2 = layout["rect"]
	var gate: Vector2 = layout["gate"]
	var front: float = gate.y
	var back: float = rect.position.y if layout["inward"] > 0 else rect.end.y
	draw_rect(rect, Color(0.43, 0.31, 0.18, 0.1))
	_rail(Vector2(rect.position.x, back), Vector2(rect.end.x, back))
	_rail(rect.position, Vector2(rect.position.x, rect.end.y))
	_rail(Vector2(rect.end.x, rect.position.y), rect.end)
	_rail(Vector2(rect.position.x, front), gate - Vector2(35, 0))
	_rail(gate + Vector2(35, 0), Vector2(rect.end.x, front))
	if not opened:
		_rail(gate - Vector2(35, 0), gate + Vector2(35, 0), Color("dcac57"))
		for x in range(-28, 29, 14):
			draw_line(gate + Vector2(x, -10), gate + Vector2(x, 10), Color("dfb56b"), 5, true)
	else:
		draw_line(gate - Vector2(35, 0), gate - Vector2(50, layout["inward"] * 28), Color("dcac57"), 6, true)
		draw_line(gate + Vector2(35, 0), gate + Vector2(50, layout["inward"] * 28), Color("dcac57"), 6, true)
	draw_string(ThemeDB.fallback_font, Vector2(rect.position.x + 8, back + (18 if layout["inward"] > 0 else -10)), "RECINTO %d" % number, HORIZONTAL_ALIGNMENT_LEFT, 100, 12, Color("fff1cf"))
func _rail(a: Vector2, b: Vector2, color: Color = Color("815638")) -> void:
	draw_line(a + Vector2(2, 5), b + Vector2(2, 5), Color(0.2, 0.14, 0.1, 0.2), 8, true)
	draw_line(a, b, color, 6, true)
	var steps: int = maxi(1, int(a.distance_to(b) / 30))
	for i in range(steps + 1):
		var point: Vector2 = a.lerp(b, float(i) / steps)
		draw_rect(Rect2(point - Vector2(4, 7), Vector2(8, 14)), Color("bd905d"))
