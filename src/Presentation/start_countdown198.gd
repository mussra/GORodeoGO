class_name StartCountdown198
extends Label
## Non-interactive central 3-2-1; does not cover aim input or change time scale.
var session:Node
var go_left:float=0.
var was_waiting:bool=false
func _ready()->void:
 mouse_filter=Control.MOUSE_FILTER_IGNORE
 horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
 add_theme_font_size_override("font_size",74)
 add_theme_color_override("font_color",Color("fff1cc"))
 add_theme_color_override("font_shadow_color",Color("10262c"))
 add_theme_constant_override("shadow_offset_x",4);add_theme_constant_override("shadow_offset_y",4)
 set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
 offset_left=-200.;offset_right=200.;offset_top=100.;offset_bottom=220.
func _process(delta:float)->void:
 var waiting:bool=session.countdown>0.
 if session.has_method("prestart_aim198") and waiting:waiting=session.prestart_aim198()
 if waiting:
  text=str(ceili(session.countdown));was_waiting=true;go_left=.65;show()
 elif was_waiting and session.running and go_left>0.:
  go_left=maxf(0.,go_left-delta);text="¡YA!";show()
 else:
  hide()
  if not session.running:was_waiting=false
