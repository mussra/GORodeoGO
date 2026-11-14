extends GutTest
func after_each() -> void:
	get_tree().paused = false
func test_double_movement_gesture_dodges_without_releasing_capture() -> void:
	var source: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	var player: Node = source.get_node("Player").duplicate()
	source.free()
	add_child_autofree(player)
	await wait_physics_frames(1)
	watch_signals(player)
	assert_true(player.request_dodge_path(PackedVector2Array([Vector2.ZERO, Vector2(40, 0), Vector2(20, 30), Vector2(60, 30)])))
	assert_gt(player._dodge_remaining, 0.0)
	var start: Vector2 = player.global_position
	await wait_physics_frames(4)
	assert_gt(player.global_position.x, start.x + 5)
	assert_signal_not_emitted(player, "release_requested")
	assert_false(player.request_dodge(Vector2.LEFT), "recharge prevents chaining dodges")
	player.stun(1.0)
	assert_eq(player._dodge_remaining, 0.0, "a hit still interrupts dodge, no immunity")
	assert_false(player.request_dodge(Vector2.LEFT), "cannot dodge while stunned")

func test_double_tap_then_drag_records_path_but_normal_drag_does_not() -> void:
	var source: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	var player: Node = source.get_node("Player").duplicate()
	source.free()
	add_child_autofree(player)
	await wait_physics_frames(1)
	var touch := InputEventScreenTouch.new()
	touch.pressed = true
	touch.position = Vector2(100,300)
	touch.index = 0
	player._input(touch)
	player._on_move_pressed()
	var drag := InputEventScreenDrag.new()
	drag.position = Vector2(160,300)
	drag.index = 0
	player._input(drag)
	assert_false(player._drawing_dodge, "single ordinary drag remains normal movement")
	player._on_move_released(Vector2.RIGHT)
	player._input(touch)
	player._on_move_pressed()
	assert_true(player._drawing_dodge)
	player._input(drag)
	drag.position = Vector2(110,350)
	player._input(drag)
	drag.position = Vector2(170,350)
	player._input(drag)
	assert_eq(player._draw_points.size(), 4, "Z is recorded, not reduced to one direction")
	drag.index = 1
	drag.position = Vector2(900,100)
	player._input(drag)
	assert_eq(player._draw_points.size(), 4, "other finger on lasso cannot distort movement trace")
	player._on_move_released(Vector2.RIGHT)
	assert_gt(player._dodge_path.size(), 3,"shared smooth curve retains the freehand trace")

func test_trace_transitions_immediately_to_normal_running() -> void:
	var source: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	var player: Node = source.get_node("Player").duplicate()
	source.free()
	add_child_autofree(player)
	player.set_physics_process(false)
	var start: Vector2 = player.global_position
	assert_true(player.request_dodge_path(PackedVector2Array([Vector2.ZERO,Vector2(60,0)])))
	for i in range(60):
		player._physics_process(1.0/60)
		if player._dodge_path.is_empty():break
	assert_almost_eq(player.global_position.x,start.x+60,.2,"trace ends at preview, running begins after it")
	assert_almost_eq(player.velocity.length(),player.max_speed,.1,"no stationary transition frame")
	player._physics_process(1.0/60)
	assert_gt(player.global_position.x,start.x+60,"keeps running without held input")
	Input.action_press("move_up")
	player._physics_process(.1)
	assert_lt(player.velocity.y,0.0,"fresh joystick steers running")
	Input.action_release("move_up")
	player.cancel_input()
	assert_eq(player._run_after_dodge,Vector2.ZERO,"pause/stun can stop continuation")

func test_finish_preserves_endpoint_tangent_and_dual_capture_speed() -> void:
	var source: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	var player: Node = source.get_node("Player").duplicate()
	source.free()
	add_child_autofree(player)
	player.set_physics_process(false)
	player.set_active_capture_count(2)
	assert_true(player.request_dodge_path(PackedVector2Array([Vector2.ZERO,Vector2(30,0)])))
	Input.action_press("move_down")
	for i in range(60):
		player._physics_process(1.0/60)
		if player._dodge_path.is_empty():break
	assert_almost_eq(player.velocity.x,player.max_speed*player.dual_capture_speed_multiplier,.1,"endpoint tangent is retained before normal steering")
	assert_almost_eq(player.velocity.y,0.0,.01)
	Input.action_release("move_down")
	player._on_move_released(Vector2.DOWN)
	assert_eq(player._run_after_dodge,Vector2.ZERO,"normal joystick release still stops running")

