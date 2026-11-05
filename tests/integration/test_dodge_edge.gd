extends GutTest
func after_each()->void:Engine.time_scale=1.0
func test_edge_can_draw_full_left_or_right_without_mirroring_and_return_has_no_jump()->void:
	var scene:Node=load("res://src/Presentation/level_0.tscn").instantiate()
	var player:Node=scene.get_node("Player").duplicate();scene.free()
	add_child_autofree(player)
	await wait_physics_frames(1)
	for sign_x in [-1,1]:
		player._drawing_dodge=true
		player._draw_points=PackedVector2Array([Vector2.ZERO])
		player._draw_virtual=Vector2.ZERO
		player._draw_heading=Vector2(sign_x,0)
		player._last_pointer=Vector2(5 if sign_x<0 else get_viewport().get_visible_rect().size.x-5,360)
		for i in range(90):player._extend_drawing_at_edge(1.0/60)
		assert_gt(player._draw_virtual.x*sign_x,400.0,"full upgraded gesture possible from either screen edge")
		var before:Vector2=player._draw_virtual
		player._draw_heading=Vector2(-sign_x,0)
		player._extend_drawing_at_edge(.05)
		assert_eq(player._draw_virtual,before,"moving inward stops extension without resetting origin")
		player.cancel_all_actions()
