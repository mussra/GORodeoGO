extends GutTest

## Full level loop against real scenes/physics. Deterministic placement is intentional:
## this proves completion wiring, not a human player's ability or mobile game feel.
var _original_progress: int = 0
var _intro_shown: bool

func before_each() -> void:
	_original_progress = SaveData.highest_level_completed
	# Prevent any disk writes from the real victory handler.
	SaveData.highest_level_completed = LevelCatalog.MAX_LEVEL
	_intro_shown = SaveData.dual_lasso_intro_shown
	SaveData.dual_lasso_intro_shown = true  # campaign loop must not stop at the one-shot intro

func after_each() -> void:
	SaveData.highest_level_completed = _original_progress
	SaveData.dual_lasso_intro_shown = _intro_shown
	get_tree().paused = false

func test_every_level_can_release_capture_calm_deliver_and_win() -> void:
	for number in range(1, LevelCatalog.MAX_LEVEL + 1):
		GameState.selected_level = number
		var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
		add_child_autofree(level)
		await wait_physics_frames(2)
		# No AI movement during deterministic capture/delivery verification.
		for bull in level._active_bulls:
			bull.set_physics_process(false)
		for index in range(level._pens_data.size()):
			level._on_pen_door_opened(index)
		for index in range(level._active_bulls.size()):
			var bull: Node2D = level._active_bulls[index]
			assert_true(bull.controller.is_wild(), "level %d bull %d released" % [number, index])
			level._on_lasso_thrown(level.player.global_position, bull.global_position)
			assert_true(bull.controller.is_held(), "level %d bull %d captured" % [number, index])
			bull.controller.update_hold(100.0, 0.0, 0.0)
			assert_eq(bull.controller.current_state(), BullState.State.CONTROLLED)
			bull.global_position = level.pen.global_position
			await wait_physics_frames(3)
			assert_eq(level._bulls_returned, index + 1, "level %d delivery count" % number)
		assert_true(level._game_over, "level %d wins" % number)
		assert_true(level.hud.end_panel.visible)
		assert_eq(SaveData.highest_level_completed, LevelCatalog.MAX_LEVEL, "no real save mutation")
		level.queue_free()
		await wait_physics_frames(2)

func test_loaded_sprite_animation_advances_and_idle_loops() -> void:
	GameState.selected_level = 1
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var sprite: AnimatedSprite2D = level.player._sprite_swap._sprite
	assert_eq(sprite.sprite_frames.get_frame_count("walk_diag_down"), 12)
	assert_true(sprite.is_playing())
	var first_frame: int = sprite.frame
	await wait_seconds(0.4)
	assert_ne(sprite.frame, first_frame, "idle animation really advances in the engine")
	assert_eq(sprite.animation, "idle")
