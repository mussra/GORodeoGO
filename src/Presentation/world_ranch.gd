extends Node2D
## The ranch anchor of the frontier: house, corral rails and the job board sign.
## Each item is its own node (Ant 7-nov): depth-sorted by its base y and solid
## at the base, with a south corral gate and a walkable house door.

const DrawNode := preload("res://src/Presentation/world_draw_node.gd")
const Physics := preload("res://src/Presentation/world_physics.gd")
## House and barn sprites cut from Ant's cartoon art sheet (7-nov-2026 23:01);
## fences and props from the extended sheet (23:06).
const HOUSE_TEX: Texture2D = preload("res://art/world/cartoon/house.png")
const BARN_TEX: Texture2D = preload("res://art/world/cartoon/barn.png")
const FENCE_TEX: Texture2D = preload("res://art/world/cartoon/fence_2rail.png")
const RAILS_TEX: Texture2D = preload("res://art/world/cartoon/rails.png")
const POST_TEX: Texture2D = preload("res://art/world/cartoon/post.png")
const WELL_TEX: Texture2D = preload("res://art/world/cartoon/well.png")
const BARREL_TEX: Texture2D = preload("res://art/world/cartoon/barrel.png")
const CRATE_TEX: Texture2D = preload("res://art/world/cartoon/crate.png")
const CART_TEX: Texture2D = preload("res://art/world/cartoon/cart.png")
const POND_TEX: Texture2D = preload("res://art/world/cartoon/pond.png")
const GATE_TEX: Texture2D = preload("res://art/world/cartoon/fence_gate.png")
const SIGNPOST_TEX: Texture2D = preload("res://art/world/cartoon/signpost.png")
const STUMP_TEX: Texture2D = preload("res://art/world/cartoon/stump.png")
const LOG_TEX: Texture2D = preload("res://art/world/cartoon/log.png")
const HAYBALE_TEX: Texture2D = preload("res://art/world/cartoon/haybale.png")
const GRASS_TEXES: Array[Texture2D] = [
	preload("res://art/world/cartoon/grass1.png"),
	preload("res://art/world/cartoon/grass2.png"),
	preload("res://art/world/cartoon/grass3.png"),
	preload("res://art/world/cartoon/grass4.png"),
	preload("res://art/world/cartoon/grass5.png"),
]
## Barn base spot: inside the corral, south-west meadow — off the roads,
## clear of the rails circle, the house (NW), the sign (E) and the gate.
const BARN_BASE := Vector2(-165, 95)
const BARN_H := 120.0

func _ready() -> void:
	var world: Node2D = get_parent()
	# Corral rails around the home meadow (radius 300), south gate opening.
	# Each segment: upright post at the node + rails stretched to the next
	# node along the chord (posts always stand up; only the rails rotate).
	var pts: Array[Vector2] = []
	for i in range(32):
		var a: float = TAU * float(i) / 32.0
		var p: Vector2 = Vector2(cos(a), sin(a)) * 300.0
		if p.y > 120.0 and absf(p.x) < 120.0:
			pts.append(Vector2(INF, INF))  # gate gap marker
		else:
			pts.append(p)
	for i in range(32):
		var p: Vector2 = pts[i]
		if p.x == INF:
			continue
		var pn: Vector2 = pts[(i + 1) % 32]
		var seg := DrawNode.new()
		seg.position = p + Vector2(0, 4)
		seg.draw_origin = Vector2(0, -4)
		if pn.x == INF:
			seg.draw_fn = func(n): _draw_post(n)
		else:
			seg.draw_fn = func(n): _draw_fence_seg(n, p, pn)
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
	# Barn from Ant's sheet: solid at the body base, fence and hay walkable.
	var barn := DrawNode.new()
	barn.position = BARN_BASE
	barn.draw_origin = -BARN_BASE
	barn.draw_fn = _draw_barn
	world.add_child(barn)
	Physics.add_box(world, Rect2(BARN_BASE + Vector2(-90, -22), Vector2(110, 24)))
	world.register_occluder("ranch_barn", Rect2(BARN_BASE + Vector2(-95, -115), Vector2(120, 115)))
	# Job board sign.
	var sign := DrawNode.new()
	sign.position = Vector2(145, 50)
	sign.draw_origin = Vector2(-145, -50)
	sign.draw_fn = _draw_sign
	world.add_child(sign)
	Physics.add_box(world, Rect2(139, 20, 12, 30))
	# Props from Ant's sheet: well by the house, barrel+crate by the barn,
	# hay cart in the south meadow, pond east outside the corral.
	_prop(world, WELL_TEX, Vector2(105, -170), 78.0, Rect2(83, -184, 44, 20), true)
	_prop(world, BARREL_TEX, Vector2(-52, 100), 26.0, Rect2(-60, 92, 16, 12))
	_prop(world, CRATE_TEX, Vector2(-26, 106), 26.0, Rect2(-36, 96, 20, 14))
	_prop(world, CART_TEX, Vector2(-60, 230), 55.0, Rect2(-92, 222, 64, 14))
	_prop(world, POND_TEX, Vector2(520, 260), 100.0, Rect2(462, 232, 116, 56))
	# Second props pass: gate leaf at the south opening (hinged on the east
	# boundary post, swung open inward), signpost by the gate-road junction,
	# woodcutting corner NW (stump + log), hay bales by the barn and grass
	# tufts sprinkled over the meadow (decorative, walkable).
	_draw_gate(world)
	_prop(world, SIGNPOST_TEX, Vector2(205, 285), 66.0, Rect2(199, 278, 12, 10))
	_prop(world, STUMP_TEX, Vector2(-200, -60), 34.0, Rect2(-212, -66, 24, 10))
	_prop(world, LOG_TEX, Vector2(-228, -24), 26.0, Rect2(-240, -30, 44, 10))
	_prop(world, HAYBALE_TEX, Vector2(-118, 152), 40.0, Rect2(-134, 140, 32, 16))
	_prop(world, HAYBALE_TEX, Vector2(-86, 170), 32.0, Rect2(-100, 160, 28, 14))
	var tufts := [Vector2(40, -40), Vector2(90, 20), Vector2(-150, -140), Vector2(60, 140), Vector2(-60, -30), Vector2(160, -120), Vector2(-230, 60), Vector2(120, 220)]
	for i in tufts.size():
		_prop(world, GRASS_TEXES[i % GRASS_TEXES.size()], tufts[i], 14.0)

