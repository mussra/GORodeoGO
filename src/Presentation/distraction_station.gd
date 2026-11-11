class_name DistractionStation
extends Node2D

const TRIGGER_RADIUS: float = 48.0
var kind: String = "water"
var _time: float = 0.0
func _ready() -> void:
	z_index = -2
	if kind=="water":HorseWater.add(self,Rect2(-43,-20,86,45),"trough")
func _process(delta: float) -> void:
	_time += delta
	queue_redraw()
func _draw() -> void:
	draw_ellipse_shadow()
	var texture:Texture2D=preload("res://art/stations/water_trough.svg") if kind=="water" else preload("res://art/stations/hay_round.svg")
	draw_texture_rect(texture,Rect2(-53,-57,106,93),false)
	if kind=="water":
		for i in range(2):
			var y:float=-25+i*3+sin(_time*1.8+i)*.7
			draw_arc(Vector2(-13+i*25,y),5,0.1,2.5,14,Color(.7,.95,.93,.5+sin(_time*2+i)*.15),1.2,true)
	var label: String = tr("AGUA") if kind == "water" else tr("HENO")
	draw_string(ThemeDB.fallback_font, Vector2(-36, -62), label, HORIZONTAL_ALIGNMENT_CENTER, 72, 12, Color("fff1cd"))
func draw_ellipse_shadow() -> void:
	draw_set_transform(Vector2(3, 17), 0, Vector2(1, 0.35))
	draw_circle(Vector2.ZERO, 42, Color(0.2, 0.14, 0.08, 0.2))
	draw_set_transform(Vector2.ZERO)
