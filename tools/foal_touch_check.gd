extends SceneTree
func _initialize()->void:call_deferred("run")
func tap(pos:Vector2)->void:
 for pressed in [true,false]:
  var e:=InputEventScreenTouch.new();e.index=0;e.position=pos;e.pressed=pressed;Input.parse_input_event(e)
  for i in range(4):await process_frame
func run()->void:
 var save:Node=root.get_node("SaveData");assert(save.begin_trial_session())
 var before:PackedByteArray=FileAccess.get_file_as_bytes(save.save_path)
 var panel:Node=load("res://src/Presentation/horse_panel.gd").new();root.add_child(panel);await process_frame
 panel.parent_b="trial_a"
 await tap(Vector2(380,98));assert(panel.page=="breed")
 var count:int=save.horse_collection.horses.size()
 await tap(Vector2(600,590));assert(save.horse_collection.horses.size()==count+1)
 panel.page="detail";panel.refresh() # setup newly created foal detail, all navigation after uses touch
 await tap(Vector2(630,595));assert(panel.page=="family")
 await tap(Vector2(1100,445));assert(panel.focus_id=="trial_a")
 await tap(Vector2(1150,45));assert(not panel.visible)
 assert(FileAccess.get_file_as_bytes(save.save_path)==before);save.end_trial_session()
 print("FOAL_SCREEN_TOUCH_BREED_CREATE_DETAIL_FAMILY_PARENT_BACK_PASSED");quit()
