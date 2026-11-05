extends GutTest
func after_each()->void:get_tree().paused=false
func test_nearby_latch_then_one_stable_courier_leg_and_manual_cleanup()->void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=16
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	var overlay:Node=level._link_overlay
	level.player.global_position=level._puzzle_corrals[0].layout["door"]
	overlay._process(0)
	assert_eq(overlay._shown_from,0,"only nearby latch route shown")
	level.player.global_position=Vector2(0,220)
	level._on_pen_door_opened(0)
	var first_from:int=overlay.active_from
	level._on_pen_door_opened(2)
	assert_eq(overlay.active_from,first_from,"opening unrelated normal pen does not overwrite courier leg")
	assert_eq(level._courier_jobs.size(),1)
	for i in range(level._pens_data.size()):level._release_one_pen(i)
	level._process(0)
	overlay._process(0)
	assert_eq(overlay._shown_from,-1,"no obsolete trail after all destinations open")
	assert_true(level._courier_jobs.is_empty())
