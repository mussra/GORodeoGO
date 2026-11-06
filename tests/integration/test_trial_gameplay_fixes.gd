extends GutTest
var prior:Variant
func before_each()->void:
 prior=ProjectSettings.get_setting("rancho/trial_tools",false)
 SaveData.dual_lasso_intro_shown=true
func after_each()->void:
 ProjectSettings.set_setting("rancho/trial_tools",prior)
 for a in ["move_left","move_right","move_up","move_down"]:Input.action_release(a)
func setup_level()->Node:
 GameState.selected_level=5
 var l:Node=load("res://src/Presentation/level_0.tscn").instantiate();add_child_autofree(l)
 await wait_physics_frames(2)
 for b in l._active_bulls:b.set_physics_process(false)
 return l
func test_trial_tools_do_not_write_progress_inventory()->void:
 var before:int=SaveData.highest_level_completed;var owned:Array=SaveData.equipment_owned.duplicate();var equipped:Dictionary=SaveData.equipment_equipped.duplicate(true)
 ProjectSettings.set_setting("rancho/trial_tools",true)
 var l:Node=await setup_level()
 assert_true(l.player.dodge_available);assert_gte(l.player.dodge_path_limit,195.0);assert_eq(l.player._max_captures,2)
 assert_eq(SaveData.highest_level_completed,before);assert_eq(SaveData.equipment_owned,owned);assert_eq(SaveData.equipment_equipped,equipped)
 ProjectSettings.set_setting("rancho/trial_tools",false)
 l._upgrades=PlayerUpgrades.for_progress(0);l._apply_unlocked_upgrades();assert_eq(l.player._max_captures,1)
func test_second_aim_held_during_first_flight_starts_after_landing()->void:
 ProjectSettings.set_setting("rancho/trial_tools",true)
 var l:Node=await setup_level();var p:Node=l.player
 p.global_position=Vector2.ZERO
 var b:Node=l._active_bulls[0];b.global_position=Vector2(150,0)
 p._on_aim_pressed();p._on_aim_released(Vector2(150.0/p.max_throw_distance,0))
 assert_true(p._lasso_in_flight)
 p._on_aim_pressed();assert_true(p._touch_aim_active);assert_false(p._is_charging)
 await wait_seconds(p.lasso_travel_time+.05)
 assert_true(b.controller.is_held());assert_eq(p._active_capture_count,1);assert_true(p._is_charging,"second held gesture starts when first rope lands")
 var second:Node=l._active_bulls[1];second.global_position=Vector2(0,150)
 p._on_aim_released(Vector2(0,150.0/p.max_throw_distance))
 await wait_seconds(p.lasso_travel_time+.05)
 assert_true(second.controller.is_held());assert_eq(p._active_capture_count,2)
func test_safe_bull_clears_chaser_flags()->void:
 var l:Node=await setup_level();var b:Node=l._active_bulls[0]
 b._is_chaser=true;b.try_capture(b.global_position);b.controller.use_tranquilizer();assert_true(b.controller.return_to_pen())
 assert_false(b._is_chaser);assert_false(b._random_chase.is_active());assert_eq(b.controller.current_state(),BullState.State.SAFE)
func test_recovery_targets_recent_position_not_stale_trail()->void:
 var l:Node=await setup_level();var b:Node=l._active_bulls[0]
 b.global_position=Vector2(-200,100);l.player.global_position=Vector2(120,100)
 b.try_capture(b.global_position)
 b._tow_path.assign([Vector2(-150,200),Vector2(-50,200),Vector2(100,200),Vector2(120,100)])
 b._recover_tow_route()
 assert_gt(b._tow_path.size(),0);assert_lt(b._tow_path[0].y,150.0,"does not start toward old southern breadcrumb")
 assert_lt(b._tow_path[-1].distance_to(l.player.global_position),25.0)
