extends GutTest
func after_each()->void:get_tree().paused=false
func _level()->Node:
	SaveData.dual_lasso_intro_shown=true
	SaveData.highest_level_completed=20
	GameState.selected_level=20
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	return level
func test_small_first_physically_unleashes_large_but_medium_first_does_not()->void:
	var risky:Node=_level()
	await wait_physics_frames(2)
	risky.player.global_position=Vector2(0,100)
	assert_eq(risky._active_bulls.size(),10)
	risky._on_pen_door_opened(0)
	assert_false(risky._pen_released[2])
	for frame in range(2400):
		await wait_physics_frames(1)
		if risky._pen_released[2]:break
	assert_true(risky._pen_released[2],"small source physically unleashes five-bull herd")
	assert_false(risky._pen_released[1],"medium independent group remains closed")
	var wild:int=0
	for bull in risky._active_bulls:
		if bull.controller.is_wild():wild+=1
	assert_eq(wild,7,"small-first consequence: seven wild, not isolated pair")
	risky.queue_free()
	await wait_physics_frames(2)
	var planned:Node=_level()
	await wait_physics_frames(2)
	planned._on_pen_door_opened(1)
	await wait_physics_frames(700)
	assert_false(planned._pen_released[0])
	assert_false(planned._pen_released[2],"medium-first leaves large locked until player chooses")
	assert_true(planned._courier_jobs.is_empty())
func test_small_last_has_no_pending_door_once_large_already_open()->void:
	var level:Node=_level()
	await wait_physics_frames(2)
	level._on_pen_door_opened(1)
	level._on_pen_door_opened(2)
	level._on_pen_door_opened(0)
	assert_true(level._courier_jobs.is_empty(),"planning removes the opener consequence without cancelling its intent")
	assert_false(level._pen_released.has(false))

func test_capturing_small_opener_is_valid_control_but_release_restores_risk()->void:
	var level:Node=_level()
	await wait_physics_frames(2)
	level._on_pen_door_opened(0)
	var opener:Node=level._active_bulls[0]
	assert_true(opener.try_capture(opener.global_position))
	await wait_physics_frames(700)
	assert_false(level._pen_released[2],"player can deliberately hold opener and prevent release")
	assert_eq(level._courier_jobs.size(),1,"holding does not erase its tendency")
	opener.release_by_player()
	for frame in range(2400):
		await wait_physics_frames(1)
		if level._pen_released[2]:break
	assert_true(level._pen_released[2],"letting opener go restores consequence")
func test_repeated_capture_release_and_manually_opened_destination_cleanup()->void:
	var level:Node=_level()
	await wait_physics_frames(2)
	level._on_pen_door_opened(0)
	var opener:Node=level._active_bulls[0]
	for cycle in range(3):
		assert_true(opener.try_capture(opener.global_position))
		await wait_physics_frames(20)
		assert_eq(level._courier_jobs.size(),1)
		opener.release_by_player()
		await wait_physics_frames(24)
		assert_true(opener._courier_active)
	level._on_pen_door_opened(2)
	await wait_physics_frames(2)
	assert_true(level._courier_jobs.is_empty(),"no stale task after player opens target")
	assert_false(opener._courier_active)
func test_delivered_opener_is_secured_not_a_stale_pending_job()->void:
	var level:Node=_level()
	await wait_physics_frames(2)
	level._on_pen_door_opened(0)
	var opener:Node=level._active_bulls[0]
	assert_true(opener.try_capture(opener.global_position))
	opener.controller.update_hold(100,50,0)
	# Delivery-handler isolation; physical delivery is separately covered in live-tow tests.
	level._on_bull_returned(opener)
	assert_true(level._courier_jobs.is_empty())
	assert_false(level._pen_released[2],"secure delivery controls the consequence, release would not")
