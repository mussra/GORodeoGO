extends Node2D
## The ranch anchor of the frontier: house, corral rails and the job board sign.
## Code-drawn, same cartoon spirit as world_decor.

func _draw() -> void:
	# Corral rails around the home meadow (radius ~RANCH_CLEAR_RADIUS).
	for i in range(28):
		var a: float = TAU * float(i) / 28.0
		var p: Vector2 = Vector2(cos(a), sin(a)) * 300.0
		if p.y > 120.0 and absf(p.x) < 120.0:
			continue  # gate opening towards the south meadow
		draw_rect(Rect2(p - Vector2(14, 4), Vector2(28, 8)), Color("7a5230"))
	# Ranch house.
	draw_rect(Rect2(-120, -210, 150, 90), Color("9c6b3f"))
	draw_colored_polygon(PackedVector2Array([Vector2(-132, -210), Vector2(-45, -262), Vector2(42, -210)]), Color("6d4a2f"))
	draw_rect(Rect2(-66, -168, 30, 48), Color("4c3b2a"))
	draw_rect(Rect2(-110, -196, 26, 22), Color("f2e3b3"))
	# Job board sign at the gate.
	draw_rect(Rect2(140, -8, 10, 58), Color("6d4a2f"))
	draw_rect(Rect2(106, -52, 78, 48), Color("8a5a33"))
	draw_rect(Rect2(112, -46, 66, 36), Color("c8a86b"))
	draw_line(Vector2(120, -36), Vector2(170, -36), Color("6d4a2f"), 3.0)
	draw_line(Vector2(120, -26), Vector2(160, -26), Color("6d4a2f"), 3.0)
