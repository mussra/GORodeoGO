class_name CartoonBackdrop
extends Control
var clock: float = 0.0
func _ready() -> void: mouse_filter = Control.MOUSE_FILTER_IGNORE
func _process(delta: float) -> void:
	clock += delta
	queue_redraw()
func _draw() -> void:
	var s: Vector2 = size
	draw_rect(Rect2(Vector2.ZERO,s),Color("71c8db"))
	var c := Vector2(s.x*.49,s.y*.40)
	for i in range(12):
		var angle: float = i*TAU/12 + clock*.012
		var pts := PackedVector2Array([c,c+Vector2.from_angle(angle)*s.x*2,c+Vector2.from_angle(angle+.13)*s.x*2])
		draw_polygon(pts,PackedColorArray([Color(1,1,1,.09)]))
	draw_circle(Vector2(s.x*.83,s.y*.15),50,Color("ffe5a1"))
	var hill := PackedVector2Array([Vector2(0,s.y*.65),Vector2(s.x*.22,s.y*.48),Vector2(s.x*.5,s.y*.69),Vector2(s.x*.75,s.y*.54),Vector2(s.x,s.y*.64),s,Vector2(0,s.y)])
	draw_polygon(hill,PackedColorArray([Color("66afa4")]))
	draw_rect(Rect2(0,s.y*.76,s.x,s.y*.24),Color("eac987"))
	# Broad stage with front face and a thick outline.
	var center := Vector2(s.x*.49,s.y*.73)
	draw_set_transform(center,0,Vector2(1,.32))
	draw_circle(Vector2(0,38),224,Color("283d48"))
	draw_circle(Vector2(0,25),216,Color("b78150"))
	draw_circle(Vector2.ZERO,224,Color("283d48"))
	draw_circle(Vector2.ZERO,216,Color("fff0c4"))
	draw_arc(Vector2.ZERO,194,0,TAU,80,Color("e4ba75"),4,true)
	draw_set_transform(Vector2.ZERO)
