class_name QuestButtonStyle
extends RefCounted
static func apply(button:Button):
 # Same footprint, opaque gold face, warm border and dark readable lettering.
 for state in ["normal","hover","pressed"]:
  var box=RanchTheme.box(Color("efb950") if state=="normal" else Color("ffe09a") if state=="hover" else Color("d99b35"),Color("704122"),10)
  box.content_margin_top=5;box.content_margin_bottom=5;box.shadow_color=Color(0,0,0,.28);box.shadow_size=3;box.shadow_offset=Vector2(0,2)
  button.add_theme_stylebox_override(state,box)
 for state in ["font_color","font_hover_color","font_pressed_color"]:button.add_theme_color_override(state,Color("342313"))
 button.add_theme_font_size_override("font_size",20)
 var focus=RanchTheme.box(Color(1,1,1,.05),Color("fff1d2"),10);focus.set_border_width_all(3);button.add_theme_stylebox_override("focus",focus)
