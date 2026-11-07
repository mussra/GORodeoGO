extends SceneTree
func _initialize() -> void:
	print("step0")
	var SD: Node = root.get_node("SaveData")
	SD.world_seed = 424242
	SD.horse_collection.seed_trial()
	SD.world_position = Vector2(0, 160)
	var world: Node2D = load("res://src/Presentation/frontier_world.tscn").instantiate()
	root.add_child(world)
	for i in 6:
		await physics_frame
	print("step1")
	for cx in range(-1, 2):
		for cy in range(-1, 2):
			SD.mark_world_discovered("%d,%d" % [cx, cy])
	print("step2")
	world._toggle_map()
	print("step3 visible=", world._map_overlay.visible)
	await process_frame
	print("step4")
	await process_frame
	print("step5")
	root.get_texture().get_image().save_png("/downloads/map-small.png")
	world._map_overlay.expanded = true
	for i in 4:
		await process_frame
	root.get_texture().get_image().save_png("/downloads/map-expanded.png")
	quit()
