extends GutTest
func after_each() -> void: get_tree().paused=false
func test_player_opening_real_latch_has_space_beside_initial_exit() -> void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=11
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level.player.global_position=level._puzzle_corrals[0].layout["door"]
	level._on_pen_door_opened(0)
	await wait_physics_frames(35)
	assert_lte(level.player._stun_time_remaining,0.0,"visible release warning gives opening player time to react")

	level.player.global_position += Vector2(95,65)
	await wait_physics_frames(60)
	assert_lte(level.player._stun_time_remaining,0.0,"stepping aside during warning avoids initial rush")
	# No player immunity: a later ordinary wild contact still stuns and drops capture.
	var bull:Node=level._active_bulls[0]
	bull._release_delay=0.0
	bull.global_position=level.player.global_position
	bull._check_player_contact()
	assert_gt(level.player._stun_time_remaining,0.0)
