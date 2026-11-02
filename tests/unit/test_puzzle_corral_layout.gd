extends GutTest
func test_all_layouts_contain_bulls_and_clear_goal_spawn_each_other() -> void:
	for number in range(11, 21):
		var pens: Array = LevelCatalog.get_level(number).pens
		var rects: Array = []
		for i in range(pens.size()):
			var layout: Dictionary = PuzzleCorralLayout.build(pens.size(), i, pens[i]["bull_indices"].size())
			var rect: Rect2 = layout["rect"]
			assert_true(Rect2(-480, -270, 960, 540).encloses(rect.grow(4)))
			assert_false(rect.grow(24).has_point(Vector2.ZERO))
			assert_false(rect.grow(24).intersects(Rect2(-340, -40, 80, 80)))
			for slot: Vector2 in layout["slots"]:
				assert_true(rect.grow(-28).has_point(slot))
			for previous: Rect2 in rects:
				assert_false(rect.grow(24).intersects(previous), "bull-size aisle between pens")
			rects.append(rect)
