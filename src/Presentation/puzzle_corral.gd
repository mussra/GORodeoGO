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
	_wall(Rect2(rect.position.x, front_y - 4, rect.size.x / 2 - 60, 8))
	_wall(Rect2(gate.x + 60, front_y - 4, rect.size.x / 2 - 60, 8))
	_gate_body = _wall(Rect2(gate.x - 60, front_y - 4, 120, 8))
	# Root-level y-sort places the foreground rail in front of a bull behind it.
	var rail := CorralFrontRail.new()
	rail.position.y = front_y
	rail.left = rect.position.x
	rail.right = rect.end.x
	rail.gate_x = gate.x
	rail.corral = self
	get_parent().call_deferred("add_child",rail)
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
	draw_rect(rect, Color(.03,.13,.19,.32))
	_rail(Vector2(rect.position.x, back), Vector2(rect.end.x, back))
	_rail(rect.position, Vector2(rect.position.x, rect.end.y))
	_rail(Vector2(rect.end.x, rect.position.y), rect.end)
	if not opened:
		pass # closed front rail is drawn once by its y-sorted sibling
	draw_string(ThemeDB.fallback_font, Vector2(rect.position.x + 8, back + (18 if layout["inward"] > 0 else -10)), "RECINTO %d" % number, HORIZONTAL_ALIGNMENT_LEFT, 100, 12, Color("fff1cf"))
func _rail(a: Vector2, b: Vector2, color: Color = Color("84aeb4")) -> void:
	if absf(a.y-b.y)<.1:
		CorralArt310.horizontal(self,a.x,b.x,a.y);return
	CorralArt310.vertical(self,a.x,a.y,b.y)
