class_name WorldTestZone
extends Node2D
## Zona de pruebas fija junto al rancho (Ant, 7-nov-2026): dos caballos salvajes
## de genotipos fijos y distintos paseando (marchas visibles), 2 árboles, 2
## cactus, 2 casas, 2 senderos, cerdos y vallas. Overlay fijo: no toca la
## semilla de chunks, el streaming ni el guardado. Los caballos son de
## exhibición (no capturables); la captura con genética sigue en las manadas.

const WildHorseScript := preload("res://src/Presentation/wild_horse.gd")
const DecorScript := preload("res://src/Presentation/world_decor.gd")
const PigScript := preload("res://src/Presentation/wild_pig.gd")

const ZONE_POS := Vector2(160, 650)
const MEADOW := Rect2(-195, -105, 235, 215)
const PEN := Rect2(110, -50, 170, 120)
const HORSES := [
	{"home": Vector2(-120, -35), "traits": {"coat": 10, "pattern": 0, "mane": 0, "eyes": 0, "finish": "normal"}},
	{"home": Vector2(-45, 40), "traits": {"coat": 1, "pattern": 2, "mane": 1, "eyes": 1, "finish": "normal"}},
]
const TREES: Array[Vector2] = [Vector2(-235, -125), Vector2(305, -115)]
const CACTI: Array[Vector2] = [Vector2(-255, 95), Vector2(335, 75)]
const HOUSES := [
	{"pos": Vector2(-75, -215), "body": Color("9c6b3f"), "roof": Color("6d4a2f")},
	{"pos": Vector2(90, -205), "body": Color("8a5a33"), "roof": Color("b4452f")},
]
const TRAILS := [
	{"from": Vector2(-290, 145), "to": Vector2(390, 145)},
	{"from": Vector2(-100, -335), "to": Vector2(-100, -150)},
]
const PIGS: Array[Vector2] = [Vector2(155, -5), Vector2(215, 30)]

const DrawNode := preload("res://src/Presentation/world_draw_node.gd")
const Physics := preload("res://src/Presentation/world_physics.gd")
const RAIL := Color("7a5230")

func _ready() -> void:
	position = ZONE_POS
	z_index = -8  # trails stay at ground level under the y-sorted entities
	var world: Node2D = get_parent()
	for h in HORSES:
		var horse := WildHorseScript.new()
		horse.setup({"pos": h["home"] + ZONE_POS, "traits": h["traits"]})
		horse.wander = true
		horse.wander_radius = 60.0
		horse.add_to_group("test_zone")
		world.add_child(horse)
	for t in TREES:
		_add_decor(world, "tree", t)
	for c in CACTI:
		_add_decor(world, "cactus", c)
	for p in PIGS:
		var pig := PigScript.new()
		pig.setup({"pos": p + ZONE_POS})
		world.add_child(pig)
		Physics.add_box(world, Rect2(p + ZONE_POS + Vector2(-12, -6), Vector2(24, 12)))
	for h in HOUSES:
		_add_house(world, h)
	# meadow fence with a gate on the east side; pig pen with a gate on the west
	_rail_nodes_h(world, MEADOW.position.y, MEADOW.position.x, MEADOW.end.x)
	_rail_nodes_h(world, MEADOW.end.y, MEADOW.position.x, MEADOW.end.x)
	_rail_nodes_v(world, MEADOW.position.x, MEADOW.position.y, MEADOW.end.y)
	_rail_nodes_v(world, MEADOW.end.x, MEADOW.position.y, MEADOW.end.y, Vector2(-20, 30))
	_rail_nodes_h(world, PEN.position.y, PEN.position.x, PEN.end.x)
	_rail_nodes_h(world, PEN.end.y, PEN.position.x, PEN.end.x)
	_rail_nodes_v(world, PEN.position.x, PEN.position.y, PEN.end.y, Vector2(-10, 30))
	_rail_nodes_v(world, PEN.end.x, PEN.position.y, PEN.end.y)

func _add_decor(world: Node2D, kind: String, pos: Vector2) -> void:
	var decor := DecorScript.new()
	decor.kind = kind
	decor.size_scale = 1.0
	var boff: float = DecorScript.base_offset(kind, 1.0)
	decor.draw_offset = Vector2(0, -boff)
	decor.position = ZONE_POS + pos + Vector2(0, boff)
	world.add_child(decor)
	var box: Rect2 = DecorScript.solid_box(kind, ZONE_POS + pos, 1.0)
	if box.has_area():
		Physics.add_box(world, box)

