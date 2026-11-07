extends GutTest

## Integration: the real level scene wired to LevelCatalog, for representative levels of every
## kind (classic, first puzzle, linked doors, most doors). Verifies wiring, not feel.

const LEVEL_SCENE: String = "res://src/Presentation/level_0.tscn"
const SAMPLE_LEVELS: Array = [1, 5, 10, 11, 14, 15, 18, 20]

func _spawn_level(level_number: int) -> Node:
	GameState.selected_level = level_number
	var level: Node = (load(LEVEL_SCENE) as PackedScene).instantiate()
	add_child_autofree(level)
	await wait_physics_frames(3)
	return level

func _doors(level: Node) -> Array:
	return level.get_children().filter(func(c): return c is PenDoor)

func test_every_sample_level_boots_with_the_expected_bulls_and_doors() -> void:
	for n in SAMPLE_LEVELS:
		var level: Node = await _spawn_level(n)
		var data: LevelData = LevelCatalog.get_level(n)
		assert_eq(level._active_bulls.size(), data.bull_count, "level %d active bulls" % n)
		assert_eq(_doors(level).size(), data.pens.size(), "level %d doors" % n)
		level.queue_free()
		await wait_physics_frames(2)

func test_unused_bulls_are_fully_inert() -> void:
	var level: Node = await _spawn_level(3)
	for i in range(3, level.all_bulls.size()):
		var bull = level.all_bulls[i]
		assert_false(bull.visible)
		assert_eq(bull.collision_layer, 0, "bull %d must not be a hidden wall" % i)
		assert_eq(bull.collision_mask, 0)

func test_non_puzzle_level_releases_every_bull_immediately() -> void:
	var level: Node = await _spawn_level(4)
	for bull in level._active_bulls:
		assert_eq(bull.controller.current_state(), BullState.State.ESCAPED)

func test_penned_bulls_stay_inert_until_their_door_opens() -> void:
	var level: Node = await _spawn_level(11)
	for bull in level._active_bulls:
		assert_eq(bull.controller.current_state(), BullState.State.SAFE)
	level._on_pen_door_opened(0)
	for bull in level._active_bulls:
		assert_eq(bull.controller.current_state(), BullState.State.ESCAPED)

func test_linked_door_releases_its_targets_only() -> void:
	var level: Node = await _spawn_level(15)  # NE door (pen 0) also opens NW (pen 1)
	level._on_pen_door_opened(0)
	assert_true(level._pen_released[0])
	assert_false(level._pen_released[1],"linked target waits for real courier arrival")
	assert_eq(level._courier_jobs.values()[0]["targets"],[1])
	assert_eq(level._pen_released.size(),2)

func test_pause_and_resume_toggle_the_tree_and_hud() -> void:
	var level: Node = await _spawn_level(1)
	level.pause_game()
	assert_true(get_tree().paused)
	assert_true(level.hud._pause_panel.visible)
	level.resume_game()
	assert_false(get_tree().paused)
	assert_false(level.hud._pause_panel.visible)

func test_exactly_one_designated_chaser_appears_while_a_bull_is_held() -> void:
	var level: Node = await _spawn_level(4)
	var held = level._active_bulls[0]
	assert_true(held.try_capture(held.global_position))
	level._update_chaser(level.CHASER_ENGAGE_DELAY_SECONDS + 0.1)
	var chasers: int = 0
	for bull in level._active_bulls:
		if bull._is_chaser:
			chasers += 1
	assert_eq(chasers, 1)
	assert_ne(level._chaser_index, ChaserDirector.NO_CHASER)

func test_no_chaser_when_nothing_is_held() -> void:
	var level: Node = await _spawn_level(4)
	level._update_chaser(level.CHASER_ENGAGE_DELAY_SECONDS + 0.1)
	for bull in level._active_bulls:
		assert_false(bull._is_chaser)

func _hold(bull) -> void:
	assert_true(bull.try_capture(bull.global_position))

func test_held_bull_ignores_other_bulls_and_wild_bulls_ignore_it() -> void:
	var level: Node = await _spawn_level(4)
	var held = level._active_bulls[0]
	_hold(held)
	assert_eq(held.collision_layer, CollisionLayers.BULL_PASSIVE)
	assert_eq(held.collision_mask & CollisionLayers.BULL, 0, "held bull must not collide with bulls")
	for i in range(1, level._active_bulls.size()):
		var other = level._active_bulls[i]
		assert_eq(other.collision_mask & CollisionLayers.BULL_PASSIVE, 0, "wild bulls must not collide with the held bull")
		assert_ne(other.collision_mask & CollisionLayers.BULL, 0, "wild bulls still collide with each other (D029)")

