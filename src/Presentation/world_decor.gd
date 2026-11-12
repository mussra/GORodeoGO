extends Node2D
## Frontier decoration from Ant's cartoon art sheets (7-nov-2026 23:01/23:06).
## Trees, bushes, rocks and flowers are sprites cut from the sheets; cactus
## stays code-drawn until Ant provides its art.
## Deterministic per chunk via WorldMap; kinds: tree, rock, bush, cactus.

const OAK_TEX: Texture2D = preload("res://art/world/cartoon/oak.png")
const TREE2_TEX: Texture2D = preload("res://art/world/cartoon/tree2.png")
const PINE_TEX: Texture2D = preload("res://art/world/cartoon/pine.png")
const APPLE_TEX: Texture2D = preload("res://art/world/cartoon/apple.png")
const BUSH_TEXS: Array[Texture2D] = [
	preload("res://art/world/cartoon/bush1.png"),
	preload("res://art/world/cartoon/bush2.png"),
]
const ROCK_TEXS: Array[Texture2D] = [
	preload("res://art/world/cartoon/rock1.png"),
	preload("res://art/world/cartoon/rock2.png"),
]
const FLOWER_TEXS: Array[Texture2D] = [
	preload("res://art/world/cartoon/flower_1.png"),
	preload("res://art/world/cartoon/flower_2.png"),
	preload("res://art/world/cartoon/flower_3.png"),
	preload("res://art/world/cartoon/flower_4.png"),
	preload("res://art/world/cartoon/flower_5.png"),
	preload("res://art/world/cartoon/flower_6.png"),
	preload("res://art/world/cartoon/f_daisy1.png"),
	preload("res://art/world/cartoon/f_daisy2.png"),
	preload("res://art/world/cartoon/f_daisy3.png"),
	preload("res://art/world/cartoon/f_red1.png"),
	preload("res://art/world/cartoon/f_red2.png"),
	preload("res://art/world/cartoon/f_red3.png"),
	preload("res://art/world/cartoon/f_sun1.png"),
	preload("res://art/world/cartoon/f_sun2.png"),
	preload("res://art/world/cartoon/f_blue1.png"),
	preload("res://art/world/cartoon/f_blue2.png"),
	preload("res://art/world/cartoon/f_violet.png"),
	preload("res://art/world/cartoon/f_purple.png"),
	preload("res://art/world/cartoon/f_tulip1.png"),
	preload("res://art/world/cartoon/f_tulip2.png"),
]
## Base art sizes. Tree variation is presentation-only; generated worlds stay intact.
const TREE_H := 76.0
const PINE_H := 68.0
const BUSH_H := 22.0
const ROCK_W := 30.0
const FLOWER_H := 30.0

var kind: String = "tree"
var size_scale: float = 1.0
var draw_offset: Vector2 = Vector2.ZERO

## Stable spot hash, independent of RNG consumption and chunk activation order.
## Square bias gives many modest trees and few giants, multiplier always 1..3.
static func tree_multiplier121(p_kind: String, pos: Vector2, seed_: int) -> float:
	if p_kind not in ["tree", "pine", "fruit_tree"]:return 1.
	var h: int = hash(str(seed_)+":"+p_kind+":"+str(snappedf(pos.x,.01))+":"+str(snappedf(pos.y,.01)))
	var u: float = float(h % 10001)/10000.
	return 1.+2.*u*u

static func effective_scale121(p_kind: String, pos: Vector2, original: float, seed_: int) -> float:
	return original*tree_multiplier121(p_kind,pos,seed_)

## Keep growth of generated trunk colliders off paths. Canopies may overhang.
static func road_safe_scale121(p_kind: String, pos: Vector2, original: float, desired: float, surface) -> float:
	if p_kind not in ["tree","pine","fruit_tree"] or surface==null:return desired
	var low: float=original
	var high: float=desired
	for i in 10:
		var candidate: float=high if i==0 else (low+high)*.5
		var box: Rect2=solid_box(p_kind,pos,candidate)
		var intersects: bool=false
		for x in [box.position.x,box.get_center().x,box.end.x]:
			for y in [box.position.y,box.get_center().y,box.end.y]:
				if surface.contains(Vector2(x,y),8.):intersects=true
		if intersects:high=candidate
		elif i==0:return candidate
		else:low=candidate
	return low

## Node sorts at the trunk's foot. Draw offset is LOCAL, not world-scaled twice.
func configure121(p_kind: String, pos: Vector2, original: float, seed_: int, surface=null) -> void:
	kind=p_kind
	size_scale=road_safe_scale121(kind,pos,original,effective_scale121(kind,pos,original,seed_),surface)
	position=pos+Vector2(0,base_offset(kind,size_scale))
	draw_offset=Vector2(0,-base_offset(kind,1.))

