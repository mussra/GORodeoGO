extends GutTest

func test_all_movement_animations_have_six_registered_frames() -> void:
	for entity: String in ["player", "bull"]:
		var prefix: String = "walk_" if entity == "player" else "flee_"
		for direction: String in ["side", "up", "down", "diag_down", "diag_up"]:
			var folder: String = "res://art/%s/%s%s" % [entity, prefix, direction]
			var paths: Array = SpriteSwap.new(autofree(Node.new()), autofree(Control.new()), "missing", [])._list_sorted_image_paths(folder)
			assert_eq(paths.size(), 6, folder)
			for path: String in paths:
				var texture: Texture2D = load(path)
				assert_eq(texture.get_size(), Vector2(96, 96), path)

func test_idle_bull_matches_the_movement_canvas() -> void:
	var texture: Texture2D = load("res://art/bull/idle/frame_0.png")
	assert_eq(texture.get_size(), Vector2(96, 96))
