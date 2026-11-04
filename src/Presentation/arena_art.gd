class_name ArenaArt
extends Node2D

## Decorative layer only. Collision and level geometry remain owned by the scene/catalog.
var world_bounds: Rect2 = Rect2(-480,-270,960,540)
var obstacle_rects: Array = []
var pen_position: Vector2 = Vector2(-300, 0)

func _ready() -> void:
	z_index = -20
	queue_redraw()

func _draw() -> void:
	# Grass apron, inset dirt arena and a deliberately quiet centre for gameplay.
	draw_rect(world_bounds.grow(300), Color("6d8660"))
	draw_style_box(RanchTheme.box(Color("506c4f"), Color("425744"), 24), world_bounds.grow(43))
	draw_style_box(RanchTheme.box(Color("c59a65"), Color("8a6646"), 18), world_bounds.grow(15))
	draw_style_box(RanchTheme.box(Color("d7b17b"), Color.TRANSPARENT, 12), world_bounds.grow(-6))
	var random := RandomNumberGenerator.new()
	random.seed = 93842
	for i in range(430):
		var point := Vector2(random.randf_range(world_bounds.position.x+12, world_bounds.end.x-12), random.randf_range(world_bounds.position.y+12, world_bounds.end.y-12))
		draw_line(point, point + Vector2(random.randf_range(1, 5), 0), Color(0.54, 0.37, 0.22, 0.14), 1.0)
	# Rail fence is drawn over the original perimeter collision shapes.
	var left: float = world_bounds.position.x - 10
	var right: float = world_bounds.end.x + 10
	var top: float = world_bounds.position.y - 10
	var bottom: float = world_bounds.end.y + 10
	for y: float in [top,bottom]:
		for offset: float in [-5.0,4.0]:
			draw_line(Vector2(left,y+offset),Vector2(right,y+offset),Color("95613f"),5)
		for x in range(int(left),int(right)+1,49): _post(Vector2(x,y))
	for x: float in [left,right]:
		for offset: float in [-4.0,4.0]:
			draw_line(Vector2(x+offset,top),Vector2(x+offset,bottom),Color("95613f"),5)
		for y in range(int(top),int(bottom)+1,49): _post(Vector2(x,y))
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
	draw_string(font, pen_position + Vector2(-34, -49), "META", HORIZONTAL_ALIGNMENT_CENTER, 68, 15, Color("fff2cf"))
	# Small grass clumps outside the playable fence.
	for side: int in [-1, 1]:
		for i in range(13):
			var p := Vector2(side * random.randf_range(world_bounds.end.x + 55, world_bounds.end.x + 170), random.randf_range(world_bounds.position.y - 60, world_bounds.end.y + 60))
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
