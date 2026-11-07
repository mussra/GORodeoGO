extends SceneTree
func _initialize() -> void:
	var SD: Node = root.get_node("SaveData")
	SD.world_seed = 424242
	SD.horse_collection.seed_trial()
	SD.world_position = Vector2(-400, 1200)
	var world: Node2D = load("res://src/Presentation/frontier_world.tscn").instantiate()
	root.add_child(world)
	for i in 6:
		await physics_frame
	world.player.position = Vector2(-400, 1200)
	world.player.velocity = Vector2.RIGHT * 200.0
	world.player.request_dodge(Vector2(1, 0.25).normalized())
	for i in 10:
		await physics_frame
	print("trailnode=", world._trail_node.visible, " fade=", world.player._trail_fade)
	print("trail=", world.player._skid_trail.size(), " first=", world.player._skid_trail[0], " last=", world.player._skid_trail[-1], " player=", world.player.global_position)
	root.get_texture().get_image().save_png("/downloads/dodge-world.png")
	quit()
