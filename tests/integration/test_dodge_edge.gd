extends GutTest
func after_each()->void:Engine.time_scale=1.0
func test_all_edges_corners_dwell_inward_return_and_exact_direction()->void:
	var scene:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	var player:Node=scene.get_node("Player").duplicate();scene.free()
	add_child_autofree(player)
	await wait_physics_frames(1)
	var size:Vector2=get_viewport().get_visible_rect().size
	var cases:Array=[[Vector2(5,360),Vector2.LEFT],[Vector2(size.x-5,360),Vector2.RIGHT],[Vector2(300,5),Vector2.UP],[Vector2(300,size.y-5),Vector2.DOWN],[Vector2(5,5),Vector2(-1,-1).normalized()],[size-Vector2(5,5),Vector2.ONE.normalized()],[Vector2(5,250),Vector2(-1,.3).normalized()]]
	for item in cases:
		player._drawing_dodge=true
		player._draw_points=PackedVector2Array([Vector2.ZERO])
		player._draw_virtual=Vector2.ZERO
		player._draw_edge_elapsed=0.0
		player._draw_heading=item[1]
		player._last_pointer=item[0]
		player._extend_drawing_at_edge(.05)
		assert_eq(player._draw_virtual,Vector2.ZERO,"brief edge contact never extends")
		for i in range(100):player._extend_drawing_at_edge(1.0/60)
		assert_gt(player._draw_virtual.length(),420.0,"full upgraded path possible at any edge")
		assert_almost_eq(player._draw_virtual.normalized().dot(item[1]),1.0,.001,"preserves latest diagonal, never snaps to cardinal")
		var before:Vector2=player._draw_virtual
		player._draw_heading=-item[1]
		player._extend_drawing_at_edge(.05)
		assert_eq(player._draw_virtual,before,"inward stops extension without origin jump")
		player.cancel_all_actions()
	player._draw_virtual=Vector2.ZERO
	player._draw_heading=Vector2.LEFT
	player._last_pointer=size/2
	for i in range(60):player._extend_drawing_at_edge(.02)
	assert_eq(player._draw_virtual,Vector2.ZERO,"quiet in centre is not auto-extension")
func test_native_touch_edge_hold_release_executes_same_preview_and_other_finger_cannot_redirect()->void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=18
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var player:Node=level.player
	player.dodge_available=true
	var touch:=InputEventScreenTouch.new()
	touch.index=0;touch.position=Vector2(130,420);touch.pressed=true
	Input.parse_input_event(touch.duplicate())
	await get_tree().process_frame;await get_tree().process_frame
	touch.pressed=false;Input.parse_input_event(touch.duplicate())
	await get_tree().process_frame;await get_tree().process_frame
	touch.pressed=true;Input.parse_input_event(touch.duplicate())
	await get_tree().process_frame;await get_tree().process_frame
	assert_true(player._drawing_dodge)
	var drag:=InputEventScreenDrag.new()
	drag.index=0;drag.position=Vector2(5,420);drag.relative=Vector2(-125,0)
	Input.parse_input_event(drag)
	await get_tree().process_frame;await get_tree().process_frame
	await wait_seconds(.3)
	assert_true(player._draw_edge_active)
	var last:Vector2=player._last_pointer
	drag=InputEventScreenDrag.new();drag.index=1;drag.position=Vector2(900,600)
	player._input(drag)
	assert_eq(player._last_pointer,last,"other finger cannot move edge tracking")
	var preview:PackedVector2Array=player.dodge_preview_points(player._draw_points)
	var origin:Vector2=player.global_position
	# Direct release here permits exact before-first-physics comparison.
	player._on_move_released(Vector2.ZERO)
	assert_false(player._drawing_dodge)
	assert_eq(Engine.time_scale,1.0)
	assert_eq(player._dodge_path[-1],origin+preview[-1])
	assert_lte(preview[-1].length(),player.dodge_path_limit+.1)
	touch.pressed=false;Input.parse_input_event(touch.duplicate())
