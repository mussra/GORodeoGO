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

func _ready() -> void:
	position = ZONE_POS
	for h in HORSES:
		var horse := WildHorseScript.new()
		horse.setup({"pos": h["home"], "traits": h["traits"]})
		horse.wander = true
		horse.wander_radius = 60.0
		add_child(horse)
	for t in TREES:
		var tree := DecorScript.new()
		tree.kind = "tree"
		tree.size_scale = 1.0
		tree.position = t
		add_child(tree)
	for c in CACTI:
		var cactus := DecorScript.new()
		cactus.kind = "cactus"
		cactus.size_scale = 1.0
		cactus.position = c
		add_child(cactus)
	for p in PIGS:
		var pig := PigScript.new()
		pig.setup({"pos": p})
		add_child(pig)

func _draw() -> void:
	for t in TRAILS:
		_draw_trail(t["from"], t["to"])
	for h in HOUSES:
		_draw_house(h)
	# meadow fence with a gate on the east side; pig pen with a gate on the west
	_rail_h(MEADOW.position.y, MEADOW.position.x, MEADOW.end.x)
	_rail_h(MEADOW.end.y, MEADOW.position.x, MEADOW.end.x)
	_rail_v(MEADOW.position.x, MEADOW.position.y, MEADOW.end.y)
	_rail_v(MEADOW.end.x, MEADOW.position.y, MEADOW.end.y, Vector2(-20, 30))
	_rail_h(PEN.position.y, PEN.position.x, PEN.end.x)
	_rail_h(PEN.end.y, PEN.position.x, PEN.end.x)
	_rail_v(PEN.position.x, PEN.position.y, PEN.end.y, Vector2(-10, 30))
	_rail_v(PEN.end.x, PEN.position.y, PEN.end.y)

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

func _rail_h(y: float, x0: float, x1: float, gap := Vector2(-1, -1)) -> void:
	var x := x0
	while x < x1:
		if gap.x < 0.0 or x + 14.0 < gap.x or x - 14.0 > gap.y:
			draw_rect(Rect2(x - 14, y - 4, 28, 8), Color("7a5230"))
		x += 30.0

func _rail_v(x: float, y0: float, y1: float, gap := Vector2(-1, -1)) -> void:
	var y := y0
	while y < y1:
		if gap.x < 0.0 or y + 4.0 < gap.x or y - 4.0 > gap.y:
			draw_rect(Rect2(x - 4, y - 14, 8, 28), Color("7a5230"))
		y += 30.0
