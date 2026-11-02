extends SceneTree
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	var original_progress: int = root.get_node("SaveData").highest_level_completed
	root.get_node("SaveData").highest_level_completed = LevelCatalog.MAX_LEVEL # no disk write
	root.get_node("GameState").selected_level = 1
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	root.add_child(level)
	await physics_frame
	await physics_frame
	var bull: Node2D = level._active_bulls[0]
	bull.set_physics_process(false)
	level._on_lasso_thrown(level.player.global_position, bull.global_position)
	bull.controller.update_hold(100.0, 0.0, 0.0)
	bull.global_position = level.pen.global_position
	level.player.global_position = level.pen.global_position + Vector2(55, 0)
	for i in range(4): await physics_frame
	print("REAL_VICTORY game_over=", level._game_over, " count=", level._bulls_returned, " state=", bull.controller.current_state(), " inside=", level.pen.overlaps_body(bull))
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/downloads/gorodeo/real-victory.png")
	root.get_node("SaveData").highest_level_completed = original_progress
	level.queue_free()
	await process_frame
	quit()
