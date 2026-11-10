extends GutTest
func rider()->Node2D:
 SaveData.horse_collection.seed_trial()
 var p:Node2D=load("res://src/Presentation/world_player.gd").new();add_child_autofree(p)
 return p
func test_collision_stun_cancels_held_aim_and_requires_fresh_press()->void:
 var p:=rider()
 p.lasso._on_aim_pressed();p.lasso._charge_distance=180;p.lasso._update_charge_visual()
 assert_true(p.lasso.is_charging())
 p.stun(2)
 assert_false(p.lasso.is_charging());assert_false(p.lasso._touch_aim_active)
 assert_eq(p.lasso.charge_distance(),0.0);assert_null(p.lasso._charge_visual)
 p.lasso._on_aim_released(Vector2.RIGHT)
 assert_false(p.lasso.is_in_flight())
 p.lasso._on_aim_pressed();assert_false(p.lasso.is_charging())
 p._stun_time_remaining=0
 p.lasso._on_aim_released(Vector2.RIGHT);assert_false(p.lasso.is_in_flight())
 p.lasso._on_aim_pressed();assert_true(p.lasso.is_charging())
 p.lasso._on_aim_released(Vector2.RIGHT);assert_true(p.lasso.is_in_flight())
 await wait_seconds(.9)
func test_shared_guard_covers_keyboard_continuation_and_release()->void:
 var p:=rider()
 p.lasso._on_aim_pressed();p._stun_time_remaining=1
 p.lasso.process_throw_input(.1);assert_false(p.lasso.is_charging())
 p._stun_time_remaining=0;p.lasso._on_aim_pressed();p._stun_time_remaining=1
 p.lasso._on_aim_released(Vector2.RIGHT);assert_false(p.lasso.is_in_flight());assert_false(p.lasso.is_charging())
 p.lasso._release_throw(Vector2.RIGHT);assert_false(p.lasso.is_in_flight())
func test_stun_after_release_does_not_cancel_or_shorten_flight()->void:
 var p:=rider();p.lasso.lasso_travel_time=.35
 var landings:Array=[]
 p.lasso.landing_resolved.connect(func(point:Vector2,_prey:Node2D):landings.append(point))
 var expected:Vector2=p.global_position+Vector2(220,0)
 p.lasso._release_throw(Vector2.RIGHT)
 p.stun(2)
 assert_true(p.lasso.is_in_flight())
 await wait_seconds(.15);assert_true(p.lasso.is_in_flight());assert_eq(landings.size(),0)
 await wait_seconds(.3);assert_false(p.lasso.is_in_flight());assert_eq(landings.size(),1)
 assert_eq(landings[0],expected);assert_eq(p.lasso.max_throw_distance,220.0);assert_eq(p.lasso.capture_area_visual_radius,58.0)