const POST_H := 34.0
const RAIL_H := 18.0

func _draw_post(n: Node2D) -> void:
	var pw := POST_H * POST_TEX.get_width() / float(POST_TEX.get_height())
	n.draw_texture_rect(POST_TEX, Rect2(Vector2(-pw * 0.5, -POST_H + 4), Vector2(pw, POST_H)), false)

## Rails from p to pn (rotated), then the upright post at p. Local space:
## the node sits at p + (0,4) with draw origin (0,-4), so local (0,0) = p.
func _draw_fence_seg(n: Node2D, p: Vector2, pn: Vector2) -> void:
	var chord := pn - p
	var mid := chord * 0.5
	var len := chord.length() + 6.0
	# rails raised 16px above the ground line, in world orientation
	n.draw_set_transform(mid + Vector2(0, -16), chord.angle(), Vector2.ONE)
	n.draw_texture_rect(RAILS_TEX, Rect2(Vector2(-len * 0.5, -RAIL_H * 0.5), Vector2(len, RAIL_H)), false)
	n.draw_set_transform(Vector2.ZERO)
	_draw_post(n)

## The gate leaf: hinged on the east post of the south opening (166.6, 249.9),
## swung fully open so it rests against the fence line inside (135° from the
## closed pose); the entrance stays clear and the fence box already covers it.
func _draw_gate(world: Node2D) -> void:
	var node := DrawNode.new()
	node.position = Vector2(166.6, 253.9)
	node.draw_origin = Vector2(0, -4)
	node.draw_fn = func(n):
		var h := 40.0
		var w := h * GATE_TEX.get_width() / float(GATE_TEX.get_height())
		n.draw_set_transform(Vector2(0, -h + 4), deg_to_rad(135.0), Vector2.ONE)
		n.draw_texture_rect(GATE_TEX, Rect2(Vector2(-w, 0), Vector2(w, h)), false)
		n.draw_set_transform(Vector2.ZERO)
	world.add_child(node)

## A small dressing item: y-sorted by its base, optional solid box and occluder.
func _prop(world: Node2D, tex: Texture2D, base: Vector2, h: float, solid := Rect2(), occ := false) -> void:
	var node := DrawNode.new()
	node.position = base
	node.draw_origin = -base
	node.draw_fn = func(n):
		var w := h * tex.get_width() / float(tex.get_height())
		n.draw_texture_rect(tex, Rect2(base - Vector2(w * 0.5, h), Vector2(w, h)), false)
	world.add_child(node)
	if solid.has_area():
		Physics.add_box(world, solid)
	if occ:
		world.register_occluder("prop_%s" % str(base), Rect2(base + Vector2(-h * 0.4, -h), Vector2(h * 0.8, h)))

func _draw_house(n: Node2D) -> void:
	# 171x142 matches the old walls + roof and the registered occluder box
	n.draw_texture_rect(HOUSE_TEX, Rect2(-130.5, -262, 171, 142), false)

func _draw_barn(n: Node2D) -> void:
	var w := BARN_H * BARN_TEX.get_width() / float(BARN_TEX.get_height())
	n.draw_texture_rect(BARN_TEX, Rect2(BARN_BASE - Vector2(w * 0.5, BARN_H), Vector2(w, BARN_H)), false)

func _draw_sign(n: Node2D) -> void:
	n.draw_rect(Rect2(140, -8, 10, 58), Color("6d4a2f"))
	n.draw_rect(Rect2(106, -52, 78, 48), Color("8a5a33"))
	n.draw_rect(Rect2(112, -46, 66, 36), Color("c8a86b"))
	n.draw_line(Vector2(120, -36), Vector2(170, -36), Color("6d4a2f"), 3.0)
	n.draw_line(Vector2(120, -26), Vector2(160, -26), Color("6d4a2f"), 3.0)
