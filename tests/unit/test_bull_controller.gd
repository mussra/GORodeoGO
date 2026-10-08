extends GutTest

func test_capture_then_hold_reaches_controlled() -> void:
	var tuning := BullTuning.new()
	tuning.calm_rate_per_second = 1000.0  # fast for test
	var controller := BullController.new(BullState.State.ESCAPED, tuning)

	var attempt := CaptureAttempt.new(Vector2(5, 0), Vector2(5, 0), 0.5)
	assert_true(controller.attempt_capture(attempt))
	assert_eq(controller.current_state(), BullState.State.CAPTURED)

	controller.update_hold(1.0, 5.0)
	assert_eq(controller.current_state(), BullState.State.CONTROLLED)

func test_capture_miss_stays_escaped() -> void:
	var controller := BullController.new(BullState.State.ESCAPED)
	var attempt := CaptureAttempt.new(Vector2(20, 0), Vector2(5, 0), 0.5)
	assert_false(controller.attempt_capture(attempt))
	assert_eq(controller.current_state(), BullState.State.ESCAPED)

func test_rope_break_reverts_to_escaped() -> void:
	var tuning := BullTuning.new()
	tuning.max_rope_distance = 10.0
	var controller := BullController.new(BullState.State.CAPTURED, tuning)

	controller.update_hold(0.1, 50.0)

	assert_eq(controller.current_state(), BullState.State.ESCAPED)

func test_disturbance_prevents_calming() -> void:
	var tuning := BullTuning.new()
	tuning.calm_rate_per_second = 1000.0
	var controller := BullController.new(BullState.State.CAPTURED, tuning)

	controller.update_hold(1.0, 5.0, 1.0)  # disturbance active

	assert_ne(controller.current_state(), BullState.State.CONTROLLED)
	assert_eq(controller.current_state(), BullState.State.CALMING)

func test_return_to_pen_from_controlled() -> void:
	var controller := BullController.new(BullState.State.CONTROLLED)
	assert_true(controller.return_to_pen())
	assert_eq(controller.current_state(), BullState.State.SAFE)

func test_return_to_pen_fails_if_not_controlled() -> void:
	var controller := BullController.new(BullState.State.ESCAPED)
	assert_false(controller.return_to_pen())
	assert_eq(controller.current_state(), BullState.State.ESCAPED)

func test_update_hold_ignored_outside_captured_or_calming() -> void:
	var controller := BullController.new(BullState.State.ESCAPED)
	controller.update_hold(1.0, 5.0)
	assert_eq(controller.current_state(), BullState.State.ESCAPED)

func test_tuning_defaults_when_none_provided() -> void:
	var controller := BullController.new(BullState.State.SAFE)
	assert_not_null(controller.tuning())
	assert_eq(controller.tuning().tow_speed, 240.0)

func test_startup_chain_from_safe_reaches_escaped() -> void:
	# Regression: bull.gd's intro sequence must go SAFE -> CALM -> ALERT -> ESCAPED;
	# jumping straight to ALERT/ESCAPED from SAFE silently fails (invalid transition).
	var controller := BullController.new(BullState.State.SAFE)
	assert_true(controller.go_calm())
	assert_true(controller.go_alert())
	assert_true(controller.go_escaped())
	assert_eq(controller.current_state(), BullState.State.ESCAPED)

func test_force_escape_from_each_held_state() -> void:
	for state: BullState.State in [BullState.State.CAPTURED, BullState.State.CALMING, BullState.State.CONTROLLED]:
		var controller := BullController.new(state)
		assert_true(controller.force_escape(), "expected force_escape to succeed from %s" % state)
		assert_eq(controller.current_state(), BullState.State.ESCAPED)

func test_force_escape_noop_when_not_held() -> void:
	var controller := BullController.new(BullState.State.SAFE)
	assert_false(controller.force_escape())
	assert_eq(controller.current_state(), BullState.State.SAFE)

func test_use_tranquilizer_from_captured_instantly_controls() -> void:
	var controller := BullController.new(BullState.State.CAPTURED)
	assert_true(controller.use_tranquilizer())
	assert_eq(controller.current_state(), BullState.State.CONTROLLED)
	assert_eq(controller.current_nerves(), 0.0)

func test_use_tranquilizer_from_calming_instantly_controls() -> void:
	var controller := BullController.new(BullState.State.CALMING)
	assert_true(controller.use_tranquilizer())
	assert_eq(controller.current_state(), BullState.State.CONTROLLED)

func test_use_tranquilizer_noop_when_not_held() -> void:
	var controller := BullController.new(BullState.State.ESCAPED)
	assert_false(controller.use_tranquilizer())
	assert_eq(controller.current_state(), BullState.State.ESCAPED)

func test_is_held_true_for_captured_calming_controlled() -> void:
	for state: BullState.State in [BullState.State.CAPTURED, BullState.State.CALMING, BullState.State.CONTROLLED]:
		var controller := BullController.new(state)
		assert_true(controller.is_held(), "expected is_held() true for %s" % state)

func test_is_held_false_for_other_states() -> void:
	for state: BullState.State in [BullState.State.SAFE, BullState.State.CALM, BullState.State.ALERT, BullState.State.ESCAPED, BullState.State.PURSUED]:
		var controller := BullController.new(state)
		assert_false(controller.is_held(), "expected is_held() false for %s" % state)

func test_is_wild_true_for_escaped_pursued_alert() -> void:
	for state: BullState.State in [BullState.State.ESCAPED, BullState.State.PURSUED, BullState.State.ALERT]:
		var controller := BullController.new(state)
		assert_true(controller.is_wild(), "expected is_wild() true for %s" % state)

func test_is_wild_false_for_other_states() -> void:
	for state: BullState.State in [BullState.State.SAFE, BullState.State.CALM, BullState.State.CAPTURED, BullState.State.CALMING, BullState.State.CONTROLLED]:
		var controller := BullController.new(state)
		assert_false(controller.is_wild(), "expected is_wild() false for %s" % state)

func test_rope_never_breaks_with_default_infinite_max_distance() -> void:
	# Regression: max_rope_distance used to equal max_throw_distance (220), so capturing
	# from near max range broke the rope on the very next frame, before the player could
	# close in. Default tuning now disables rope-break entirely (INF).
	var controller := BullController.new(BullState.State.CAPTURED)
	controller.update_hold(0.1, 1_000_000.0)
	assert_ne(controller.current_state(), BullState.State.ESCAPED)