func test_pen_still_detects_passive_bulls() -> void:
	var level: Node = await _spawn_level(1)
	assert_ne(level.pen.collision_mask & CollisionLayers.BULL_PASSIVE, 0)

func test_delivered_bull_stops_being_an_obstacle_for_the_next_one() -> void:
	var level: Node = await _spawn_level(11)  # all bulls start penned and inert (SAFE)
	var a = level._active_bulls[0]
	var b = level._active_bulls[1]
	a.global_position = Vector2(200, 100)
	b.global_position = Vector2(260, 100)
	await wait_physics_frames(2)
	var toward_a := Vector2(-40, 0)
	assert_true(b.test_move(b.global_transform, toward_a), "control: a never-captured SAFE bull is solid (D029)")
	# deliver a: SAFE -> ESCAPED -> captured -> CONTROLLED -> back in the pen (SAFE)
	a.begin_active()
	_hold(a)
	a.controller.update_hold(100.0, 0.0, 0.0)
	a.controller.update_hold(100.0, 0.0, 0.0)
	assert_eq(a.controller.current_state(), BullState.State.CONTROLLED)
	assert_true(a.controller.return_to_pen())
	assert_eq(a.controller.current_state(), BullState.State.SAFE)
	assert_eq(a.collision_layer, CollisionLayers.BULL_PASSIVE, "delivered bull is passive")
	a.global_position = Vector2(200, 100)
	await wait_physics_frames(2)
	assert_false(b.test_move(b.global_transform, toward_a), "delivered bull no longer blocks others")

func test_bull_released_from_capture_is_solid_again() -> void:
	var level: Node = await _spawn_level(4)
	var bull = level._active_bulls[0]
	_hold(bull)
	assert_true(bull.controller.force_escape())
	assert_eq(bull.collision_layer, CollisionLayers.BULL)
	assert_ne(bull.collision_mask & CollisionLayers.BULL, 0)

func test_blocked_chaser_hands_the_baton_to_another_wild_bull() -> void:
	var level: Node = await _spawn_level(4)
	_hold(level._active_bulls[3])
	level._update_chaser(level.CHASER_ENGAGE_DELAY_SECONDS + 0.1)
	var old_chaser: int = level._chaser_index
	assert_ne(old_chaser, ChaserDirector.NO_CHASER)
	level._on_chaser_blocked(level._active_bulls[old_chaser])
	assert_ne(level._chaser_index, ChaserDirector.NO_CHASER)
	assert_ne(level._chaser_index, old_chaser)
	assert_false(level._active_bulls[old_chaser]._is_chaser)
	var chasers: int = 0
	for bull in level._active_bulls:
		if bull._is_chaser:
			chasers += 1
	assert_eq(chasers, 1, "still exactly one chaser")

func test_stale_blocked_report_from_a_non_chaser_is_ignored() -> void:
	var level: Node = await _spawn_level(4)
	_hold(level._active_bulls[3])
	level._update_chaser(level.CHASER_ENGAGE_DELAY_SECONDS + 0.1)
	var chaser: int = level._chaser_index
	var other = level._active_bulls[(chaser + 1) % level._active_bulls.size()]
	level._on_chaser_blocked(other)
	assert_eq(level._chaser_index, chaser)

func test_both_sticks_use_following_mode() -> void:
	var level: Node = await _spawn_level(1)
	for stick_name in ["MoveJoystick", "AimJoystick"]:
		var stick := level.get_node("TouchControls/" + stick_name) as VirtualJoystick
		assert_eq(stick.joystick_mode, VirtualJoystick.JOYSTICK_FOLLOWING, stick_name)

func test_releasing_the_aim_stick_near_the_centre_cancels_the_throw() -> void:
	var level: Node = await _spawn_level(1)
	var player = level.player
	player._on_aim_pressed()
	assert_true(player._is_charging)
	player._on_aim_released(Vector2(0.05, 0.0))
	assert_false(player._is_charging)
	assert_false(player._lasso_in_flight, "a cancelled throw must not spend the lasso")

func test_a_tap_without_moving_cancels_too() -> void:
	var level: Node = await _spawn_level(1)
	var player = level.player
	player._on_aim_pressed()
	player._on_aim_released(Vector2.ZERO)
	assert_false(player._is_charging)
	assert_false(player._lasso_in_flight)

