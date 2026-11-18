extends Node
func _ready():run.call_deferred()
func event(e:InputEvent):
 Input.parse_input_event(e.xformed_by(get_viewport().get_final_transform()));Input.flush_buffered_events()
 await get_tree().process_frame
func swipe(scroll:ScrollContainer):
 var p:=scroll.get_global_rect().position+Vector2(240,270)
 var e:=InputEventScreenTouch.new();e.index=0;e.pressed=true;e.position=p;await event(e)
 for i in 10:
  var d:=InputEventScreenDrag.new();d.index=0;d.position=p-Vector2(0,24*(i+1));d.relative=Vector2(0,-24);await event(d)
 e=InputEventScreenTouch.new();e.index=0;e.pressed=false;e.position=p-Vector2(0,240);await event(e)
 await get_tree().create_timer(.1).timeout
func shot(label_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/qa257-"+label_+".png")
func run():
 get_tree().root.size=Vector2i(1600,720);TranslationServer.set_locale("es");GameState.sound_enabled=false;SaveData.save_path="user://qa257.dat";SaveData.equipment_points=240;SaveData.equipment_owned.clear();SaveData.equipment_equipped.clear()
 for context in ["standalone","workshop","scaled"]:
  var room:SaddleryRoom256
  var panel:EquipmentPanel
  if context=="workshop":
   room=SaddleryRoom256.new();add_child(room);room.open_equipment();panel=room.equipment
  else:panel=EquipmentPanel.new();add_child(panel)
  if context=="scaled":get_tree().root.size=Vector2i(1280,720)
  await get_tree().create_timer(.3).timeout
  var scroll:ScrollContainer=panel.find_child("EquipmentList257",true,false)
  await swipe(scroll);assert(scroll.scroll_vertical>150);print(context," DRAG ",scroll.scroll_vertical)
  assert(panel._pending_purchase.is_empty());assert(SaveData.equipment_points==240)
  var wheel:=InputEventMouseButton.new();wheel.position=scroll.get_global_rect().get_center();wheel.button_index=MOUSE_BUTTON_WHEEL_DOWN;wheel.pressed=true
  var before:=scroll.scroll_vertical;await event(wheel);assert(scroll.scroll_vertical>before);print(context," WHEEL ",scroll.scroll_vertical)
  for i in 12:await swipe(scroll)
  assert(absf(scroll.scroll_vertical-(scroll.get_v_scroll_bar().max_value-scroll.get_v_scroll_bar().page))<2);print(context," BOTTOM true")
  await shot(context)
  scroll.scroll_vertical=0;await get_tree().process_frame;await shot(context+"-top")
  var p:Vector2=panel._buy["lasso_small257"].get_global_rect().get_center()
  for down in [true,false]:
   var tap:=InputEventScreenTouch.new();tap.index=0;tap.position=p;tap.pressed=down;await event(tap)
  await get_tree().create_timer(.15).timeout
  assert(panel._confirm.visible);assert(SaveData.equipment_points==240);print(context," TAP_CONFIRM_ONLY true")
  if room!=null:room.free()
  else:panel.free()
  await get_tree().process_frame
 get_tree().quit()
