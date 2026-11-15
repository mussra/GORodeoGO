extends GutTest
var race:Node2D
func before_each():
 RaceCourse190.selected=0;RaceCourse190.start_selected=true
 race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race)
 await wait_physics_frames(2)
 race.selector.hide();race.countdown=0.;race.running=true;race.set_physics_process(false)
 for rider in race.riders:rider.set_physics_process(false)
func after_each():
 get_tree().paused=false;Engine.time_scale=1.
 for action in ["move_right","move_left","move_up","move_down"]:Input.action_release(action)
 race.free();await wait_physics_frames(2)
func test_player_and_ai_stop_exactly_sixty_steps_and_resume_without_teleport():
 for rider in [race.player,race.riders[1]]:
  rider.position=race.course.at(500.);rider.route_s=500.;rider.previous_position=rider.position
  rider.velocity=Vector2.RIGHT*260.;rider.protected_left=0.;rider.attack_think=100.
  assert_true(rider.request_dodge_path(PackedVector2Array([Vector2.ZERO,Vector2(250,0)])))
  assert_true(rider.try_capture(rider.position));assert_eq(rider.slow_left,1.)
  assert_true(rider.dodge.path.is_empty());assert_eq(rider.velocity,Vector2.ZERO)
  var at:Vector2=rider.position
  Input.action_press("move_right")
  for i in 60:
   assert_false(rider.request_dodge(Vector2.RIGHT),"Sprint cannot bypass the stop")
   assert_false(rider.lasso.throw_guard.call(),"No throw during stop")
   rider._physics_process(1./60.)
   assert_eq(rider.position,at,"Hit rider stays still for the whole second")
   assert_eq(rider.velocity,Vector2.ZERO)
  assert_eq(rider.slow_left,0.);assert_gt(rider.protected_left,0.)
  assert_false(rider.try_capture(rider.position),"Existing protection prevents chain stops")
  rider._physics_process(1./60.)
  assert_gt(rider.velocity.length(),0.,"Player/AI can resume after one second")
  assert_lt(rider.position.distance_to(at),10.,"No stored dash or teleport on release")
  Input.action_release("move_right")
func test_pause_does_not_consume_stop_and_no_other_rider_is_stopped():
 var target=race.riders[1];var other=race.riders[2]
 assert_true(target.try_capture(target.position));assert_eq(other.slow_left,0.)
 target.set_physics_process(true);race._pause();var left:float=target.slow_left
 await wait_process_frames(5)
 assert_eq(target.slow_left,left);get_tree().paused=false
 target.set_physics_process(false)
func test_real_shared_lasso_flight_stops_only_target_without_rewards():
 var before:=SaveData.horse_collection.export_state().duplicate(true);var points:int=SaveData.equipment_points
 var attacker=race.player;var target=race.riders[1]
 attacker.position=race.course.at(10.);target.position=race.course.at(150.);attacker.velocity=Vector2.ZERO
 attacker.lasso.aim_direction=(target.position-attacker.position).normalized()
 attacker.lasso._start_charging();attacker.lasso._charge_distance=attacker.position.distance_to(target.position);attacker.lasso._release_throw()
 assert_true(attacker.lasso.is_in_flight());assert_eq(target.slow_left,0.)
 await wait_physics_frames(35)
 assert_eq(target.slow_left,1.);assert_eq(target.velocity,Vector2.ZERO);assert_eq(target.tether_from,attacker)
 assert_eq(attacker.slow_left,0.);assert_eq(target.lasso._active_capture_count,0)
 assert_eq(SaveData.horse_collection.export_state(),before);assert_eq(SaveData.equipment_points,points)
