extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	root.get_node("GameState").selected_level = 3
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	root.add_child(level)
	await physics_frame
	await physics_frame
	var bull: Node2D = level._active_bulls[0]
	bull.global_position = level._distraction_stations[0].global_position + Vector2(25, 0)
	level.player.global_position = bull.global_position + Vector2(65, 60)
	bull.set_is_chaser(true)
	for i in range(5): await physics_frame
	print("DRINKING ", bull._distraction.active(), " velocity=", bull.velocity)
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/downloads/gorodeo/drinking.png")
	level.queue_free()
	await process_frame
	quit()