static func base_offset(p_kind: String, sc: float) -> float:
	match p_kind:
		"tree", "pine", "fruit_tree", "cactus":
			return 20.0 * sc
		"rock":
			return 10.0 * sc
		"bush", "flower":
			return 8.0 * sc
	return 0.0

static func solid_box(p_kind: String, pos: Vector2, sc: float) -> Rect2:
	match p_kind:
		"tree", "fruit_tree":
			return Rect2(pos + Vector2(-5, 4) * sc, Vector2(10, 16) * sc)
		"pine":
			return Rect2(pos + Vector2(-4, 2) * sc, Vector2(8, 18) * sc)
		"cactus":
			return Rect2(pos + Vector2(-5, 8) * sc, Vector2(10, 12) * sc)
		"rock":
			return Rect2(pos + Vector2(-14, 0) * sc, Vector2(28, 10) * sc)
	return Rect2()

## World-space rect where this decor's body covers whatever stands behind it.
## Low decor (rock, bush, flower) never hides the rider: empty rect.
static func occluder_box(p_kind: String, pos: Vector2, sc: float) -> Rect2:
	match p_kind:
		"tree", "fruit_tree":
			return Rect2(pos + Vector2(-26, -54) * sc, Vector2(52, 74) * sc)
		"pine":
			return Rect2(pos + Vector2(-24, -48) * sc, Vector2(48, 68) * sc)
		"cactus":
			return Rect2(pos + Vector2(-18, -32) * sc, Vector2(36, 52) * sc)
	return Rect2()

## A save can stand inside a trunk enlarged by this cosmetic update. Recover
## only overlap with a tagged tree, searching nearby clear feet, never a road teleport.
static func clear_spawn121(actor:CharacterBody2D)->bool:
	var shape=actor.get_node_or_null("CollisionShape2D")
	if shape==null:return true
	var q=PhysicsShapeQueryParameters2D.new();q.shape=shape.shape;q.transform=actor.global_transform;q.collision_mask=actor.collision_mask;q.exclude=[actor.get_rid()]
	var space=actor.get_world_2d().direct_space_state
	var hits=space.intersect_shape(q,16)
	var in_tree:bool=false
	for hit in hits:
		if hit.collider.has_meta("tree121"):in_tree=true
	if not in_tree:return true
	for distance in range(12,145,12):
		for i in 16:
			var offset=Vector2.RIGHT.rotated(i*TAU/16)*distance;q.transform=actor.global_transform;q.transform.origin+=offset
			if space.intersect_shape(q,1).is_empty():actor.global_position+=offset;return true
	return false

func _ready() -> void:
	scale = Vector2.ONE * size_scale
	queue_redraw()

## Deterministic per-spot pick so each instance can differ (Ant: vary them).
func _variant(count: int) -> int:
	return int(abs(position.x * 31.0 + position.y * 17.0)) % count

func _draw_tex(tex: Texture2D, base_y: float, h: float) -> void:
	var w := h * tex.get_width() / float(tex.get_height())
	draw_texture_rect(tex, Rect2(-w * 0.5, base_y - h, w, h), false)

func _draw() -> void:
	draw_set_transform(draw_offset)
	match kind:
		"tree":
			_draw_tex(OAK_TEX if _variant(2) == 0 else TREE2_TEX, 20.0, TREE_H)
		"fruit_tree":
			_draw_tex(APPLE_TEX, 20.0, TREE_H)
		"pine":
			_draw_tex(PINE_TEX, 20.0, PINE_H)
		"bush":
			_draw_tex(BUSH_TEXS[_variant(BUSH_TEXS.size())], 8.0, BUSH_H)
		"rock":
			var tex := ROCK_TEXS[_variant(ROCK_TEXS.size())]
			var h := ROCK_W * tex.get_height() / float(tex.get_width())
			draw_texture_rect(tex, Rect2(-ROCK_W * 0.5, 10.0 - h, ROCK_W, h), false)
		"flower":
			_draw_tex(FLOWER_TEXS[_variant(FLOWER_TEXS.size())], 8.0, FLOWER_H)
		"cactus":
			draw_rect(Rect2(-5, -26, 10, 46), Color("3e7d46"))
			draw_rect(Rect2(-16, -14, 8, 18), Color("3e7d46"))
			draw_rect(Rect2(-16, -14, 14, 7), Color("3e7d46"))
			draw_rect(Rect2(8, -20, 8, 16), Color("478a4f"))
			draw_rect(Rect2(2, -20, 14, 7), Color("478a4f"))
