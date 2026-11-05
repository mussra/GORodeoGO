extends GutTest
func after_each()->void:
	get_tree().paused=false
	for action in ["move_left","move_right","move_up","move_down"]:Input.action_release(action)
func test_density_scope_and_all_gaps_allow_two_bull_widths()->void:
	for n in range(1,15):assert_eq(ArenaLayout.scale_for_level(n),1.0)
	for n in range(15,21):
		var data:LevelData=LevelCatalog.get_level(n)
		var scale:float=ArenaLayout.scale_for_level(n)
		var rects:Array[Rect2]=[]
		for i in range(data.pens.size()):
			var layout:Dictionary=ArenaLayout.spread_corral(PuzzleCorralLayout.build(data.pens.size(),i,data.pens[i]["bull_indices"].size()),scale)
			var rect:Rect2=layout["rect"]
			assert_eq(rect.size.y,136.0)
			assert_true(ArenaLayout.bounds_for_level(n).encloses(rect.grow(35)),"usable outside perimeter path")
			for other in rects:assert_false(other.grow(64).intersects(rect.grow(64)),"at least128px passage between enclosures")
			rects.append(rect)
func test_expanded_grid_routes_and_real_tow_work_beyond_old_arena()->void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=18
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level.set_process(false)
	for bull in level._active_bulls:bull.set_physics_process(false)
	var bull:Node=level._active_bulls[0]
	bull.begin_active()
	bull.global_position=Vector2(620,60)
	level.player.global_position=Vector2(670,60)
	assert_true(bull.try_capture(bull.global_position))
	assert_gt(bull._courier_detour(Vector2(800,150)).size(),0,"grid reaches past old x480boundary")
	bull.set_physics_process(true)
	Input.action_press("move_down")
	await wait_physics_frames(60)
	Input.action_release("move_down")
	assert_gt(bull.global_position.y,130.0,"actual held bull travels outside old grid")
	level._update_follow_camera()
	level._edge_indicators._process(0)
	assert_gt(level.get_node("Camera2D").position.x,200.0)
	assert_gt(level._edge_indicators.markers.size(),0)
