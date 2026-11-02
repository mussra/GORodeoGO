class_name DistractionStation
extends Node2D

const TRIGGER_RADIUS: float = 48.0
var kind: String = "water"
var _time: float = 0.0
func _ready() -> void:
	z_index = -2
func _process(delta: float) -> void:
	_time += delta
	queue_redraw()
func _draw() -> void:
	draw_ellipse_shadow()
	if kind == "water":
		draw_style_box(RanchTheme.box(Color("805f43"), Color("d4ad73"), 10), Rect2(-42, -24, 84, 46))
		draw_style_box(RanchTheme.box(Color("4e98ac"), Color("badbd0"), 8), Rect2(-33, -17, 66, 28))
		for i in range(3):
			var y: float = -10 + i * 8 + sin(_time * 2 + i) * 2
			draw_line(Vector2(-22, y), Vector2(21, y), Color("9bd8db"), 1.5, true)
	else:
		draw_style_box(RanchTheme.box(Color("c89c46"), Color("805e31"), 8), Rect2(-36, -25, 72, 47))
		for x in range(-29, 30, 7):
			draw_line(Vector2(x, -20), Vector2(x + 3, 17), Color("e6c977"), 3, true)
		for x: float in [-18, 18]: draw_line(Vector2(x, -24), Vector2(x, 22), Color("867343"), 4, true)
	var label: String = "AGUA" if kind == "water" else "HENO"
	draw_string(ThemeDB.fallback_font, Vector2(-36, -32), label, HORIZONTAL_ALIGNMENT_CENTER, 72, 12, Color("fff1cd"))
func draw_ellipse_shadow() -> void:
	draw_set_transform(Vector2(3, 17), 0, Vector2(1, 0.35))
	draw_circle(Vector2.ZERO, 42, Color(0.2, 0.14, 0.08, 0.2))
	draw_set_transform(Vector2.ZERO)
