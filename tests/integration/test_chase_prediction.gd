extends GutTest
func after_each() -> void:
	for action in ["move_right", "move_left"]: Input.action_release(action)
	get_tree().paused = false
func test_predictive_chaser_aims_ahead_and_turns_gradually() -> void:
	var previous: bool = SaveData.dual_lasso_intro_shown
	SaveData.dual_lasso_intro_shown = true
	GameState.selected_level = 1
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level.set_process(false)  # isolate controlled chaser designation
	var bull: Node = level._active_bulls[0]
	level.player.global_position = Vector2(0,0)
	bull.global_position = Vector2(-300,0)
	bull.set_is_chaser(true)
	Input.action_press("move_right")
	await wait_physics_frames(10)
	bull._chase_reaction = 0.0
	await wait_physics_frames(1)
	assert_gt(bull._chase_target.x, level.player.global_position.x + 20, "target predicts forward movement")
	var heading: Vector2 = bull._chase_heading
	var target: Vector2 = bull._chase_target
	Input.action_release("move_right")
	Input.action_press("move_left")
	bull._chase_reaction = .2
	await wait_physics_frames(2)
	assert_eq(bull._chase_target, target, "reaction interval delays resampling")
	assert_lt(absf(heading.angle_to(bull._chase_heading)), .2, "heading cannot snap on feint")
	assert_true(bull.try_capture(bull.global_position))
	assert_eq(bull._chase_heading, Vector2.ZERO, "held bulls use close-follow not free pursuit")
	SaveData.dual_lasso_intro_shown = previous
