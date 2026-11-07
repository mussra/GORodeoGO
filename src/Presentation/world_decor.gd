extends Node2D
## Code-drawn frontier decoration, in the same cartoon spirit as the arena art.
## Deterministic per chunk via WorldMap; kinds: tree, rock, bush, cactus.

var kind: String = "tree"
var size_scale: float = 1.0

func _ready() -> void:
	scale = Vector2.ONE * size_scale
	queue_redraw()

func _draw() -> void:
	match kind:
		"tree":
			draw_rect(Rect2(-5, -6, 10, 26), Color("6d4a2f"))
			draw_circle(Vector2(-12, -18), 16, Color("3f7031"))
			draw_circle(Vector2(12, -16), 14, Color("477c37"))
			draw_circle(Vector2(0, -30), 18, Color("528b3f"))
		"rock":
			draw_colored_polygon(PackedVector2Array([Vector2(-16, 10), Vector2(-12, -6), Vector2(0, -12), Vector2(14, -4), Vector2(16, 10)]), Color("8b96a0"))
			draw_colored_polygon(PackedVector2Array([Vector2(-12, -6), Vector2(0, -12), Vector2(14, -4), Vector2(4, 2)]), Color("9fabb6"))
		"bush":
			draw_circle(Vector2(-8, 2), 10, Color("3f7031"))
			draw_circle(Vector2(7, 0), 12, Color("477c37"))
			draw_circle(Vector2(0, -8), 9, Color("528b3f"))
		"cactus":
			draw_rect(Rect2(-5, -26, 10, 46), Color("3e7d46"))
			draw_rect(Rect2(-16, -14, 8, 18), Color("3e7d46"))
			draw_rect(Rect2(-16, -14, 14, 7), Color("3e7d46"))
			draw_rect(Rect2(8, -20, 8, 16), Color("478a4f"))
			draw_rect(Rect2(2, -20, 14, 7), Color("478a4f"))
