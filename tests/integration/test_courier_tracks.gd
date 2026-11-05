extends GutTest
func after_each() -> void: get_tree().paused = false
func test_linked_gate_opens_only_after_real_bull_follows_track() -> void:
	SaveData.dual_lasso_intro_shown = true
	GameState.selected_level = 15
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level.player.global_position = Vector2(0,220)
	level._on_pen_door_opened(0)
	assert_true(level._pen_released[0])
	assert_false(level._pen_released[1],"linked target waits for courier, not instant open")
	var bull: Node = level._active_bulls[level._pens_data[0]["bull_indices"][0]]
	assert_true(bull._courier_active)
	await wait_physics_frames(700)
	assert_true(level._pen_released[1],"physical courier reaches target latch and opens it")

func test_capturing_courier_cancels_errand_but_manual_latch_remains_available() -> void:
	SaveData.dual_lasso_intro_shown = true
	GameState.selected_level = 15
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level._on_pen_door_opened(0)
	var bull: Node = level._active_bulls[level._pens_data[0]["bull_indices"][0]]
	assert_true(bull.try_capture(bull.global_position))
	assert_false(bull._courier_active)
	assert_true(level._courier_jobs.is_empty())
	assert_false(level._pen_released[1])
	level._on_pen_door_opened(1)
	assert_true(level._pen_released[1],"interrupted courier never locks progression")

func test_master_courier_physically_visits_every_latch_without_recursive_jobs() -> void:
	SaveData.dual_lasso_intro_shown = true
	GameState.selected_level = 20
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level.player.global_position = Vector2(0,220)
	level._on_pen_door_opened(0)
	for frame in range(4800):
		await wait_physics_frames(1)
		if not level._pen_released.has(false):break
	for i in range(level._pen_released.size()): assert_true(level._pen_released[i],"master route delivered latch %d" % i)
	assert_true(level._courier_jobs.is_empty(),"arrival does not recursively launch target jobs")

func test_manually_opened_targets_retire_remaining_master_errand() -> void:
	SaveData.dual_lasso_intro_shown = true
	GameState.selected_level = 20
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level._on_pen_door_opened(0)
	assert_eq(level._courier_jobs.size(),1)
	for i in range(1,level._pen_released.size()): level._on_pen_door_opened(i)
	await wait_physics_frames(2)
	assert_true(level._courier_jobs.is_empty(),"manual destinations retire obsolete errand")
	assert_false(level._active_bulls[0]._courier_active)
