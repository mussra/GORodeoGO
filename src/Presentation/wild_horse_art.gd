extends AnimatedSprite2D
## Wild horse rendered with the game's real horse sprites (Ant 7-nov 12:00):
## riderless bases derived from art/player frames (tools/make_wild_base.py),
## recolored per genotype by HorseAppearance with the extended wild_* masks,
## so coat, mane, patterns and finish match exactly what taming adds to the
## collection. Faces right; the native flip_h mirrors. SpriteFrames are shared per
## genotype so a herd costs one recolor, and a 2+4 frame subset keeps the
## per-pixel recolor under the no-stutter rule (Ant 11:30:58).

const IDLE_FRAMES: Array[int] = [0, 3]
const WALK_FRAMES: Array[int] = [0, 3, 6, 9]
const DIRS: Array[String] = ["down", "up", "diag_down", "diag_up"]
static var frame_cache: Dictionary = {}

var traits: Dictionary = {}
var grazing: bool = false : set = set_grazing
var walk_dir: String = "side"

func set_grazing(value: bool) -> void:
	if grazing == value: return
	grazing = value
	_update_anim()

func set_walk_direction(dir: Vector2) -> void:
	var ax: float = absf(dir.x)
	var ay: float = absf(dir.y)
	var d: String
	if ax > ay * 1.6:
		d = "side"
	elif ax > ay * 0.45:
		d = "diag_down" if dir.y > 0.0 else "diag_up"
	else:
		d = "down" if dir.y > 0.0 else "up"
	if d == walk_dir: return
	walk_dir = d
	_update_anim()

static func _build_frames(traits: Dictionary) -> SpriteFrames:
	var frames := SpriteFrames.new()
	for spec in [["wild_side", [0], "idle", 3.0], ["wild_side", [0], "walk", 8.0], ["wild_down", [0], "walk_down", 4.0], ["wild_up", [0], "walk_up", 4.0], ["wild_diag_down", [0], "walk_diag_down", 4.0], ["wild_diag_up", [0], "walk_diag_up", 4.0]]:
		var anim: String = spec[0]
		frames.add_animation(spec[2])
		frames.set_animation_speed(spec[2], spec[3])
		for i in spec[1]:
			var base: Texture2D = load("res://art/world/wild_base/%s/frame_%02d.png" % [anim.trim_prefix("wild_"), i])
			frames.add_frame(spec[2], HorseAppearance.texture(base, anim, i, traits))
	return frames

func _ready() -> void:
	var key := str(traits)
	if not frame_cache.has(key):
		frame_cache[key] = _build_frames(traits)
	sprite_frames = frame_cache[key]
	centered = false
	offset = Vector2(-48, -80)  # hooves at node origin, like the code-drawn version
	_update_anim()

func _update_anim() -> void:
	if sprite_frames == null: return
	if grazing:
		play("idle")
	elif walk_dir == "side":
		play("walk")
	else:
		play("walk_" + walk_dir)
