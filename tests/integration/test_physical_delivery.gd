extends GutTest

## Scripted engine checks, not a human playthrough or difficulty measurement.
var _progress: int
var _intro_shown: bool
func before_each() -> void:
	_progress = SaveData.highest_level_completed
	SaveData.highest_level_completed = LevelCatalog.MAX_LEVEL
	_intro_shown = SaveData.dual_lasso_intro_shown
	SaveData.dual_lasso_intro_shown = true  # these tests exercise gameplay, not the one-shot intro
func after_each() -> void:
	SaveData.highest_level_completed = _progress
	SaveData.dual_lasso_intro_shown = _intro_shown
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
	level.player.lasso.resolve_capture(bull.global_position)
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
	level.player.lasso.resolve_capture(bull.global_position)
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
	await wait_physics_frames(40)
	assert_lt(bull.global_position.distance_to(bull._distraction_target), 1.1, "short physical approach aligns muzzle with station")
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

func test_drinking_bull_does_not_disturb_a_nearby_held_bull() -> void:
	GameState.selected_level = 3
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var held: Node2D = level._active_bulls[0]
	var drinking: Node2D = level._active_bulls[1]
	for bull in level._active_bulls: bull.set_physics_process(false)
	held.try_capture(held.global_position)
	drinking.global_position = held.global_position + Vector2(20, 0)
	drinking._distraction.try_start(true, true, "water")
	assert_eq(held._compute_disturbance(), 0.0, "distracted pursuer no longer agitates captured bull")
	drinking._distraction.cancel()
	assert_eq(held._compute_disturbance(), 1.0, "wild contact matters again after distraction")

func test_distraction_timer_freezes_in_pause_and_at_game_end() -> void:
	GameState.selected_level = 3
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var bull: Node2D = level._active_bulls[0]
	bull._distraction.try_start(true, true, "hay")
	level.pause_game()
	var remaining: float = bull._distraction.remaining
	await get_tree().create_timer(0.2, true).timeout
	assert_eq(bull._distraction.remaining, remaining)
	level.resume_game()
	await wait_physics_frames(3)
	assert_lt(bull._distraction.remaining, remaining)
	level._trigger_lose("Test")
	remaining = bull._distraction.remaining
	await wait_physics_frames(4)
	assert_eq(bull._distraction.remaining, remaining)
