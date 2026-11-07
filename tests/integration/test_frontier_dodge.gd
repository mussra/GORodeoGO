extends GutTest
## Regate in the open world: the SAME system as the corral (shared
## DodgeController + DodgeVisuals, Ant 7-nov-2026 20:04 "Todo usar lo mismo"):
## double-press the move stick to draw the trace in bullet-time, release to
## execute; no Dodge button, no world_dodge action, no separate dash copy.

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

func test_dodge_gesture_draws_and_executes_path() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	world.player.position = Vector2(0, 600)
	var from: Vector2 = world.player.position
	var dodge = world.player.dodge
	# double-press of the move stick (same gesture as the corral)
	dodge.on_move_pressed()
	dodge.on_move_released(Vector2.ZERO)
	dodge.on_move_pressed()
	assert_true(dodge.drawing, "double-press arms bullet-time drawing")
	assert_lt(Engine.time_scale, 1.0, "bullet-time while drawing")
	dodge.draw_points = PackedVector2Array([Vector2.ZERO, Vector2(120, 0)])
	dodge.on_move_released(Vector2.ZERO)
	assert_false(dodge.drawing, "release ends the drawing")
	assert_eq(Engine.time_scale, 1.0, "bullet-time ends on release")
	assert_gt(dodge.path.size(), 0, "traced path executing")
	await wait_physics_frames(30)
	assert_gt(world.player.position.distance_to(from), 40.0, "the dodge covers ground")
	assert_gt(dodge.cooldown, 0.0, "cooldown running after the dodge")
	assert_gt(dodge.skid_trail.size(), 1, "estela de regate while the trace runs")
	Engine.time_scale = 1.0

func test_dodge_needs_a_direction() -> void:
	var world := _fresh_world()
	await wait_physics_frames(4)
	assert_false(world.player.request_dodge(Vector2.ZERO), "no dash without direction")

func test_dodge_requires_a_trained_horse_like_the_levels() -> void:
	var world := _fresh_world()
	# Ant 7-nov-2026 21:33 "Igual": skills need training in the world too.
	SaveData.horse_collection.horses[0]["can_dodge"] = false
	await wait_physics_frames(4)
	assert_false(world.player.dodge_available, "untrained horse: dodge unavailable")
	var dodge = world.player.dodge
	dodge.on_move_pressed()
	dodge.on_move_released(Vector2.ZERO)
	dodge.on_move_pressed()
	await wait_physics_frames(2)
	assert_false(dodge.drawing, "double-press does not arm bullet-time without training")
	assert_eq(Engine.time_scale, 1.0, "no bullet-time without training")
	assert_false(world.player.request_dodge(Vector2(1, 0)), "no dash without training")
	# training the horse unlocks it, same rule as the corral
	SaveData.horse_collection.horses[0]["can_dodge"] = true
	await wait_physics_frames(2)
	assert_true(world.player.dodge_available, "trained horse: dodge available")