func test_releasing_the_aim_stick_beyond_the_zone_throws_at_the_stick_distance() -> void:
	var level: Node = await _spawn_level(1)
	var player = level.player
	watch_signals(player)
	player.lasso_travel_time = 0.05
	player._on_aim_pressed()
	player._on_aim_released(Vector2(0.5, 0.0))
	assert_true(player._lasso_in_flight)
	await wait_seconds(0.3)
	assert_signal_emitted(player, "lasso_thrown")
	var params: Array = get_signal_parameters(player, "lasso_thrown")
	assert_almost_eq((params[1] as Vector2).distance_to(params[0]), 0.5 * player.max_throw_distance, 0.5)

func _capture(level: Node, bull_index: int) -> Node:
	# Throw like the player: the landing point decides which bull is hit.
	var bull = level._active_bulls[bull_index]
	level._on_lasso_thrown(level.player.global_position, bull.global_position)
	assert_true(bull.controller.is_held(), "bull %d should be captured" % bull_index)
	return bull

func _tap(player: Node) -> void:
	player._on_aim_pressed()
	player._on_aim_released(Vector2.ZERO)

func test_lasso_captures_a_bull_even_with_an_obstacle_in_between() -> void:
	var level: Node = await _spawn_level(5)
	var bull = level._active_bulls[0]
	level.player.global_position = Vector2(0, 0)
	bull.global_position = Vector2(200, 0)
	# a solid wall exactly between the player and the bull
	var wall := StaticBody2D.new()
	wall.collision_layer = CollisionLayers.FENCE
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(20, 300)
	shape.shape = rect
	wall.add_child(shape)
	wall.position = Vector2(100, 0)
	level.add_child(wall)
	await wait_physics_frames(2)
	level._on_lasso_thrown(level.player.global_position, bull.global_position)
	assert_true(bull.controller.is_held(), "obstacles no longer block the lasso (D038)")

func test_double_tap_releases_the_captured_bull() -> void:
	var level: Node = await _spawn_level(5)
	var bull = _capture(level, 0)
	_tap(level.player)
	assert_true(bull.controller.is_held(), "one tap is not enough")
	_tap(level.player)
	assert_eq(bull.controller.current_state(), BullState.State.ESCAPED)
	assert_eq(bull.collision_layer, CollisionLayers.BULL, "released bull is solid again")

func test_double_tap_releases_only_the_most_recently_captured_bull() -> void:
	var level: Node = await _spawn_level(5)  # dual capture is allowed by the level via upgrades? force it
	level._max_simultaneous_captures = 2
	var first = _capture(level, 0)
	var second = _capture(level, 1)
	_tap(level.player)
	_tap(level.player)
	assert_true(first.controller.is_held(), "the older capture stays")
	assert_eq(second.controller.current_state(), BullState.State.ESCAPED)

func test_taps_too_far_apart_do_not_release() -> void:
	var level: Node = await _spawn_level(5)
	var bull = _capture(level, 0)
	_tap(level.player)
	await wait_seconds(LassoAim.DOUBLE_TAP_WINDOW_SECONDS + 0.1)
	_tap(level.player)
	assert_true(bull.controller.is_held())

func test_a_throw_between_two_taps_breaks_the_double_tap() -> void:
	var level: Node = await _spawn_level(5)
	level._max_simultaneous_captures = 2
	var bull = _capture(level, 0)
	_tap(level.player)
	level.player.lasso_travel_time = 5.0
	level.player._on_aim_pressed()
	level.player._on_aim_released(Vector2(0.8, 0.0))  # a real throw
	_tap(level.player)
	assert_true(bull.controller.is_held())

func test_double_tap_with_nothing_held_does_nothing() -> void:
	var level: Node = await _spawn_level(5)
	_tap(level.player)
	_tap(level.player)
	for bull in level._active_bulls:
		assert_false(bull.controller.is_held())

func test_a_bull_released_on_purpose_cannot_stun_the_player_right_away() -> void:
	var level: Node = await _spawn_level(5)
	var bull = _capture(level, 0)
	level.player.global_position = Vector2.ZERO
	bull.global_position = Vector2(10, 0)  # overlapping: would stun immediately if wild
	_tap(level.player)
	_tap(level.player)
	assert_eq(bull.controller.current_state(), BullState.State.ESCAPED)
	await wait_physics_frames(5)
	assert_eq(level.player._stun_time_remaining, 0.0, "grace period after a deliberate release")

var _intro_shown: bool
func before_each() -> void:
	# the phone applies Spanish from the menu; the bare level spawn skips that,
	# so set it here or the guidance cues come out in English (OS locale)
	TranslationServer.set_locale("es")
	_intro_shown = SaveData.dual_lasso_intro_shown
	SaveData.dual_lasso_intro_shown = true  # smoke wiring tests, not the one-shot intro

