extends GutTest
var ticks: int = 0
func before_each() -> void:
	ticks = 0
func after_each() -> void:
	for a in ["move_left","move_right","move_up","move_down"]: Input.action_release(a)
	get_tree().paused = false
func _drive_to(level: Node, target: Vector2, max_frames: int) -> bool:
	for frame in range(max_frames):
		var offset: Vector2 = target-level.player.global_position
		for a in ["move_left","move_right","move_up","move_down"]: Input.action_release(a)
		if offset.length()<5: return true
		var direction: Vector2 = offset.normalized()*minf(1.0,offset.length()/70.0)
		if direction.x>0: Input.action_press("move_right",direction.x)
		else: Input.action_press("move_left",-direction.x)
		if direction.y>0: Input.action_press("move_down",direction.y)
		else: Input.action_press("move_up",-direction.y)
		await wait_physics_frames(1)
		ticks += 1
	return false
func test_level11_physical_latch_capture_tow_roundtrip_under_existing_clock() -> void:
	var progress: int = SaveData.highest_level_completed
	var intro: bool = SaveData.dual_lasso_intro_shown
	SaveData.highest_level_completed = 20
	SaveData.dual_lasso_intro_shown = true
	GameState.selected_level = 11
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	# No teleports; isolate one trip from unrelated pursuers, not difficulty validation.
	for bull in level._active_bulls: bull.set_physics_process(false)
	var latch: Vector2 = level._pens_data[0]["door_position"]
	assert_true(await _drive_to(level,latch,360),"real rider reaches latch")
	await wait_seconds(1.7)
	assert_true(level._pen_released[0],"actual latch overlap and stillness releases corral")
	var bull: Node = level._active_bulls[0]
	bull.set_physics_process(true)
	assert_true(bull.try_capture(bull.global_position),"capture at real corral spawn")
	# Follow an outside route away from walls, then pass through META rather than stop in front.
	assert_true(await _drive_to(level,Vector2(-510,0),180))
	await wait_seconds(8.5)
	assert_true(await _drive_to(level,level.pen.global_position+Vector2(-110,0),180))
	await wait_physics_frames(15)
	assert_eq(level._bulls_returned,1,"physical tow delivers after actual journey")
	print("EXPANDED LEVEL11 TRIP: remaining=",level._time_remaining," of90s; drive frames=",ticks)
	assert_gt(level._time_remaining,45.0,"one isolated trip takes less than half of clock")
	SaveData.highest_level_completed = progress
	SaveData.dual_lasso_intro_shown = intro

func test_level20_far_corral_physical_roundtrip_under_existing_clock() -> void:
	var progress: int = SaveData.highest_level_completed
	var intro: bool = SaveData.dual_lasso_intro_shown
	SaveData.highest_level_completed = 20
	SaveData.dual_lasso_intro_shown = true
	GameState.selected_level = 20
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	# No teleports; isolate one trip from unrelated pursuers, not difficulty validation.
	for bull in level._active_bulls: bull.set_physics_process(false)
	var latch: Vector2 = level._pens_data[3]["door_position"]
	assert_true(await _drive_to(level,latch,600),"real rider reaches latch")
	await wait_seconds(1.7)
	assert_true(level._pen_released[3],"actual latch overlap and stillness releases corral")
	var bull: Node = level._active_bulls[level._pens_data[3]["bull_indices"][0]]
	bull.set_physics_process(true)
	assert_true(bull.try_capture(bull.global_position),"capture at real corral spawn")
	# Follow an outside route away from walls, then pass through META rather than stop in front.
	assert_true(await _drive_to(level,Vector2(450,0),360))
	await wait_seconds(8.5)
	assert_true(await _drive_to(level,level.pen.global_position+Vector2(-110,0),600))
	await wait_physics_frames(15)
	assert_eq(level._bulls_returned,1,"physical tow delivers after actual journey")
	print("EXPANDED LEVEL20 TRIP: remaining=",level._time_remaining," of450s; drive frames=",ticks)
	assert_gt(level._time_remaining,350.0,"one isolated trip leaves over350s")
	SaveData.highest_level_completed = progress
	SaveData.dual_lasso_intro_shown = intro
