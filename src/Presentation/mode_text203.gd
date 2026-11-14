class_name ModeText203
extends RefCounted
## Local to race/joust HUD: larger ink and near-opaque surface, no input capture.
static func apply(label:Label,font_size:int=24)->void:
 label.add_theme_font_size_override("font_size",font_size)
 label.add_theme_color_override("font_color",Color("fff8e8"))
 label.add_theme_color_override("font_shadow_color",Color("071920"))
 label.add_theme_constant_override("shadow_offset_x",1)
 label.add_theme_constant_override("shadow_offset_y",2)
 var box:=RanchTheme.box(Color("102d35",.96),Color("77b9b2"),8)
 box.content_margin_left=12.;box.content_margin_right=12.
 box.content_margin_top=6.;box.content_margin_bottom=6.
 label.add_theme_stylebox_override("normal",box)
 label.mouse_filter=Control.MOUSE_FILTER_IGNORE
