extends SceneTree
func _initialize() -> void:
	var SD: Node = root.get_node("SaveData")
	SD.world_seed = 424242
	SD.horse_collection.seed_trial()
	SD.world_position = Vector2(0, 160)
	var world: Node2D = load("res://src/Presentation/frontier_world.tscn").instantiate()
	root.add_child(world)
	for i in 6:
		await physics_frame
	world.player.position = Vector2(0, 160)
	# charge visual: aim stick held to the right (corral gesture)
	world._start_charge(false)
	world._aim_dir = Vector2(1, -0.15).normalized()
	world._charge_distance = 180.0
	world._update_charge_visual()
	for i in 3:
		await physics_frame
	root.get_texture().get_image().save_png("/downloads/lasso-charge.png")
	world._stop_charge()
	# roped pig
	var chunk: Node2D = world._chunks.values()[0]
	var pen := Node2D.new()
	pen.name = "pigs"
	chunk.add_child(pen)
	var pig: Node2D = world.PigScript.new()
	pig.setup({"pos": Vector2(150, 160)})
	pen.add_child(pig)
	pig.position = Vector2(150, 160)
	var bar := ProgressBar.new()
	bar.name = "bar"
	pig.add_child(bar)
	for i in 3:
		await physics_frame
	world._throw_lasso(Vector2.RIGHT, 145.0)
	for i in range(32):
		await physics_frame
	root.get_texture().get_image().save_png("/downloads/lasso-pig.png")
	quit()
