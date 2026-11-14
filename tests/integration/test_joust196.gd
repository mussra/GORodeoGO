extends GutTest
var joust:Node2D
var old:HorseCollection
var old_path:String
func before_each():
 old=SaveData.horse_collection;old_path=SaveData.save_path;SaveData.save_path="user://joust196-never-written.cfg"
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 _ignore(get_tree().root.get_node("GutRunner"))
 joust=load("res://src/Presentation/joust196.tscn").instantiate();add_child(joust);await wait_physics_frames(2)
func after_each():
 get_tree().paused=false
 if is_instance_valid(joust):joust.free()
 SaveData.horse_collection=old;SaveData.save_path=old_path;await wait_physics_frames(2)
func start():
 joust.countdown=0.;joust.running=true
func test_opposite_automatic_pass_and_shared_components():
 assert_eq(joust.pass_number,1);assert_false(joust.running)
 assert_eq(joust.riders[0].position.x,-440.);assert_eq(joust.riders[1].position.x,440.)
 for rider in joust.riders:
  assert_true(rider is DuelRider193);assert_true(rider.lasso is LassoController);assert_true(rider.dodge is DodgeController);assert_eq(rider.lasso.lasso_travel_time,.35)
 start();joust.riders[1].attack_cooldown=99.
 var left:float=joust.player.position.x;var right:float=joust.riders[1].position.x
 await wait_physics_frames(20)
 assert_gt(joust.player.position.x,left+10.);assert_lt(joust.riders[1].position.x,right-10.)
func test_pass_without_capture_keeps_score_and_reverses_sides():
 start()
 for rider in joust.riders:rider.set_physics_process(false);rider.position.x=rider.forward*480.
 joust._physics_process(.6)
 assert_false(joust.running);assert_true(joust.result.visible);assert_eq(joust.scores,[0,0]);assert_true(joust.result_text.text.contains("sin captura"))
 var side:float=joust.player.position.x;joust._next_round()
 assert_eq(joust.round_number,1);assert_eq(joust.pass_number,2);assert_eq(joust.player.position.x,440.);assert_eq(joust.player.forward,-1.)
func test_shared_actual_flight_scores_without_harm_and_match_has_no_rewards():
 start()
 for rider in joust.riders:rider.set_physics_process(false)
 var before:=SaveData.horse_collection.export_state()
 var a=joust.player;var b=joust.riders[1];a.position=Vector2(-100,0);b.position=Vector2(40,0);a.velocity=Vector2.ZERO
 a.lasso.aim_direction=Vector2.RIGHT;a.lasso._start_charging();a.lasso._charge_distance=140.;a.lasso._release_throw()
 assert_true(a.lasso.is_in_flight());await wait_seconds(.5)
 assert_eq(joust.scores,[1,0]);assert_eq(b._stun_time_remaining,0.)
 joust._next_round();start();joust.capture_landed(b);joust._resolve_round()
 assert_eq(joust.scores,[2,0]);assert_true(joust.finished)
 assert_eq(SaveData.horse_collection.export_state(),before);assert_false(FileAccess.file_exists(SaveData.save_path))
func test_simultaneous_hits_repeat_without_point_and_clear_inputs():
 start();joust.capture_landed(joust.riders[0]);joust.capture_landed(joust.riders[1]);joust._resolve_round()
 assert_eq(joust.scores,[0,0]);joust._next_round();assert_eq(joust.round_number,1);assert_eq(joust.pass_number,2)
 assert_eq(Input.get_vector("move_left","move_right","move_up","move_down"),Vector2.ZERO)
func test_pause_stops_pass_and_resets_controls_without_restarting_score():
 start();joust._pause();var position:Vector2=joust.player.position;await wait_physics_frames(4)
 assert_true(get_tree().paused);assert_eq(joust.player.position,position)
 joust._resume();assert_false(get_tree().paused);assert_eq(joust.pass_number,1)
