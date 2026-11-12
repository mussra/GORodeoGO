class_name FlowerQuestGlyph105
extends Control
var color:Color=Color("68cfff")
var caption:String=""
func _ready()->void:
 custom_minimum_size=Vector2(190,68);mouse_filter=Control.MOUSE_FILTER_IGNORE
 var label=Label.new();label.text=caption;label.position=Vector2(65,20);label.add_theme_font_size_override("font_size",18);add_child(label)
func _draw()->void:WorldFlowerTarget105.glyph(self,Vector2(32,32),19.,color)
