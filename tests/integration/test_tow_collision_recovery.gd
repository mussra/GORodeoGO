extends GutTest
func after_each() -> void:
	for a in ["move_left","move_right","move_up","move_down"]: Input.action_release(a)
	get_tree().paused=false
func _setup() -> Node:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=1
	var level: Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level.set_process(false)
	for b in level._active_bulls: b.set_physics_process(false)
	return level
func test_tow_recovers_when_player_path_hugs_outer_boundary_then_returns_inside() -> void:
	var level: Node=await _setup()
	var bull: Node=level._active_bulls[0]
	level.player.global_position=Vector2(440,140)
	bull.global_position=Vector2(370,140)
	assert_true(bull.try_capture(bull.global_position))
	bull.set_physics_process(true)
	Input.action_press("move_right")
	await wait_physics_frames(45)
	Input.action_release("move_right")
	Input.action_press("move_up")
	await wait_physics_frames(50)
	assert_lt(bull.global_position.y,100.0,"continues moving along boundary, not only after rider returns inside")
	Input.action_release("move_up")
	Input.action_press("move_left")
	await wait_physics_frames(70)
	Input.action_release("move_left")
	await wait_physics_frames(120)
	assert_true(bull.controller.is_held(),"edge recovery keeps capture")
	assert_lt(bull.global_position.distance_to(level.player.global_position),75.0,"bull resumes behind rider after edge turn")
func test_tow_recovers_around_real_obstacle_after_narrow_corner() -> void:
	var level: Node=await _setup()
	var rect:=Rect2(0,-60,100,120)
	level._spawn_obstacles([rect])
	var bull: Node=level._active_bulls[0]
	level.player.global_position=Vector2(-65,80)
	bull.global_position=Vector2(-130,80)
	assert_true(bull.try_capture(bull.global_position))
	bull.set_physics_process(true)
	Input.action_press("move_right")
	await wait_physics_frames(54)
	Input.action_release("move_right")
	Input.action_press("move_up")
	await wait_physics_frames(65)
	Input.action_release("move_up")
	Input.action_press("move_left")
	await wait_physics_frames(40)
	Input.action_release("move_left")
	var previous: Vector2=bull.global_position
	var previous_frame: int=Engine.get_physics_frames()
	for frame in range(100):
		await wait_physics_frames(1)
		assert_lte(bull.global_position.distance_to(previous),6.0*(Engine.get_physics_frames()-previous_frame),"bounded speed, not teleport")
		assert_false(rect.grow(23.5).has_point(bull.global_position),"bull never cuts through obstacle")
		previous=bull.global_position
		previous_frame=Engine.get_physics_frames()
	assert_true(bull.controller.is_held(),"object recovery keeps capture")
	assert_lt(bull.global_position.distance_to(level.player.global_position),75.0,"bull resumes after obstacle corner")
