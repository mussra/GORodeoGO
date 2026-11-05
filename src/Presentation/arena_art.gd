class_name ArenaArt
extends Node2D

## Decorative layer only. Collision and level geometry remain owned by the scene/catalog.
var obstacle_rects: Array = []
var world_bounds:Rect2=Rect2(-480,-270,960,540)
var pen_position: Vector2 = Vector2(-300, 0)

func _ready() -> void:
	z_index = -20
	queue_redraw()

func _draw() -> void:
	# Grass apron, inset dirt arena and a deliberately quiet centre for gameplay.
	draw_rect(world_bounds.grow(350), Color("091b27"))
	draw_style_box(RanchTheme.box(Color("102c38"), Color("27505e"), 24), world_bounds.grow(43))
	draw_style_box(RanchTheme.box(Color("27444c"), Color("54b9b1"), 18), world_bounds.grow(15))
	draw_style_box(RanchTheme.box(Color("34575c"), Color.TRANSPARENT, 12), world_bounds.grow(-6))
	# Embedded ranch-floor panels, quiet enough to keep silhouettes legible.
	for x in range(int(world_bounds.position.x+40),int(world_bounds.end.x),80):
		draw_line(Vector2(x,world_bounds.position.y+12),Vector2(x,world_bounds.end.y-12),Color(.3,.6,.64,.075),1,true)
	for y in range(int(world_bounds.position.y+30),int(world_bounds.end.y),80):
		draw_line(Vector2(world_bounds.position.x+12,y),Vector2(world_bounds.end.x-12,y),Color(.3,.6,.64,.075),1,true)
	var random := RandomNumberGenerator.new()
	random.seed = 93842
	for i in range(430):
		var point := Vector2(random.randf_range(world_bounds.position.x+12,world_bounds.end.x-12),random.randf_range(world_bounds.position.y+12,world_bounds.end.y-12))
		draw_line(point, point + Vector2(random.randf_range(1, 5), 0), Color(.55,.78,.78,.10), 1.0)
	# Rail fence is drawn over the original perimeter collision shapes.
	for y: float in [world_bounds.position.y-10,world_bounds.end.y+10]:
		draw_line(Vector2(world_bounds.position.x-12, y + 6), Vector2(world_bounds.end.x+12, y + 6), Color(0.22, 0.16, 0.1, 0.23), 10)
		for offset: float in [-5.0, 4.0]:
			draw_line(Vector2(world_bounds.position.x-12, y + offset), Vector2(world_bounds.end.x+12, y + offset), Color("81b4bb"), 5)
		for x in range(int(world_bounds.position.x-10),int(world_bounds.end.x+11),49):
			_post(Vector2(x, y))
	for x: float in [world_bounds.position.x-10,world_bounds.end.x+10]:
		for offset: float in [-4.0, 4.0]:
			draw_line(Vector2(x + offset, world_bounds.position.y-10), Vector2(x + offset, world_bounds.end.y+10), Color("81b4bb"), 5)
		for y in range(int(world_bounds.position.y+25),int(world_bounds.end.y-24),49):
			_post(Vector2(x, y))
	for rect: Rect2 in obstacle_rects:
		_crates(rect)
	# Safe corral: the size of the actual goal (80 x 80), no pretend bigger target.
	var goal := Rect2(pen_position - Vector2(40, 40), Vector2(80, 80))
	draw_style_box(RanchTheme.box(Color("1b6564"), Color("99ffdc"), 9), goal)
	for x in range(-28, 29, 14):
		draw_line(pen_position + Vector2(x, -32), pen_position + Vector2(x, 32), Color(0.2, 0.4, 0.3, 0.13), 1)
	draw_arc(pen_position, 22, 0, TAU, 32, Color("e8e4ad"), 2, true)
	draw_polyline(PackedVector2Array([pen_position + Vector2(-10, 0), pen_position + Vector2(-2, 8), pen_position + Vector2(12, -9)]), Color("faf0bf"), 4, true)
	var font: Font = ThemeDB.fallback_font
	draw_string(font, pen_position + Vector2(-34, -49), "META", HORIZONTAL_ALIGNMENT_CENTER, 68, 15, Color("fff2cf"))
	# Small grass clumps outside the playable fence.
	for side: int in [-1, 1]:
		for i in range(13):
			var p := Vector2(side * random.randf_range(world_bounds.size.x/2+55,world_bounds.size.x/2+170), random.randf_range(world_bounds.position.y-60,world_bounds.end.y+60))
			for j in range(3):
				draw_line(p + Vector2(j * 4, 0), p + Vector2(j * 5 - 3, -10 - j * 2), Color("1e4655"), 3, true)

func _post(point: Vector2) -> void:
	draw_circle(point + Vector2(2, 5), 7, Color(0.2, 0.13, 0.1, 0.2))
	draw_rect(Rect2(point - Vector2(5, 9), Vector2(10, 18)), Color("1a333e"))
	draw_rect(Rect2(point - Vector2(4, 9), Vector2(8, 5)), Color("9eead8"))

func _crates(rect: Rect2) -> void:
	draw_style_box(RanchTheme.box(Color(0.2, 0.13, 0.07, 0.22), Color.TRANSPARENT, 5), Rect2(rect.position + Vector2(4, 6), rect.size))
	draw_style_box(RanchTheme.box(Color("264c59"), Color("9bbaba"), 4), rect)
	var inner: Rect2 = rect.grow(-7)
	draw_rect(inner, Color("88b4b9"), false, 3)
	draw_line(inner.position, inner.end, Color("173c4b"), 4)
	draw_line(Vector2(inner.position.x, inner.end.y), Vector2(inner.end.x, inner.position.y), Color("173c4b"), 4)
