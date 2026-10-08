class_name SpriteSwap
extends RefCounted

## Runtime sprite loader with graceful fallback — never fails on missing art.
##
## Expected folder layout under [param art_root] (e.g. "res://art/bull/"):
##   <art_root>/<animation_name>/frame_0.png, frame_1.png, frame_2.png, ...
## One subfolder per animation name in [param animation_names]. Frames are loaded in
## sorted filename order. Missing art_root entirely -> no sprite is created, the existing
## placeholder (e.g. Polygon2D) stays visible untouched. Missing one specific animation
## subfolder -> play() just returns false for that call; caller decides the fallback
## (typically: keep using the placeholder's own color-coding for that state).

var _sprite: AnimatedSprite2D = null
var _frames: SpriteFrames = null

func _init(host: Node, placeholder: CanvasItem, art_root: String, animation_names: Array, fps: float = 8.0) -> void:
	if not DirAccess.dir_exists_absolute(art_root):
		return

	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")

	var found_any: bool = false
	for anim_name in animation_names:
		var folder: String = art_root.path_join(anim_name)
		if not DirAccess.dir_exists_absolute(folder):
			continue
		var frame_paths: Array = _list_sorted_image_paths(folder)
		if frame_paths.is_empty():
			continue

		frames.add_animation(anim_name)
		frames.set_animation_speed(anim_name, fps)
		frames.set_animation_loop(anim_name, true)
		for path in frame_paths:
			var tex: Texture2D = load(path)
			if tex != null:
				frames.add_frame(anim_name, tex)
		found_any = true

	if not found_any:
		return

	_frames = frames
	_sprite = AnimatedSprite2D.new()
	_sprite.sprite_frames = _frames
	host.add_child(_sprite)
	placeholder.visible = false

func _list_sorted_image_paths(folder: String) -> Array:
	var paths: Array = []
	var dir: DirAccess = DirAccess.open(folder)
	if dir == null:
		return paths
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			# Exported builds (APK) do not ship the source PNG: DirAccess lists
			# "frame_0.png.import" / "frame_0.png.remap" instead. Strip that suffix and load
			# the original path, which ResourceLoader resolves to the imported texture.
			var image_name: String = file_name.trim_suffix(".import").trim_suffix(".remap")
			if image_name.ends_with(".png") or image_name.ends_with(".webp"):
				var image_path: String = folder.path_join(image_name)
				if not paths.has(image_path):
					paths.append(image_path)
		file_name = dir.get_next()
	dir.list_dir_end()
	paths.sort()
	return paths

func has_sprite() -> bool:
	return _sprite != null

func set_flip_h(flip: bool) -> void:
	if _sprite != null:
		_sprite.flip_h = flip

## Maps a movement vector to one of 5 base directions + a horizontal-flip flag, so only
## 5 directional animation sets are needed to cover all 8 directions of movement. Art
## convention: face right / down / up / down-right / up-right; left-leaning directions
## reuse the mirrored right-leaning art. Returns [String suffix, bool flip_h].
static func direction_suffix(dir: Vector2) -> Array:
	if dir.length() == 0.0:
		return ["down", false]
	var angle_deg: float = fposmod(rad_to_deg(dir.angle()), 360.0)
	if angle_deg >= 337.5 or angle_deg < 22.5:
		return ["side", false]       # East
	elif angle_deg < 67.5:
		return ["diag_down", false]  # South-East
	elif angle_deg < 112.5:
		return ["down", false]       # South
	elif angle_deg < 157.5:
		return ["diag_down", true]   # South-West (mirrors SE)
	elif angle_deg < 202.5:
		return ["side", true]        # West (mirrors East)
	elif angle_deg < 247.5:
		return ["diag_up", true]     # North-West (mirrors NE)
	elif angle_deg < 292.5:
		return ["up", false]         # North
	else:
		return ["diag_up", false]    # North-East

## Attempts to play [param anim_name]. Returns true if a real sprite animation played
## (caller should NOT apply its own color-coding in that case), false if this animation
## isn't available (caller should fall back to its own placeholder feedback).
func play(anim_name: String) -> bool:
	if _sprite != null and _frames.has_animation(anim_name):
		if _sprite.animation != anim_name:
			_sprite.play(anim_name)
		return true
	return false
