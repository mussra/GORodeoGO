extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	root.get_node("GameState").selected_level = 1
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	root.add_child(level)
	await physics_frame
	await physics_frame
	level.set_process(false)
	level.player.set_physics_process(false)
	var bull: Node2D = level._active_bulls[0]
	bull.set_physics_process(false)
	bull.global_position = Vector2(20, 18)
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/downloads/gorodeo/depth-front.png")
	bull.global_position = Vector2(20, -18)
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/downloads/gorodeo/depth-back.png")
	level.queue_free()
	await process_frame
	quit()
