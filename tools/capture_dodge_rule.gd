extends SceneTree
## Dodge training-rule parity captures (Ant 7-nov-2026 21:33 "Igual").
## corral | world, untrained (refused) and trained (bullet-time trace).
## Run under an X server: godot --path . --script tools/capture_dodge_rule.gd
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

func _try_gesture(dodge: DodgeController) -> void:
	dodge.on_move_pressed()
	dodge.on_move_released(Vector2.ZERO)
	dodge.on_move_pressed()

func capture() -> void:
	var save: Node = root.get_node("SaveData")
	save.horse_collection.seed_trial()

	# ---------- UNTRAINED (can_dodge = false): both modes refuse ----------
	save.horse_collection.horses[0]["can_dodge"] = false
	root.get_node("GameState").selected_level = 1
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	root.add_child(level)
	await create_timer(0.5).timeout
	_try_gesture(level.player.dodge)
	for i in range(6):
		await physics_frame
	await shot("rule_corral_untrained.png")
	level.queue_free()
	await process_frame

	save.world_seed = 424242
	save.world_discovered.clear()
	save.world_position = Vector2(0, 160)
	var world: Node2D = load("res://src/Presentation/frontier_world.tscn").instantiate()
	root.add_child(world)
	for i in range(4):
		await physics_frame
	_try_gesture(world.player.dodge)
	for i in range(6):
		await physics_frame
	await shot("rule_world_untrained.png")
	world.queue_free()
	await process_frame

	# ---------- TRAINED: both modes draw the bullet-time trace ----------
	save.horse_collection.horses[0]["can_dodge"] = true
	# corral-only condition (unchanged): the dodge trace needs an equipped whip
	save.equipment_owned.append("whip_basic")
	save.equipment_equipped["whip"] = "whip_basic"
	level = load("res://src/Presentation/level_0.tscn").instantiate()
	root.add_child(level)
	await create_timer(0.5).timeout
	_try_gesture(level.player.dodge)
	await process_frame
	level.player.dodge.draw_points = PackedVector2Array([Vector2.ZERO, Vector2(90, 0), Vector2(160, -60)])
	for i in range(4):
		await physics_frame
	await shot("rule_corral_trained.png")
	level.player.dodge.on_move_released(Vector2.ZERO)
	Engine.time_scale = 1.0
	level.queue_free()
	await process_frame

	world = load("res://src/Presentation/frontier_world.tscn").instantiate()
	root.add_child(world)
	for i in range(4):
		await physics_frame
	_try_gesture(world.player.dodge)
	await process_frame
	world.player.dodge.draw_points = PackedVector2Array([Vector2.ZERO, Vector2(90, 0), Vector2(160, -60)])
	for i in range(4):
		await physics_frame
	await shot("rule_world_trained.png")
	world.player.dodge.on_move_released(Vector2.ZERO)
	Engine.time_scale = 1.0
	world.queue_free()
	quit()
