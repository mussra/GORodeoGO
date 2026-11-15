extends GutTest

func _menu(path: String) -> Control:
	var menu: Control = load(path).instantiate()
	add_child_autofree(menu)
	await wait_frames(3)
	return menu

func test_both_variants_build_all_reachable_level_buttons_and_close_drawer() -> void:
	for path in ["res://src/Presentation/main_menu.tscn","res://src/Presentation/main_menu_cartoon.tscn"]:
		var menu: Control = await _menu(path)
		assert_eq(menu.level_grid.get_child_count(),LevelCatalog.MAX_LEVEL)
		assert_false(menu._drawer.visible)
		menu._missions.pressed.emit()
		await wait_frames(2)
		assert_true(menu._drawer.visible)
		menu._hide_levels()
		assert_false(menu._drawer.visible)
		assert_false(menu._play.disabled)
		for button in menu.level_grid.get_children():
			assert_true(button.pressed.is_connected(menu._on_level_selected.bind(button.get_index()+1)))
		menu.queue_free()
		await wait_frames(2)

func test_cartoon_has_hd_portrait_and_marginal_navigation() -> void:
	var menu: Control = await _menu("res://src/Presentation/main_menu_cartoon.tscn")
	# Finish intro before evaluating the settled composition.
	await wait_seconds(1.2)
	assert_not_null(menu._portrait.texture)
	assert_gt(menu._portrait.texture.get_width(),1000)
	assert_gt(menu._play.position.x,menu._portrait.position.x+menu._portrait.size.x)
	assert_gt(menu._missions.position.x,menu._portrait.position.x+menu._portrait.size.x)
	assert_gte(menu._play.size.y,70.0)

func test_cartoon_actions_and_progress_do_not_overlap_and_games_label_matches_route():
	var menu:Control=await _menu("res://src/Presentation/main_menu_cartoon.tscn")
	await wait_seconds(.8)
	assert_eq(menu._play.text,"JUEGOS")
	assert_true(menu._caption.text.contains("/ %02d RETOS"%LevelCatalog.MAX_LEVEL))
	for b in [menu._play,menu._world_button,menu._equipment_button]:
		assert_false(b.get_global_rect().intersects(menu._card.get_global_rect()))
	assert_lt(menu._play.position.y+menu._play.size.y,menu._world_button.position.y)
	assert_lt(menu._world_button.position.y+menu._world_button.size.y,menu._equipment_button.position.y)
	menu._refresh_points_caption();assert_true(menu._caption.text.contains("/ %02d RETOS"%LevelCatalog.MAX_LEVEL))
	menu._show_games213();await wait_process_frames(3)
	assert_not_null(menu._games213.canvas.get_node_or_null("GameAccess239"))
	assert_true(menu._games213.access_note239.contains("Copa"))
