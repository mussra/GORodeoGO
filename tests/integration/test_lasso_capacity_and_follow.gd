extends GutTest

## Ant's 4-nov gameplay requests, against the real level scene:
## 1. A lassoed bull keeps pace with the player and follows close (no more lagging into the herd).
## 2. Lasso throws are limited to free slots: 1 normally, 2 with the dual lasso; a full
##    grip refuses the throw until a double-tap release frees a slot.
## 3. The dual-lasso unlock celebration shows once, pauses the action, and persists.

var _progress: int
var _intro_shown: bool
var _save_path: String

func before_each() -> void:
	_progress = SaveData.highest_level_completed
	_intro_shown = SaveData.dual_lasso_intro_shown
	_save_path = SaveData.save_path
	SaveData.dual_lasso_intro_shown = true  # default: gameplay tests skip the one-shot intro

func after_each() -> void:
	SaveData.highest_level_completed = _progress
	SaveData.dual_lasso_intro_shown = _intro_shown
	SaveData.save_path = _save_path
	for action in ["move_left", "move_right", "move_up", "move_down", "throw_lasso"]:
		Input.action_release(action)
	get_tree().paused = false

func _spawn_level(level_number: int, progress: int) -> Node:
	SaveData.highest_level_completed = progress
	GameState.selected_level = level_number
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	level.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child_autofree(level)
	await wait_physics_frames(3)
	return level

func _capture(level: Node, bull: CharacterBody2D) -> void:
	level.player.global_position = bull.global_position + Vector2(-80, 0)
	level.player.lasso.resolve_capture(bull.global_position)

func test_towed_bull_keeps_pace_with_sprinting_player() -> void:
	var level: Node = await _spawn_level(1, 0)  # base speed, no upgrades
	var bull: CharacterBody2D = level._active_bulls[0]
	for other in level._active_bulls:
		if other != bull:
			other.set_physics_process(false)
	_capture(level, bull)
	assert_true(bull.controller.is_held())
	Input.action_press("move_right")
	var max_distance: float = 0.0
	for frame in range(180):  # 3s at 60fps — long enough to cross the arena
		await wait_physics_frames(1)
		max_distance = maxf(max_distance, bull.global_position.distance_to(level.player.global_position))
	Input.action_release("move_right")
	var final_distance: float = bull.global_position.distance_to(level.player.global_position)
	assert_lt(max_distance, 160.0, "bull never lags far behind a sprinting player (old tow let the herd catch it)")
	assert_lt(final_distance, 90.0, "bull settles into close follow")
	assert_gt(level.player.global_position.x, 250.0, "player actually sprinted across the arena")

func test_towed_bull_stays_close_with_dense_herd_around() -> void:
	var level: Node = await _spawn_level(10, 0)  # 10 wild bulls, no pens
	var bull: CharacterBody2D = level._active_bulls[0]
	# Isolate the tow mechanic under crowding: the herd mills around the pair (nerves and
	# disturbance keep working), but no chaser and no stun-release chain — that mechanic is
	# retained explicitly by Ant at 19:58 and
	# has its own tests. The touch grace is the game's own "just released" contact suppressor.
	level._chaser_director = ChaserDirector.new(999.0)
	for other in level._active_bulls:
		other.chase_probability = 0.0
		if other != bull:
			other._touch_grace_remaining = 999.0
	_capture(level, bull)
	Input.action_press("move_right")
	Input.action_press("move_up")
	var max_distance: float = 0.0
	for frame in range(120):
		await wait_physics_frames(1)
		max_distance = maxf(max_distance, bull.global_position.distance_to(level.player.global_position))
		if level._game_over:
			break
	Input.action_release("move_right")
	Input.action_release("move_up")
	assert_lt(max_distance, 200.0, "even with 9 wild bulls crowding, the towed bull keeps up")
	assert_true(bull.controller.is_held(), "still held at the end: nothing but a real stun dropped it")

