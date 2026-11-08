class_name RiddenHorseArt
extends RefCounted
## Player's ridden horse in the open world (Fase 2, Ant 8-nov 12:48): the new
## wild-horse base recolored with the selected horse's traits, plus a static
## saddle+rider overlay per direction (generated art, art/world/tack/). The
## whole sprite bobs with the existing SpriteSwap.set_gait_pose, so the tack
## needs no per-frame animation. Recolor happens BEFORE pasting the tack, so
## the saddle and rider are never touched by coat/mane masks.

const WALK_CYCLE_FRAMES: Array[int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
const TACK_ROOT: String = "res://art/world/tack/"

static func available() -> bool:
	return DirAccess.dir_exists_absolute(TACK_ROOT) and DirAccess.dir_exists_absolute("res://art/world/wild_base/")

## Same animation names the player already drives: idle + walk_<direction>.
static func build_frames(traits: Dictionary) -> SpriteFrames:
	var tack: Dictionary = {}
	for d in ["side", "down", "up", "diag_down", "diag_up"]:
		var tex: Texture2D = load(TACK_ROOT + d + ".png")
		if tex != null:
			tack[d] = tex.get_image()
	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")
	for spec in [["side", [0], "idle", 3.0], ["walk_side", WALK_CYCLE_FRAMES, "walk_side", 12.0], ["walk_down", WALK_CYCLE_FRAMES, "walk_down", 12.0], ["walk_up", WALK_CYCLE_FRAMES, "walk_up", 12.0], ["walk_diag_down", WALK_CYCLE_FRAMES, "walk_diag_down", 12.0], ["walk_diag_up", WALK_CYCLE_FRAMES, "walk_diag_up", 12.0]]:
		var dir: String = spec[0]
		frames.add_animation(spec[2])
		frames.set_animation_speed(spec[2], spec[3])
		frames.set_animation_loop(spec[2], true)
		for i in spec[1]:
			var base: Texture2D = load("res://art/world/wild_base/%s/frame_%02d.png" % [dir, i])
			var recolored: Texture2D = HorseAppearance.texture(base, "wild_" + dir, i, traits)
			frames.add_frame(spec[2], _with_tack(recolored, tack.get(dir.trim_prefix("walk_"))))
	return frames

static func _with_tack(base: Texture2D, tack: Variant) -> Texture2D:
	if tack == null:
		return base
	var img: Image = base.get_image()
	img.blend_rect(tack, Rect2i(Vector2i.ZERO, tack.get_size()), Vector2i.ZERO)
	return ImageTexture.create_from_image(img)
