extends GutTest
## Frontier streaming (Ant 11:30:45): off-view chunks unload with margin, and
## walking the world does not grow nodes or memory - seed + edits + discovery
## regenerate everything on return. Hard rule: nothing pops or degrades.

func _fresh_world() -> Node2D:
	SaveData.world_seed = 424242
	SaveData.world_discovered.clear()
	SaveData.world_tamed.clear()
	SaveData.world_missions.clear()
	SaveData.world_pigs.clear()
	SaveData.world_edits.clear()
	SaveData.horse_collection.seed_trial()
	var world: Node2D = load("res://src/Presentation/frontier_world.tscn").instantiate()
	add_child_autofree(world)
	return world

func test_chunks_stream_with_margin_and_unload() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	assert_eq(world._chunks.size(), 9, "3x3 around the rider")
	world.player.position = Vector2(WorldMap.CHUNK_SIZE * 4, 0)
	await wait_physics_frames(4)
	assert_eq(world._chunks.size(), 9, "same budget far from the ranch")
	var pc: Vector2i = WorldMap.chunk_at(world.player.position)
	for key in world._chunks:
		var c: Vector2i = world._chunks[key].get_meta("c")
		assert_true(absi(c.x - pc.x) <= 1 and absi(c.y - pc.y) <= 1, "no distant chunk stays loaded")

func test_walking_out_and_back_keeps_node_and_memory_budget() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	Input.action_press("move_right", 1.0)
	for i in 40:
		await wait_physics_frames(6)
	Input.action_release("move_right")
	await wait_physics_frames(2)
	var nodes_far: int = int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	var mem_far: float = Performance.get_monitor(Performance.MEMORY_STATIC)
	Input.action_press("move_left", 1.0)
	for i in 40:
		await wait_physics_frames(6)
	Input.action_release("move_left")
	await wait_physics_frames(2)
	var nodes_back: int = int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	var mem_back: float = Performance.get_monitor(Performance.MEMORY_STATIC)
	# same land, same budget: revisit costs nothing extra
	assert_almost_eq(float(nodes_back), float(nodes_far), 60.0)
	assert_lt(mem_back - mem_far, 8.0 * 1048576.0, "static memory must not grow while roaming")

func test_world_regenerates_identically_from_minimal_data() -> void:
	# seed + edits are all it takes: two worlds built from them match exactly
	var a: Dictionary = WorldEdits.apply(WorldMap.generate(424242, 3, -2), [{"type": "add_decor", "kind": "pine", "pos": Vector2(3300, -1800), "scale": 1.0}], 3, -2)
	var b: Dictionary = WorldEdits.apply(WorldMap.generate(424242, 3, -2), [{"type": "add_decor", "kind": "pine", "pos": Vector2(3300, -1800), "scale": 1.0}], 3, -2)
	assert_eq(a, b, "same seed + same edits -> identical chunk, no hidden state")
