extends "res://tests/integration/test_touch_lost224.gd"
var old_mode:bool
var old_pref:PackedByteArray
var had_pref:bool
func before_each():
 old_mode=GameState.anchored_movement258;had_pref=FileAccess.file_exists(GameState.CONTROL_PREF258)
 if had_pref:old_pref=FileAccess.get_file_as_bytes(GameState.CONTROL_PREF258)
 GameState.anchored_movement258=true
 await super.before_each()
func after_each():
 await super.after_each();GameState.anchored_movement258=old_mode
 if had_pref:
  var f:=FileAccess.open(GameState.CONTROL_PREF258,FileAccess.WRITE);f.store_buffer(old_pref);f.close()
 else:DirAccess.remove_absolute(GameState.CONTROL_PREF258)
func test_anchored_origin_does_not_chase_finger_after_saturation():
 var stick:VirtualJoystick=host.get_node("TouchControls/MoveJoystick")
 assert_eq(stick.joystick_mode,VirtualJoystick.JOYSTICK_DYNAMIC);assert_eq(stick.joystick_size,120.)
 touch(Vector2(180,400),true);await wait_physics_frames(2);drag(Vector2(500,400));await wait_physics_frames(2)
 assert_gt(moving().x,.9)
 drag(Vector2(220,400));await wait_physics_frames(2);assert_gt(moving().x,.1);assert_eq(moving().y,0.)
 drag(Vector2(130,400));await wait_physics_frames(2);assert_lt(moving().x,-.1)
 touch(Vector2(130,400),false);await wait_physics_frames(3);assert_eq(moving(),Vector2.ZERO)
func test_lasso_works_with_second_finger_while_moving_anchored():
 await start();touch(Vector2(900,400),true,1);await wait_physics_frames(2);drag(Vector2(980,400),1);await wait_physics_frames(2)
 assert_gt(moving().length(),.1);assert_true(player.lasso.is_charging())
 touch(Vector2(980,400),false,1);await wait_physics_frames(2);assert_true(player.lasso.is_in_flight());assert_gt(moving().length(),.1)
 touch(Vector2(30,420),false);await wait_physics_frames(3);assert_eq(moving(),Vector2.ZERO)
func test_setting_persists_and_current_mode_remains_available():
 assert_true(GameState.set_movement258(true));GameState.anchored_movement258=false;GameState.load_movement258();assert_true(GameState.anchored_movement258)
 assert_true(GameState.set_movement258(false));GameState.load_movement258();assert_false(GameState.anchored_movement258)
 var fresh:=Node2D.new();fresh.set_script(load("res://tests/integration/touch_host224.gd"));add_child(fresh);await wait_process_frames(3)
 assert_eq(fresh.get_node("TouchControls/MoveJoystick").joystick_mode,VirtualJoystick.JOYSTICK_FOLLOWING);fresh.free()
