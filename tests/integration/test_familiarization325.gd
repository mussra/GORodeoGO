extends GutTest
var menu:Control
var demo:BullTutorial323
var real_bytes325:PackedByteArray
func ignore_runner325(node:Node):
 if node is Control:node.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for child in node.get_children():ignore_runner325(child)
func touch325(at:Vector2,down:bool,index_:int):
 var e=InputEventScreenTouch.new();e.index=index_;e.position=get_viewport().get_final_transform()*at;e.pressed=down;Input.parse_input_event(e);Input.flush_buffered_events()
func drag325(at:Vector2,index_:int):
 var e=InputEventScreenDrag.new();e.index=index_;e.position=get_viewport().get_final_transform()*at;Input.parse_input_event(e);Input.flush_buffered_events()
func make325(extent:Vector2i):
 SaveData.end_trial_session();get_tree().root.size=extent
 # Prior world integration fixtures can leave a root loading curtain mid-fade.
 var cover=get_tree().root.get_node_or_null('FrontierTransition')
 if cover!=null:cover.free()
 ignore_runner325(get_tree().root.get_node('GutRunner'))
 GameState.brand_intro_played=true;SaveData.story_intro319=true;SaveData.save_path='user://familiarization325-only.cfg';SaveData._load_valid=true
 SaveData.save_progress();real_bytes325=FileAccess.get_file_as_bytes(SaveData.save_path)
 menu=load('res://src/Presentation/main_menu.tscn').instantiate();add_child(menu)
 await wait_process_frames(5)
 demo=PracticeCatalog323.show323(menu,'bull');await wait_physics_frames(6)
func after_each():
 if is_instance_valid(menu):menu.free()
 SaveData.end_trial_session();get_tree().paused=false
 get_tree().root.size=Vector2i(1280,720)
 for action in ['move_left','move_right','move_up','move_down','aim_left','aim_right','aim_up','aim_down']:Input.action_release(action)
 await wait_process_frames(2)
func test_real_two_finger_input_from_menu_at_phone_and_tablet_aspects():
 for extent in [Vector2i(1280,720),Vector2i(1600,720),Vector2i(1280,960)]:
  await make325(extent)
  var level=demo.level325;var before:Vector2=level.player.position
  assert_false(menu._play.disabled==false,'Underlying menu is blocked')
  for name_ in ['MoveJoystick','AimJoystick']:
   assert_eq(level.touch_controls.get_node(name_).mouse_filter,Control.MOUSE_FILTER_STOP,'Modal must own the actual level controls')
  touch325(Vector2(150,490),true,0);await wait_physics_frames(2)
  drag325(Vector2(220,490),0);await wait_physics_frames(12)
  print('TOUCH325 extent=',extent,' delta=',level.player.position-before,' move=',Input.get_action_strength('move_right'),' speed=',level.player.max_speed,' paused=',get_tree().paused)
  assert_gt(level.player.position.distance_to(before),10.,'Actual screen touch moves rider from menu')
  touch325(Vector2(extent.x-300,490),true,1);await wait_physics_frames(2)
  drag325(Vector2(extent.x-220,490),1);await wait_physics_frames(3)
  assert_gt(Input.get_action_strength('aim_right'),.1,'Second finger aims while first moves')
  touch325(Vector2(220,490),false,0);touch325(Vector2(extent.x-220,490),false,1)
  demo._finish323();await wait_process_frames(3)
  assert_false(SaveData.trial_session_active);assert_false(menu._play.disabled)
  menu.free();await wait_process_frames(2)
func test_real_capture_pen_victory_restart_and_quit_preserve_progress():
 await make325(Vector2i(1280,720))
 var saved=SaveData._trial_snapshot.duplicate(true)
 var level=demo.level325
 assert_eq(level._level_number,1);assert_eq(SaveData.effective_progress(),0)
 assert_false(GameState.debug_cheats_active());assert_eq(level._max_simultaneous_captures,1)
 var bull=level._active_bulls[0]
 var captured=level.player.lasso.resolve_capture(bull.global_position)
 assert_same(captured,bull);assert_true(bull.controller.is_held())
 level._on_bull_returned(bull)
 assert_true(level._game_over);assert_false(level.hud._next_button.visible)
 assert_eq(SaveData.equipment_points,saved.equipment_points)
 assert_eq(SaveData.highest_level_completed,saved.highest_level_completed)
 level._on_restart_requested();await wait_process_frames(6)
 assert_ne(demo.level325,level);assert_eq(demo.level325._level_number,1)
 demo.level325._on_quit_requested();await wait_process_frames(4)
 assert_false(SaveData.trial_session_active);assert_false(SaveData.familiarization325)
 assert_eq(SaveData.equipment_points,saved.equipment_points)
 assert_eq(SaveData.horse_collection.export_state(),saved.horses)
 assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),real_bytes325,'Real save bytes are unchanged after familiarization')