func test_trace_hits_obstacle_instead_of_crossing_it() -> void:
	var source: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	var player: Node = source.get_node("Player").duplicate()
	source.free()
	add_child_autofree(player)
	player.global_position = Vector2.ZERO
	var wall := StaticBody2D.new()
	wall.collision_layer = 4
	wall.position = Vector2(45,0)
	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(10,150)
	shape.shape = rectangle
	wall.add_child(shape)
	add_child_autofree(wall)
	await wait_physics_frames(2)
	assert_true(player.request_dodge_path(PackedVector2Array([Vector2.ZERO, Vector2(180,0)])))
	await wait_physics_frames(40)
	assert_lt(player.global_position.x, 45.0, "solid fence stops trace")
	assert_true(player._dodge_path.is_empty())
	assert_eq(player.velocity, Vector2.ZERO, "no sprint coast after a collision either")

func test_long_stationary_hold_does_not_arm_next_touch_as_double_tap() -> void:
	var source: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	var player: Node = source.get_node("Player").duplicate()
	source.free()
	add_child_autofree(player)
	await wait_physics_frames(1)
	player._on_move_pressed()
	player._move_pressed_at -= .4
	player._on_move_released(Vector2.RIGHT)
	player._on_move_pressed()
	assert_false(player._drawing_dodge, "ordinary long movement gesture does not arm special")

func test_freeform_s_retains_all_waypoints_and_stun_cancels_soft_stop() -> void:
	var source: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	var player: Node = source.get_node("Player").duplicate()
	source.free()
	add_child_autofree(player)
	await wait_physics_frames(1)
	var start: Vector2 = player.global_position
	var points := PackedVector2Array([Vector2.ZERO, Vector2(30,-20),Vector2(55,0),Vector2(15,30),Vector2(45,50),Vector2(70,40)])
	assert_true(player.request_dodge_path(points))
	var preview:PackedVector2Array=player.dodge.preview_points(points)
	assert_eq(player._dodge_path.size(),preview.size()-1, "execution matches shared smooth preview")
	for i in range(player._dodge_path.size()):
		assert_eq(player._dodge_path[i],start+preview[i+1])
	await wait_physics_frames(30)
	player._dodge_coast_remaining = .1
	player.stun(.5)
	assert_eq(player._dodge_coast_remaining,0.0)

func test_handoff_has_no_stationary_frame_at_30_60_120_fps() -> void:
	for fps in [30,60,120]:
		var source:Node=load("res://src/Presentation/level_0.tscn").instantiate()
		var player:Node=source.get_node("Player").duplicate()
		source.free()
		add_child_autofree(player)
		player.set_physics_process(false)
		player.global_position=Vector2.ZERO
		assert_true(player.request_dodge_path(PackedVector2Array([Vector2.ZERO,Vector2(35,15),Vector2(65,0)])))
		for i in range(fps):
			player._physics_process(1.0/fps)
			if player._dodge_path.is_empty():break
		assert_true(player._dodge_path.is_empty())
		assert_almost_eq(player.velocity.length(),player.max_speed,.1)
		var endpoint:Vector2=player.global_position
		player._physics_process(1.0/fps)
		assert_gt(player.global_position.distance_to(endpoint),0.1,"manual transition advances; move_and_slide uses engine tick, not injected delta")
		player.stun(.5)
		assert_eq(player._run_after_dodge,Vector2.ZERO,"contact cancels continued running")
		assert_eq(player.velocity,Vector2.ZERO)

func _gesture_player() -> Node:
	var source: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	var player: Node = source.get_node("Player").duplicate()
	source.free()
	add_child_autofree(player)
	player.set_physics_process(false)
	return player

func test_running_hold_release_and_single_repress_arms_dodge() -> void:
	var player := _gesture_player()
	player._on_move_pressed()
	player._move_pressed_at -= 5.0
	player.velocity = Vector2(200,0)
	player._on_move_released(Vector2.RIGHT)
	player._on_move_pressed()
	assert_true(player._drawing_dodge, "long running hold counts as the first press")
	player.cancel_input()

func test_running_repress_after_window_is_normal_movement() -> void:
	var player := _gesture_player()
	player._on_move_pressed()
	player._move_pressed_at -= 5.0
	player.velocity = Vector2(200,0)
	player._on_move_released(Vector2.RIGHT)
	player._running_release_at -= .31
	player._on_move_pressed()
	assert_false(player._drawing_dodge)

func test_stationary_start_still_requires_two_quick_presses() -> void:
	var player := _gesture_player()
	player._on_move_pressed()
	assert_false(player._drawing_dodge)
	player._on_move_released(Vector2.ZERO)
	player._on_move_pressed()
	assert_true(player._drawing_dodge)
	player.cancel_input()

func test_cancel_clears_running_release_and_cooldown_blocks_repress() -> void:
	var player := _gesture_player()
	player._on_move_pressed()
	player._move_pressed_at -= 5.0
	player.velocity = Vector2(200,0)
	player._on_move_released(Vector2.RIGHT)
	player.cancel_input()
	player._on_move_pressed()
	assert_false(player._drawing_dodge)
	player.velocity = Vector2(200,0)
	player._on_move_released(Vector2.RIGHT)
	player._dodge_cooldown = 1.0
	player._on_move_pressed()
	assert_false(player._drawing_dodge)
