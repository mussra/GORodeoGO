extends GutTest
func after_each()->void:get_tree().paused=false
func test_rope_origin_tracks_rider_and_capture_radius_matches_visible_area()->void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=1
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var player:Node=level.player
	assert_almost_eq(player.capture_area_visual_radius,level._active_bulls[0].hit_radius+level._active_bulls[0].capture_tolerance,.01)
	assert_almost_eq(player.lasso_travel_time,LassoController.FLIGHT_SECONDS,.01)
	player.lasso._animate_lasso_flight(player.global_position,player.global_position+Vector2(180,0))
	var rope:Node=player.lasso._flight_line
	assert_eq(rope.rider,player)
	player.global_position+=Vector2(60,30)
	await wait_physics_frames(2)
	assert_eq(rope.rider.global_position,player.global_position)
	player.lasso.cancel_all_actions()
	await wait_physics_frames(1)
	assert_false(is_instance_valid(rope))
func test_static_bull_near_edge_matches_actual_landing_radius()->void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=1
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var bull:Node=level._active_bulls[0]
	bull.set_physics_process(false)
	var center:Vector2=bull.global_position
	assert_false(bull.try_capture(center+Vector2(58.1,0)),"just outside visible boundary misses")
	assert_true(bull.try_capture(center+Vector2(57.9,0)),"just inside visible boundary captures")
func test_moving_bull_is_resolved_at_landing_not_initial_preview()->void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=1
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var bull:Node=level._active_bulls[0]
	bull.set_physics_process(false)
	var landing:Vector2=Vector2(150,100)
	bull.global_position=landing
	bull.global_position+=Vector2(59,0)
	assert_false(bull.try_capture(landing),"bull moved outside during flight, old target is not auto-capture")
	bull.global_position=landing+Vector2(57,0)
	assert_true(bull.try_capture(landing),"moving into visible radius at landing captures")
func test_real_flight_samples_moving_bull_at_landing_and_rider_motion_does_not_shift_target()->void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=1
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	for other in level._active_bulls:other.set_physics_process(false)
	var bull:Node=level._active_bulls[0]
	var player:Node=level.player
	player.global_position=Vector2(-200,100)
	bull.global_position=Vector2(0,100)
	player.lasso._charge_distance=200
	player.aim_direction=Vector2.RIGHT
	player.lasso._release_throw()
	player.global_position+=Vector2(0,80)
	bull.global_position+=Vector2(59,0)
	await wait_physics_frames(60)
	assert_true(bull.controller.is_wild(),"near at release, outside at landing is a genuine miss")
	assert_false(player.lasso._lasso_in_flight)
	player.global_position=Vector2(-200,100)
	bull.global_position=Vector2(80,100)
	player.lasso._charge_distance=200
	player.aim_direction=Vector2.RIGHT
	player.lasso._release_throw()
	bull.global_position=Vector2(57,100)
	await wait_physics_frames(60)
	assert_false(bull.controller.is_wild(),"outside at release, inside at landing captures")
