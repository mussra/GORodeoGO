class_name RadialGauge
extends Control
## Shared circular indicator using Ant's supplied clock art (11 November).
## Dynamic clock fill retains the existing ratio and availability rules.

const ART={
 "stamina":preload("res://art/ui/skills/stamina.png"),
 "dodge":preload("res://art/ui/skills/dodge.png"),
 "jump":preload("res://art/ui/skills/jump.png")}
var skill: String = "stamina"  # stamina | dodge | jump
var capable: bool = true
var ratio: float = 1.0  # 0..1, 1 = ready

func _ready() -> void:
	visible=capable
	custom_minimum_size = Vector2(72, 72)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func set_state(p_capable: bool, p_ratio: float) -> void:
	visible=p_capable
	if capable == p_capable and is_equal_approx(ratio, p_ratio):
		return
	capable = p_capable
	ratio = clampf(p_ratio, 0.0, 1.0)
	queue_redraw()

func _draw() -> void:
	var c: Vector2 = size * 0.5
	var r: float = minf(size.x, size.y) * 0.5 - 3.0
	# Ant's supplied clock, cropped only; same shared indicator in both modes.
	var art:Texture2D=ART.get(skill,ART.stamina)
	draw_texture_rect(art,Rect2(Vector2(3,3),size-Vector2(6,6)),false)
	# clock fill from the top
	if capable and ratio < 0.999:
		var pts := PackedVector2Array([c])
		var steps: int = 28
		for i in range(steps + 1):
			var a: float = -PI / 2.0 + ratio * TAU * float(i) / steps
			pts.append(c + Vector2(cos(a), sin(a)) * (minf(size.x,size.y)-6.0)*.37)
		draw_colored_polygon(pts, Color(0.15, 0.35, 0.4, 0.45))
	elif capable:
		draw_circle(c, (minf(size.x,size.y)-6.0)*.37, Color(0.15, 0.35, 0.4, 0.18))
	if not capable:
		draw_line(c + Vector2(-r * 0.55, -r * 0.55), c + Vector2(r * 0.55, r * 0.55), Color("e9a59b"), 5.0, true)
