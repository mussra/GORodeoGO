extends SceneTree
func _initialize() -> void: call_deferred("run_check")
func run_check() -> void:
	for path in ["res://src/Presentation/main_menu.tscn","res://src/Presentation/main_menu_cartoon.tscn"]:
		change_scene_to_file(path)
		await create_timer(.15).timeout
		var menu: Control = current_scene
		menu._missions.pressed.emit()
		await process_frame
		assert(menu._drawer.visible)
		menu._hide_levels()
		menu.level_grid.get_child(10).pressed.emit()
		await create_timer(.2).timeout
		assert(current_scene.scene_file_path == "res://src/Presentation/level_0.tscn")
		assert(root.get_node("GameState").selected_level == 11)
		current_scene._on_quit_requested()
		await create_timer(.2).timeout
		assert(current_scene.scene_file_path == path)
		print("VERIFIED menu > level11 > same menu: ",path)
	quit()
