extends GutTest
var host:Node2D
var player:Node2D
var aim_joystick:VirtualJoystick
func before_each():
 ignore(get_tree().root.get_node("GutRunner"))
 host=Node2D.new();host.set_script(load("res://tests/integration/touch_host224.gd"));add_child(host)
 player=host.player;aim_joystick=host.aim_joystick;await wait_physics_frames(3)
func after_each():
 get_tree().paused=false
 if is_instance_valid(host):host.free()
 for a in ["move_left","move_right","move_up","move_down","aim_left","aim_right","aim_up","aim_down"]:Input.action_release(a)
 Engine.time_scale=1.;await wait_physics_frames(2)
func ignore(n:Node):
 if n is Control:n.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for c in n.get_children():ignore(c)
func touch(p:Vector2,down:bool,index:int=0,cancel:bool=false):
 var e:=InputEventScreenTouch.new();e.position=get_viewport().get_final_transform()*p;e.index=index;e.pressed=down;e.canceled=cancel;Input.parse_input_event(e);Input.flush_buffered_events()
func drag(p:Vector2,index:int=0):
 var e:=InputEventScreenDrag.new();e.position=get_viewport().get_final_transform()*p;e.index=index;Input.parse_input_event(e);Input.flush_buffered_events()
func moving()->Vector2:return Input.get_vector("move_left","move_right","move_up","move_down")
func start():
 touch(Vector2(150,400),true);await wait_physics_frames(2);drag(Vector2(30,420));await wait_physics_frames(3);assert_gt(moving().length(),.1)
func test_outside_release_stops():
 await start();touch(Vector2(-30,420),false);await wait_physics_frames(20);assert_eq(moving(),Vector2.ZERO);assert_lt(player.velocity.length(),1.)
func test_focus_out_stops_native_stick_and_actions():
 await start();host.get_node("GameplayGestures209").notification(NOTIFICATION_APPLICATION_FOCUS_OUT);await wait_physics_frames(20);assert_eq(moving(),Vector2.ZERO);assert_lt(player.velocity.length(),1.)
func test_reused_index_after_lost_release_can_take_new_control_and_stop():
 await start();touch(Vector2(180,400),true);await wait_physics_frames(2);drag(Vector2(260,400));await wait_physics_frames(3);assert_gt(moving().x,.1)
 touch(Vector2(260,400),false);await wait_physics_frames(20);assert_eq(moving(),Vector2.ZERO);assert_lt(player.velocity.length(),1.)
func test_pause_clears_old_hold_even_without_release():
 await start();get_tree().paused=true;await wait_process_frames(4);get_tree().paused=false;await wait_physics_frames(20);assert_eq(moving(),Vector2.ZERO);assert_lt(player.velocity.length(),1.)
func test_pointer_leaves_screen_keeps_hold_until_release():
 await start();drag(Vector2(-30,420));await wait_physics_frames(20);assert_gt(moving().length(),.1)
 touch(Vector2(-30,420),false);await wait_physics_frames(20);assert_eq(moving(),Vector2.ZERO)
func test_canceled_aim_never_throws_or_commits_a_regate():
 await start();touch(Vector2(900,400),true,1);await wait_physics_frames(2);drag(Vector2(980,400),1);await wait_physics_frames(2)
 assert_true(player.lasso.is_charging());touch(Vector2(30,420),false,0,true);await wait_physics_frames(3)
 assert_false(player.lasso.is_charging());assert_false(player.lasso.is_in_flight());assert_true(player.dodge.path.is_empty());assert_eq(moving(),Vector2.ZERO)
func test_fresh_touch_after_edge_cancel_controls_again():
 await start();drag(Vector2(-30,420));await wait_physics_frames(3)
 touch(Vector2(200,400),true);await wait_physics_frames(3);drag(Vector2(290,400));await wait_physics_frames(3);assert_gt(moving().x,.1)
 touch(Vector2(290,400),false);await wait_physics_frames(20);assert_eq(moving(),Vector2.ZERO);assert_lt(player.velocity.length(),1.)
func test_stationary_long_hold_is_not_cut_off_by_inactivity_timer():
 await start();await wait_seconds(1.);assert_gt(moving().length(),.1)
 touch(Vector2(30,420),false);await wait_physics_frames(20);assert_eq(moving(),Vector2.ZERO)
func test_disabling_player_cancels_old_touch_without_launching():
 await start();player.set_physics_process(false);await wait_process_frames(3);player.set_physics_process(true);await wait_physics_frames(20);assert_eq(moving(),Vector2.ZERO);assert_lt(player.velocity.length(),1.)
func test_pending_release_is_invalidated_when_focus_is_lost():
 await start();touch(Vector2(900,400),true,1);await wait_physics_frames(2);drag(Vector2(980,400),1);await wait_physics_frames(2)
 touch(Vector2(980,400),false,1);host.get_node("GameplayGestures209").notification(NOTIFICATION_APPLICATION_FOCUS_OUT);await wait_physics_frames(3)
 assert_false(player.lasso.is_in_flight());assert_false(player.lasso.is_charging());assert_eq(moving(),Vector2.ZERO)
func test_drawn_regate_can_still_extend_at_edge_and_execute_on_release():
 touch(Vector2(150,400),true);await wait_physics_frames(2);touch(Vector2(150,400),false);await wait_physics_frames(2)
 touch(Vector2(150,400),true);await wait_physics_frames(2);drag(Vector2(0,400));await wait_physics_frames(2);assert_true(player.dodge.drawing)
 drag(Vector2(-10,400));await wait_physics_frames(2);assert_true(player.dodge.drawing)
 touch(Vector2(-10,400),false);await wait_physics_frames(2);assert_false(player.dodge.path.is_empty());assert_eq(Engine.time_scale,1.)

func test_hold_survives_every_edge_and_release_stops():
 for edge in [Vector2(0,420),Vector2(1279,420),Vector2(150,0),Vector2(150,719)]:
  await start();drag(edge);await wait_physics_frames(15);assert_gt(moving().length(),.1)
  touch(edge,false);await wait_physics_frames(15);assert_eq(moving(),Vector2.ZERO)
  await wait_seconds(.5)
