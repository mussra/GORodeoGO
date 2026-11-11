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
	# Filled part keeps the original bright art. Only the unfilled remainder
	# is dimmed, so readiness grows clockwise from twelve, not darkness.
	var face_radius=(minf(size.x,size.y)-6.0)*.37
	var dim=Color(0.05,0.08,0.08,0.72)
	if capable and ratio <= 0.0:
		draw_circle(c,face_radius,dim)
	elif capable and ratio < 1.0:
		draw_colored_polygon(unfilled_sector(c,face_radius,ratio),dim)
	if not capable:
		draw_line(c + Vector2(-r * 0.55, -r * 0.55), c + Vector2(r * 0.55, r * 0.55), Color("e9a59b"), 5.0, true)

static func unfilled_sector(center:Vector2,radius:float,fill:float)->PackedVector2Array:
	var pts=PackedVector2Array([center])
	for i in 29:
		var a=-PI/2.0+lerpf(clampf(fill,0.0,1.0),1.0,float(i)/28.0)*TAU
		pts.append(center+Vector2(cos(a),sin(a))*radius)
	return pts
