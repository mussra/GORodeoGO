class_name MenuBackdrop
extends Control
var clock: float = 0.0
func _ready() -> void: mouse_filter = Control.MOUSE_FILTER_IGNORE
func _process(delta: float) -> void:
	clock += delta
	queue_redraw()
func _draw() -> void:
	var s: Vector2 = size
	draw_rect(Rect2(Vector2.ZERO, s), Color("0b1822"))
	# Layered angular landscape, not an unrelated sci-fi wallpaper.
	draw_polygon(PackedVector2Array([Vector2(s.x*0.43,0),Vector2(s.x,0),s,Vector2(s.x*0.26,s.y)]),PackedColorArray([Color("102d36")]))
	for i in range(15):
		var y: float = s.y * 0.60 + pow(float(i)/14,2)*s.y*.4
		draw_line(Vector2(0,y),Vector2(s.x,y),Color(0.25,0.75,0.72,0.10),1)
	for i in range(-8,16):
		draw_line(Vector2(s.x*.72,s.y*.55),Vector2(i*s.x/8,s.y),Color(0.25,0.75,0.72,0.10),1)
	var center := Vector2(s.x*.76,s.y*.61)
	for r: float in [130,155,180]:
		draw_set_transform(center,0,Vector2(1,.35))
		draw_arc(Vector2.ZERO,r,clock*.12,clock*.12+TAU*.85,80,Color(0.4,0.9,0.82,.35),2,true)
	draw_set_transform(Vector2.ZERO)
	# Distant ranch ridge and fence silhouette.
	var ridge := PackedVector2Array([Vector2(0,s.y*.65),Vector2(s.x*.12,s.y*.53),Vector2(s.x*.25,s.y*.60),Vector2(s.x*.4,s.y*.48),Vector2(s.x*.6,s.y*.62),Vector2(s.x*.82,s.y*.49),Vector2(s.x,s.y*.58),s,Vector2(0,s.y)])
	draw_polygon(ridge,PackedColorArray([Color(0.03,.10,.14,.5)]))
	for i in range(22):
		var x: float = i*s.x/21
		draw_line(Vector2(x,s.y*.70),Vector2(x,s.y*.76),Color("1c3d44"),4)
	draw_line(Vector2(0,s.y*.72),Vector2(s.x,s.y*.72),Color("1c3d44"),3)
	for i in range(18):
		var p := Vector2(fposmod(i*97.0+clock*(4+i%3),s.x),fposmod(i*53.0-clock*(3+i%4),s.y))
		draw_circle(p,1.3,Color(.6,.9,.8,.25))
