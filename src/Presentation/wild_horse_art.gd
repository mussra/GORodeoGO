extends Node2D
## Code-drawn riderless wild horse at gameplay scale (the only riderless art in the
## project is the foal, and the HD portrait carries the rider). Recolors from traits:
## coat, mane and a light pattern wash. Faces right; flip_h mirrors.

var traits: Dictionary = {}
var grazing: bool = false : set = set_grazing
var flip_h: bool = false : set = set_flip_h

func set_grazing(value: bool) -> void:
	if grazing == value: return
	grazing = value
	queue_redraw()

func set_flip_h(value: bool) -> void:
	if flip_h == value: return
	flip_h = value
	scale.x = -1.0 if flip_h else 1.0

func _ready() -> void:
	queue_redraw()

static func _ellipse(center: Vector2, rx: float, ry: float, rot: float = 0.0, steps: int = 20) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in steps:
		var a := TAU * float(i) / float(steps)
		var p := Vector2(cos(a) * rx, sin(a) * ry).rotated(rot)
		pts.append(center + p)
	return pts

func _draw() -> void:
	var coat: Color = Color(HorseAppearance.COLORS[int(traits.get("coat", 10)) % HorseAppearance.COLORS.size()])
	var mane_idx: int = int(traits.get("mane", 1)) % (HorseAppearance.MANES.size() + 1)
	var mane: Color = Color(HorseAppearance.MANES[mini(mane_idx, HorseAppearance.MANES.size() - 1)])
	if mane_idx == HorseAppearance.MANES.size(): mane = Color("e04c52") # rainbow fallback: warm red at this scale
	var dark: Color = coat.darkened(0.25)
	var light: Color = coat.lightened(0.35)
	var graze := Vector2(12, 26) if grazing else Vector2.ZERO
	# soft ground shadow
	draw_colored_polygon(_ellipse(Vector2(0, 38), 40, 8), Color(0, 0, 0, 0.18))
	# tail (behind body)
	draw_colored_polygon(PackedVector2Array([Vector2(-30, -10), Vector2(-46, 0), Vector2(-50, 18), Vector2(-40, 12), Vector2(-30, 4)]), mane)
	# far legs
	draw_rect(Rect2(-18, 8, 9, 26), dark)
	draw_rect(Rect2(12, 8, 9, 26), dark)
	draw_rect(Rect2(-18, 30, 9, 6), Color("4a3428"))
	draw_rect(Rect2(12, 30, 9, 6), Color("4a3428"))
	# body
	draw_colored_polygon(_ellipse(Vector2(0, 0), 34, 19), coat)
	# neck + head (lowered while grazing)
	draw_colored_polygon(PackedVector2Array([Vector2(10, -10), Vector2(28, -36), Vector2(42, -30), Vector2(24, 0)]) , coat)
	var head_c := Vector2(42, -36) + graze
	draw_colored_polygon(_ellipse(head_c, 13, 9, -0.35), coat)
	draw_circle(head_c + Vector2(11, 3), 5.5, light) # muzzle
	draw_colored_polygon(PackedVector2Array([head_c + Vector2(-8, -6), head_c + Vector2(-3, -16), head_c + Vector2(1, -6)]), coat) # ear
	draw_circle(head_c + Vector2(2, -3), 2.2, Color("1b1b1b")) # eye
	# mane along the neck
	draw_colored_polygon(PackedVector2Array([Vector2(28, -38) + graze * 0.6, Vector2(14, -14), Vector2(6, -12), Vector2(22, -40) + graze * 0.6]), mane)
	# near legs
	draw_rect(Rect2(-26, 8, 10, 28), coat)
	draw_rect(Rect2(18, 8, 10, 28), coat)
	draw_rect(Rect2(-26, 32, 10, 6), Color("4a3428"))
	draw_rect(Rect2(18, 32, 10, 6), Color("4a3428"))
	# pattern wash (bounded: Parches/Moteado-style blobs for any non-plain pattern)
	var pattern: int = int(traits.get("pattern", 0))
	if pattern > 0:
		var wash: Color = light if pattern != 2 else dark
		wash.a = 0.85
		var rng := RandomNumberGenerator.new()
		rng.seed = hash("pattern-%d-%d" % [int(traits.get("coat", 10)), pattern])
		var blobs: int = 3 if pattern == 1 else 6
		for i in blobs:
			var p := Vector2(rng.randf_range(-24, 20), rng.randf_range(-12, 10))
			draw_colored_polygon(_ellipse(p, rng.randf_range(5, 9 if pattern == 1 else 5), rng.randf_range(4, 7)), wash)
