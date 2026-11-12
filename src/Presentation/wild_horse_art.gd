extends AnimatedSprite2D
## Nominal five-view PixelLab horse. Nine frames per movement view.
## Coat, mane and patterns use the reviewed v5 masks and shared genotype cache.
static var frame_cache: Dictionary = {}

var traits: Dictionary = {}
var grazing: bool = false : set = set_grazing
var walk_dir: String = "side"
var resting107:bool=false
func set_motion107(motion:Vector2)->void:
	var rest:bool=motion.length()<12.
	if rest==resting107:return
	resting107=rest;_update_anim()

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
	PixelLabTrial.apply(frames,"horse","walk",traits)
	return frames

func _ready() -> void:
	var key := PixelLabTrial.cache_key(traits)
	if not frame_cache.has(key):
		frame_cache[key] = _build_frames(traits)
	sprite_frames = frame_cache[key]
	centered = false
	offset = Vector2(-48, -80)  # hooves at node origin, like the code-drawn version
	_update_anim()

func _update_anim() -> void:
	if sprite_frames == null: return
	if grazing or resting107:
		play("idle")
	elif walk_dir == "side":
		play("walk")
	else:
		play("walk_" + walk_dir)
