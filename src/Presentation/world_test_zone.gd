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
const PIGS: Array[Vector2] = [Vector2(155, -5), Vector2(215, 30)]

const DrawNode := preload("res://src/Presentation/world_draw_node.gd")
const Physics := preload("res://src/Presentation/world_physics.gd")
const RAIL := Color("7a5230")
## House sprite cut from Ant's cartoon art sheet (7-nov-2026 23:01); fence
## and road tiles from the extended sheet (23:06).
const HOUSE_TEX: Texture2D = preload("res://art/world/cartoon/house.png")
const FENCE_TEX: Texture2D = preload("res://art/world/cartoon/fence_2rail.png")
const RAILS_TEX: Texture2D = preload("res://art/world/cartoon/rails.png")
const POST_TEX: Texture2D = preload("res://art/world/cartoon/post.png")

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
	# 140x116 covers the old 120x70 body + roof and the registered occluder;
	# walls and door gap physics below stay exactly as they were
	node.draw_fn = func(n):
		n.draw_texture_rect(HOUSE_TEX, Rect2(Vector2(-10, -114), Vector2(140, 116)), false)
	world.add_child(node)
	world.register_occluder("zone_house_%s" % str(base), Rect2(base + Vector2(-10, -110), Vector2(140, 110)))
	# walls: back, sides, front split at the door gap (x 47..73); interior open
	Physics.add_box(world, Rect2(base + Vector2(0, 0), Vector2(120, 8)))
	Physics.add_box(world, Rect2(base + Vector2(0, 8), Vector2(8, 54)))
	Physics.add_box(world, Rect2(base + Vector2(112, 8), Vector2(8, 54)))
	Physics.add_box(world, Rect2(base + Vector2(0, 60), Vector2(47, 10)))
	Physics.add_box(world, Rect2(base + Vector2(73, 60), Vector2(47, 10)))

func _rail_seg(world: Node2D, pos: Vector2, horizontal: bool) -> void:
	var size := Vector2(28, 8) if horizontal else Vector2(8, 28)
	# upright post + rails along the run direction (only the rails rotate)
	var node := DrawNode.new()
	node.position = ZONE_POS + pos + Vector2(0, 4)
	node.draw_origin = Vector2(0, -4)
	var ang := 0.0 if horizontal else PI * 0.5
	node.draw_fn = func(n):
		n.draw_set_transform(Vector2(0, -16), ang, Vector2.ONE)
		n.draw_texture_rect(RAILS_TEX, Rect2(Vector2(-17, -9), Vector2(34, 18)), false)
		n.draw_set_transform(Vector2.ZERO)
		var pw := 34.0 * POST_TEX.get_width() / float(POST_TEX.get_height())
		n.draw_texture_rect(POST_TEX, Rect2(Vector2(-pw * 0.5, -30), Vector2(pw, 34)), false)
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

# Access roads are drawn by FrontierTrail from shared WorldPaths data.
