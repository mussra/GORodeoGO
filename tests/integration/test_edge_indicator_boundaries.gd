extends GutTest
var screen := Rect2(0,80,1280,570)
func sample(edge: EdgeIndicators, id: int, p: Vector2, frames: int = 1, delta: float = 1.0/60.0) -> bool:
	var shown: bool = false
	for i in range(frames): shown = edge._marker_visible(id,p,screen,delta)
	return shown
func test_old_boundary_jitter_does_not_toggle_and_true_crossing_is_stable()->void:
	var e:=EdgeIndicators.new();add_child_autofree(e)
	for p in [Vector2(0,300),Vector2(1280,300),Vector2(600,80),Vector2(600,650),Vector2(0,80),Vector2(1280,650)]:
		e._visibility.clear()
		for i in range(120):
			assert_false(sample(e,1,p+Vector2.ONE*(.5 if i%2==0 else -.5)))
		var outward:Vector2=(p-screen.get_center()).normalized()*60
		assert_true(sample(e,1,p+outward,30))
		for i in range(120):assert_true(sample(e,1,p+Vector2.ONE*(.5 if i%2==0 else -.5)))
		assert_false(sample(e,1,screen.get_center(),30))
func test_exact_thresholds_epsilon_and_time_dwell_at_different_frame_rates()->void:
	for fps in [30,60,120]:
		var e:=EdgeIndicators.new();add_child_autofree(e)
		assert_false(sample(e,1,Vector2(-16,300),fps,1.0/fps))
		assert_true(sample(e,1,Vector2(-16.01,300),fps,1.0/fps))
		assert_true(sample(e,1,Vector2(23.99,300),fps,1.0/fps))
		assert_false(sample(e,1,Vector2(24,300),fps,1.0/fps))
func test_targets_keep_independent_state_and_short_excursions_reset()->void:
	var e:=EdgeIndicators.new();add_child_autofree(e)
	assert_false(sample(e,1,Vector2(-30,300),3))
	assert_false(sample(e,1,Vector2(0,300),1))
	assert_false(sample(e,1,Vector2(-30,300),3))
	assert_true(sample(e,2,Vector2(1400,300),20))
	assert_false(sample(e,1,Vector2(600,300),20))
func test_edge_projection_remains_finite_inside_safe_box_at_corner_and_zero()->void:
	var safe:=Rect2(70,110,1140,485)
	for p in [safe.get_center(),Vector2(-1,-1),Vector2(1280,720),Vector2(-1e6,1e6)]:
		var q:=ArenaLayout.edge_point(p,safe)
		assert_true(q.is_finite())
		assert_true(q.x>=safe.position.x-.01 and q.x<=safe.end.x+.01 and q.y>=safe.position.y-.01 and q.y<=safe.end.y+.01)
