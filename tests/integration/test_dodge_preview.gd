extends GutTest
func test_z_and_curves_preview_are_identical_to_executed_waypoints_at_both_limits() -> void:
	var source:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	var player:Node=source.get_node("Player").duplicate()
	source.free()
	add_child_autofree(player)
	await wait_physics_frames(1)
	var curves:Array=[PackedVector2Array([Vector2.ZERO,Vector2(500,0),Vector2(0,300),Vector2(500,300)])]
	var circle:=PackedVector2Array([Vector2.ZERO])
	for i in range(1,25): circle.append(Vector2(sin(i*TAU/24),1-cos(i*TAU/24))*150)
	curves.append(circle)
	for limit in [260.0,420.0]:
		player.dodge_path_limit=limit
		for path in curves:
			player._dodge_cooldown=0.0
			var preview:PackedVector2Array=player.dodge_preview_points(path)
			assert_true(player.request_dodge_path(path))
			assert_eq(player._dodge_path.size(),preview.size()-1)
			for i in range(player._dodge_path.size()): assert_eq(player._dodge_path[i],player.global_position+preview[i+1])
			var length:float=0
			for i in range(1,preview.size()): length+=preview[i].distance_to(preview[i-1])
			assert_almost_eq(length,limit,.01)
func test_bullet_cues_are_short_quiet_and_muted_with_switch() -> void:
	var audio:=RanchAudio.new()
	add_child_autofree(audio)
	await wait_physics_frames(1)
	for cue in ["bullet_in","bullet_out"]:
		assert_lt(audio._sounds[cue].get_length(),.15)
		audio.play(cue)
		assert_eq(audio._voices[(audio._next_voice+3)%4].volume_db,-25.0)
	audio.enabled=false
	var before:int=audio._next_voice
	audio.play("bullet_in")
	assert_eq(audio._next_voice,before)