func after_each() -> void:
	SaveData.dual_lasso_intro_shown = _intro_shown
	get_tree().paused = false

func test_keyboard_charge_increases_range_without_a_touch_stick() -> void:
	var level: Node = await _spawn_level(1)
	var player = level.player
	player._start_charging()
	player._process_throw_input(0.25)
	assert_almost_eq(player._charge_distance, player.charge_speed * 0.25, 0.1)
	player._process_throw_input(5.0)
	assert_almost_eq(player._charge_distance, player.max_throw_distance, 0.1)

func test_touch_aim_does_not_use_keyboard_charge_growth() -> void:
	var level: Node = await _spawn_level(1)
	level.player._on_aim_pressed()
	level.player._process_throw_input(0.5)
	assert_eq(level.player._charge_distance, 0.0)

func test_pause_cancels_a_charge_and_hides_touch_input() -> void:
	var level: Node = await _spawn_level(1)
	level.player._on_aim_pressed()
	level.pause_game()
	assert_false(level.player._is_charging)
	assert_false(level.touch_controls.visible)
	level.resume_game()
	assert_true(level.touch_controls.visible)

func test_bull_that_calms_inside_the_goal_is_delivered_without_reentering() -> void:
	var level: Node = await _spawn_level(1)
	var bull = _capture(level, 0)
	bull.set_physics_process(false)
	bull.global_position = level.pen.global_position
	await wait_physics_frames(3)
	assert_eq(level._bulls_returned, 0, "still calming, not delivered")
	# Do not write a real progression record when this one-bull level wins.
	level._win_requires_all_bulls = false
	bull.controller.update_hold(100.0, 0.0, 0.0)
	bull.controller.update_hold(100.0, 0.0, 0.0)
	await wait_physics_frames(3)
	assert_eq(level._bulls_returned, 1)
	await wait_physics_frames(3)
	assert_eq(level._bulls_returned, 1, "delivery emits only once")

func test_end_of_game_stops_door_progress() -> void:
	var level: Node = await _spawn_level(11)
	var door: PenDoor = _doors(level)[0]
	level._trigger_lose("test")
	assert_false(door.is_processing())
	assert_false(level.player._is_charging)

func test_next_level_button_only_appears_after_winning_before_last_level() -> void:
	var level: Node = await _spawn_level(1)
	assert_false(level.hud._next_button.visible)
	level.hud.show_win()
	assert_true(level.hud._next_button.visible)
	assert_false(level.hud.restart_button.visible)
	level.queue_free()
	await wait_physics_frames(2)
	level = await _spawn_level(LevelCatalog.MAX_LEVEL)
	level.hud.show_win()
	assert_false(level.hud._next_button.visible)
	assert_true(level.hud.restart_button.visible)

func test_keyboard_release_lands_at_charged_distance() -> void:
	var level: Node = await _spawn_level(1)
	var player = level.player
	watch_signals(player)
	player.lasso_travel_time = 0.02
	player.aim_direction = Vector2.LEFT
	player._start_charging()
	player._process_throw_input(0.5)
	player._release_throw()
	await wait_seconds(0.15)
	assert_signal_emitted(player, "lasso_thrown")
	var params: Array = get_signal_parameters(player, "lasso_thrown")
	assert_almost_eq((params[1] as Vector2).x - (params[0] as Vector2).x, -150.0, 0.1)

func test_puzzle_bulls_and_gates_have_matching_numbers() -> void:
	var level: Node = await _spawn_level(20)
	var doors: Array = _doors(level)
	for index in range(level._pens_data.size()):
		assert_eq(doors[index].door_number, index + 1)
		for bull_index: int in level._pens_data[index].get("bull_indices", []):
			assert_eq(level._active_bulls[bull_index].pen_number, index + 1)
	assert_eq(doors[0].linked_count,1)
	assert_false(doors[1].is_master)

func test_stunned_player_cannot_start_a_touch_throw() -> void:
	var level: Node = await _spawn_level(1)
	level.player.stun(1.0)
	level.player._on_aim_pressed()
	level.player._on_aim_released(Vector2.RIGHT)
	assert_false(level.player._is_charging)
	assert_false(level.player._lasso_in_flight)

func test_release_from_before_pause_does_not_throw_after_resume() -> void:
	var level: Node = await _spawn_level(1)
	level.player._on_aim_pressed()
	level.pause_game()
	level.resume_game()
	level.player._on_aim_released(Vector2.RIGHT)
	assert_false(level.player._lasso_in_flight)
	assert_false(level.player._is_charging)

