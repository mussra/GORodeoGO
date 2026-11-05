extends GutTest
func after_each()->void:
	get_tree().paused=false
	for action in ["move_left","move_right","move_up","move_down"]:Input.action_release(action)
func _walk(player:Node,target:Vector2,max_frames:int)->int:
	var frames:int=0
	while player.global_position.distance_to(target)>12 and frames<max_frames:
		var delta:Vector2=target-player.global_position
		for pair in [["move_left",delta.x<-7],["move_right",delta.x>7],["move_up",delta.y<-7],["move_down",delta.y>7]]:
			if pair[1]:Input.action_press(pair[0])
			else:Input.action_release(pair[0])
		await wait_physics_frames(1)
		frames+=1
	for action in ["move_left","move_right","move_up","move_down"]:Input.action_release(action)
	return frames
func test_real_player_reaches_latch_and_tows_back_inside_level18_budget()->void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=18
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	# Isolate geometry/timing, not live-herd balance; other bulls frozen explicitly.
	for b in level._active_bulls:b.set_physics_process(false)
	var target:Vector2=level._puzzle_corrals[2].layout["door"]
	var frames:int=await _walk(level.player,Vector2(target.x,0),400)
	frames+=await _walk(level.player,target,300)
	assert_lt(level.player.global_position.distance_to(target),15.0)
	await wait_physics_frames(90);frames+=90
	assert_true(level._pen_released[2],"real latch hold")
	var bull:Node=level._active_bulls[level._pens_data[2]["bull_indices"][0]]
	# Start capture outside opened gate, then movement and delivery are physical.
	bull.global_position=level.player.global_position+Vector2(0,45)
	bull.try_capture(bull.global_position)
	bull.controller.update_hold(100,50,0)
	bull.set_physics_process(true)
	frames+=await _walk(level.player,Vector2(target.x,0),350)
	frames+=await _walk(level.player,level.pen.global_position,700)
	await wait_physics_frames(120);frames+=120
	assert_true(bull._delivered,"actual goal detection, not direct method call")
	assert_lt(frames,2400,"geometry roundtrip under40s of390s level budget")
	print("ROUTE18_SECONDS ",frames/60.0)
