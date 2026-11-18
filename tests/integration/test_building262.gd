extends GutTest
var snapshot264:Dictionary={}
var horses264:Dictionary={}
func before_each():
 for property in SaveData.get_script().get_script_property_list():
  var value:Variant=SaveData.get(property.name);snapshot264[property.name]=value.duplicate(true) if value is Dictionary or value is Array else value
 horses264=SaveData.horse_collection.export_state().duplicate(true)
 SaveData.save_path="user://building264-isolated.cfg";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.interior_search264={}
func after_each():
 DirAccess.remove_absolute(SaveData.save_path)
 for key in snapshot264:SaveData.set(key,snapshot264[key])
 SaveData.horse_collection.restore(horses264)
 await wait_process_frames(2)

func test_florist_prototype_explicitly_separates_inspection_and_ownership():
 var points:int=SaveData.equipment_points;var quests:Dictionary=SaveData.world_quests.duplicate(true)
 var room:=FloristRoom262.new();add_child(room);await wait_process_frames(3)
 assert_false(room.prototype);assert_eq(room.objects.get_child_count(),3)
 room.objects.get_child(0).pressed.emit();assert_true(room.message.text.contains("no se recogen"))
 room.objects.get_child(1).pressed.emit();assert_true(room.message.text.contains("Si te interesa algo"));assert_false(room.message.text.to_lower().contains("regalo"))
 room.objects.get_child(2).pressed.emit();assert_true(room.message.text.contains("habla conmigo"))
 assert_eq(SaveData.equipment_points,points);assert_eq(SaveData.world_quests,quests)
 room._talk();await wait_process_frames(2);assert_true(is_instance_valid(room.dialog));room.pending264.clear();room.finish();await wait_process_frames(2)
func test_exit_emits_once_and_room_fits_small_viewport():
 var room:=FloristRoom262.new();add_child(room);await wait_process_frames(2);watch_signals(room)
 room._fit();assert_gt(room.canvas.scale.x,0.);room.finish();room.finish();assert_signal_emit_count(room,"closed",1);await wait_process_frames(2)

func test_shared_search_uses_site_not_ui_and_only_emits_discovery():
 var room:=FloristRoom262.new();add_child(room);room.room_id264="";await wait_process_frames(2);watch_signals(room)
 room.add_search_site264("empty",Rect2(500,400,80,60));room.add_search_site264("owned",Rect2(600,400,80,60),"ribbon","owner")
 var original:String=room.message.text
 for n in 3:room.search_buttons264["empty"].pressed.emit()
 assert_eq(room.message.text,original);room.search_buttons264["empty"].pressed.emit();assert_eq(room.message.text,InteriorSearch264.EMPTY_HINT)
 room.search_buttons264["owned"].pressed.emit();assert_true(room.message.text.contains("Le mostraré"));assert_signal_emit_count(room,"collectible_found264",1)
 for n in 4:room.search_buttons264["owned"].pressed.emit()
 assert_eq(room.message.text,InteriorSearch264.EXHAUSTED_HINT);assert_signal_emit_count(room,"collectible_found264",1)
 room.pending264.clear();room.finish();await wait_process_frames(2)

func test_collectibles_cannot_overlap_exit_or_other_reserved_ui():
 var room:=FloristRoom262.new();add_child(room);await wait_process_frames(2)
 assert_false(room.add_search_site264("bad_exit",Rect2(220,650,50,40),"bad"))
 assert_false(room.add_search_site264("bad_actions",Rect2(100,530,40,40),"bad"))
 for region in room.search_regions264.values():
  for reserved in room.reserved_ui264:assert_false(reserved.intersects(region))
 room.pending264.clear();room.finish();await wait_process_frames(2)
func test_exit_with_findings_converses_without_transferring_ownership():
 var room:=FloristRoom262.new();add_child(room);await wait_process_frames(2);room.room_id264="";watch_signals(room)
 room.search264.sites.worktable.found=false;room.search_site264("worktable");room.finish();await wait_process_frames(2)
 assert_true(is_instance_valid(room.exit_dialog264));assert_signal_not_emitted(room,"closed")
 room.exit_dialog264.closed.emit();assert_signal_emitted(room,"closed");await wait_process_frames(2)

func test_found_and_pending_are_saved_across_exit_and_reload():
 var path_before:String=SaveData.save_path;var state_before:=SaveData.interior_search264.duplicate(true)
 SaveData.save_path="user://search264-test.cfg";SaveData.interior_search264={}
 var room:=FloristRoom262.new();add_child(room);await wait_process_frames(2)
 assert_eq(room.search_site264("worktable").kind,"found");assert_true(FileAccess.file_exists(SaveData.save_path));room.queue_free();await wait_process_frames(2)
 SaveData.interior_search264={};SaveData.load_progress();assert_true(SaveData.interior_search264.has("home:florist"))
 var next:=FloristRoom262.new();add_child(next);await wait_process_frames(2)
 assert_true(next.search264.sites.worktable.found);assert_eq(next.pending264,["worktable"]);next.finish();await wait_process_frames(2);assert_true(is_instance_valid(next.exit_dialog264))
 next.exit_dialog264.closed.emit();await wait_process_frames(2);assert_true(SaveData.interior_search264["home:florist"].pending.is_empty())
 DirAccess.remove_absolute(SaveData.save_path);SaveData.save_path=path_before;SaveData.interior_search264=state_before
func test_saddlery_uses_shared_search_and_reserved_exit_area():
 var room:=SaddleryRoom256.new();add_child(room);await wait_process_frames(2);room.room_id264=""
 assert_eq(room.search_buttons264.size(),2);assert_eq(room.search_site264("workbench").kind,"found");assert_true(room.message.text.contains("Juanito"))
 room.finish();await wait_process_frames(2);assert_true(is_instance_valid(room.exit_dialog264));room.exit_dialog264.closed.emit();await wait_process_frames(2)
