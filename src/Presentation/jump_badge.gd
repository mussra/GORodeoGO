class_name JumpBadge
extends Button
var capable:bool=false
var skill:String="jump"
func _ready()->void:
 custom_minimum_size=Vector2(64,56);size_flags_vertical=Control.SIZE_SHRINK_CENTER;flat=true
 pressed.connect(show_explanation)
 tooltip_text=tr("DODGE_CAPABLE" if capable else "DODGE_GROUNDED") if skill=="dodge" else (tr("JUMP_CAPABLE") if capable else tr("JUMP_GROUNDED"))
 queue_redraw()
func show_explanation()->void:
 var explanation:=AcceptDialog.new();explanation.title=tr("DODGE_BADGE_TITLE" if skill=="dodge" else "JUMP_BADGE_TITLE");explanation.dialog_text=(tr("DODGE_CAPABLE") if capable else tr("DODGE_GROUNDED")) if skill=="dodge" else (tr("JUMP_CAPABLE") if capable else tr("JUMP_GROUNDED"));explanation.dialog_text=explanation.title+"\n\n"+explanation.dialog_text;explanation.min_size=Vector2i(460,120);explanation.dialog_autowrap=true;add_child(explanation);RanchTheme.style_dialog(explanation,true);explanation.confirmed.connect(explanation.queue_free);explanation.canceled.connect(explanation.queue_free);explanation.popup_centered()
func _draw()->void:
 var ink:Color=Color("f4cf67") if capable else Color("c8d3d5")
 draw_style_box(RanchTheme.box(Color("10252d"),ink,8),Rect2(0,0,64,56))
 if skill=="dodge":
  draw_polyline(PackedVector2Array([Vector2(12,14),Vector2(44,14),Vector2(18,39),Vector2(49,39)]),ink,4,true)
  draw_polyline(PackedVector2Array([Vector2(42,32),Vector2(50,39),Vector2(42,46)]),ink,3,true)
  if not capable:
   draw_line(Vector2(15,10),Vector2(49,47),Color("e9a59b"),4,true)
  return
 # Fence with two posts and rails, horse silhouette above it.
 for x in [15,49]:draw_line(Vector2(x,32),Vector2(x,45),ink,3,true)
 for y in [35,41]:draw_line(Vector2(13,y),Vector2(51,y),ink,2,true)
 draw_line(Vector2(22,21),Vector2(38,18),ink,7,true)
 draw_line(Vector2(38,19),Vector2(42,11),ink,5,true)
 draw_line(Vector2(42,11),Vector2(49,13),ink,5,true)
 draw_line(Vector2(43,11),Vector2(43,6),ink,2,true)
 draw_polyline(PackedVector2Array([Vector2(23,23),Vector2(27,28),Vector2(32,25)]),ink,3,true)
 draw_polyline(PackedVector2Array([Vector2(37,21),Vector2(39,27),Vector2(45,23)]),ink,3,true)
 draw_line(Vector2(21,20),Vector2(15,25),ink,3,true)
 if capable:
  draw_polyline(PackedVector2Array([Vector2(6,15),Vector2(11,9),Vector2(17,8)]),ink,2,true)
  draw_polyline(PackedVector2Array([Vector2(13,5),Vector2(18,8),Vector2(14,12)]),ink,2,true)
 else:
  draw_circle(Vector2(51,42),10,Color("10252d"))
  draw_line(Vector2(46,37),Vector2(56,47),Color("e9a59b"),4,true)
  draw_line(Vector2(56,37),Vector2(46,47),Color("e9a59b"),4,true)

func _has_point(point:Vector2)->bool:
 return Rect2(Vector2.ZERO,Vector2(64,56)).has_point(point)
