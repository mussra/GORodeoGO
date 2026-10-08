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
	assert_true(level._pen_released[1])
	assert_false(level._pen_released[2])
	assert_false(level._pen_released[3])

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

func after_each() -> void:
	get_tree().paused = false
