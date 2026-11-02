extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	root.get_node("GameState").selected_level = 20
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	root.add_child(level)
	await physics_frame
	await physics_frame
	level._on_pen_door_opened(0)
	for i in range(150): await physics_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/downloads/gorodeo/release-corrals.png")
	var remaining: int = 0
	for bull in level._active_bulls:
		if bull._leaving_corral: remaining += 1
	print("EXIT_IN_PROGRESS ",remaining)
	level.queue_free()
	await process_frame
	quit()
