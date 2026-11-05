extends GutTest
func after_each()->void:get_tree().paused=false
func test_map_coordinates_modal_pause_and_real_touch_do_not_trigger_throw()->void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=18
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var map:ArenaMinimap
	for child in level.get_children():
		if child is CanvasLayer:
			for item in child.get_children():
				if item is ArenaMinimap:map=item
	assert_not_null(map)
	assert_eq(map._point(level.world_bounds.position,Rect2(10,10,100,60)),Vector2(10,10))
	assert_eq(map._point(level.world_bounds.end,Rect2(10,10,100,60)),Vector2(110,70))
	map.set_expanded(true)
	assert_true(get_tree().paused)
	assert_false(level.player._lasso_in_flight)
	assert_gt(map.size.x,600.0)
	map.set_expanded(false)
	assert_false(get_tree().paused)
	assert_eq(map.size,Vector2(180,112))
func test_actual_screen_touch_opens_and_closes_map_without_aim_charge()->void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=18
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var map:ArenaMinimap
	for child in level.get_children():
		if child is CanvasLayer:
			for item in child.get_children():
				if item is ArenaMinimap:map=item
	var touch:=InputEventScreenTouch.new()
	touch.index=1;touch.pressed=true;touch.position=map.position+map.size/2
	Input.parse_input_event(touch)
	await get_tree().process_frame
	await get_tree().process_frame
	assert_true(map.expanded,"real screen input reaches map control")
	assert_false(level.player._is_charging)
	touch=InputEventScreenTouch.new()
	touch.index=1;touch.pressed=false;touch.position=map.position+map.size/2
	Input.parse_input_event(touch)
	await get_tree().process_frame
	touch=InputEventScreenTouch.new()
	touch.index=1;touch.pressed=true;touch.position=map.position+map.size/2
	Input.parse_input_event(touch)
	await get_tree().process_frame
	await get_tree().process_frame
	assert_false(map.expanded)
	assert_false(get_tree().paused)
	assert_false(level.player._is_charging)
