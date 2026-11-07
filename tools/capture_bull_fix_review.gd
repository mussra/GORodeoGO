extends SceneTree
## Ant 22:22 bulls-mode regression fix: bulls move, get lassoed and the counter
## counts deliveries again. Run under X:
##   REVIEW_DIR=/tmp/review xvfb-run -a godot --path . --script tools/capture_bull_fix_review.gd
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

func capture() -> void:
	var sd = root.get_node("SaveData")
	sd.highest_level_completed = 999
	sd.dual_lasso_intro_shown = true
	root.get_node("GameState").selected_level = 3
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	root.add_child(level)
	await create_timer(0.5).timeout
	await shot("bulls_moving_a.png")
	await create_timer(1.5).timeout
	await shot("bulls_moving_b.png")
	# lasso the nearest wild bull for real (through the shared controller)
	var best: Node2D = null
	var best_d: float = 1e9
	for bull in level._active_bulls:
		if not bull.controller.is_wild():
			continue
		var d: float = bull.global_position.distance_to(level.player.global_position)
		if d < best_d:
			best_d = d
			best = bull
	if best != null:
		level.player.global_position = best.global_position + Vector2(-120, 0)
		await process_frame
		var landing: Vector2 = best.global_position
		level.player.lasso._lasso_in_flight = true  # keep the flight bookkeeping consistent
		level.player.lasso.resolve_capture(landing)
		level.player.lasso._lasso_in_flight = false
		for i in range(30):
			await physics_frame
	await shot("bull_captured.png")
	quit()
