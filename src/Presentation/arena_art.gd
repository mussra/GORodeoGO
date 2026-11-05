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
	_draw_destination()
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

## Decorative receiving corral. The lit80x80 floor is the unchanged delivery zone;
## four open approaches and corner rails do not introduce any physical obstacles.
func _draw_destination() -> void:
	var p: Vector2 = pen_position
	var goal := Rect2(p - Vector2(40,40),Vector2(80,80))
	draw_style_box(RanchTheme.box(Color(.02,.10,.13,.35),Color.TRANSPARENT,16),goal.grow(11))
	draw_style_box(RanchTheme.box(Color("594b39"),Color("b89b66"),8),goal.grow(4))
	draw_style_box(RanchTheme.box(Color("246460"),Color("a4f5d4"),7),goal)
	for y in range(-28,32,12):
		draw_line(p+Vector2(-33,y),p+Vector2(33,y),Color(.75,.9,.69,.13),2,true)
	# Short wooden corner rails leave64px clear at every side, never a closed gate.
	for x in [-1,1]:
		for y in [-1,1]:
			var corner:Vector2=p+Vector2(x*48,y*48)
			draw_line(corner,corner+Vector2(-x*15,0),Color("d2b27c"),5,true)
			draw_line(corner,corner+Vector2(0,-y*15),Color("d2b27c"),5,true)
			draw_style_box(RanchTheme.box(Color("66523d"),Color("d8bd8a"),2),Rect2(corner-Vector2(4,6),Vector2(8,13)))
			draw_circle(corner-Vector2(0,4),2,Color("9cf7d7"))
	# Ranch horseshoe badge; no opaque structure hides bulls over the floor.
	draw_arc(p+Vector2(0,-2),16,-.15,PI+.15,24,Color("e5c47d"),4,true)
	draw_line(p+Vector2(-16,-3),p+Vector2(-16,-12),Color("e5c47d"),4,true)
	draw_line(p+Vector2(16,-3),p+Vector2(16,-12),Color("e5c47d"),4,true)
	for x in [-10,10]:draw_circle(p+Vector2(x,7),1.5,Color("564f40"))
	draw_style_box(RanchTheme.box(Color("213f49"),Color("bba271"),4),Rect2(p+Vector2(-43,-76),Vector2(86,23)))
	draw_string(ThemeDB.fallback_font,p+Vector2(-38,-59),"RANCHO",HORIZONTAL_ALIGNMENT_CENTER,76,14,Color("fff0c5"))
	# A gold inward chevron makes the front approach visible under the dark floor.
	draw_polyline(PackedVector2Array([p+Vector2(-7,55),p+Vector2(0,49),p+Vector2(7,55)]),Color("c8ead5"),2,true)
