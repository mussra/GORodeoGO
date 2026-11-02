extends GutTest
func after_each() -> void:
	get_tree().paused = false
func test_physical_gate_blocks_then_opens_and_towed_bull_exits() -> void:
	GameState.selected_level = 11
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var corral: PuzzleCorral = level._puzzle_corrals[0]
	var bull: CharacterBody2D = level._active_bulls[1]
	var gate: Vector2 = corral.layout["gate"]
	var hit := bull.move_and_collide(Vector2(0, 160), true)
	assert_not_null(hit, "closed gate is real physics")
	for other in level._active_bulls: other.set_physics_process(false)
	level.player.global_position = corral.layout["door"]
	await wait_physics_frames(4)
	await wait_seconds(1.35)
	assert_true(corral.opened)
	assert_eq(corral._gate_body.collision_layer, 0)
	assert_true(bull.controller.is_wild())
	assert_true(bull.try_capture(bull.global_position))
	bull.controller.update_hold(100, 0, 0)
	level.player.global_position = gate + Vector2(0, 130)
	bull.set_physics_process(true)
	await wait_physics_frames(70)
	assert_gt(bull.global_position.y, gate.y + 30, "held bull exits through real open gate")
func test_master_opens_all_physical_gates_and_members() -> void:
	GameState.selected_level = 20
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level._on_pen_door_opened(0)
	for corral in level._puzzle_corrals:
		assert_true(corral.opened)
		assert_eq(corral._gate_body.collision_layer, 0)
	for bull in level._active_bulls: assert_true(bull.controller.is_wild())

func test_every_puzzle_spawn_can_exit_its_own_gate_with_a_held_bull() -> void:
	for number in range(11, 21):
		GameState.selected_level = number
		var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
		add_child_autofree(level)
		await wait_physics_frames(2)
		for bull in level._active_bulls: bull.set_physics_process(false)
		level.set_process(false) # isolate route check from countdown/chaser assignment
		for index in range(level._pens_data.size()): level._on_pen_door_opened(index)
		for index in range(level._pens_data.size()):
			var corral: PuzzleCorral = level._puzzle_corrals[index]
			var gate: Vector2 = corral.layout["gate"]
			var inward: float = corral.layout["inward"]
			for bull_index: int in level._pens_data[index]["bull_indices"]:
				var bull: CharacterBody2D = level._active_bulls[bull_index]
				bull.try_capture(bull.global_position)
				bull.controller.update_hold(100, 0, 0)
				# First align with opening inside corral, then tow through it.
				level.player.global_position = Vector2(gate.x, bull.global_position.y)
				for frame in range(80): bull._apply_tow_movement()
				# Leash50 leaves side bulls off-centre; walk toward opening gradually.
				level.player.global_position = gate + Vector2(0, inward * 125)
				for frame in range(120): bull._apply_tow_movement()
				assert_gt((bull.global_position.y - gate.y) * inward, 25.0, "level %d bull %d exits" % [number, bull_index])
		level.queue_free()
		await wait_physics_frames(2)

func test_chain_only_opens_configured_physical_corrals() -> void:
	GameState.selected_level = 20
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level._on_pen_door_opened(3)
	for index in range(8):
		assert_eq(level._puzzle_corrals[index].opened, index in [3, 6])

func test_released_wild_bulls_naturally_exit_corrals_without_teleporting() -> void:
	for number in [11, 13, 20]:
		GameState.selected_level = number
		var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
		add_child_autofree(level)
		await wait_physics_frames(2)
		level.player.global_position = Vector2(0, 50)
		level.set_process(false)
		for index in range(level._pens_data.size()): level._on_pen_door_opened(index)
		await wait_physics_frames(720)
		for bull in level._active_bulls:
			assert_false(bull._leaving_corral, "level %d %s naturally cleared gate" % [number, bull.name])
		level.queue_free()
		await wait_physics_frames(2)

func test_capture_cancels_release_guidance_and_pause_freezes_exit_delay() -> void:
	GameState.selected_level = 11
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level._on_pen_door_opened(0)
	var bull: Node2D = level._active_bulls[0]
	assert_true(bull._leaving_corral)
	assert_true(bull.try_capture(bull.global_position))
	assert_false(bull._leaving_corral, "captured bull is controlled by rope, not release route")
	var waiting: Node2D = level._active_bulls[2]
	assert_gt(waiting._release_delay, 0.0)
	level.pause_game()
	var delay: float = waiting._release_delay
	await get_tree().create_timer(0.2, true).timeout
	assert_eq(waiting._release_delay, delay)
	level.resume_game()
	await wait_physics_frames(3)
	assert_lt(waiting._release_delay, delay)
