extends GutTest

func test_release_at_the_centre_cancels() -> void:
	assert_true(LassoAim.is_cancel(Vector2.ZERO))

func test_release_inside_the_cancel_zone_cancels() -> void:
	assert_true(LassoAim.is_cancel(Vector2(0.1, 0.1)))
	assert_true(LassoAim.is_cancel(Vector2(0.0, -0.19)))

func test_release_at_or_beyond_the_threshold_throws() -> void:
	assert_false(LassoAim.is_cancel(Vector2(LassoAim.CANCEL_THRESHOLD, 0.0)))
	assert_false(LassoAim.is_cancel(Vector2(0.0, 1.0)))

func test_cancel_threshold_matches_the_aim_action_deadzone() -> void:
	for action in ["aim_left", "aim_right", "aim_up", "aim_down"]:
		assert_almost_eq(InputMap.action_get_deadzone(action), LassoAim.CANCEL_THRESHOLD, 0.001, action)

func test_distance_is_linear_in_stick_length() -> void:
	assert_almost_eq(LassoAim.throw_distance(Vector2(0.5, 0.0), 220.0), 110.0, 0.001)
	assert_almost_eq(LassoAim.throw_distance(Vector2(0.0, -1.0), 220.0), 220.0, 0.001)

func test_distance_is_clamped_to_the_maximum() -> void:
	assert_almost_eq(LassoAim.throw_distance(Vector2(3.0, 4.0), 220.0), 220.0, 0.001)

func test_quick_release_at_the_centre_is_a_tap() -> void:
	assert_true(LassoAim.is_tap(Vector2.ZERO, 0.1))
	assert_true(LassoAim.is_tap(Vector2(0.05, 0.0), LassoAim.TAP_MAX_SECONDS))

func test_slow_release_at_the_centre_is_not_a_tap() -> void:
	assert_false(LassoAim.is_tap(Vector2.ZERO, LassoAim.TAP_MAX_SECONDS + 0.05))

func test_a_drag_is_never_a_tap() -> void:
	assert_false(LassoAim.is_tap(Vector2(0.6, 0.0), 0.1))