func test_steering_and_reverse_input_never_reverse_pass():
 start();joust.riders[1].attack_cooldown=99.
 Input.action_press("move_left");Input.action_press("move_up")
 var old_x:float=joust.player.position.x;await wait_physics_frames(20)
 assert_gt(joust.player.position.x,old_x);assert_lt(joust.player.position.y,-45.)
 Input.action_release("move_left");Input.action_release("move_up")
 assert_false(joust.player.request_dodge(Vector2.LEFT));old_x=joust.player.position.x
 await wait_physics_frames(10);assert_gte(joust.player.position.x,old_x);assert_gte(joust.player.position.y,-140.)
func test_bot_never_uses_players_lasso_action():
 start();joust.riders[1].attack_cooldown=99.
 Input.action_press("throw_lasso");await wait_physics_frames(4)
 assert_true(joust.player.lasso.is_charging());assert_false(joust.riders[1].lasso.is_charging())
 Input.action_release("throw_lasso");await wait_physics_frames(2)
 assert_false(joust.riders[1].lasso.is_in_flight())

func _ignore(node:Node):
 if node is Control:node.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for child in node.get_children():_ignore(child)
func touch(index:int,point:Vector2,pressed:bool):
 var e:=InputEventScreenTouch.new();e.index=index;e.position=point;e.pressed=pressed;Input.parse_input_event(e);Input.flush_buffered_events()
func drag(index:int,point:Vector2):
 var e:=InputEventScreenDrag.new();e.index=index;e.position=point;Input.parse_input_event(e);Input.flush_buffered_events()
func test_native_steer_aim_flight_and_held_finger_reset_between_passes():
 start();joust.riders[1].attack_cooldown=99.
 var extent:Vector2=get_viewport().get_visible_rect().size
 var left:Vector2=extent*Vector2(.15,.78);var right:Vector2=extent*Vector2(.75,.78)
 var old_y:float=joust.player.position.y
 touch(0,left,true);await wait_physics_frames(2);drag(0,left+Vector2(0,-75))
 touch(1,right,true);await wait_physics_frames(2);drag(1,right+Vector2(75,0));await wait_physics_frames(10)
 assert_lt(joust.player.position.y,old_y);assert_true(joust.player.lasso.is_charging());assert_false(joust.riders[1].lasso.is_charging())
 touch(1,right+Vector2(75,0),false);await wait_physics_frames(3);assert_true(joust.player.lasso.is_in_flight())
 joust._miss_pass();joust._next_round()
 assert_eq(Input.get_vector("move_left","move_right","move_up","move_down"),Vector2.ZERO)
 assert_false(joust.player.lasso.is_in_flight());assert_false(joust.player.lasso.is_charging())
 touch(0,left+Vector2(0,-75),false)

func test_menu_entries_do_not_cover_each_other_or_quit_at_supported_sizes():
 GameState.brand_intro_played=true
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);await wait_physics_frames(2)
 var first=menu._hero.get_node("DuelEntry193");var second=menu._hero.get_node("JoustEntry196")
 for extent in [Vector2(960,540),Vector2(1280,720),Vector2(1600,720)]:
  menu.size=extent;menu._layout()
  assert_false(first.get_global_rect().intersects(second.get_global_rect()))
  assert_false(second.get_global_rect().intersects(menu.quit_button.get_global_rect()))
  assert_lte(second.get_global_rect().end.x,extent.x)
 menu.free()

func test_regate_disabled_for_both_riders_and_stays_off_after_round_reset():
 start()
 for rider in joust.riders:
  assert_false(rider.dodge.available)
  assert_false(rider.request_dodge(Vector2.UP))
  assert_false(rider.request_dodge_path(PackedVector2Array([Vector2.ZERO,Vector2(0,80)])))
  rider.dodge.on_move_pressed();rider.dodge.on_move_released(Vector2.ZERO);rider.dodge.on_move_pressed()
  assert_false(rider.dodge.drawing);assert_eq(Engine.time_scale,1.)
 joust._miss_pass();joust._next_round()
 for rider in joust.riders:assert_false(rider.dodge.available)
