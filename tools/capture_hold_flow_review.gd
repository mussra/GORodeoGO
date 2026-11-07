extends SceneTree
## Captures Ant's 21:47 fixes: world charge-aim circle (restored, shared with
## the corral) and the world hold-timer capture flow (roped horse stays put,
## timer captures it). Run under an X server:
##   REVIEW_DIR=/tmp/review xvfb-run -a godot --path . --script tools/capture_hold_flow_review.gd
var output_dir: String = OS.get_environment("REVIEW_DIR")

func _initialize() -> void:
	if output_dir.is_empty():
		output_dir = "user://review"
	DirAccess.make_dir_recursive_absolute(output_dir)
	call_deferred("capture")

func shot(filename: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output_dir.path_join(filename))

var save: Node
func _reset_save() -> void:
	save = root.get_node("SaveData")
	save.world_seed = 424242
	save.world_discovered.clear()
	save.world_tamed.clear()
	save.world_missions.clear()
	save.world_pigs.clear()
	save.world_edits.clear()
	save.horse_collection.seed_trial()
	save.world_position = Vector2(0, 160)

func _plant_horse(world: Node2D, pos: Vector2, key: Vector2i = Vector2i(99, 99)) -> Node2D:
	var horse: Node2D = world.WildHorseScript.new()
	horse.setup({"pos": pos, "temperament": 0.0, "traits": {"coat": 0, "pattern": 0, "mane": 0, "eyes": 0, "finish": "normal"}, "stats": {}})
	world.add_child(horse)
	horse.position = pos
	horse.set_meta("c", key)
	world._herd_horses[key] = horse
	return horse

func capture() -> void:
	# --- corral charge-aim circle (existing reference) ---
	root.get_node("GameState").selected_level = 1
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	root.add_child(level)
	await create_timer(0.4).timeout
	level.player.lasso._start_charging()
	level.player.lasso.process_throw_input(0.45)
	await shot("corral_charge_aim.png")
	level.player.lasso.cancel_input()
	level.queue_free()
	await process_frame

	# --- world: charge-aim circle (was missing) ---
	_reset_save()
	var world: Node2D = load("res://src/Presentation/frontier_world.tscn").instantiate()
	root.add_child(world)
	await create_timer(0.4).timeout
	world.player.position = Vector2(0, 160)
	var horse: Node2D = _plant_horse(world, Vector2(150, 160))
	world.player.lasso._start_charging()
	world.player.lasso.process_throw_input(0.45)
	await shot("world_charge_aim.png")
	world.player.lasso.cancel_input()
	await process_frame

	# --- world: roped horse stays put, rope visible, trust bar ---
	world.player.lasso._release_throw(Vector2(140.0 / 220.0, 0))
	for i in range(60):
		await physics_frame
		if world._lasso_state == "hold":
			break
	await create_timer(1.0).timeout
	await shot("world_hold_roped.png")

	# --- world: after the hold timer the horse is captured (joins cuadra) ---
	for i in range(200):
		await physics_frame
		if not is_instance_valid(horse):
			break
	await create_timer(0.3).timeout
	await shot("world_hold_captured.png")
	quit()
