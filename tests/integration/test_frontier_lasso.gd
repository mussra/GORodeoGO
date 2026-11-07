extends GutTest
## Lasso on fleeing wild horses (Ant 7-nov-2026 16:20): a landed rope holds the
## horse, trust fills while held, and the horse joins the cuadra when tamed.

func after_each() -> void:
	# leave the shared save clean for the unit suite (taming appends to the cuadra)
	SaveData.world_tamed.clear()
	SaveData.world_missions.clear()
	SaveData.horse_collection.seed_trial()
	SaveData.world_position = Vector2(0, 160)
	SaveData.save_world_state(Vector2(0, 160))

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

func _plant_horse(world: Node2D, pos: Vector2) -> Node2D:
	var horse: Node2D = world.WildHorseScript.new()
	horse.setup({"pos": pos, "temperament": 0.0, "traits": {"coat": 0, "pattern": 0, "mane": 0, "eyes": 0, "finish": "normal"}, "stats": {}})
	world.add_child(horse)
	horse.position = pos
	horse.set_meta("c", Vector2i(99, 99))
	world._herd_horses[Vector2i(99, 99)] = horse
	var bar := ProgressBar.new()
	bar.name = "bar"
	horse.add_child(bar)
	return horse

func test_lasso_holds_and_tames_wild_horse() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.position = Vector2(0, 160)
	var horse: Node2D = _plant_horse(world, Vector2(150, 160))
	world._throw_lasso(Vector2.RIGHT, 140.0)
	assert_eq(world._lasso_state, "flight", "rope in flight after the throw")
	for i in range(40):
		await wait_physics_frames(3)
	assert_eq(world._lasso_state, "hold", "landed rope holds the horse")
	assert_gt(horse.held, 0.0, "horse is held")
	var still: Vector2 = horse.position
	await wait_physics_frames(6)
	assert_eq(horse.position, still, "held horse cannot flee")
	for i in range(120):
		await wait_physics_frames(3)
		if not is_instance_valid(horse):
			break
	assert_true(SaveData.world_tamed.has(WorldMap.herd_mission_id(99, 99)), "held horse tames and joins the cuadra")

func test_lasso_miss_recovers() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.position = Vector2(0, 160)
	world._throw_lasso(Vector2.RIGHT, 140.0)
	for i in range(17):
		await wait_physics_frames(3)
	assert_eq(world._lasso_state, "", "missed rope retracts")
	assert_gt(world._lasso_cooldown, 0.0, "short cooldown after a miss")

func test_aim_stick_charge_and_release_throws() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	world._on_aim_pressed()
	assert_true(world._lasso_charging, "pressing the aim stick starts the charge")
	world._on_aim_released(Vector2(1, 0) * 0.8)
	assert_eq(world._lasso_state, "flight", "releasing with direction throws the rope")
	assert_gt(world._lasso.progress, -1.0)

func test_aim_release_near_center_cancels() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	world._on_aim_pressed()
	world._on_aim_released(Vector2(0.05, 0.0))
	assert_eq(world._lasso_state, "", "short release cancels, no throw")

func test_double_tap_releases_held_horse() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.position = Vector2(0, 160)
	var horse: Node2D = _plant_horse(world, Vector2(150, 160))
	world._throw_lasso(Vector2.RIGHT, 140.0)
	for i in range(30):
		await wait_physics_frames(3)
	assert_eq(world._lasso_state, "hold", "rope holding")
	world._on_aim_pressed()
	world._on_aim_released(Vector2.ZERO)
	world._on_aim_pressed()
	world._on_aim_released(Vector2.ZERO)
	assert_eq(world._lasso_state, "", "double tap drops the roped horse")
	assert_eq(horse.held <= 0.0, true, "horse free to bolt")

func test_lasso_captures_pig_and_counts() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	var before: int = SaveData.world_pigs.size()
	world.player.position = Vector2(0, 160)
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
	world._throw_lasso(Vector2.RIGHT, 140.0)
	for i in range(80):
		await wait_physics_frames(3)
		if not is_instance_valid(pig):
			break
	assert_false(is_instance_valid(pig), "roped pig is captured")
	# the pen registers the capture one frame after the pig node is freed
	await wait_physics_frames(6)
	assert_gt(SaveData.world_pigs.size(), before, "pig counts in the counter")
