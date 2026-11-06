extends SceneTree
func _initialize()->void:call_deferred("run")
func tap(at:Vector2)->void:
 var event:=InputEventScreenTouch.new();event.index=0;event.position=at;event.pressed=true;Input.parse_input_event(event)
 for i in range(3):await process_frame
 event=InputEventScreenTouch.new();event.index=0;event.position=at;event.pressed=false;Input.parse_input_event(event)
 for i in range(6):await process_frame
func run()->void:
 var save:Node=root.get_node("SaveData");var gs:Node=root.get_node("GameState");gs.brand_intro_played=true
 var before:PackedByteArray=FileAccess.get_file_as_bytes(save.save_path)
 var menu:Node=load("res://src/Presentation/main_menu.tscn").instantiate();root.add_child(menu);current_scene=menu
 for i in range(90):await process_frame
 await tap(Vector2(320,650));assert(save.trial_session_active,"ScreenTouch opens isolated session")
 await tap(Vector2(300,390));assert(save.horse_collection.selected=="preview_temporary","ScreenTouch applies aspect")
 await tap(Vector2(300,210))
 var hp:Node=null
 for child in current_scene.get_children():
  for sub in child.get_children():
   if sub.get_script()!=null and sub.get_script().resource_path.ends_with("horse_panel.gd"):hp=sub
 assert(hp!=null and hp.visible,"ScreenTouch opens horse panel")
 await tap(Vector2(1140,45))
 assert(not hp.visible,"ScreenTouch closes horse panel")
 await tap(Vector2(600,580))
 for i in range(20):await process_frame
 assert(current_scene.scene_file_path.ends_with("level_0.tscn"),"ScreenTouch play enters level")
 change_scene_to_file("res://src/Presentation/main_menu.tscn")
 for i in range(90):await process_frame
 assert(not save.trial_session_active)
 await tap(Vector2(320,650));assert(save.trial_session_active)
 await tap(Vector2(600,660))
 for i in range(20):await process_frame
 assert(not save.trial_session_active,"ScreenTouch exit restores normal")
 assert(FileAccess.get_file_as_bytes(save.save_path)==before)
 print("SCREEN_TOUCH_ENTRY_ASPECT_HORSES_BACK_PLAY_EXIT_PASSED bytes=",before.size())
 quit()
