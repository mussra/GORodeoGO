extends GutTest
func after_each()->void:
	get_tree().paused=false
	for action in ["move_left","move_right","move_up","move_down"]:Input.action_release(action)
func test_late_sources_keep_companions_and_routes_finish_with_live_herd()->void:
	SaveData.dual_lasso_intro_shown=true
	SaveData.highest_level_completed=20
	for number in range(15,20):
		seed(20261105)
		GameState.selected_level=number
		var data:LevelData=LevelCatalog.get_level(number)
		for i in range(data.pens.size()):
			var courier:int=0 if PenLinkResolver.get_linked_pen_indices(data.pens,i).is_empty() else 1
			assert_gte(data.pens[i]["bull_indices"].size()-courier-2,1,"%d/%d leaves threat beyond two captures"%[number,i])
		var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
		add_child_autofree(level)
		await wait_physics_frames(2)
		level.player.global_position=Vector2(0,150)
		level._on_pen_door_opened(0)
		var frames:int=0
		for frame in range(4800):
			await wait_physics_frames(1)
			frames+=1
			if level._courier_jobs.is_empty():break
		assert_true(level._courier_jobs.is_empty(),"%d courier physical route completes with all bulls running"%number)
		for target in PenLinkResolver.get_linked_pen_indices(data.pens,0):assert_true(level._pen_released[target])
		for bull in level._active_bulls:assert_true(bull.is_physics_processing())
		print("CAMPAIGN_ROUTE ",number," seconds=",frames/60.0," gates=",data.pens.size())
		level.queue_free()
		await wait_physics_frames(2)
func test_pair_capture_attempts_use_input_motion_and_leave_live_companion()->void:
	SaveData.dual_lasso_intro_shown=true
	SaveData.highest_level_completed=20
	for number in range(15,20):
		seed(20261105)
		GameState.selected_level=number
		var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
		add_child_autofree(level)
		await wait_physics_frames(2)
		level.player.global_position=Vector2(0,150)
		level._on_pen_door_opened(0)
		await wait_physics_frames(500)
		var travel:int=0
		for frame in range(1800):
			if level._held_bulls().size()==2:break
			var candidates:Array=[]
			for index in level._pens_data[0]["bull_indices"]:
				var bull:Node=level._active_bulls[index]
				if bull.controller.is_wild() and not bull._courier_active:candidates.append(bull)
			candidates.sort_custom(func(a,b):return level.player.global_position.distance_to(a.global_position)<level.player.global_position.distance_to(b.global_position))
			if candidates.is_empty():break
			var target:Node=candidates[0]
			var offset:Vector2=target.global_position-level.player.global_position
			if offset.length()<level.player.max_throw_distance-20:
				level._on_lasso_thrown(level.player.global_position,target.global_position)
			else:_drive(offset)
			await wait_physics_frames(1)
			travel+=1
		_drive(Vector2.ZERO)
		assert_eq(level._held_bulls().size(),2,"%d within-reach pair captured with live herd"%number)
		var pursuit_seen:bool=false
		var contact_seen:bool=false
		for frame in range(75):
			if level._chaser_index>=0:
				pursuit_seen=true
				assert_false(level._active_bulls[level._chaser_index]._courier_active)
				var away:Vector2=level.player.global_position-level._active_bulls[level._chaser_index].global_position
				_drive(away)
			if level.player._stun_time_remaining>0:contact_seen=true
			await wait_physics_frames(1)
		_drive(Vector2.ZERO)
		assert_true(pursuit_seen or contact_seen,"%d active companion either pursues or makes real contact; pair is not isolated"%number)
		print("CAMPAIGN_PAIR ",number," travel_seconds=",travel/60.0," held=",level._held_bulls().size()," chaser=",level._chaser_index)
		level.queue_free()
		await wait_physics_frames(2)
func _drive(offset:Vector2)->void:
	for action in ["move_left","move_right","move_up","move_down"]:Input.action_release(action)
	if offset.x>10:Input.action_press("move_right")
	if offset.x< -10:Input.action_press("move_left")
	if offset.y>10:Input.action_press("move_down")
	if offset.y< -10:Input.action_press("move_up")
