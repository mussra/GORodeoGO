extends GutTest

func test_default_state_is_safe() -> void:
	var sut := BullStateMachine.new()
	assert_eq(sut.current, BullState.State.SAFE)

func test_valid_transitions_succeed() -> void:
	var valid_pairs: Array = [
		[BullState.State.SAFE, BullState.State.CALM],
		[BullState.State.CALM, BullState.State.ALERT],
		[BullState.State.ALERT, BullState.State.ESCAPED],
		[BullState.State.ALERT, BullState.State.CALM],
		[BullState.State.ESCAPED, BullState.State.PURSUED],
		[BullState.State.ESCAPED, BullState.State.CAPTURED],
		[BullState.State.PURSUED, BullState.State.CAPTURED],
		[BullState.State.PURSUED, BullState.State.ESCAPED],
		[BullState.State.CAPTURED, BullState.State.CALMING],
		[BullState.State.CAPTURED, BullState.State.ESCAPED],
		[BullState.State.CALMING, BullState.State.CONTROLLED],
		[BullState.State.CALMING, BullState.State.ESCAPED],
		[BullState.State.CONTROLLED, BullState.State.SAFE],
		[BullState.State.CONTROLLED, BullState.State.ESCAPED],
	]
	for pair: Array in valid_pairs:
		var sut := BullStateMachine.new(pair[0])
		var result: bool = sut.try_transition(pair[1])
		assert_true(result, "expected %s -> %s to succeed" % [pair[0], pair[1]])
		assert_eq(sut.current, pair[1])

func test_invalid_transitions_fail_and_keep_state() -> void:
	var invalid_pairs: Array = [
		[BullState.State.SAFE, BullState.State.ESCAPED],
		[BullState.State.CALM, BullState.State.CAPTURED],
		[BullState.State.ESCAPED, BullState.State.CONTROLLED],
		[BullState.State.CAPTURED, BullState.State.SAFE],
		[BullState.State.CONTROLLED, BullState.State.ALERT],
		[BullState.State.CALMING, BullState.State.PURSUED],
	]
	for pair: Array in invalid_pairs:
		var sut := BullStateMachine.new(pair[0])
		var result: bool = sut.try_transition(pair[1])
		assert_false(result, "expected %s -> %s to fail" % [pair[0], pair[1]])
		assert_eq(sut.current, pair[0])

func test_can_transition_does_not_mutate_state() -> void:
	var sut := BullStateMachine.new(BullState.State.CALM)
	var can_go: bool = sut.can_transition(BullState.State.ESCAPED)
	assert_false(can_go)
	assert_eq(sut.current, BullState.State.CALM)

func test_full_happy_path_loop_reaches_safe_again() -> void:
	var sut := BullStateMachine.new(BullState.State.SAFE)
	assert_true(sut.try_transition(BullState.State.CALM))
	assert_true(sut.try_transition(BullState.State.ALERT))
	assert_true(sut.try_transition(BullState.State.ESCAPED))
	assert_true(sut.try_transition(BullState.State.PURSUED))
	assert_true(sut.try_transition(BullState.State.CAPTURED))
	assert_true(sut.try_transition(BullState.State.CALMING))
	assert_true(sut.try_transition(BullState.State.CONTROLLED))
	assert_true(sut.try_transition(BullState.State.SAFE))
	assert_eq(sut.current, BullState.State.SAFE)
