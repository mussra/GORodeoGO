extends SceneTree
## Run under an X server: godot --path . --script tools/capture_review.gd
var output_dir: String = OS.get_environment("REVIEW_DIR")
func _initialize() -> void:
	if output_dir.is_empty():
		output_dir = "user://review"
	DirAccess.make_dir_recursive_absolute(output_dir)
	call_deferred("capture")
func shot(filename: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output_dir.path_join(filename))
func capture() -> void:
	var menu: Node = load("res://src/Presentation/main_menu.tscn").instantiate()
	root.add_child(menu)
	await process_frame
	await shot("menu.png")
	menu.queue_free()
	await process_frame
	for number: int in [1, 11, 20]:
		root.get_node("GameState").selected_level = number
		var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
		root.add_child(level)
		await create_timer(0.4).timeout
		await shot("level_%02d.png" % number)
		if number == 1:
			level.player._start_charging()
			level.player._process_throw_input(0.45)
			await shot("aim.png")
			level.player.cancel_input()
			level.pause_game()
			await shot("pause.png")
			level.resume_game()
		level.queue_free()
		await process_frame
	quit()
