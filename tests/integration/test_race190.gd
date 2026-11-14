extends GutTest
var race:Node2D
var collection:HorseCollection
var save_path:String
var screen:Vector2i
func before_each():
 collection=SaveData.horse_collection;save_path=SaveData.save_path;screen=get_tree().root.size;get_tree().root.size=Vector2i(1280,720)
 for a in ["move_left","move_right","move_up","move_down","aim_left","aim_right","aim_up","aim_down","throw_lasso"]:Input.action_release(a)
 SaveData.save_path="user://race190tests-never-written.dat";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 _ignore_gut(get_tree().root.get_node("GutRunner"))
 race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race);await wait_physics_frames(2)
func after_each():
 get_tree().paused=false;Engine.time_scale=1.
 if is_instance_valid(race):race.free()
 SaveData.horse_collection=collection;SaveData.save_path=save_path;get_tree().root.size=screen
 for a in ["move_left","move_right","move_up","move_down","throw_lasso"]:Input.action_release(a)
 await wait_frames(2)
func start()->void:
 race.selector.hide();race.countdown=0.;race.running=true
func test_countdown_equalization_and_shared_components()->void:
 assert_false(race.running)
 for rider in race.riders:
  assert_true(rider.lasso is LassoController)
  assert_true(rider.dodge is DodgeController)
  assert_eq(rider.base_pace,260.)
  assert_eq(rider.lasso.lasso_travel_time,LassoController.FLIGHT_SECONDS)
  assert_eq(rider.collision_mask,HorseJump.FENCE_LAYER)
  assert_eq(rider.can_jump,HorseJump.capable(SaveData.horse_collection.find(SaveData.horse_collection.selected)))
 assert_eq(race.riders.size(),4)
func test_keyboard_movement_and_ai_progress_without_teleport()->void:
 start();var player_start:Vector2=race.player.position;var bot_start:Vector2=race.riders[1].position
 Input.action_press("move_right");await wait_seconds(.5);Input.action_release("move_right")
 assert_gt(race.player.position.x,player_start.x+20.)
 assert_gt(race.riders[1].position.x,bot_start.x+20.)
 assert_lt(race.player.position.distance_to(player_start),180.)
 assert_gt(race.elapsed,.3)
func test_temporal_lasso_has_no_damage_stun_or_capture_slot()->void:
 start();var target:RaceRider190=race.riders[1]
 assert_true(target.try_capture(target.position))
 assert_eq(target.slow_left,1.2)
 assert_eq(target.protected_left,3.2)
 assert_eq(target._stun_time_remaining,0.)
 assert_eq(target.lasso._active_capture_count,0)
 assert_false(target.try_capture(target.position))
 target.slow_left=0.;target.protected_left=1.
 assert_false(target.try_capture(target.position),"Protection outlasts the brief slowdown")
 target.protected_left=0.
 assert_true(target.try_capture(target.position))
func test_outside_landing_misses_and_spatial_dodge_evades()->void:
 start();var target:RaceRider190=race.riders[1]
 var landing:Vector2=target.position
 assert_false(target.try_capture(landing+Vector2(100,0)))
 assert_true(target.request_dodge(Vector2.RIGHT))
 target.set_physics_process(false)
 for i in 12:target.dodge.step_dash(260.,1./60.)
 assert_gt(target.position.distance_to(landing),58.)
 assert_false(target.try_capture(landing))
func test_real_lasso_flight_lands_later_and_respects_cooldown()->void:
 start()
 for rider in race.riders:rider.set_physics_process(false)
 var attacker:RaceRider190=race.player;var target:RaceRider190=race.riders[1]
 attacker.position=race.course.at(10.);target.position=race.course.at(150.);attacker.velocity=Vector2.ZERO
 attacker.lasso.aim_direction=(target.position-attacker.position).normalized();attacker.lasso._start_charging();attacker.lasso._charge_distance=attacker.position.distance_to(target.position);attacker.lasso._release_throw()
 assert_true(attacker.lasso.is_in_flight())
 assert_eq(target.slow_left,0.)
 assert_eq(attacker.attack_cooldown,3.)
 assert_true(attacker.lasso._flight_line is LassoRope)
 await wait_seconds(.5)
 assert_gt(target.slow_left,0.)
 assert_eq(target.tether_from,attacker)
 assert_false(attacker.lasso.throw_guard.call())
func test_targets_only_ahead_and_in_range_without_reordering_roster()->void:
 start();var original:Array=race.riders.duplicate()
 race.player.position=race.course.at(400.)
 race.riders[1].position=race.course.at(500.)
 race.riders[2].position=race.course.at(300.)
 race.riders[3].position=race.course.at(900.)
 var targets:Array=race.targets_for(race.player)
 assert_eq(targets.size(),1)
 assert_eq(targets[0],race.riders[1])
 assert_eq(race.riders,original)
