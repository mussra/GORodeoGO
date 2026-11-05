extends GutTest
func after_each() -> void:
	for action in ["move_left","move_right","move_up","move_down"]: Input.action_release(action)
	get_tree().paused = false
func test_tow_follows_behind_and_retains_corner_path() -> void:
	SaveData.dual_lasso_intro_shown = true
	GameState.selected_level = 1
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level.player.global_position = Vector2(-200,100)
	var bull: Node = level._active_bulls[0]
	bull.global_position = Vector2(-270,100)
	assert_true(bull.try_capture(bull.global_position))
	Input.action_press("move_right")
	await wait_physics_frames(60)
	assert_lt(bull.global_position.x,level.player.global_position.x-35,"bull stays behind sprinting rider")
	assert_almost_eq(bull.global_position.y,level.player.global_position.y,1.0)
	Input.action_release("move_right")
	Input.action_press("move_up")
	await wait_physics_frames(10)
	assert_gt(bull._tow_path.size(),2,"corner retained as path, not cut with parallel velocity")
	await wait_physics_frames(30)
	assert_gt(bull.global_position.y,level.player.global_position.y+25,"bull follows behind upward turn")
	Input.action_release("move_up")
	await wait_physics_frames(50)
	assert_lt(bull.global_position.distance_to(level.player.global_position),65.0)
	assert_gt(bull.global_position.distance_to(level.player.global_position),45.0,"does not run over rider when stopped")
func test_bull_follows_z_dodge_in_order_without_shortcut_or_release() -> void:
	SaveData.dual_lasso_intro_shown = true
	GameState.selected_level = 1
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level.player.global_position = Vector2(-200,50)
	var bull: Node = level._active_bulls[0]
	bull.global_position = Vector2(-260,50)
	assert_true(bull.try_capture(bull.global_position))
	Input.action_press("move_right")
	await wait_physics_frames(30)
	Input.action_release("move_right")
	var start: Vector2 = level.player.global_position
	level.player.dodge_available=true
	assert_true(level.player.request_dodge_path(PackedVector2Array([Vector2.ZERO,Vector2(80,0),Vector2(0,60),Vector2(80,60)])))
	await wait_physics_frames(10)
	assert_gt(bull._tow_path.size(),2,"bull remembers rapid trace rather than velocity copy")
	await wait_physics_frames(90)
	assert_true(bull.controller.is_held(),"dodge itself does not drop capture")
	assert_gt(bull.global_position.x,start.x+20)
	assert_lt(bull.global_position.distance_to(level.player.global_position),65.0)