func test_sound_choice_survives_level_instances_in_this_session() -> void:
	var original: bool = GameState.sound_enabled
	var level: Node = await _spawn_level(1)
	level._on_sound_toggled(false)
	assert_false(GameState.sound_enabled)
	assert_false(level._audio.enabled)
	level.queue_free()
	await wait_physics_frames(2)
	level = await _spawn_level(2)
	assert_false(level._audio.enabled)
	GameState.sound_enabled = original

func test_pause_clears_native_joystick_actions() -> void:
	var level: Node = await _spawn_level(1)
	Input.action_press("move_right", 0.75)
	Input.action_press("aim_up", 0.75)
	level.pause_game()
	assert_false(Input.is_action_pressed("move_right"))
	assert_false(Input.is_action_pressed("aim_up"))
	level.resume_game()

func test_escape_on_always_processing_hud_resumes_pause() -> void:
	# Escape reaches the level through GameState.request_back() -> navigate_back()
	# (safe Back navigation, 1486bd3); the HUD no longer handles ui_cancel itself.
	var level: Node = await _spawn_level(1)
	level.pause_game()
	assert_eq(level.hud.process_mode, Node.PROCESS_MODE_ALWAYS)
	level.navigate_back()
	assert_false(get_tree().paused)
	assert_false(level.hud._pause_panel.visible)

func test_end_game_cancels_a_lasso_already_in_flight() -> void:
	var level: Node = await _spawn_level(1)
	var player = level.player
	watch_signals(player)
	player.lasso_travel_time = 0.1
	player._start_charging()
	player._release_throw(Vector2.RIGHT)
	assert_true(player._lasso_in_flight)
	level._trigger_lose("test")
	await wait_seconds(0.3)
	assert_signal_not_emitted(player, "lasso_thrown")
	assert_false(player._lasso_in_flight)

func test_tranquilizer_cannot_be_used_behind_pause_overlay() -> void:
	var level: Node = await _spawn_level(5)
	var bull = _capture(level, 0)
	level._tranquilizer_available = true
	level.pause_game()
	level._on_tranquilizer_requested()
	assert_true(level._tranquilizer_available)
	assert_ne(bull.controller.current_state(), BullState.State.CONTROLLED)
	level.resume_game()

func test_guidance_changes_from_capture_to_calming_to_delivery() -> void:
	var level: Node = await _spawn_level(1)
	level._update_nerves_hud()
	assert_string_contains(level.hud._hint_label.text, "Laza")
	var bull = _capture(level, 0)
	level._update_nerves_hud()
	assert_string_contains(level.hud._hint_label.text, "mientras se calma")
	bull.controller.use_tranquilizer()
	level._update_nerves_hud()
	assert_string_contains(level.hud._hint_label.text, "META")
	assert_string_contains(level.hud._hint_label.text, "calmado")

func test_keyboard_release_action_is_mapped_and_releases_a_bull() -> void:
	var level: Node = await _spawn_level(1)
	var bull = _capture(level, 0)
	assert_true(InputMap.has_action("release_capture"))
	var events: Array[InputEvent] = InputMap.action_get_events("release_capture")
	assert_eq(events.size(), 1)
	assert_eq(events[0].physical_keycode, KEY_R)
	Input.action_press("release_capture")
	await wait_physics_frames(2)
	Input.action_release("release_capture")
	assert_false(bull.controller.is_held())

func test_end_panel_hides_gameplay_only_controls() -> void:
	var level: Node = await _spawn_level(5)
	level.hud.set_tranquilizer_available(true)
	level.hud.update_nerves_slot(0, 50)
	level.hud.show_lose("test")
	assert_false(level.hud.tranquilizer_button.visible)
	assert_false(level.hud.nerves_group.visible)
	assert_false(level.hud._pause_button.visible)

func test_lasso_in_flight_waits_through_pause_then_lands_on_resume() -> void:
	var level: Node = await _spawn_level(1)
	var player = level.player
	watch_signals(player)
	player.lasso_travel_time = 0.1
	player._start_charging()
	player._release_throw(Vector2.RIGHT)
	level.pause_game()
	await get_tree().create_timer(0.25, true).timeout
	assert_signal_not_emitted(player, "lasso_thrown")
	assert_true(player._lasso_in_flight)
	level.resume_game()
	await wait_seconds(0.25)
	assert_signal_emitted(player, "lasso_thrown")
	assert_false(player._lasso_in_flight)
