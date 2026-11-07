extends GutTest
## Lasso on fleeing wild horses (Ant 7-nov-2026 16:20): a landed rope holds the
## horse, and from there the corral post-capture flow applies (Ant 7-nov-2026
## 20:02-20:06, "el lazo después de cazar igual"): the animal follows the rider
## (TowFollower), trust fills while roped, and it joins the cuadra when led
## back to the ranch — no timer, no auto-join.

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

func _plant_horse(world: Node2D, pos: Vector2, key: Vector2i = Vector2i(99, 99)) -> Node2D:
	var horse: Node2D = world.WildHorseScript.new()
	horse.setup({"pos": pos, "temperament": 0.0, "traits": {"coat": 0, "pattern": 0, "mane": 0, "eyes": 0, "finish": "normal"}, "stats": {}})
	world.add_child(horse)
	horse.position = pos
	horse.set_meta("c", key)
	world._herd_horses[key] = horse
	return horse

func _rope_horse(world: Node2D) -> void:
	world.player.lasso._release_throw(Vector2(140.0 / 220.0, 0))
	assert_true(world.player.lasso._lasso_in_flight, "rope in flight after the throw")

func test_lasso_holds_horse_in_place_then_captures() -> void:
	# Ant 21:47: the roped horse does NOT follow; after the hold timer it is captured.
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.position = Vector2(0, 160)
	var horse: Node2D = _plant_horse(world, Vector2(150, 160))
	_rope_horse(world)
	for i in range(40):
		await wait_physics_frames(3)
		if world._lasso_state == "hold":
			break
	assert_eq(world._lasso_state, "hold", "landed rope holds the horse")
	assert_true(horse.roped, "horse is roped")
	# the roped horse stays in place even when the rider walks away
	var planted_at: Vector2 = horse.position
	Input.action_press("move_right")
	for i in range(30):
		await wait_physics_frames(3)
		if not is_instance_valid(horse):
			break
	Input.action_release("move_right")
	if is_instance_valid(horse):
		assert_almost_eq(horse.position.x, planted_at.x, 4.0, "roped horse does not follow the rider")
		assert_almost_eq(horse.position.y, planted_at.y, 4.0, "roped horse does not follow the rider")
	# the hold timer captures it (trust fills while held, then it joins the cuadra)
	for i in range(120):
		await wait_physics_frames(3)
		if not is_instance_valid(horse):
			break
	assert_true(SaveData.world_tamed.has(WorldMap.herd_mission_id(99, 99)), "timer-captured horse joins the cuadra")
	assert_eq(world._lasso_state, "", "lasso session ends on capture")

func test_rider_not_blocked_by_horse() -> void:
	# Ant 21:48: bumping into a horse must never block the rider.
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.position = Vector2(0, 160)
	world.player.velocity = Vector2.ZERO
	_plant_horse(world, Vector2(60, 160))  # calm horse right in the rider's path
	Input.action_press("move_right")
	await wait_physics_frames(90)
	Input.action_release("move_right")
	assert_gt(world.player.position.x, 100.0, "the rider walks straight through a calm horse")

func test_lasso_miss_recovers() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.position = Vector2(0, 160)
	world.player.lasso._release_throw(Vector2(140.0 / 220.0, 0))
	for i in range(17):
		await wait_physics_frames(3)
	assert_eq(world._lasso_state, "", "missed rope holds nothing")
	assert_false(world.player.lasso._lasso_in_flight, "missed rope retracts")
	world.player.lasso._on_aim_pressed()
	assert_true(world.player.lasso._is_charging, "no cooldown: a new charge starts right away (corral behavior)")

func test_aim_stick_charge_and_release_throws() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.lasso._on_aim_pressed()
	assert_true(world.player.lasso._is_charging, "pressing the aim stick starts the charge")
	world.player.lasso._on_aim_released(Vector2(1, 0) * 0.8)
	assert_true(world.player.lasso._lasso_in_flight, "releasing with direction throws the rope")

func test_aim_release_near_center_cancels() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.lasso._on_aim_pressed()
	world.player.lasso._on_aim_released(Vector2(0.05, 0.0))
	assert_eq(world._lasso_state, "", "short release cancels, no throw")
	assert_false(world.player.lasso._lasso_in_flight, "no rope in flight after a cancel")

func test_double_tap_releases_roped_horse() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.position = Vector2(0, 160)
	var horse: Node2D = _plant_horse(world, Vector2(150, 160))
	_rope_horse(world)
	for i in range(30):
		await wait_physics_frames(3)
		if world._lasso_state == "hold":
			break
	assert_eq(world._lasso_state, "hold", "rope holding")
	world.player.lasso._on_aim_pressed()
	world.player.lasso._on_aim_released(Vector2.ZERO)
	world.player.lasso._on_aim_pressed()
	world.player.lasso._on_aim_released(Vector2.ZERO)
	assert_eq(world._lasso_state, "", "double tap drops the roped horse")
	assert_false(horse.roped, "horse free to bolt")
	assert_gt(float(horse.state.get("spook", 0.0)), 0.0, "released horse bolts (keeps its trust progress)")

func test_bolting_horse_stuns_rider_and_drops_capture() -> void:
	# "Que suelte" (Ant 19:58): contact with a bolting wild animal stuns the
	# rider and drops the roped capture — the corral's contact rule.
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.position = Vector2(0, 160)
	var horse: Node2D = _plant_horse(world, Vector2(150, 160))
	_rope_horse(world)
	for i in range(30):
		await wait_physics_frames(3)
		if world._lasso_state == "hold":
			break
	assert_eq(world._lasso_state, "hold", "rope holding")
	var spooked: Node2D = _plant_horse(world, Vector2(40, 160), Vector2i(98, 98))
	spooked.state = {"progress": 0.0, "spook": WorldTaming.SPOOK_SECONDS}
	await wait_physics_frames(6)
	assert_gt(world.player._stun_time_remaining, 0.0, "bolting horse stuns the rider on contact")
	assert_eq(world._lasso_state, "", "the stun drops the roped horse")
	assert_false(horse.roped, "dropped horse is free")

func test_lasso_ropes_pig_and_timer_captures() -> void:
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
	world.player.lasso._release_throw(Vector2(140.0 / 220.0, 0))
	for i in range(120):
		await wait_physics_frames(3)
		if not is_instance_valid(pig):
			break
	assert_false(is_instance_valid(pig), "roped pig captured when the hold timer fills")
	# the pen registers the capture one frame after the pig node is freed
	await wait_physics_frames(6)
	assert_gt(SaveData.world_pigs.size(), before, "pig counts in the counter")
