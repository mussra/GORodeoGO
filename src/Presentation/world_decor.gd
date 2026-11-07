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
## Sprite heights in world px, matched to the old code-drawn bodies so the
## solid/occluder boxes and the depth sorting keep working unchanged.
const TREE_H := 76.0
const PINE_H := 68.0
const BUSH_H := 22.0
const ROCK_W := 30.0
const FLOWER_H := 30.0

var kind: String = "tree"
var size_scale: float = 1.0
var draw_offset: Vector2 = Vector2.ZERO

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