func test_throw_blocked_without_free_slot_single_lasso() -> void:
	var level: Node = await _spawn_level(1, 0)  # max_simultaneous_captures == 1
	var bull: CharacterBody2D = level._active_bulls[0]
	_capture(level, bull)
	await wait_physics_frames(2)  # Level0 propagates the held count to the player
	assert_eq(level.player._active_capture_count, 1)
	watch_signals(level.player)
	Input.action_press("throw_lasso")
	await wait_physics_frames(2)
	Input.action_release("throw_lasso")
	assert_false(level.player.lasso._is_charging, "no throw starts with every slot occupied")
	assert_signal_emitted(level.player, "throw_blocked")
	assert_true(level.hud._toasts.active.any(func(n):return str(n.text).contains("hueco") or str(n.text).contains("room")), "HUD explains how to free a slot")

func test_throw_allowed_with_dual_lasso_while_one_slot_free() -> void:
	var level: Node = await _spawn_level(3, LevelCatalog.MAX_LEVEL)  # dual capture unlocked
	_capture(level, level._active_bulls[0])
	await wait_physics_frames(2)
	Input.action_press("throw_lasso")
	await wait_physics_frames(2)
	assert_true(level.player.lasso._is_charging, "second throw allowed with dual lasso and one slot free")
	Input.action_release("throw_lasso")
	level.player.cancel_all_actions()

func test_throw_blocked_with_dual_lasso_until_double_tap_release_frees_slot() -> void:
	var level: Node = await _spawn_level(3, LevelCatalog.MAX_LEVEL)
	_capture(level, level._active_bulls[0])
	_capture(level, level._active_bulls[1])
	await wait_physics_frames(2)
	assert_eq(level.player._active_capture_count, 2)
	watch_signals(level.player)
	Input.action_press("throw_lasso")
	await wait_physics_frames(2)
	Input.action_release("throw_lasso")
	assert_false(level.player.lasso._is_charging, "two held bulls with dual lasso: no third throw")
	assert_signal_emitted(level.player, "throw_blocked")
	# Double tap on the aim stick drops the most recent capture (D038) and frees a slot.
	level.player.lasso._on_aim_pressed()
	level.player.lasso._on_aim_released(Vector2.ZERO)
	level.player.lasso._on_aim_pressed()
	level.player.lasso._on_aim_released(Vector2.ZERO)
	await wait_physics_frames(2)
	assert_eq(level.player._active_capture_count, 1)
	Input.action_press("throw_lasso")
	await wait_physics_frames(2)
	assert_true(level.player.lasso._is_charging, "throw works again after releasing one bull")
	Input.action_release("throw_lasso")
	level.player.cancel_all_actions()

func test_dual_lasso_intro_shows_once_pauses_and_persists() -> void:
	SaveData.dual_lasso_intro_shown = false
	SaveData.save_path = "user://qa_dual_lasso_intro_test.dat"  # never touch the real save
	var level: Node = await _spawn_level(6, LevelCatalog.MAX_LEVEL)
	assert_true(get_tree().paused, "action pauses behind the celebration")
	assert_true(level.hud._dual_lasso_panel.visible, "celebration overlay visible")
	var time_before: float = level._time_remaining
	var bull_before: Vector2 = level._active_bulls[0].global_position
	await get_tree().create_timer(.25, true).timeout
	assert_eq(level._time_remaining, time_before, "reading costs no game time")
	assert_eq(level._active_bulls[0].global_position, bull_before, "bulls cannot move during explanation")
	level.hud._on_dual_lasso_accept_pressed()
	assert_false(get_tree().paused, "dismissing resumes the action")
	assert_false(level.hud._dual_lasso_panel.visible)
	assert_true(SaveData.dual_lasso_intro_shown, "intro marked as seen")
	# A later level start does not show it again.
	var level2: Node = await _spawn_level(7, LevelCatalog.MAX_LEVEL)
	assert_false(get_tree().paused, "intro does not nag on the next level")
	assert_true(level2.hud._dual_lasso_panel == null or not level2.hud._dual_lasso_panel.visible)
	DirAccess.remove_absolute("user://qa_dual_lasso_intro_test.dat")

