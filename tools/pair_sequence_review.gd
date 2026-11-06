extends SceneTree
func _initialize()->void:call_deferred("run")
func find_button(n:Node,text:String)->Button:
 if n is Button and n.text==text:return n
 for c in n.get_children():
  var b:=find_button(c,text)
  if b!=null:return b
 return null
func tap(at:Vector2)->void:
 var e:=InputEventScreenTouch.new();e.index=0;e.position=at;e.pressed=true;Input.parse_input_event(e)
 for i in range(3):await process_frame
 e=InputEventScreenTouch.new();e.index=0;e.position=at;e.pressed=false;Input.parse_input_event(e)
 for i in range(8):await process_frame
func run()->void:
 var save:Node=root.get_node("SaveData");save.save_path="user://qa_pair_sequence.dat"
 save.horse_collection=HorseCollection.new();save.horse_collection.seed_trial();save.horse_collection.add_trial_parents();save.horse_collection.grant_achievement(1);save.save_progress()
 var original:Dictionary=save.horse_collection.export_state();var bytes:=FileAccess.get_file_as_bytes(save.save_path)
 var panel:Control=load("res://src/Presentation/horse_panel.gd").new();root.add_child(panel);await process_frame
 for expected in [6,8]:
  await tap(Vector2(960,100))
  print("UI_PAIR_COUNT ",save.horse_collection.horses.size()," EXPECTED ",expected)
  assert(save.horse_collection.horses.size()==expected)
  for h in original.horses:assert(save.horse_collection.find(h.id)==h)
  await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/pair-sequence-%d.png"%expected)
 assert(FileAccess.get_file_as_bytes(save.save_path)==bytes);save.end_trial_session();assert(save.horse_collection.export_state()==original)
 print("UI_PAIR_SEQUENCE_ISOLATION_PASS");quit()
