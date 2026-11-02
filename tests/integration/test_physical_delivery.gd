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

func test_pursuer_stops_drinking_without_stun_then_can_be_captured() -> void:
	GameState.selected_level = 3
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var bull: CharacterBody2D = level._active_bulls[0]
	for other in level._active_bulls:
		if other != bull: other.set_physics_process(false)
	var station: Node2D = level._distraction_stations[0]
	bull.global_position = station.global_position
	level.player.global_position = station.global_position + Vector2(20, 0)
	bull.set_is_chaser(true)
	await wait_physics_frames(4)
	assert_true(bull._distraction.active())
	assert_eq(bull.velocity, Vector2.ZERO)
	assert_eq(level.player._stun_time_remaining, 0.0, "drinking bull does not stun nearby player")
	var before: Vector2 = bull.global_position
	await wait_physics_frames(15)
	assert_eq(bull.global_position, before, "bull stays still during distraction")
	assert_true(bull.try_capture(bull.global_position))
	assert_false(bull._distraction.active(), "capture immediately cancels drinking")
	assert_true(bull.controller.is_held())

func test_distraction_stations_are_non_solid_and_clear_of_obstacles() -> void:
	for number in range(3, LevelCatalog.MAX_LEVEL + 1):
		var data: LevelData = LevelCatalog.get_level(number)
		for point: Vector2 in [Vector2(-350, -150), Vector2(400, 100)]:
			for obstacle: Rect2 in data.obstacle_rects:
				assert_false(obstacle.grow(DistractionStation.TRIGGER_RADIUS).has_point(point), "station trigger not blocked at level %d" % number)