func _add_house(world: Node2D, h: Dictionary) -> void:
	var base: Vector2 = ZONE_POS + h["pos"]
	var node := DrawNode.new()
	node.position = base + Vector2(60, 70)
	node.draw_origin = Vector2(-60, -70)
	node.draw_fn = func(n):
		n.draw_rect(Rect2(Vector2.ZERO, Vector2(120, 70)), h["body"])
		n.draw_colored_polygon(PackedVector2Array([Vector2(-10, 0), Vector2(60, -40), Vector2(130, 0)]), h["roof"])
		n.draw_rect(Rect2(Vector2(47, 28), Vector2(26, 42)), Color("4c3b2a"))
		n.draw_rect(Rect2(Vector2(14, 14), Vector2(22, 18)), Color("f2e3b3"))
		n.draw_rect(Rect2(Vector2(86, 14), Vector2(22, 18)), Color("f2e3b3"))
	world.add_child(node)
	# walls: back, sides, front split at the door gap (x 47..73); interior open
	Physics.add_box(world, Rect2(base + Vector2(0, 0), Vector2(120, 8)))
	Physics.add_box(world, Rect2(base + Vector2(0, 8), Vector2(8, 54)))
	Physics.add_box(world, Rect2(base + Vector2(112, 8), Vector2(8, 54)))
	Physics.add_box(world, Rect2(base + Vector2(0, 60), Vector2(47, 10)))
	Physics.add_box(world, Rect2(base + Vector2(73, 60), Vector2(47, 10)))

func _rail_seg(world: Node2D, pos: Vector2, horizontal: bool) -> void:
	var size := Vector2(28, 8) if horizontal else Vector2(8, 28)
	var node := DrawNode.new()
	node.position = ZONE_POS + pos + Vector2(0, 4)
	node.draw_origin = Vector2(0, -4)
	node.draw_fn = func(n): n.draw_rect(Rect2(-size / 2, size), RAIL)
	world.add_child(node)
	Physics.add_box(world, Rect2(ZONE_POS + pos - size / 2, size))

func _rail_nodes_h(world: Node2D, y: float, x0: float, x1: float, gap := Vector2(-1, -1)) -> void:
	var x := x0
	while x < x1:
		if gap.x < 0.0 or x + 14.0 < gap.x or x - 14.0 > gap.y:
			_rail_seg(world, Vector2(x, y), true)
		x += 30.0

func _rail_nodes_v(world: Node2D, x: float, y0: float, y1: float, gap := Vector2(-1, -1)) -> void:
	var y := y0
	while y < y1:
		if gap.x < 0.0 or y + 4.0 < gap.x or y - 4.0 > gap.y:
			_rail_seg(world, Vector2(x, y), false)
		y += 30.0

func _draw() -> void:
	for t in TRAILS:
		_draw_trail(t["from"], t["to"])

func _draw_trail(a: Vector2, b: Vector2) -> void:
	var dist: float = a.distance_to(b)
	var n: int = maxi(1, int(dist / 16.0))
	var dir: Vector2 = (b - a).normalized()
	var perp := Vector2(-dir.y, dir.x)
	for i in n + 1:
		var p: Vector2 = a.lerp(b, float(i) / float(n))
		var wob: float = sin(float(i) * 1.7) * 4.0
		draw_circle(p + perp * wob, 5.0, Color("a5825a"))
		draw_circle(p + perp * (wob + 7.0), 3.5, Color("96754c"))

func _draw_house(h: Dictionary) -> void:
	var p: Vector2 = h["pos"]
	draw_rect(Rect2(p, Vector2(120, 70)), h["body"])
	draw_colored_polygon(PackedVector2Array([p + Vector2(-10, 0), p + Vector2(60, -40), p + Vector2(130, 0)]), h["roof"])
	draw_rect(Rect2(p + Vector2(47, 28), Vector2(26, 42)), Color("4c3b2a"))
	draw_rect(Rect2(p + Vector2(14, 14), Vector2(22, 18)), Color("f2e3b3"))
	draw_rect(Rect2(p + Vector2(86, 14), Vector2(22, 18)), Color("f2e3b3"))

