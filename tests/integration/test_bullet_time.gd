extends GutTest
func after_each() -> void:
	Engine.time_scale = 1.0
func test_drawing_slows_world_and_every_exit_restores_time() -> void:
	var source: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	var player: Node = source.get_node("Player").duplicate()
	source.free()
	add_child_autofree(player)
	await wait_physics_frames(1)
	player._on_move_pressed()
	player._on_move_released(Vector2.ZERO)
	player._on_move_pressed()
	assert_almost_eq(Engine.time_scale,.24,.01)
	player._draw_points = PackedVector2Array([Vector2.ZERO,Vector2(100,0)])
	player._on_move_released(Vector2.ZERO)
	assert_eq(Engine.time_scale,1.0)
	assert_gt(player._dodge_path.size(),0)
	player.cancel_input()
	assert_eq(Engine.time_scale,1.0)
func test_long_trace_upgrade_has_no_cost_and_later_progression_gate() -> void:
	assert_eq(PlayerUpgrades.for_progress(9).dodge_path_limit,260.0)
	assert_eq(PlayerUpgrades.for_progress(10).dodge_path_limit,420.0)

func test_real_time_timeout_and_pause_cannot_leave_world_slowed() -> void:
	SaveData.dual_lasso_intro_shown = true
	GameState.selected_level = 1
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var player: Node = level.player
	player._drawing_dodge = true
	player._drawing_real_started = player._now_seconds()-2.1
	player._draw_points = PackedVector2Array([Vector2.ZERO])
	Engine.time_scale = .24
	player._physics_process(.01)
	assert_false(player._drawing_dodge)
	assert_eq(Engine.time_scale,1.0)
	player._drawing_dodge = true
	Engine.time_scale = .24
	level.pause_game()
	assert_eq(Engine.time_scale,1.0)
	level.resume_game()