func test_pause_stops_clock_resume_and_touch_zones_remain_shared()->void:
 start();race._pause();var elapsed:float=race.elapsed
 await wait_frames(4)
 assert_true(get_tree().paused)
 assert_true(race.pause_panel.visible)
 assert_eq(race.elapsed,elapsed)
 get_tree().paused=false;race.pause_panel.hide();await wait_physics_frames(3)
 assert_gt(race.elapsed,elapsed)
 assert_true(race.get_node("TouchControls/MoveJoystick") is VirtualJoystick)
 assert_eq(race.aim_joystick.joystick_size,220.)
func test_no_save_or_collection_changes_after_hit_finish_and_cleanup()->void:
 start();var horses:String=var_to_str(SaveData.horse_collection.horses)
 race.player.try_capture(race.player.position)
 race.player.finish_time=45.;race._finish()
 assert_false(race.running)
 assert_true(race.results.visible)
 assert_eq(var_to_str(SaveData.horse_collection.horses),horses)
 assert_false(FileAccess.file_exists(SaveData.save_path))
func test_gate_order_and_finish_only_after_all_sixteen()->void:
 start()
 for rider in race.riders:rider.set_physics_process(false)
 var player:RaceRider190=race.player
 player.position=race.course.at(race.course.length*.5)
 race._physics_process(.016)
 assert_eq(player.next_gate,1)
 for gate in range(1,17):
  var s:float=race.course.length*gate/16.;var p:Vector2=race.course.at(s);var forward:Vector2=race.course.tangent(s)
  player.previous_position=p-forward*8.;player.position=p+forward*8.;race._physics_process(.016)
  assert_eq(player.next_gate,gate+1)
 assert_gt(player.finish_time,0.)
 assert_true(race.results.visible)
func test_exit_cancels_bullet_time_and_input()->void:
 Engine.time_scale=.24;Input.action_press("move_right")
 race.free();race=null
 assert_eq(Engine.time_scale,1.)
 assert_false(Input.is_action_pressed("move_right"))

func touch(index:int,point:Vector2,pressed:bool)->void:
 var e:=InputEventScreenTouch.new();e.index=index;e.position=point;e.pressed=pressed;Input.parse_input_event(e)
func drag(index:int,point:Vector2)->void:
 var e:=InputEventScreenDrag.new();e.index=index;e.position=point;Input.parse_input_event(e)
func test_native_touch_movement_and_aim_throw()->void:
 start();var extent:Vector2=get_viewport().get_visible_rect().size
 var from:Vector2=extent*Vector2(.15,.75);var at:Vector2=race.player.position
 touch(0,from,true);await wait_physics_frames(2);drag(0,from+Vector2(85,0));await wait_physics_frames(12)
 assert_gt(race.player.position.x,at.x+5.,"Native move stick forwards action input")
 touch(0,from+Vector2(85,0),false);await wait_physics_frames(2)
 var aim:Vector2=extent*Vector2(.75,.75)
 touch(1,aim,true);await wait_physics_frames(2);drag(1,aim+Vector2(75,0));await wait_physics_frames(3)
 assert_true(race.player.lasso.is_charging())
 touch(1,aim+Vector2(75,0),false);await wait_physics_frames(1)
 assert_true(race.player.lasso.is_in_flight())
 assert_gt(race.player.attack_cooldown,2.5)

func _ignore_gut(node:Node)->void:
 if node is Control:node.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for child in node.get_children():_ignore_gut(child)
func test_partial_fence_is_solid_for_nonjumper_but_opening_is_clear()->void:
 start();var rider:RaceRider190=race.player;rider.set_physics_process(false)
 var s:float=race.course.fences[0];var point:Vector2=race.course.at(s);var forward:Vector2=race.course.tangent(s);var side:Vector2=forward.orthogonal()
 rider.can_jump=false;rider.position=point-forward*70.
 assert_false(rider.request_jump(forward))
 assert_true(rider.test_move(rider.global_transform,forward*140.))
 rider.position=point-forward*70.+side*132.
 assert_false(rider.test_move(rider.global_transform,forward*140.))
func test_existing_jump_crosses_fence_and_restores_mask()->void:
 start();var rider:RaceRider190=race.player;rider.set_physics_process(false)
 var s:float=race.course.fences[0];var point:Vector2=race.course.at(s);var forward:Vector2=race.course.tangent(s)
 rider.can_jump=true;rider.position=point-forward*65.
 assert_true(rider.request_jump(forward))
 assert_eq(rider.collision_mask & HorseJump.FENCE_LAYER,0)
 assert_false(rider.lasso.throw_guard.call())
 for i in 45:HorseJumpMotion.process(rider,1./60.)
 assert_gt((rider.position-point).dot(forward),50.)
 assert_eq(rider.collision_mask & HorseJump.FENCE_LAYER,HorseJump.FENCE_LAYER)
func test_selector_stops_countdown_and_has_three_courses()->void:
 var left:float=race.countdown
 await wait_physics_frames(5)
 assert_eq(race.countdown,left)
 assert_true(race.selector.visible)
 race._choose_course(race.course.variant)
 assert_false(race.selector.visible)
 await wait_physics_frames(4)
 assert_lt(race.countdown,left)
