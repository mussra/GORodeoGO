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
	assert_almost_eq(player.lasso_travel_time,.8*PlayerUpgrades.for_progress(SaveData.highest_level_completed).lasso_travel_time_multiplier,.01)
	player._animate_lasso_flight(player.global_position,player.global_position+Vector2(180,0))
	var rope:Node=player._flight_line
	assert_eq(rope.rider,player)
	player.global_position+=Vector2(60,30)
	await wait_physics_frames(2)
	assert_eq(rope.rider.global_position,player.global_position)
	player.cancel_all_actions()
	await wait_physics_frames(1)
	assert_false(is_instance_valid(rope))
