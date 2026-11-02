extends SceneTree
var level: Node
func _initialize() -> void:
	call_deferred("run")
func touch(index: int, point: Vector2, pressed: bool) -> void:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.position = point
	event.pressed = pressed
	root.push_input(event)
func drag(index: int, point: Vector2) -> void:
	var event := InputEventScreenDrag.new()
	event.index = index
	event.position = point
	event.relative = Vector2(80, -80)
	root.push_input(event)
func run() -> void:
	root.get_node("GameState").selected_level = 1
	level = load("res://src/Presentation/level_0.tscn").instantiate()
	root.add_child(level)
	await process_frame
	await process_frame
	var size: Vector2 = root.get_visible_rect().size
	var left: Vector2 = size * Vector2(0.2, 0.7)
	var right: Vector2 = size * Vector2(0.75, 0.7)
	touch(0, left, true)
	touch(1, right, true)
	drag(0, left + Vector2(80, 0))
	drag(1, right + Vector2(0, -80))
	await create_timer(0.25).timeout
	print("TOUCH_STATE ", level.player.position, " charging=", level.player._is_charging, " aim=", level.player.aim_direction)
	var success: bool = level.player.position.x > 1 and level.player._is_charging and level.player.aim_direction.y < -0.5
	touch(1, right + Vector2(0, -80), false)
	await process_frame
	success = success and level.player._lasso_in_flight
	print("TOUCH_RESULT ", success)
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/downloads/gorodeo/touch-review.png")
	touch(0, left + Vector2(80, 0), false)
	await process_frame
	success = success and Input.get_vector("move_left", "move_right", "move_up", "move_down") == Vector2.ZERO
	# Fresh two-finger drag interrupted by pause: neither stick may retain actions.
	touch(0, left, true)
	touch(1, right, true)
	drag(0, left + Vector2(80, 0))
	drag(1, right + Vector2(0, -80))
	await process_frame
	level.pause_game()
	await process_frame
	var movement: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var aim: Vector2 = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	print("PAUSED_INPUT movement=", movement, " aim=", aim)
	success = success and movement == Vector2.ZERO and aim == Vector2.ZERO
	level.resume_game()
	touch(0, left + Vector2(80, 0), false)
	touch(1, right + Vector2(0, -80), false)
	await process_frame
	print("TOUCH_FINAL ", success)
	level.queue_free()
	await process_frame
	quit(0 if success else 1)
