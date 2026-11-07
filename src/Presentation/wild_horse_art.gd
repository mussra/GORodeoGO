extends AnimatedSprite2D
## Wild horse rendered with the game's real horse sprites (Ant 7-nov 12:00):
## riderless bases derived from art/player frames (tools/make_wild_base.py),
## recolored per genotype by HorseAppearance with the extended wild_* masks,
## so coat, mane, patterns and finish match exactly what taming adds to the
## collection. Faces right; flip_h mirrors.

var traits: Dictionary = {}
var grazing: bool = false : set = set_grazing
var flip_h: bool = false : set = set_flip_h

func set_grazing(value: bool) -> void:
	if grazing == value: return
	grazing = value
	_update_anim()

func set_flip_h(value: bool) -> void:
	if flip_h == value: return
	flip_h = value
	scale.x = -1.0 if flip_h else 1.0

func _ready() -> void:
	var frames := SpriteFrames.new()
	for spec in [["wild_idle", 6, "idle", 3.0], ["wild_walk_side", 12, "walk", 10.0]]:
		var anim: String = spec[0]
		var count: int = spec[1]
		var alias: String = spec[2]
		frames.add_animation(alias)
		frames.set_animation_speed(alias, spec[3])
		for i in count:
			var base: Texture2D = load("res://art/world/wild_base/%s/frame_%02d.png" % [anim.trim_prefix("wild_"), i])
			frames.add_frame(alias, HorseAppearance.texture(base, anim, i, traits))
	sprite_frames = frames
	centered = false
	offset = Vector2(-48, -80)  # hooves at node origin, like the code-drawn version
	_update_anim()

func _update_anim() -> void:
	if sprite_frames == null: return
	if grazing:
		play("idle")
	else:
		play("walk")
