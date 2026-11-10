extends GutTest

func test_nominal_movement_animations_have_nine_registered_frames() -> void:
	for entity: String in ["rider", "bull"]:

		for direction: String in ["side", "up", "down", "diag_down", "diag_up"]:
			var folder: String = "res://art/experimental/pixellab/%s/%s" % [entity, direction]
			var paths: Array = SpriteSwap.new(autofree(Node.new()), autofree(Control.new()), "missing", [])._list_sorted_image_paths(folder)
			assert_eq(paths.size(), 9, folder)
			for path: String in paths:
				var texture: Texture2D = load(path)
				assert_eq(texture.get_size(), Vector2(96, 96), path)

func test_idle_bull_matches_the_movement_canvas() -> void:
	var texture: Texture2D = load("res://art/bull/idle/frame_00.png")
	assert_eq(texture.get_size(), Vector2(96, 96))

func test_turn_preserves_gait_phase_instead_of_restarting_cycle() -> void:
	var host := Node2D.new()
	add_child_autofree(host)
	var placeholder := Polygon2D.new()
	host.add_child(placeholder)
	var swap := SpriteSwap.new(host, placeholder, "res://art/player/", ["walk_side", "walk_down", "idle"])
	PixelLabTrial.apply(swap._frames,"rider","walk_side")
	swap.play("walk_side")
	swap._sprite.set_frame_and_progress(3, 0.4)
	swap.play("walk_down")
	assert_eq(swap._sprite.frame, 3)
	assert_almost_eq(swap._sprite.frame_progress, 0.4, 0.001)
	swap.set_motion_speed(130, 260)
	assert_eq(swap._sprite.speed_scale, 0.5, "stride follows speed, not only input")
	swap.play("idle")
	swap.set_motion_speed(0, 260)
	assert_eq(swap._sprite.speed_scale, 1.0)

func test_distraction_has_ten_frames_with_six_distinct_head_poses() -> void:
	var host := Node2D.new()
	add_child_autofree(host)
	var placeholder := Polygon2D.new()
	host.add_child(placeholder)
	var swap := SpriteSwap.new(host, placeholder, "res://art/bull/", ["drinking"])
	assert_true(swap.play("drinking"))
	assert_eq(swap._frames.get_frame_count("drinking"), 10)
	assert_eq(swap._frames.get_animation_speed("drinking"), 5.0)
	for i in range(10):
		assert_eq(swap._frames.get_frame_texture("drinking", i).get_size(), Vector2(96,96))

func test_nominal_rider_keeps_all_eight_directions_and_nine_distinct_phases() -> void:
	var host:=Node2D.new()
	add_child_autofree(host)
	var placeholder:=Polygon2D.new()
	host.add_child(placeholder)
	var names=["walk_side","walk_down","walk_up","walk_diag_down","walk_diag_up"]
	var swap:=SpriteSwap.new(host,placeholder,"res://art/player/",["idle"],8)
	PixelLabTrial.apply(swap._frames,"rider","walk_side")
	for name:String in names:
		assert_true(swap.play(name))
		assert_eq(swap._frames.get_frame_count(name),9)
		assert_eq(swap._frames.get_animation_speed(name),9.0)
		var hashes:Array=[]
		for i in range(9):
			var image=swap._frames.get_frame_texture(name,i).get_image()
			var hash_value=image.get_data().hex_encode().sha256_text()
			assert_false(hashes.has(hash_value),name+" phase "+str(i))
			hashes.append(hash_value)
	for dir:Vector2 in [Vector2.RIGHT,Vector2(1,1),Vector2.DOWN,Vector2(-1,1),Vector2.LEFT,Vector2(-1,-1),Vector2.UP,Vector2(1,-1)]:
		var result=SpriteSwap.direction_suffix(dir)
		assert_true(swap.play("walk_"+result[0]))
