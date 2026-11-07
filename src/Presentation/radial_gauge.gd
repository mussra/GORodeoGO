class_name RadialGauge
extends Control
## Clock-fill circular indicator (Ant 11:39/11:40): icon inside (same shapes as
## the ficha badges), radial fill = recharge until next use; dimmed with a cross
## when the horse lacks the ability. Cartoon ring, legible at 1599x719.

var skill: String = "stamina"  # stamina | dodge | jump
var capable: bool = true
var ratio: float = 1.0  # 0..1, 1 = ready

func _ready() -> void:
	custom_minimum_size = Vector2(72, 72)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func set_state(p_capable: bool, p_ratio: float) -> void:
	if capable == p_capable and is_equal_approx(ratio, p_ratio):
		return
	capable = p_capable
	ratio = clampf(p_ratio, 0.0, 1.0)
	queue_redraw()

func _draw() -> void:
	var c: Vector2 = size * 0.5
	var r: float = minf(size.x, size.y) * 0.5 - 3.0
	var ink: Color = Color("f4cf67") if capable else Color("c8d3d5")
	if skill == "stamina":
		ink = Color("8fd07a") if ratio > 0.35 else Color("f4cf67")
	# ring + face
	draw_circle(c, r, Color("10252d"))
	draw_circle(c, r - 3.0, Color("f8edce") if capable else Color("d8d2c4"))
	# clock fill from the top
	if capable and ratio < 0.999:
		var pts := PackedVector2Array([c])
		var steps: int = 28
		for i in range(steps + 1):
			var a: float = -PI / 2.0 + ratio * TAU * float(i) / steps
			pts.append(c + Vector2(cos(a), sin(a)) * (r - 4.0))
		draw_colored_polygon(pts, Color(0.15, 0.35, 0.4, 0.45))
	elif capable:
		draw_circle(c, r - 4.0, Color(0.15, 0.35, 0.4, 0.18))
	_draw_icon(c, r, ink)
	if not capable:
		draw_line(c + Vector2(-r * 0.55, -r * 0.55), c + Vector2(r * 0.55, r * 0.55), Color("e9a59b"), 5.0, true)

func _draw_icon(c: Vector2, r: float, ink: Color) -> void:
	var s: float = r / 26.0  # icons sketched on a 52px grid, scaled
	var o: Vector2 = c - Vector2(26, 26) * s
	var P := func(x: float, y: float) -> Vector2: return o + Vector2(x, y) * s
	match skill:
		"stamina":
			# energy bolt
			draw_colored_polygon(PackedVector2Array([P.call(30, 8), P.call(18, 30), P.call(26, 30), P.call(22, 46), P.call(36, 24), P.call(28, 24)]), ink)
		"dodge":
			draw_polyline(PackedVector2Array([P.call(12, 14), P.call(44, 14), P.call(18, 39), P.call(49, 39)]), ink, 4.0 * s, true)
			draw_polyline(PackedVector2Array([P.call(42, 32), P.call(50, 39), P.call(42, 46)]), ink, 3.0 * s, true)
		"jump":
			for x in [15, 49]:
				draw_line(P.call(x, 32), P.call(x, 45), ink, 3.0 * s, true)
			for y in [35, 41]:
				draw_line(P.call(13, y), P.call(51, y), ink, 2.0 * s, true)
			draw_line(P.call(22, 21), P.call(38, 18), ink, 7.0 * s, true)
			draw_line(P.call(38, 19), P.call(42, 11), ink, 5.0 * s, true)
			draw_line(P.call(42, 11), P.call(49, 13), ink, 5.0 * s, true)
			draw_polyline(PackedVector2Array([P.call(23, 23), P.call(27, 28), P.call(32, 25)]), ink, 3.0 * s, true)
			draw_polyline(PackedVector2Array([P.call(37, 21), P.call(39, 27), P.call(45, 23)]), ink, 3.0 * s, true)
			draw_line(P.call(21, 20), P.call(15, 25), ink, 3.0 * s, true)
