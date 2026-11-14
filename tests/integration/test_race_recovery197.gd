extends GutTest
var race:Node2D
func before_each():
 _ignore(get_tree().root.get_node("GutRunner"))
 RaceCourse190.selected=0;RaceCourse190.start_selected=true
 race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race);await wait_physics_frames(2)
 race.selector.hide();race.countdown=0.;race.running=true
 for rider in race.riders:
  if rider!=race.player:rider.set_physics_process(false)
func after_each():
 if is_instance_valid(race):race.free()
 Engine.time_scale=1.;await wait_physics_frames(2)
func test_trace_outside_oval_does_not_lock_rider_forever():
 var s:float=race.course.length*7./16.+70.
 var center:Vector2=race.course.at(s);var outward:Vector2=race.course.tangent(s).orthogonal()
 var p=race.player;p.position=center+outward*165.;p.previous_position=p.position;p.next_gate=8
 assert_true(p.request_dodge_path(PackedVector2Array([Vector2.ZERO,outward*240.])))
 await wait_physics_frames(120)
 print("RECOVERY197 path=",p.dodge.path.size()," remaining=",p.dodge.remaining," speed=",p.velocity.length()," pos=",p.position)
 assert_true(p.dodge.path.is_empty(),"A trace pushed back by the track boundary must release control")
 assert_eq(p.dodge.remaining,0.)
func test_lasso_press_during_reload_can_throw_after_it_is_ready():
 var p=race.player;p.set_physics_process(false);p.attack_cooldown=.05
 p.lasso._on_aim_pressed()
 p.attack_cooldown=0.
 p.lasso.process_throw_input(.1)
 assert_true(p.lasso.is_charging(),"Held aim should arm when reload ends")
 p.lasso._on_aim_released(Vector2.RIGHT*.6)
 assert_true(p.lasso.is_in_flight(),"A valid release after reload should throw")

func test_releasing_during_reload_never_fires_later_and_cancel_discards_hold():
 var p=race.player;p.set_physics_process(false);p.attack_cooldown=1.
 p.lasso._on_aim_pressed();p.lasso._on_aim_released(Vector2.RIGHT)
 p.attack_cooldown=0.;p.lasso.process_throw_input(.1)
 assert_false(p.lasso.is_charging());assert_false(p.lasso.is_in_flight())
 p.attack_cooldown=1.;p.lasso._on_aim_pressed();p.cancel_input();p.attack_cooldown=0.;p.lasso.process_throw_input(.1)
 assert_false(p.lasso.is_charging());assert_false(p.lasso.is_in_flight())
func test_recover_then_move_inward_and_throw_again():
 var p=race.player;var s:float=race.course.length*7./16.+70.;var normal:Vector2=race.course.tangent(s).orthogonal()
 p.position=race.course.at(s)+normal*165.;p.previous_position=p.position;p.next_gate=8
 p.request_dodge_path(PackedVector2Array([Vector2.ZERO,normal*240.]));await wait_physics_frames(50)
 var from:Vector2=p.position
 var inward:Vector2=-normal
 Input.action_press("move_left",maxf(0.,-inward.x));Input.action_press("move_right",maxf(0.,inward.x));Input.action_press("move_up",maxf(0.,-inward.y));Input.action_press("move_down",maxf(0.,inward.y))
 await wait_physics_frames(30)
 for action in ["move_left","move_right","move_up","move_down"]:Input.action_release(action)
 assert_gt(p.position.distance_to(from),25.)
 p.lasso._on_aim_pressed();p.lasso.process_throw_input(.1);p.lasso._on_aim_released(Vector2.RIGHT*.6)
 assert_true(p.lasso.is_in_flight());assert_false(p.dodge.drawing);assert_true(p.dodge.path.is_empty())
func test_ai_has_no_extra_speed_and_uses_equalized_base():
 for rider in race.riders:assert_eq(rider.base_pace,260.)
func _ignore(node:Node):
 if node is Control:node.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for child in node.get_children():_ignore(child)
func touch(index:int,point:Vector2,pressed:bool):
 var e:=InputEventScreenTouch.new();e.index=index;e.position=point;e.pressed=pressed;Input.parse_input_event(e);Input.flush_buffered_events()
func drag(index:int,point:Vector2):
 var e:=InputEventScreenDrag.new();e.index=index;e.position=point;Input.parse_input_event(e);Input.flush_buffered_events()
func test_native_held_aim_during_reload_arms_and_release_fires_once():
 var point:Vector2=get_viewport().get_visible_rect().size*Vector2(.8,.8)
 race.player.attack_cooldown=.5
 touch(1,point,true);await wait_physics_frames(2);drag(1,point+Vector2(70,0))
 await wait_physics_frames(36)
 assert_true(race.player.lasso.is_charging())
 assert_gt(race.player.lasso.charge_distance(),10.)
 touch(1,point+Vector2(70,0),false);await wait_physics_frames(3)
 assert_true(race.player.lasso.is_in_flight());assert_gt(race.player.attack_cooldown,2.)
 await wait_physics_frames(60);assert_false(race.player.lasso.is_in_flight());assert_false(race.player.lasso.is_charging())
func test_ai_uses_forward_trace_with_same_cooldown_as_player():
 var ai=race.riders[1];ai.position=race.course.at(race.course.length/16.)+race.course.tangent(race.course.length/16.).orthogonal()*(-80.)
 ai.route_s=race.course.length/16.;ai.dodge.cooldown=0.;ai._boost197()
 assert_false(ai.dodge.path.is_empty());assert_eq(ai.dodge.cooldown,race.player.dodge.recharge_seconds)
 assert_lte(ai.position.distance_to(ai.dodge.path[-1]),race.player.dodge.path_limit+.1)
