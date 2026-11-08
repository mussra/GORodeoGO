extends GutTest
## Frontier depth + collision (Ant 7-nov-2026): y-sort by base/feet, feet
## collision with fences and houses, gates and doors passable, walls block.

func _fresh_world() -> Node2D:
	SaveData.world_seed = 424242
	SaveData.world_discovered.clear()
	SaveData.world_tamed.clear()
	SaveData.world_missions.clear()
	SaveData.world_pigs.clear()
	SaveData.world_edits.clear()
	SaveData.horse_collection.seed_trial()
	SaveData.world_position = Vector2(0, 160)
	var world: Node2D = load("res://src/Presentation/frontier_world.tscn").instantiate()
	add_child_autofree(world)
	return world

func _drive(world: Node2D, action: String, frames: int) -> void:
	world.player.velocity = Vector2.ZERO
	Input.action_press(action, 1.0)
	for i in frames:
		await wait_physics_frames(3)
	Input.action_release(action)

func test_world_y_sorts_entities() -> void:
	var world := _fresh_world()
	assert_true(world.y_sort_enabled, "world root y-sorts entities")

func test_ranch_gate_passes_and_rail_blocks() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.position = Vector2(0, 260)
	await _drive(world, "move_down", 20)
	assert_gt(world.player.position.y, 320.0, "south gate lets the rider out")
	world.player.position = Vector2(0, -270)
	await _drive(world, "move_up", 20)
	assert_lt(world.player.position.y, -285.0, "rider moved towards the rail")
	assert_gt(world.player.position.y, -315.0, "north rail blocks the rider")

func test_house_door_and_walls() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.position = Vector2(-51, -100)
	await _drive(world, "move_up", 25)
	assert_lt(world.player.position.y, -128.0, "door lets the rider inside")
	world.player.position = Vector2(0, -100)
	await _drive(world, "move_up", 20)
	assert_lt(world.player.position.y, -105.0, "rider moved to the wall")
	assert_gt(world.player.position.y, -130.0, "front wall blocks")

func test_marker_shows_when_rider_hidden() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.position = Vector2(0, 260)
	await wait_physics_frames(3)
	assert_false(world._marker.visible, "marker hidden out in the open")
	world.player.position = Vector2(-60, -150)
	await wait_physics_frames(3)
	assert_true(world._marker.visible, "marker shows when the house covers the rider")
	world.player.position = Vector2(0, 260)
	await wait_physics_frames(3)
	assert_false(world._marker.visible, "marker hides again once visible")

func test_map_is_small_and_expands() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	var map: Control = world._map_overlay
	# Ant 22:49: the small map is always there, collapsed like the arena minimap.
	assert_true(map.visible, "small map is always there")
	assert_false(map.expanded, "starts collapsed")
	assert_eq(map.size, Vector2(180, 112), "small corner size matches the arena minimap")
	world._toggle_map()
	await wait_process_frames(2)
	assert_true(map.expanded, "Mapa button expands it")
	assert_gt(map.size.x, 400.0, "expanded map is large")
	world._toggle_map()
	assert_true(map.visible, "small map stays visible")
	assert_false(map.expanded, "map collapses back to the corner")
