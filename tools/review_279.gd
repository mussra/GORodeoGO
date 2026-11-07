extends SceneTree
## 2.7.9 proof captures: rider marker when hidden, lasso holding a wild horse,
## discovery map with pulsing marker and close button.

func _snap(path: String) -> void:
	await process_frame
	root.get_texture().get_image().save_png(path)

func _initialize() -> void:
	var SD: Node = root.get_node("SaveData")
	SD.world_seed = 424242
	SD.world_discovered.clear()
	SD.world_tamed.clear()
	SD.world_missions.clear()
	SD.world_pigs.clear()
	SD.world_edits.clear()
	SD.horse_collection.seed_trial()
	SD.world_position = Vector2(0, 160)
	var world: Node2D = load("res://src/Presentation/frontier_world.tscn").instantiate()
	root.add_child(world)
	for i in 6:
		await physics_frame
	# 1. rider hidden behind the ranch house: marker must float above him
	world.player.position = Vector2(-60, -150)
	for i in 6:
		await physics_frame
	await _snap("/downloads/marker-hidden.png")
	# 2. lasso holding a wild horse
	world.player.position = Vector2(0, 160)
	var horse: Node2D = world.WildHorseScript.new()
	horse.setup({"pos": Vector2(160, 150), "temperament": 0.3, "traits": {"coat": 0, "pattern": 0, "mane": 0, "eyes": 0, "finish": "normal"}, "stats": {}})
	world.add_child(horse)
	horse.position = Vector2(160, 150)
	horse.set_meta("c", Vector2i(99, 99))
	world._herd_horses[Vector2i(99, 99)] = horse
	var bar := ProgressBar.new()
	bar.name = "bar"
	horse.add_child(bar)
	for i in 4:
		await physics_frame
	world._throw_lasso(Vector2(1, -0.07).normalized(), 155.0)
	for i in 32:
		await physics_frame
	await _snap("/downloads/lasso-hold.png")
	# 3. discovery map: pulsing rider marker + X close button
	SD.mark_world_discovered(Vector2i(0, 0))
	SD.mark_world_discovered(Vector2i(-1, 0))
	SD.mark_world_discovered(Vector2i(0, -1))
	world._toggle_map()
	for i in 6:
		await process_frame
	await _snap("/downloads/map-279.png")
	world._toggle_map()
	for i in 3:
		await process_frame
	quit()
