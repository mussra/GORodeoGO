extends SceneTree
## Depth/collision proof captures (Ant 7-nov): rider in front of the house,
## hidden behind it, and inside through the door.

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
	# in front of the house (below its base)
	world.player.position = Vector2(-45, -60)
	for i in 4:
		await physics_frame
	await _snap("/downloads/depth-front.png")
	# behind the house (above its base): only feet hidden
	world.player.position = Vector2(-45, -170)
	for i in 4:
		await physics_frame
	await _snap("/downloads/depth-behind.png")
	# next to a zone tree, south of it
	var horses: Array = get_nodes_in_group("test_zone")
	if horses.size() > 0:
		world.player.position = Vector2(160, 650) + Vector2(-235, -90)
		for i in 4:
			await physics_frame
		await _snap("/downloads/depth-tree.png")
	quit()
