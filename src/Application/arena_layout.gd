class_name ArenaLayout
extends RefCounted

## Prototype progression: early arenas untouched, puzzle arenas grow without
## inflating the rider, bull bodies, goal, or physical gate widths.
static func scale_for_level(level: int) -> float:
	return 1.0 if level < 15 else 1.65 + .09 * clampi(level - 15, 0, 5)

static func bounds_for_level(level: int) -> Rect2:
	var scale: float = scale_for_level(level)
	return Rect2(Vector2(-480,-270) * scale, Vector2(960,540) * scale)

static func spread_corral(layout: Dictionary, scale: float) -> Dictionary:
	var moved: Dictionary = layout.duplicate(true)
	var shift: Vector2 = (layout["rect"] as Rect2).get_center() * (scale - 1.0)
	moved["rect"] = Rect2(layout["rect"].position + shift, layout["rect"].size)
	moved["gate"] += shift
	moved["door"] += shift
	# Compact puzzle arenas (11-14): keep latch radius clear of destination pen.
	# Expanded arenas retain the original latch and all memberships/gates.
	if is_equal_approx(scale,1.0):moved["door"].y -= 11.0 * float(layout["inward"])
	for i in range(moved["slots"].size()): moved["slots"][i] += shift
	return moved

static func edge_point(target: Vector2, screen: Rect2) -> Vector2:
	var center: Vector2 = screen.get_center()
	var direction: Vector2 = target - center
	var half: Vector2 = screen.size / 2
	var factor: float = maxf(absf(direction.x) / half.x, absf(direction.y) / half.y)
	return center + direction / maxf(1.0, factor)
