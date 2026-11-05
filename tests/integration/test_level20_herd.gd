extends GutTest
var _progress:int
func before_each()->void:
	_progress=SaveData.highest_level_completed
	SaveData.highest_level_completed=20
	SaveData.dual_lasso_intro_shown=true
	seed(20261105)
func after_each()->void:
	SaveData.highest_level_completed=_progress
	get_tree().paused=false
	for action in ["move_left","move_right","move_up","move_down"]:Input.action_release(action)
func _level()->Node:
	GameState.selected_level=20
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	return level
func test_medium_and_large_keep_pressure_but_small_is_deliberate_lure()->void:
	var data:LevelData=LevelCatalog.get_level(20)
	assert_eq(data.bull_count,10)
	assert_eq(data.pens.size(),3)
	for i in [1,2]:
		var messengers:int=0
		assert_gte(data.pens[i]["bull_indices"].size()-messengers-2,1,"a pair cannot empty release %d"%i)
func test_courier_never_consumes_chaser_even_if_nearest()->void:
	GameState.selected_level=19
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level._on_pen_door_opened(0)
	var courier:Node=level._active_bulls[0]
	assert_true(courier._courier_active)
	assert_false(level._wild_distances().has(0))
	var peer:Node=level._active_bulls[1]
	peer._leaving_corral=false
	assert_true(level._wild_distances().has(1))
	# A real lasso capture, not a fabricated held flag, enables the chaser rule.
	level._on_lasso_thrown(level.player.global_position,level._active_bulls[5].global_position)
	assert_eq(level._held_bulls().size(),1)
	level._update_chaser(1.1)
	assert_eq(level._chaser_index,1)
	assert_false(courier._is_chaser)
	assert_true(peer._is_chaser)
func test_live_herd_pair_capture_still_creates_real_pursuit()->void:
	var level:Node=_level()
	await wait_physics_frames(2)
	# Initial setup puts rider on the approach. Then only movement input, no bull teleport,
	# no disabled physics, no forced nerves, no collision exception or immunity.
	level.player.global_position=level._puzzle_corrals[1].layout["door"]+Vector2(-100,80)
	level._on_pen_door_opened(1)
	await wait_physics_frames(530)
	for frame in range(1000):
		var candidates:Array=[]
		for index in level._pens_data[1]["bull_indices"]:
			var bull:Node=level._active_bulls[index]
			if bull.controller.is_wild():candidates.append(bull)
		candidates.sort_custom(func(a,b):return level.player.global_position.distance_to(a.global_position)<level.player.global_position.distance_to(b.global_position))
		if level._held_bulls().size()==2:break
		if candidates.is_empty():break
		var target:Node=candidates[0]
		var offset:Vector2=target.global_position-level.player.global_position
		if offset.length()<level.player.max_throw_distance-20:
			level._on_lasso_thrown(level.player.global_position,target.global_position)
		else:
			_drive(offset)
		await wait_physics_frames(1)
	_drive(Vector2.ZERO)
	assert_eq(level._held_bulls().size(),2,"two within-range lasso impacts use actual capture handler")
	await wait_physics_frames(80)
	assert_ne(level._chaser_index,-1,"third bull actually takes pursuit with herd running")
	if level._chaser_index==-1:return
	var threat:Node=level._active_bulls[level._chaser_index]
	var distance:float=threat.global_position.distance_to(level.player.global_position)
	var moved:Vector2=threat.global_position
	await wait_physics_frames(100)
	assert_gt(threat.global_position.distance_to(moved),30.0,"live chaser physically moves")
	assert_lt(threat.global_position.distance_to(level.player.global_position),distance,"pursuit closes real separation")
	print("HERD20 pursuit: ",distance," -> ",threat.global_position.distance_to(level.player.global_position)," held=",level._held_bulls().size())
func test_master_errand_and_companion_pursuit_run_together()->void:
	GameState.selected_level=19
	var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level.player.global_position=Vector2(-100,0)
	level._on_pen_door_opened(0)
	await wait_physics_frames(530)
	for index in [1,5]:
		var bull:Node=level._active_bulls[index]
		level._on_lasso_thrown(level.player.global_position,bull.global_position)
	assert_eq(level._held_bulls().size(),2)
	var simultaneous:bool=false
	var courier:Node=level._active_bulls[0]
	for frame in range(3500):
		await wait_physics_frames(1)
		if courier._courier_active and level._chaser_index>=0:
			simultaneous=true
			assert_ne(level._chaser_index,0,"companion, not courier, pursues")
			break
	assert_true(simultaneous,"courier travels while companion pursues, full herd physics enabled")
	for frame in range(3500):
		await wait_physics_frames(1)
		if not level._pen_released.has(false):break
	assert_false(level._pen_released.has(false),"courier physically opens both destinations amid live herd")

func _drive(offset:Vector2)->void:
	for action in ["move_left","move_right","move_up","move_down"]:Input.action_release(action)
	if offset.x>10:Input.action_press("move_right")
	if offset.x< -10:Input.action_press("move_left")
	if offset.y>10:Input.action_press("move_down")
	if offset.y< -10:Input.action_press("move_up")
