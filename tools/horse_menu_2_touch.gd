extends SceneTree
var panel:Node
func _initialize()->void:call_deferred("run")
func frames()->void:
 for i in range(4):await process_frame
func tap(point:Vector2)->void:
 for pressed in [true,false]:
  var event:=InputEventScreenTouch.new();event.index=0;event.position=point;event.pressed=pressed;Input.parse_input_event(event);Input.flush_buffered_events();await frames()
func run()->void:
 Input.use_accumulated_input=false
 var sd:Node=root.get_node("SaveData");sd.save_path="user://menu2_touch.dat";sd.horse_collection=HorseCollection.new();sd.horse_collection.seed_trial();sd.horse_collection.add_trial_parents()
 panel=load("res://src/Presentation/horse_panel.gd").new();root.add_child(panel);await frames()
 panel.show_page("atlas");await frames();await tap(Vector2(1050,190));assert(not panel.atlas_owned_first)
 await tap(Vector2(1050,190));assert(panel.atlas_owned_first)
 await tap(Vector2(380,290));assert(panel.page=="detail");assert(panel.focus_id=="trial_a")
 for node in panel.content.get_children():
  if node is LineEdit:node.text="Pepe"
 await tap(Vector2(320,508));assert(sd.horse_collection.find("trial_a").name=="Pepe")
 await tap(Vector2(200,568));assert(sd.horse_collection.selected=="trial_a")
 sd.load_progress();assert(sd.horse_collection.selected=="trial_a");assert(sd.horse_collection.find("trial_a").name=="Pepe")
 panel.show_page("breed");await frames()
 for node in panel.content.get_children():
  if node is OptionButton:
   assert(node.get_item_icon(0)!=null);assert(node.get_item_icon(1)!=null)
 print("HORSE_MENU2_TOUCH_PASS sorting profile rename equip persist thumbnails")
 DirAccess.remove_absolute(sd.save_path);quit()
