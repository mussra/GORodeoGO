class_name JumpBadge
extends Button
var capable:bool=false
var skill:String="jump"
## Only the whip case ever notifies: dodge learned and no whip equipped.
var whip_equipped:bool=true
func _ready()->void:
 custom_minimum_size=Vector2(64,56);flat=true
 pressed.connect(show_explanation)
 tooltip_text=tr("DODGE_CAPABLE" if capable else "DODGE_GROUNDED") if skill=="dodge" else (tr("JUMP_CAPABLE") if capable else tr("JUMP_GROUNDED"))
 queue_redraw()
func explanation_text()->String:
 return (tr("DODGE_CAPABLE") if capable else tr("DODGE_GROUNDED")) if skill=="dodge" else (tr("JUMP_CAPABLE") if capable else tr("JUMP_GROUNDED"))
func explanation_title()->String:
 return tr("DODGE_BADGE_TITLE" if skill=="dodge" else "JUMP_BADGE_TITLE")
## Non-blocking notice: the modal dialog made the whole stable look frozen on
## the phone and hid the FICHA the rider was trying to open. This is a plain
## visual overlay: it never sees input, so FICHA and every other button keep
## responding, and it fades out by itself.
func make_notice()->PanelContainer:
 var notice:=PanelContainer.new();notice.top_level=true;notice.mouse_filter=Control.MOUSE_FILTER_IGNORE;notice.z_index=4096;notice.z_as_relative=false
 notice.add_theme_stylebox_override("panel",RanchTheme.box(Color("10252dd9"),Color("f4cf67"),8))
 var lb:=Label.new();lb.text=explanation_title()+": "+explanation_text();lb.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;lb.custom_minimum_size=Vector2(280,0);lb.mouse_filter=Control.MOUSE_FILTER_IGNORE
 notice.add_child(lb)
 return notice
func show_explanation()->void:
 # Antonio 10:02: no whip nagging. The dodge badge only explains the missing
 # whip; with a whip equipped (or dodge not learned) a tap shows nothing.
 if skill=="dodge" and (not capable or whip_equipped):return
 var notice:=make_notice()
 get_tree().root.add_child(notice) # outside the scroll hierarchy: no clipping, no input grab
 notice.size=notice.get_combined_minimum_size()
 var at:=global_position+Vector2(size.x+8,-64.0)
 var view:=get_viewport_rect().size
 at.x=clampf(at.x,8.0,view.x-notice.size.x-8.0);at.y=clampf(at.y,8.0,view.y-notice.size.y-8.0)
 notice.global_position=at
 var tween:=notice.create_tween() # bound to the notice: row rebuilds free the badge, not the fade
 tween.tween_interval(2.2);tween.tween_property(notice,"modulate:a",0.0,0.4);tween.tween_callback(notice.queue_free)
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
