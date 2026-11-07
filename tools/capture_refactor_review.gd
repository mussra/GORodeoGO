extends SceneTree
## Refactor parity captures (corral vs world, one shared code path).
## Run under an X server: godot --path . --script tools/capture_refactor_review.gd
var out_dir: String = OS.get_environment("REVIEW_DIR")

func _initialize() -> void:
	if out_dir.is_empty():
		out_dir = "user://review"
	DirAccess.make_dir_recursive_absolute(out_dir)
	call_deferred("capture")

func shot(filename: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(filename))

func _fresh_world() -> Node2D:
	var save: Node = root.get_node("SaveData")
	save.world_seed = 424242
	save.world_discovered.clear()
	save.world_tamed.clear()
	save.world_missions.clear()
	save.world_pigs.clear()
	save.world_edits.clear()
	save.horse_collection.seed_trial()
	save.world_position = Vector2(0, 160)
	var world: Node2D = load("res://src/Presentation/frontier_world.tscn").instantiate()
	root.add_child(world)
	return world

func capture() -> void:
	var save: Node = root.get_node("SaveData")
	save.horse_collection.seed_trial()

	# ---------- CORRAL ----------
	root.get_node("GameState").selected_level = 1
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	root.add_child(level)
	await create_timer(0.5).timeout
	var p = level.player
	p.dodge_available = true

	# 1. lasso in flight (shared LassoController + LassoRope)
	p.lasso._release_throw(Vector2(0.64, 0))
	await process_frame
	await process_frame
	await shot("lasso_corral.png")
	await create_timer(1.2).timeout

	# 2. dodge bullet-time trace (shared DodgeController + DodgeVisuals)
	var cd = p.dodge
	cd.on_move_pressed()
	cd.on_move_released(Vector2.ZERO)
	cd.on_move_pressed()
	await process_frame
	cd.draw_points = PackedVector2Array([Vector2.ZERO, Vector2(90, 0), Vector2(160, -60)])
	for i in range(4):
		await physics_frame
	await shot("dodge_corral.png")
	cd.on_move_released(Vector2.ZERO)
	for i in range(6):
		await physics_frame
	await shot("dodgetrail_corral.png")
	Engine.time_scale = 1.0
	await create_timer(1.5).timeout

	# 3. tow: real rope on a real bull (shared TowFollower + HeldVisuals) —
	# fresh level: the demo bull may have escaped during the earlier shots
	level.queue_free()
	await process_frame
	level = load("res://src/Presentation/level_0.tscn").instantiate()
	root.add_child(level)
	await create_timer(0.5).timeout
	p = level.player
	p.dodge_available = true
	# same capture the lasso triggers on a hit (tow test recipe)
	var bull: Node2D = level._active_bulls[0]
	p.global_position = Vector2(-140, 100)
	p.velocity = Vector2.ZERO
	bull.global_position = Vector2(-260, 100)
	print("DBG corral captured=", bull.try_capture(bull.global_position))
	# walk a few frames so the tow leash stretches and the rope reads
	Input.action_press("move_right")
	for i in range(10):
		await physics_frame
	Input.action_release("move_right")
	await physics_frame
	print("DBG corral held=", bull.controller.is_held(), " dist=", bull.global_position.distance_to(p.global_position))
	await shot("tow_corral.png")
	level.queue_free()
	await process_frame

	# ---------- WORLD ----------
	var world: Node2D = await _fresh_world_await()
	var wp = world.player

	# 1. lasso in flight
	wp.lasso._release_throw(Vector2(0.64, 0))
	await process_frame
	await process_frame
	await shot("lasso_world.png")
	await create_timer(1.2).timeout

	# 2. dodge bullet-time trace
	var wd = wp.dodge
	wd.on_move_pressed()
	wd.on_move_released(Vector2.ZERO)
	wd.on_move_pressed()
	await process_frame
	wd.draw_points = PackedVector2Array([Vector2.ZERO, Vector2(90, 0), Vector2(160, -60)])
	for i in range(4):
		await physics_frame
	await shot("dodge_world.png")
	wd.on_move_released(Vector2.ZERO)
	for i in range(6):
		await physics_frame
	await shot("dodgetrail_world.png")
	Engine.time_scale = 1.0
	await create_timer(1.5).timeout

	# 3. tow: real rope on a planted wild horse
	var horse: Node2D = world.WildHorseScript.new()
	horse.setup({"pos": wp.position + Vector2(200, 0), "temperament": 0.0, "traits": {"coat": 0, "pattern": 0, "mane": 0, "eyes": 0, "finish": "normal"}, "stats": {}})
	world.add_child(horse)
	horse.position = wp.position + Vector2(140, 0)
	horse.set_meta("c", Vector2i(99, 99))
	world._herd_horses[Vector2i(99, 99)] = horse
	wp.lasso._release_throw(Vector2(140.0 / 220.0, 0))
	print("DBG world in_flight=", wp.lasso._lasso_in_flight, " horse=", horse.position, " player=", wp.position)
	for i in range(60):
		await physics_frame
		if horse.roped:
			break
	print("DBG world roped=", horse.roped, " lasso_state=", world._lasso_state)
	for i in range(14):
		await physics_frame
		wp.position += Vector2(2.2, 0)
	await shot("tow_world.png")
	world.queue_free()
	quit()

func _fresh_world_await() -> Node2D:
	var w: Node2D = _fresh_world()
	for i in range(4):
		await physics_frame
	return w
