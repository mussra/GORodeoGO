extends GutTest
func test_florist_prototype_explicitly_separates_inspection_and_ownership():
 var points:int=SaveData.equipment_points;var quests:Dictionary=SaveData.world_quests.duplicate(true)
 var room:=FloristRoom262.new();add_child(room);await wait_process_frames(3)
 assert_true(room.prototype);assert_eq(room.objects.get_child_count(),3)
 room.objects.get_child(0).pressed.emit();assert_true(room.message.text.contains("no se recogen"))
 room.objects.get_child(1).pressed.emit();assert_true(room.message.text.contains("expresamente"))
 room.objects.get_child(2).pressed.emit();assert_true(room.message.text.contains("no cobra"))
 assert_eq(SaveData.equipment_points,points);assert_eq(SaveData.world_quests,quests)
 room._talk();await wait_process_frames(2);assert_true(is_instance_valid(room.dialog));room.finish();await wait_process_frames(2)
func test_exit_emits_once_and_room_fits_small_viewport():
 var room:=FloristRoom262.new();add_child(room);await wait_process_frames(2);watch_signals(room)
 room._fit();assert_gt(room.canvas.scale.x,0.);room.finish();room.finish();assert_signal_emit_count(room,"closed",1);await wait_process_frames(2)
