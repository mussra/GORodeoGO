class_name PuzzleCorralLayout
extends RefCounted

## Space for three bulls with radius24, a70-wide physical gate and outside latch.
## Links and bull membership remain the catalog's; only puzzle placement changes.
static func build(count: int, index: int, bull_count: int) -> Dictionary:
	var columns: int = 2 if count <= 4 else 4
	var column: int = index % columns
	var row: int = index / columns
	var x: float = (-320.0 + column * 640.0) if columns == 2 else (-360.0 + column * 240.0)
	var y: float = -178.0 if row == 0 else 178.0
	var center := Vector2(x, y)
	var size := Vector2(maxf(190, bull_count * 58 + 16), 136)
	var inward: float = 1.0 if row == 0 else -1.0
	var gate := center + Vector2(0, inward * size.y / 2)
	var slots: Array = []
	for i in range(bull_count):
		slots.append(center + Vector2((i - (bull_count - 1) / 2.0) * 58, 0))
	return {"rect": Rect2(center - size / 2, size), "gate": gate, "door": gate + Vector2(0, inward * 35), "slots": slots, "inward": inward}
