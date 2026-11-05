extends GutTest
func after_each()->void:
	get_tree().paused=false
	Input.action_release("move_down")
func test_overlapping_held_bulls_release_without_collision_recovery_jump()->void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=1
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var a:Node=level._active_bulls[0]
	var b:Node=level.all_bulls[1]
	b.visible=true;b.set_physics_process(true);b.begin_active()
	b.set_player(level.player);b.set_peers([a,b]);a.set_peers([a,b])
	level.player.global_position=Vector2(240,60)
	# Real old narrow gap from screenshot18, rebuilt beside the pair.
	level._spawn_obstacles([Rect2(25,-246,190,136),Rect2(265,-246,190,136)])
	var max_step:float=0
	for x in [220,230,240,250,260]:
		for y in [-79,-84,-88]:
			for bull in [a,b]:
				if bull.controller.is_held():bull.controller.force_escape()
				bull.global_position=Vector2(x,y)
				bull.try_capture(bull.global_position)
			a.controller.force_escape();b.controller.force_escape()
			var previous:Vector2=a.global_position
			for i in range(8):
				await wait_physics_frames(1)
				max_step=maxf(max_step,previous.distance_to(a.global_position))
				previous=a.global_position
	print("MAX_RELEASE_STEP ",max_step)
	assert_lt(max_step,8.0,"no separation pop beyond normal per-frame speed")
func test_release_restores_peer_collision_after_bounded_separation()->void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=2
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level.player.global_position=Vector2(0,150)
	var a:Node=level._active_bulls[0]
	var b:Node=level._active_bulls[1]
	for bull in [a,b]:
		bull.global_position=Vector2(0,-20)
		bull.try_capture(bull.global_position)
	a.controller.force_escape();b.controller.force_escape()
	assert_true(a._release_overlap_peers.has(b))
	assert_true(b._release_overlap_peers.has(a))
	assert_true(a.collision_mask & CollisionLayers.FENCE !=0,"fences remain solid throughout")
	await wait_physics_frames(120)
	assert_gt(a.global_position.distance_to(b.global_position),48.0)
	assert_true(a._release_overlap_peers.is_empty())
	assert_true(b._release_overlap_peers.is_empty())
	assert_false(a.get_collision_exceptions().has(b),"peer collision restored, not permanent ghosting")
func test_recaptured_bull_physically_exits_expanded_corral_side_passage()->void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=18
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level.set_process(false)
	for other in level._active_bulls:other.set_physics_process(false)
	var bull:Node=level._active_bulls[0]
	var left:Rect2=level._puzzle_corrals[2].layout["rect"]
	var right:Rect2=level._puzzle_corrals[3].layout["rect"]
	var x:float=(left.end.x+right.position.x)/2
	bull.global_position=Vector2(x,left.get_center().y)
	bull.begin_active();bull.try_capture(bull.global_position)
	level.player.global_position=bull.global_position+Vector2(0,55)
	bull.set_physics_process(true)
	Input.action_press("move_down")
	await wait_physics_frames(100)
	Input.action_release("move_down")
	assert_gt(bull.global_position.y,left.end.y+50,"recaptured body leaves passage normally")
	assert_true(bull.controller.is_held())
