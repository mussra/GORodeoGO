extends GutTest
var duel:Node2D
var old:HorseCollection
var old_path:String
func before_each():
 old=SaveData.horse_collection;old_path=SaveData.save_path;SaveData.save_path="user://duel193-never-written.dat"
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 _ignore(get_tree().root.get_node("GutRunner"))
 duel=load("res://src/Presentation/duel193.tscn").instantiate();add_child(duel);await wait_physics_frames(2)
func after_each():
 get_tree().paused=false
 if is_instance_valid(duel):duel.free()
 SaveData.horse_collection=old;SaveData.save_path=old_path
 await wait_physics_frames(2)
func start():
 duel.countdown=0.;duel.running=true
 for rider in duel.riders:rider.set_physics_process(false)
func win(index:int):
 duel.capture_landed(duel.riders[1-index]);duel._resolve_round()
func test_shared_components_and_initial_separation():
 assert_eq(duel.riders.size(),2);assert_false(duel.running)
 assert_gt(duel.riders[0].position.distance_to(duel.riders[1].position),220.)
 for rider in duel.riders:
  assert_true(rider.lasso is LassoController);assert_true(rider.dodge is DodgeController)
  assert_eq(rider.lasso.lasso_travel_time,.35);assert_eq(rider.base_pace,260.)
func test_two_zero_ends_after_two_rounds_and_alternates_sides():
 start();var x:float=duel.player.position.x;win(0)
 assert_eq(duel.scores,[1,0]);assert_false(duel.finished);assert_false(duel.running)
 duel._next_round();assert_eq(duel.round_number,2);assert_eq(duel.player.position.x,-x)
 start();win(0);assert_eq(duel.scores,[2,0]);assert_true(duel.finished)
 assert_eq(duel.round_number,2)
func test_two_one_and_simultaneous_replay_without_point():
 start();win(0);duel._next_round();start();win(1);duel._next_round()
 assert_eq(duel.round_number,3);assert_eq(duel.scores,[1,1])
 start();duel.capture_landed(duel.riders[0]);duel.capture_landed(duel.riders[1]);duel._resolve_round()
 assert_eq(duel.scores,[1,1]);assert_false(duel.finished)
 duel._next_round();assert_eq(duel.round_number,3)
 start();win(1);assert_eq(duel.scores,[1,2]);assert_true(duel.finished)
func test_first_hit_stops_later_hits_and_never_changes_collection():
 start();var state:String=var_to_str(SaveData.horse_collection.horses)
 win(0);duel.capture_landed(duel.riders[0]);assert_eq(duel.scores,[1,0])
 assert_eq(var_to_str(SaveData.horse_collection.horses),state)
 assert_false(FileAccess.file_exists(SaveData.save_path))
func test_actual_flight_captures_and_round_resolution_cancels_pending_rope():
 start();var a=duel.riders[0];var b=duel.riders[1]
 a.position=Vector2(-100,0);b.position=Vector2(40,0);a.velocity=Vector2.ZERO
 a.lasso.aim_direction=Vector2.RIGHT;a.lasso._start_charging();a.lasso._charge_distance=140.;a.lasso._release_throw()
 assert_true(a.lasso.is_in_flight());assert_eq(duel.scores,[0,0])
 await wait_seconds(.5)
 assert_eq(duel.scores,[1,0]);assert_false(duel.running)
 assert_false(a.lasso.is_in_flight());assert_true(duel.result.visible)
 assert_eq(b._stun_time_remaining,0.)
func test_pause_stops_timer_and_resume_does_not_reset_match():
 duel._pause();var left:float=duel.countdown;await wait_physics_frames(3)
 assert_true(get_tree().paused);assert_eq(duel.countdown,left)
 duel.navigate_back();assert_false(get_tree().paused)
 assert_eq(duel.scores,[0,0]);assert_false(duel.pause_panel.visible)
func test_outside_capture_misses_and_arena_clamps_shared_movement():
 start();var bot=duel.riders[1]
 assert_false(bot.try_capture(bot.position+Vector2(59,0)))
 bot.set_physics_process(true);bot.position=Vector2(800,500);bot._physics_process(.016)
 assert_true(bot.world_bounds.grow(.1).has_point(bot.position))
func touch(index:int,point:Vector2,pressed:bool):
 var e:=InputEventScreenTouch.new();e.index=index;e.position=point;e.pressed=pressed;Input.parse_input_event(e);Input.flush_buffered_events()
func drag(index:int,point:Vector2):
 var e:=InputEventScreenDrag.new();e.index=index;e.position=point;Input.parse_input_event(e);Input.flush_buffered_events()
func _ignore(node:Node):
 if node is Control:node.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for child in node.get_children():_ignore(child)
func test_native_two_finger_move_and_lasso_then_round_reset_has_no_held_input():
 duel.countdown=0.;duel.running=true;duel.riders[1].set_physics_process(false)
 var extent:Vector2=get_viewport().get_visible_rect().size
 var left:Vector2=extent*Vector2(.15,.78);var right:Vector2=extent*Vector2(.75,.78)
 var from:Vector2=duel.player.position
 touch(0,left,true);await wait_physics_frames(2);drag(0,left+Vector2(80,0));touch(1,right,true);await wait_physics_frames(2);drag(1,right+Vector2(80,0))
 await wait_physics_frames(10)
 assert_gt(duel.player.position.x,from.x+5.)
 assert_true(duel.player.lasso.is_charging())
 touch(1,right+Vector2(80,0),false);await wait_physics_frames(4)
 assert_true(duel.player.lasso.is_in_flight())
  # Keep left finger held at the end, to verify real reset rather than a clean release.
 duel.capture_landed(duel.riders[1]);duel._resolve_round();assert_false(duel.player.lasso.is_in_flight())
 duel._next_round();assert_false(duel.player.lasso.is_charging());assert_eq(duel.scores,[1,0])
 assert_eq(Input.get_vector("move_left","move_right","move_up","move_down"),Vector2.ZERO)
 touch(0,left+Vector2(80,0),false)
func test_real_flight_is_frozen_during_pause_and_cancelled_on_exit():
 start();var a=duel.player;var b=duel.riders[1]
 a.position=Vector2(-100,0);b.position=Vector2(40,0);a.velocity=Vector2.ZERO
 a.lasso.aim_direction=Vector2.RIGHT;a.lasso._start_charging();a.lasso._charge_distance=140.;a.lasso._release_throw()
 # Pause cancels the player's current rope, so it cannot win behind a modal.
 duel._pause();assert_false(a.lasso.is_in_flight());assert_eq(duel.scores,[0,0])
 duel._resume();await wait_seconds(.5);assert_eq(duel.scores,[0,0])
 duel.free();duel=null;await wait_physics_frames(2)
 assert_eq(Engine.time_scale,1.);assert_false(get_tree().paused)
