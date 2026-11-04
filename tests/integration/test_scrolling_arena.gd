extends GutTest
func after_each() -> void:
	get_tree().paused = false
func test_high_level_arena_grows_without_inflating_corral_bodies() -> void:
	var before: bool = SaveData.dual_lasso_intro_shown
	SaveData.dual_lasso_intro_shown = true
	GameState.selected_level = 20
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	assert_gt(level.world_bounds.size.x,2000.0)
	assert_eq(level.player.world_bounds,level.world_bounds)
	assert_eq(level._active_bulls[0].world_bounds,level.world_bounds)
	for corral in level._puzzle_corrals:
		assert_eq(corral.layout["rect"].size.y,136.0,"physical corral not inflated")
		assert_true(level.world_bounds.encloses(corral.layout["rect"]))
	var before_camera: Vector2 = level.get_node("Camera2D").position
	level.player.global_position = Vector2(500,200)
	await wait_physics_frames(3)
	level._update_follow_camera()
	level._edge_indicators._process(0.0)
	assert_gt(level.get_node("Camera2D").position.x,before_camera.x+200)
	assert_gt(level._edge_indicators.markers.size(),0,"offscreen targets get markers")
	SaveData.dual_lasso_intro_shown = before
func test_early_arenas_and_edge_projection_remain_stable() -> void:
	assert_eq(ArenaLayout.bounds_for_level(1),Rect2(-480,-270,960,540))
	assert_eq(ArenaLayout.bounds_for_level(10),Rect2(-480,-270,960,540))
	var rect := Rect2(70,110,1140,485)
	assert_eq(ArenaLayout.edge_point(Vector2(2000,352.5),rect),Vector2(1210,352.5))
	assert_true(rect.grow(.1).has_point(ArenaLayout.edge_point(Vector2(-300,-100),rect)))
func test_every_expanded_corral_fits_and_does_not_overlap_goal() -> void:
	for n in range(11,21):
		var data: LevelData = LevelCatalog.get_level(n)
		var scale: float = ArenaLayout.scale_for_level(n)
		var bounds: Rect2 = ArenaLayout.bounds_for_level(n)
		var goal := Rect2(Vector2(-300,0)*scale-Vector2(40,40),Vector2(80,80))
		var rects: Array = []
		for i in range(data.pens.size()):
			var layout: Dictionary = ArenaLayout.spread_corral(PuzzleCorralLayout.build(data.pens.size(),i,data.pens[i]["bull_indices"].size()),scale)
			assert_true(bounds.encloses(layout["rect"]))
			assert_false(goal.grow(25).intersects(layout["rect"]))
			for previous: Rect2 in rects: assert_false(previous.grow(25).intersects(layout["rect"]))
			rects.append(layout["rect"])
func test_indicator_hides_for_visible_targets_pause_and_game_end() -> void:
	var indicators := EdgeIndicators.new()
	add_child_autofree(indicators)
	var safe := Rect2(70,110,1140,485)
	indicators._add_marker(Vector2(300,300),safe,"TORO",Color.WHITE)
	assert_eq(indicators.markers.size(),0,"no marker for visible bull")
	indicators._add_marker(Vector2(-300,300),safe,"TORO",Color.WHITE,true)
	indicators._add_marker(Vector2(-310,302),safe,"TORO",Color.WHITE,true)
	assert_eq(indicators.markers.size(),1)
	assert_eq(indicators.markers[0]["count"],2,"nearby directions group")
	get_tree().paused = true
	indicators._process(0.0)
	assert_eq(indicators.markers.size(),0)
func test_expanded_goal_accepts_real_tow_and_markers_freeze_cleanly_in_pause() -> void:
	var before: bool = SaveData.dual_lasso_intro_shown
	SaveData.dual_lasso_intro_shown = true
	GameState.selected_level = 20
	var level: Node = load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level.set_process(false)
	var bull: Node = level._active_bulls[0]
	for other in level._active_bulls:
		if other != bull: other.set_physics_process(false)
	var goal: Vector2 = level.pen.global_position
	level.player.global_position = goal + Vector2(280,0)
	bull.global_position = goal + Vector2(320,0)
	bull.begin_active()
	assert_true(bull.try_capture(bull.global_position))
	bull.controller.update_hold(100.0,100.0,0.0)
	Input.action_press("move_left")
	for i in range(150):
		await wait_physics_frames(1)
		if level._bulls_returned > 0: break
	Input.action_release("move_left")
	assert_eq(level._bulls_returned,1,"tow physics reaches relocated META")
	assert_true(bull._delivered)
	level.pause_game()
	level._edge_indicators._process(0.0)
	assert_eq(level._edge_indicators.markers.size(),0,"markers not drawn over pause")
	level.resume_game()
	SaveData.dual_lasso_intro_shown = before
func test_expanded_layout_has_clear_routes_to_every_latch_and_goal() -> void:
	for n in range(11,21):
		var data: LevelData = LevelCatalog.get_level(n)
		var scale: float = ArenaLayout.scale_for_level(n)
		var bounds: Rect2 = ArenaLayout.bounds_for_level(n).grow(-28)
		var grid := AStarGrid2D.new()
		grid.region = Rect2i(Vector2i(bounds.position/20),Vector2i(bounds.size/20))
		grid.cell_size = Vector2(20,20)
		grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
		grid.update()
		var layouts: Array = []
		for i in range(data.pens.size()):
			layouts.append(ArenaLayout.spread_corral(PuzzleCorralLayout.build(data.pens.size(),i,data.pens[i]["bull_indices"].size()),scale))
		for x in range(grid.region.position.x,grid.region.end.x):
			for y in range(grid.region.position.y,grid.region.end.y):
				for layout in layouts:
					if layout["rect"].grow(25).has_point(Vector2(x,y)*20): grid.set_point_solid(Vector2i(x,y))
		var targets: Array = [Vector2(-300,0)*scale]
		for layout in layouts: targets.append(layout["door"]+Vector2(0,layout["inward"]*25))
		for target: Vector2 in targets:
			assert_gt(grid.get_id_path(Vector2i.ZERO,Vector2i((target/20).round())).size(),0,"level %d has static clear route to latch/goal" % n)
