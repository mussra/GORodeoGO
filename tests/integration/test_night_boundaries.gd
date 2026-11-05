extends GutTest
func after_each() -> void:
	Engine.time_scale=1.0
	get_tree().paused=false
func _player() -> Node:
	var source: Node=load("res://src/Presentation/level_0.tscn").instantiate()
	var player: Node=source.get_node("Player").duplicate()
	source.free()
	add_child_autofree(player)
	await wait_physics_frames(1)
	return player
func test_long_path_caps_actual_distance_and_keeps_recharge_and_stun_rules() -> void:
	var player: Node=await _player()
	player.dodge_path_limit=420.0
	var start: Vector2=player.global_position
	assert_true(player.request_dodge_path(PackedVector2Array([Vector2.ZERO,Vector2(600,0),Vector2(600,400)])))
	var previous: Vector2=start
	var total: float=0.0
	for p: Vector2 in player._dodge_path:
		total+=previous.distance_to(p)
		previous=p
	assert_almost_eq(total,420.0,.01)
	assert_false(player.request_dodge_path(PackedVector2Array([Vector2.ZERO,Vector2(100,0)])),"long trace cannot bypass recharge")
	player.stun(1.0)
	assert_true(player._dodge_path.is_empty())
	assert_false(player.request_dodge_path(PackedVector2Array([Vector2.ZERO,Vector2(100,0)])),"long upgrade gives no stun immunity")
func test_stun_during_drawing_restores_normal_time() -> void:
	var player: Node=await _player()
	player._drawing_dodge=true
	Engine.time_scale=.24
	player.stun(1.0)
	assert_eq(Engine.time_scale,1.0)
	assert_false(player._drawing_dodge)
func test_detour_cost_is_reported_not_android_certification() -> void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=20
	var level: Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level._on_pen_door_opened(0)
	var bull: Node=level._active_bulls[0]
	await wait_physics_frames(500)
	var begin: int=Time.get_ticks_usec()
	var path: PackedVector2Array=bull._courier_detour(Vector2(0,-75))
	var elapsed: float=(Time.get_ticks_usec()-begin)/1000.0
	print("LINUX_DETOUR_MS=",elapsed," POINTS=",path.size())
	assert_gt(path.size(),0)
func test_bullet_time_does_not_pitch_music_and_pause_restore_is_independent() -> void:
	SaveData.dual_lasso_intro_shown=true
	GameState.selected_level=1
	var level: Node=load("res://src/Presentation/level_0.tscn").instantiate()
	add_child_autofree(level)
	await wait_physics_frames(2)
	level.player._drawing_dodge=true
	Engine.time_scale=.24
	assert_eq(RanchMusic.voice.pitch_scale,1.0)
	level.pause_game()
	assert_eq(Engine.time_scale,1.0)
	assert_true(RanchMusic.voice.stream_paused)
	level.resume_game()
	assert_false(RanchMusic.voice.stream_paused)
	assert_eq(RanchMusic.voice.pitch_scale,1.0)
