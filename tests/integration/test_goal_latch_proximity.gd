extends GutTest
func after_each()->void:
	get_tree().paused=false
	for action in ["move_left","move_right","move_up","move_down"]:Input.action_release(action)
func test_actual_early_latch_approach_from_goal_remains_accessible()->void:
	SaveData.dual_lasso_intro_shown=true
	for number in range(11,15):
		GameState.selected_level=number
		var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
		add_child_autofree(level)
		await wait_physics_frames(2)
		# Setup at the goal centre, then normal rider input to the north latch.
		level.player.global_position=level.pen.global_position
		Input.action_press("move_up")
		for frame in range(80):
			await wait_physics_frames(1)
			if level.player.global_position.y< -72:break
		Input.action_release("move_up")
		await wait_physics_frames(100)
		assert_true(level._pen_released[0],"level%d rider physically reaches/holds latch despite overlapping interaction circles"%number)
		assert_lt(level.player.global_position.y,-65.0)
		print("EARLY_LATCH ",number," player=",level.player.global_position," gate=",level._puzzle_corrals[0].layout["door"]," goal=",level.pen.global_position)
		level.queue_free()
		await wait_physics_frames(2)
