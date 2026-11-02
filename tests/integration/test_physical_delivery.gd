extends GutTest

## Scripted engine checks, not a human playthrough or difficulty measurement.
var _progress: int
func before_each() -> void:
	_progress = SaveData.highest_level_completed
	SaveData.highest_level_completed = LevelCatalog.MAX_LEVEL
func after_each() -> void:
	SaveData.highest_level_completed = _progress
	for action in ["move_left", "move_right", "move_up", "move_down"]:
		Input.action_release(action)
	get_tree().paused = false

func test_real_tow_movement_delivers_without_teleporting_bull_to_pen() -> void:
	GameState.selected_level = 1
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var bull: CharacterBody2D = level._active_bulls[0]
	# Setup only: place rider within lasso range, with bull at its real spawn.
	level.player.global_position = bull.global_position + Vector2(-100, 0)
	level._on_lasso_thrown(level.player.global_position, bull.global_position)
	bull.controller.update_hold(100.0, 100.0, 0.0)
	assert_eq(bull.controller.current_state(), BullState.State.CONTROLLED)
	Input.action_press("move_left")
	for frame in range(240):
		await wait_physics_frames(1)
		if level.player.global_position.x <= -330:
			Input.action_release("move_left")
		if level._game_over:
			break
	Input.action_release("move_left")
	assert_true(level._game_over, "real player and tow physics reach goal")
	assert_eq(level._bulls_returned, 1)
	assert_true(level.pen.overlaps_body(bull))
	assert_eq(bull.controller.current_state(), BullState.State.SAFE)

func test_door_opens_via_real_player_overlap_and_stillness() -> void:
	GameState.selected_level = 11
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	for bull in level._active_bulls:
		assert_eq(bull.controller.current_state(), BullState.State.SAFE)
	level.player.global_position = level._pens_data[0]["door_position"]
	await wait_physics_frames(4)
	assert_false(level._pen_released[0], "entry alone does not skip hold duration")
	await wait_seconds(LevelCatalog.DEFAULT_DOOR_HOLD_SECONDS + 0.15)
	assert_true(level._pen_released[0], "physical overlap and hold opens pen")
	for bull in level._active_bulls:
		assert_true(bull.controller.is_wild())

func test_timeout_remains_defeat_if_controlled_bull_overlaps_goal_afterwards() -> void:
	GameState.selected_level = 1
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var bull: CharacterBody2D = level._active_bulls[0]
	level._on_lasso_thrown(level.player.global_position, bull.global_position)
	bull.controller.update_hold(100.0, 0.0, 0.0)
	bull.global_position = level.pen.global_position
	level._trigger_lose("Tiempo agotado")
	await wait_physics_frames(4)
	assert_eq(level._bulls_returned, 0, "no late delivery after defeat")
	assert_true(level.hud.end_label.text.contains("Tiempo agotado"), "defeat cannot become victory")
	assert_eq(bull.controller.current_state(), BullState.State.CONTROLLED)
