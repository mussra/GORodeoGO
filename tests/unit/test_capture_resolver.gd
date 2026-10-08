extends GutTest

func test_landing_point_inside_hit_radius_hits() -> void:
	var attempt := CaptureAttempt.new(Vector2(5, 0), Vector2(5, 0), 0.5)
	assert_true(CaptureResolver.resolve_hit(attempt))

func test_landing_point_outside_hit_radius_misses() -> void:
	var attempt := CaptureAttempt.new(Vector2(5, 0), Vector2(10, 0), 0.5)
	assert_false(CaptureResolver.resolve_hit(attempt))

func test_landing_point_exactly_at_radius_boundary_hits() -> void:
	var attempt := CaptureAttempt.new(Vector2(0, 0), Vector2(0.5, 0), 0.5)
	assert_true(CaptureResolver.resolve_hit(attempt))

func test_undershoot_misses() -> void:
	# lasso landed short of the target
	var attempt := CaptureAttempt.new(Vector2(3, 0), Vector2(10, 0), 1.0)
	assert_false(CaptureResolver.resolve_hit(attempt))

func test_overshoot_misses() -> void:
	# lasso landed past the target
	var attempt := CaptureAttempt.new(Vector2(15, 0), Vector2(10, 0), 1.0)
	assert_false(CaptureResolver.resolve_hit(attempt))

func test_exact_landing_on_target_hits() -> void:
	var attempt := CaptureAttempt.new(Vector2(10, 0), Vector2(10, 0), 0.5)
	assert_true(CaptureResolver.resolve_hit(attempt))
