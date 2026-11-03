extends GutTest

func _menu(path: String) -> Control:
	var menu: Control = load(path).instantiate()
	add_child_autofree(menu)
	await wait_frames(3)
	return menu

func test_both_variants_build_twenty_reachable_level_buttons_and_close_drawer() -> void:
	for path in ["res://src/Presentation/main_menu.tscn","res://src/Presentation/main_menu_cartoon.tscn"]:
		var menu: Control = await _menu(path)
		assert_eq(menu.level_grid.get_child_count(),20)
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
