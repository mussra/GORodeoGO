extends Node2D
## The ranch anchor of the frontier: house, corral rails and the job board sign.
## Each item is its own node (Ant 7-nov): depth-sorted by its base y and solid
## at the base, with a south corral gate and a walkable house door.

const DrawNode := preload("res://src/Presentation/world_draw_node.gd")
const Physics := preload("res://src/Presentation/world_physics.gd")

func _ready() -> void:
	var world: Node2D = get_parent()
	# Corral rails around the home meadow (radius 300), south gate opening.
	for i in range(28):
		var a: float = TAU * float(i) / 28.0
		var p: Vector2 = Vector2(cos(a), sin(a)) * 300.0
		if p.y > 120.0 and absf(p.x) < 120.0:
			continue  # gate opening towards the south meadow
		var seg := DrawNode.new()
		seg.position = p + Vector2(0, 4)
		seg.draw_origin = Vector2(0, -4)
		seg.draw_fn = _draw_rail
		world.add_child(seg)
		Physics.add_box(world, Rect2(p - Vector2(14, 4), Vector2(28, 8)))
	# Ranch house: solid walls, open interior, door gap on the front wall.
	var house := DrawNode.new()
	house.position = Vector2(-45, -120)
	house.draw_origin = Vector2(45, 120)
	house.draw_fn = _draw_house
	world.add_child(house)
	Physics.add_box(world, Rect2(-120, -210, 8, 84))
	Physics.add_box(world, Rect2(22, -210, 8, 84))
	Physics.add_box(world, Rect2(-120, -214, 150, 8))
	Physics.add_box(world, Rect2(-120, -128, 54, 10))
	Physics.add_box(world, Rect2(-36, -128, 66, 10))
	# Job board sign.
	var sign := DrawNode.new()
	sign.position = Vector2(145, 50)
	sign.draw_origin = Vector2(-145, -50)
	sign.draw_fn = _draw_sign
	world.add_child(sign)
	Physics.add_box(world, Rect2(139, 20, 12, 30))

func _draw_rail(n: Node2D) -> void:
	n.draw_rect(Rect2(-14, -4, 28, 8), Color("7a5230"))

func _draw_house(n: Node2D) -> void:
	n.draw_rect(Rect2(-120, -210, 150, 90), Color("9c6b3f"))
	n.draw_colored_polygon(PackedVector2Array([Vector2(-132, -210), Vector2(-45, -262), Vector2(42, -210)]), Color("6d4a2f"))
	n.draw_rect(Rect2(-66, -168, 30, 48), Color("4c3b2a"))
	n.draw_rect(Rect2(-110, -196, 26, 22), Color("f2e3b3"))

func _draw_sign(n: Node2D) -> void:
	n.draw_rect(Rect2(140, -8, 10, 58), Color("6d4a2f"))
	n.draw_rect(Rect2(106, -52, 78, 48), Color("8a5a33"))
	n.draw_rect(Rect2(112, -46, 66, 36), Color("c8a86b"))
	n.draw_line(Vector2(120, -36), Vector2(170, -36), Color("6d4a2f"), 3.0)
	n.draw_line(Vector2(120, -26), Vector2(160, -26), Color("6d4a2f"), 3.0)
