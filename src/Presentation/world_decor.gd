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
		"pine":
			draw_rect(Rect2(-4, 2, 8, 18), Color("6d4a2f"))
			draw_colored_polygon(PackedVector2Array([Vector2(-22, 8), Vector2(0, -18), Vector2(22, 8)]), Color("2f5d33"))
			draw_colored_polygon(PackedVector2Array([Vector2(-17, -8), Vector2(0, -30), Vector2(17, -8)]), Color("386d3b"))
			draw_colored_polygon(PackedVector2Array([Vector2(-12, -22), Vector2(0, -42), Vector2(12, -22)]), Color("417d44"))
		"fruit_tree":
			draw_rect(Rect2(-5, -6, 10, 26), Color("6d4a2f"))
			draw_circle(Vector2(-10, -16), 15, Color("3f7031"))
			draw_circle(Vector2(11, -14), 13, Color("477c37"))
			draw_circle(Vector2(0, -28), 16, Color("528b3f"))
			for apple in [Vector2(-8, -20), Vector2(6, -30), Vector2(12, -14), Vector2(-2, -12)]:
				draw_circle(apple, 3.5, Color("d94f3d"))
		"flower":
			for f in [Vector2(-8, 0), Vector2(6, -4), Vector2(0, 6)]:
				for p in 5:
					var a: float = p * TAU / 5.0
					draw_circle(f + Vector2(cos(a), sin(a)) * 4.0, 2.6, Color("e86a8a"))
				draw_circle(f, 2.4, Color("f2d987"))
		"cactus":
			draw_rect(Rect2(-5, -26, 10, 46), Color("3e7d46"))
			draw_rect(Rect2(-16, -14, 8, 18), Color("3e7d46"))
			draw_rect(Rect2(-16, -14, 14, 7), Color("3e7d46"))
			draw_rect(Rect2(8, -20, 8, 16), Color("478a4f"))
			draw_rect(Rect2(2, -20, 14, 7), Color("478a4f"))
