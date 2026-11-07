extends GutTest
## Regate in the open world (Ant 7-nov-2026 16:21): directional dash with the
## dodge trail (estela), cooldown between dashes.

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

func test_dodge_dashes_with_trail_and_cooldown() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.position = Vector2(0, 600)
	var from: Vector2 = world.player.position
	assert_true(world.player.request_dodge(Vector2.RIGHT), "dash starts")
	await wait_physics_frames(4)
	assert_gt(world.player._skid_trail.size(), 1, "estela de regate mientras dashea")
	await wait_physics_frames(12)
	var dist: float = world.player.position.distance_to(from)
	assert_gt(dist, 30.0, "the dash covers ground fast")
	assert_gt(world.player.dodge_cooldown, 0.0, "cooldown running after the dash")
	assert_false(world.player.request_dodge(Vector2.RIGHT), "no second dash during cooldown")
	world.player.dodge_cooldown = 0.0
	assert_true(world.player.request_dodge(Vector2.RIGHT), "dash again once recharged")

func test_dodge_needs_a_direction() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	assert_false(world.player.request_dodge(Vector2.ZERO), "no dash without direction")
