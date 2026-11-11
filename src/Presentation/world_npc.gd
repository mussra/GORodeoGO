class_name WorldNpc
extends Node2D
## Farmer artwork supplied by Ant, 11 November 2026; shared with quest portrait.
const PORTRAIT=preload("res://art/npc/farmer.png")
var definition:Dictionary
func setup(data:Dictionary):definition=data;position=data.position
func _ready():
 var shadow=Polygon2D.new();var points=PackedVector2Array()
 for i in 24:points.append(Vector2(cos(i*TAU/24)*18,sin(i*TAU/24)*6))
 shadow.polygon=points;shadow.color=Color(0,0,0,.2);add_child(shadow)
 var figure=Sprite2D.new();figure.name="FarmerArt";figure.texture=PORTRAIT;figure.scale=Vector2.ONE*(90.0/1536.0);figure.position=Vector2(0,-43);add_child(figure)
 var marker=Label.new();marker.text="!";marker.position=Vector2(-7,-123);marker.add_theme_font_size_override("font_size",30);marker.modulate=Color("f4cf67");add_child(marker)
 var nameplate=Label.new();nameplate.text=definition.name;nameplate.position=Vector2(-35,6);nameplate.add_theme_font_size_override("font_size",16);add_child(nameplate)
