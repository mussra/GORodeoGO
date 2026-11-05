extends GutTest
func after_each()->void:get_tree().paused=false
func test_release_keeps_partial_calm_but_full_normal_speed()->void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=1
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var bull:Node=level._active_bulls[0]
	assert_true(bull.try_capture(bull.global_position))
	bull.controller.update_hold(3.0,50.0,0.0)
	var nerves:float=bull.controller.current_nerves()
	assert_lt(nerves,100.0)
	bull.release_by_player()
	assert_true(bull.controller.is_wild())
	assert_eq(bull.controller.current_nerves(),nerves,"release preserves partial calm")
	assert_eq(bull._effective_flee_speed,bull.flee_speed,"released bull has ordinary full speed")
	assert_eq(bull._compute_flee_speed_for_nerves(),bull.flee_speed)
