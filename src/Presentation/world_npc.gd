class_name WorldNpc
extends Node2D
## Explicit temporary marker. No generated portrait or claimed finished farmer art.
var definition:Dictionary
func setup(data:Dictionary):definition=data;position=data.position
func _ready():
 var marker=Label.new();marker.text="!";marker.position=Vector2(-10,-65);marker.add_theme_font_size_override("font_size",38);marker.modulate=Color("f4cf67");add_child(marker)
 var nameplate=Label.new();nameplate.text=definition.name+"\n[PNJ provisional]";nameplate.position=Vector2(-75,-10);nameplate.add_theme_font_size_override("font_size",16);add_child(nameplate)
