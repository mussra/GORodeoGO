extends GutTest
var duel:Node2D
func before_each():
 ignore(get_tree().root.get_node("GutRunner"));duel=load("res://src/Presentation/duel193.tscn").instantiate();add_child(duel);await wait_physics_frames(2)
 duel.countdown=0.;duel.running=true
 for rider in duel.riders:rider.set_physics_process(false)
func after_each():
 if is_instance_valid(duel):duel.free()
 get_tree().paused=false;Engine.time_scale=1.
 for action in ["move_right","move_left","move_up","move_down"]:Input.action_release(action)
 await wait_physics_frames(2)
func ignore(n:Node):
 if n is Control:n.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for c in n.get_children():ignore(c)
func touch(p:Vector2,down:bool):
 var e:=InputEventScreenTouch.new();e.index=0;e.position=get_viewport().get_final_transform()*p;e.pressed=down;Input.parse_input_event(e);Input.flush_buffered_events()
func drag(p:Vector2):
 var e:=InputEventScreenDrag.new();e.index=0;e.position=get_viewport().get_final_transform()*p;Input.parse_input_event(e);Input.flush_buffered_events()
func test_landing_on_opponent_beyond_thrower_distance_still_hits():
 var a=duel.player;var b=duel.riders[1];a.position=Vector2(-100,0);b.position=Vector2(130,0)
 assert_true(b.position.distance_to(a.position)>a.lasso.max_throw_distance)
 assert_eq(a.lasso.resolve_capture(b.position),b,"An accurately landed loop must not be rejected by rider-to-rider distance")
func test_native_player_double_press_starts_and_executes_shared_regate():
 var p=duel.player;p.set_physics_process(true)
 var origin:=get_viewport().get_visible_rect().size*Vector2(.15,.78)
 touch(origin,true);await wait_physics_frames(2);touch(origin,false);await wait_physics_frames(2)
 touch(origin,true);drag(origin+Vector2(85,-25));await wait_physics_frames(2)
 assert_true(p.dodge.drawing,"Player can draw the same dodge with touch")
 touch(origin+Vector2(85,-25),false);await wait_physics_frames(2)
 assert_false(p.dodge.path.is_empty(),"Release executes traced dodge")
 var before:Vector2=p.position;await wait_physics_frames(8);assert_gt(p.position.distance_to(before),20.)
func test_both_riders_share_reach_hit_radius_speed_and_recharge():
 var a=duel.player;var b=duel.riders[1]
 assert_eq(a.lasso.max_throw_distance,b.lasso.max_throw_distance);assert_eq(a.lasso.lasso_travel_time,b.lasso.lasso_travel_time)
 assert_eq(a.base_pace,b.base_pace);assert_eq(a.dodge.recharge_seconds,b.dodge.recharge_seconds);assert_eq(a.dodge.available,b.dodge.available)
func test_real_flight_still_hits_after_thrower_moves_away_for_both_sides():
 for side in 2:
  duel.pending.clear();duel.capture_frame=-1;duel.result.hide();duel.running=true;duel.set_physics_process(false)
  var a=duel.riders[side];var b=duel.riders[1-side]
  a.position=Vector2(-100,0);b.position=Vector2(110,0);a.velocity=Vector2.ZERO;a.attack_cooldown=0.
  a.lasso.aim_direction=Vector2.RIGHT;a.lasso._start_charging();a.lasso._charge_distance=210.;a.lasso._release_throw()
  assert_true(a.lasso.is_in_flight());assert_true(duel.pending.is_empty())
  a.position=Vector2(-160,0) # Movement during flight used to discard the actual impact.
  await wait_physics_frames(26)
  assert_eq(duel.pending,[side]);assert_eq(b.tether_from,a)
  duel.running=false;a.cancel_input();b.cancel_input()
func test_hit_radius_and_miss_are_identical_in_both_directions():
 for side in 2:
  var a=duel.riders[side];var b=duel.riders[1-side]
  a.position=Vector2(-100,0);b.position=Vector2(130,0)
  assert_null(a.lasso.resolve_capture(b.position+Vector2(59,0)))
  assert_eq(a.lasso.resolve_capture(b.position+Vector2(57,0)),b)
func test_bot_does_not_gain_launch_range_from_landing_fix():
 var bot=duel.riders[1];duel.player.position=Vector2(-400,0);bot.position=Vector2(400,0);bot.attack_think=0.;bot._think(1.)
 assert_false(bot.lasso.is_in_flight());assert_false(bot.lasso.is_charging())
func test_player_regate_is_still_available_after_new_round():
 duel.capture_landed(duel.riders[1]);duel._resolve_round();duel._next_round();duel.countdown=0.;duel.running=true
 var p=duel.player;p.set_physics_process(true);duel.riders[1].set_physics_process(false)
 var origin:=get_viewport().get_visible_rect().size*Vector2(.15,.78)
 touch(origin,true);await wait_physics_frames(2);touch(origin,false);await wait_physics_frames(2)
 touch(origin,true);drag(origin+Vector2(80,0));await wait_physics_frames(2);assert_true(p.dodge.drawing)
 touch(origin+Vector2(80,0),false);await wait_physics_frames(2);assert_gt(p.dodge.cooldown,0.)
 var before:Vector2=p.position;await wait_physics_frames(6);assert_gt(p.position.distance_to(before),10.)
func test_wide_screen_regate_while_aim_finger_is_held():
 var old_size=get_tree().root.size;get_tree().root.size=Vector2i(1066,480);await wait_physics_frames(2)
 var p=duel.player;p.set_physics_process(true)
 var origin:=get_viewport().get_visible_rect().size*Vector2(.15,.78)
 var aim:=InputEventScreenTouch.new();aim.index=1;aim.position=get_viewport().get_final_transform()*(get_viewport().get_visible_rect().size*Vector2(.85,.78));aim.pressed=true;Input.parse_input_event(aim);Input.flush_buffered_events();await wait_physics_frames(2)
 touch(origin,true);await wait_physics_frames(2);touch(origin,false);await wait_physics_frames(2)
 touch(origin,true);drag(origin+Vector2(80,-20));await wait_physics_frames(2);assert_true(p.dodge.drawing)
 touch(origin+Vector2(80,-20),false);await wait_physics_frames(2);assert_gt(p.dodge.cooldown,0.);assert_false(p.dodge.path.is_empty())
 aim.pressed=false;Input.parse_input_event(aim);Input.flush_buffered_events();get_tree().root.size=old_size;await wait_physics_frames(2)
