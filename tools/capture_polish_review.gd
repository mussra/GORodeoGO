extends SceneTree
## Captures for Ant's 22:49-22:50 polish items:
##  1. homogeneous menu intro (frames during the single shared fade)
##  2. styled exit dialog (RanchTheme instead of default gray)
##  3. world small map: always visible, collapses/reopens
##   REVIEW_DIR=/tmp/review xvfb-run -a godot --path . --script tools/capture_polish_review.gd
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
	# --- 1. menu intro: frames during the homogeneous fade ---
	root.get_node("GameState").brand_intro_played = true
	var menu: Node = load("res://src/Presentation/main_menu.tscn").instantiate()
	root.add_child(menu)
	await create_timer(0.15).timeout
	await shot("menu_intro_early.png")
	await create_timer(0.25).timeout
	await shot("menu_intro_mid.png")
	await create_timer(0.8).timeout
	await shot("menu_intro_done.png")

	# --- 2. exit dialog with RanchTheme ---
	root.get_node("GameState").confirm_exit()
	await create_timer(0.2).timeout
	await shot("exit_dialog_styled.png")
	var dlg = null
	for w in root.get_children():
		if w is ConfirmationDialog:
			dlg = w
	if dlg != null:
		dlg.queue_free()
	menu.queue_free()
	await process_frame

	# --- 3. world small map: visible -> expanded -> collapsed again ---
	root.get_node("SaveData").world_seed = 424242
	root.get_node("SaveData").horse_collection.seed_trial()
	var world: Node2D = load("res://src/Presentation/frontier_world.tscn").instantiate()
	root.add_child(world)
	await create_timer(0.5).timeout
	await shot("world_map_small.png")
	world._toggle_map()
	world._map_overlay._set_zoom(2.6)
	world._map_overlay.pan = Vector2(2000, 2000)  # worst-case drag: must stay clamped
	await create_timer(0.3).timeout
	await shot("world_map_expanded.png")
	world._toggle_map()
	await create_timer(0.3).timeout
	await shot("world_map_reclosed.png")
	quit()
