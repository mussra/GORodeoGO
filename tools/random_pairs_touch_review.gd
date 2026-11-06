extends SceneTree
func _initialize()->void:call_deferred("run")
func tap(at:Vector2)->void:
 var e:=InputEventScreenTouch.new();e.index=0;e.position=at;e.pressed=true;Input.parse_input_event(e)
 for i in range(2):await process_frame
 e=InputEventScreenTouch.new();e.index=0;e.position=at;e.pressed=false;Input.parse_input_event(e)
 for i in range(5):await process_frame
func run()->void:
 var save:Node=root.get_node("SaveData");var gs:Node=root.get_node("GameState");gs.brand_intro_played=true
 var original:Dictionary=save.horse_collection.export_state();var before:=FileAccess.get_file_as_bytes(save.save_path)
 assert(save.begin_trial_session())
 var panel:Control=load("res://src/Presentation/horse_panel.gd").new();root.add_child(panel)
 for i in range(8):await process_frame
 var start:int=save.horse_collection.horses.size()
 for i in range(12):await tap(Vector2(960,100));assert(save.horse_collection.horses.size()==start+2*(i+1))
 var child:Dictionary=save.breed_horses("trial_a","trial_b",{});assert(not child.is_empty())
 for i in range(8):await tap(Vector2(960,100))
 assert(save.horse_collection.horses.size()==start+41)
 var scroll:ScrollContainer=null
 for n in panel.content.get_children():
  if n is ScrollContainer:scroll=n
 assert(scroll!=null)
 scroll.scroll_vertical=scroll.get_v_scroll_bar().max_value
 await create_timer(.25).timeout
 assert(scroll.scroll_vertical>1500)
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/random-pairs-long-list.png")
 assert(FileAccess.get_file_as_bytes(save.save_path)==before)
 panel.queue_free();await process_frame
 save.end_trial_session();assert(save.horse_collection.export_state()==original);assert(FileAccess.get_file_as_bytes(save.save_path)==before)
 print("RANDOM_PAIR_SCREENTOUCH_20_PRESSES_AFTER_BREEDING_SCROLL_SAVEBYTES_PASS")
 quit()