func test_win_flow_offers_next_level_and_main_menu_mid_campaign() -> void:
	var level: Node = await _spawn_level(6, LevelCatalog.MAX_LEVEL)
	level._trigger_win()
	await wait_physics_frames(2)
	assert_true(level.hud._next_button.visible, "next level offered mid-campaign")
	assert_true(level.hud.quit_button.visible, "main menu offered")
	assert_false(level.hud.restart_button.visible, "restart replaced by next on win")
	# Real scene switching is exercised by the standalone review_flow harness.
	assert_gt(level.hud._next_button.pressed.get_connections().size(), 0, "next button wired")

func test_win_flow_last_level_offers_menu_not_next() -> void:
	var level: Node = await _spawn_level(LevelCatalog.MAX_LEVEL, LevelCatalog.MAX_LEVEL)
	level._trigger_win()
	await wait_physics_frames(2)
	assert_false(level.hud._next_button.visible, "no next beyond the last level")
	assert_true(level.hud.quit_button.visible, "main menu still offered on the last level")
	GameState.selected_level = LevelCatalog.MAX_LEVEL
	level._on_next_requested()
	assert_eq(GameState.selected_level, LevelCatalog.MAX_LEVEL, "next is a no-op on the last level")

## Characterization: Ant 19:58 chose to KEEP dropping the capture on rider contact.
## A straight route through a dense herd therefore need not guarantee delivery.
func test_contact_still_drops_capture_with_full_herd() -> void:
	seed(20261104)
	var level: Node = await _spawn_level(10, 0)  # 10 bulls, all default behaviours
	var bull: CharacterBody2D = level._active_bulls[0]
	_capture(level, bull)
	bull.controller.update_hold(100.0, 100.0, 0.0)  # pre-calmed: isolates the tow, not the nerves timer
	var pen_pos: Vector2 = level.pen.global_position
	var dropped: bool = false
	for frame in range(600):  # 10s budget to cross the arena and deposit
		# Steer toward the pen with the real movement actions.
		for action in ["move_left", "move_right", "move_up", "move_down"]:
			Input.action_release(action)
		var to_pen: Vector2 = pen_pos - level.player.global_position
		if to_pen.x > 8: Input.action_press("move_right")
		elif to_pen.x < -8: Input.action_press("move_left")
		if to_pen.y > 8: Input.action_press("move_down")
		elif to_pen.y < -8: Input.action_press("move_up")
		await wait_physics_frames(1)
		if not bull.controller.is_held() and not level.pen.overlaps_body(bull):
			dropped = true
			break
		if level._bulls_returned >= 1:
			break
	for action in ["move_left", "move_right", "move_up", "move_down"]:
		Input.action_release(action)
	assert_true(dropped, "Ant 19:58 explicitly keeps losing capture on a hit")
	assert_gt(level.player._stun_time_remaining, 0.0, "drop accompanies actual rider stun")

func test_no_room_hint_only_once_per_level_attempt189()->void:
	var level:Node=await _spawn_level(3,LevelCatalog.MAX_LEVEL)
	level.hud._toasts.clear();level.hud._toasts.set_process(false)
	assert_false(level._no_lasso_room_hint_shown189)
	level._on_throw_blocked()
	assert_true(level._no_lasso_room_hint_shown189)
	assert_eq(level.hud._toasts.active.size(),1)
	level.hud._toasts.advance(1.)
	var left:float=level.hud._toasts.active[0].left
	level._on_throw_blocked()
	assert_eq(level.hud._toasts.active[0].left,left,"Repeated attempts must not restart the toast")
	level.hud._toasts.clear()
	level.player.set_active_capture_count(0)
	level.player.set_active_capture_count(2)
	level._on_throw_blocked()
	assert_true(level.hud._toasts.active.is_empty(),"Still quiet after freeing and filling slots")
	var next:Node=await _spawn_level(3,LevelCatalog.MAX_LEVEL)
	next.hud._toasts.clear()
	assert_false(next._no_lasso_room_hint_shown189,"Retry/new level may explain once again")
	next._on_throw_blocked()
	assert_eq(next.hud._toasts.active.size(),1)
