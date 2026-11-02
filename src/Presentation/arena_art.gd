class_name ArenaArt
extends Node2D

## Decorative layer only. Collision and level geometry remain owned by the scene/catalog.
var obstacle_rects: Array = []
var pen_position: Vector2 = Vector2(-300, 0)

func _ready() -> void:
	z_index = -20
	queue_redraw()

func _draw() -> void:
	# Grass apron, inset dirt arena and a deliberately quiet centre for gameplay.
	draw_rect(Rect2(-760, -480, 1520, 960), Color("6d8660"))
	draw_style_box(RanchTheme.box(Color("506c4f"), Color("425744"), 24), Rect2(-523, -313, 1046, 626))
	draw_style_box(RanchTheme.box(Color("c59a65"), Color("8a6646"), 18), Rect2(-495, -285, 990, 570))
	draw_style_box(RanchTheme.box(Color("d7b17b"), Color.TRANSPARENT, 12), Rect2(-474, -264, 948, 528))
	var random := RandomNumberGenerator.new()
	random.seed = 93842
	for i in range(430):
		var point := Vector2(random.randf_range(-468, 468), random.randf_range(-258, 258))
		draw_line(point, point + Vector2(random.randf_range(1, 5), 0), Color(0.54, 0.37, 0.22, 0.14), 1.0)
	# Rail fence is drawn over the original perimeter collision shapes.
	for y: float in [-280.0, 280.0]:
		draw_line(Vector2(-492, y + 6), Vector2(492, y + 6), Color(0.22, 0.16, 0.1, 0.23), 10)
		for offset: float in [-5.0, 4.0]:
			draw_line(Vector2(-492, y + offset), Vector2(492, y + offset), Color("95613f"), 5)
		for x in range(-490, 491, 49):
			_post(Vector2(x, y))
	for x: float in [-490.0, 490.0]:
		for offset: float in [-4.0, 4.0]:
			draw_line(Vector2(x + offset, -280), Vector2(x + offset, 280), Color("95613f"), 5)
		for y in range(-245, 246, 49):
			_post(Vector2(x, y))
	for rect: Rect2 in obstacle_rects:
		_crates(rect)
	# Safe corral: the size of the actual goal (80 x 80), no pretend bigger target.
	var goal := Rect2(pen_position - Vector2(40, 40), Vector2(80, 80))
	draw_style_box(RanchTheme.box(Color("7e9b6e"), Color("f2dba0"), 9), goal)
	for x in range(-28, 29, 14):
		draw_line(pen_position + Vector2(x, -32), pen_position + Vector2(x, 32), Color(0.2, 0.4, 0.3, 0.13), 1)
	draw_arc(pen_position, 22, 0, TAU, 32, Color("e8e4ad"), 2, true)
	draw_polyline(PackedVector2Array([pen_position + Vector2(-10, 0), pen_position + Vector2(-2, 8), pen_position + Vector2(12, -9)]), Color("faf0bf"), 4, true)
	var font: Font = ThemeDB.fallback_font
	draw_string(font, pen_position + Vector2(-34, -49), "CORRAL", HORIZONTAL_ALIGNMENT_CENTER, 68, 15, Color("fff2cf"))
	# Small grass clumps outside the playable fence.
	for side: int in [-1, 1]:
		for i in range(13):
			var p := Vector2(side * random.randf_range(535, 650), random.randf_range(-330, 330))
			for j in range(3):
				draw_line(p + Vector2(j * 4, 0), p + Vector2(j * 5 - 3, -10 - j * 2), Color("4c704e"), 3, true)

func _post(point: Vector2) -> void:
	draw_circle(point + Vector2(2, 5), 7, Color(0.2, 0.13, 0.1, 0.2))
	draw_rect(Rect2(point - Vector2(5, 9), Vector2(10, 18)), Color("72482f"))
	draw_rect(Rect2(point - Vector2(4, 9), Vector2(8, 5)), Color("d3a06a"))

func _crates(rect: Rect2) -> void:
	draw_style_box(RanchTheme.box(Color(0.2, 0.13, 0.07, 0.22), Color.TRANSPARENT, 5), Rect2(rect.position + Vector2(4, 6), rect.size))
	draw_style_box(RanchTheme.box(Color("a57947"), Color("775131"), 4), rect)
	var inner: Rect2 = rect.grow(-7)
	draw_rect(inner, Color("c89a5d"), false, 3)
	draw_line(inner.position, inner.end, Color("805c38"), 4)
	draw_line(Vector2(inner.position.x, inner.end.y), Vector2(inner.end.x, inner.position.y), Color("805c38"), 4)
