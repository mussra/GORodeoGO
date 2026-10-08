extends GutTest

var _next_roll: float = 0.0

func _fixed_roll() -> float:
	return _next_roll

func _make() -> RandomChaseRoller:
	return RandomChaseRoller.new(_fixed_roll)

func test_never_chases_without_a_held_capture() -> void:
	_next_roll = 0.0
	assert_false(_make().update(1.0, false, false, 1.0))

func test_designated_chaser_is_not_affected_by_the_roll() -> void:
	_next_roll = 0.0
	assert_false(_make().update(1.0, true, true, 1.0))

func test_first_roll_happens_immediately_when_capture_starts() -> void:
	_next_roll = 0.1
	assert_true(_make().update(0.016, false, true, 0.5))

func test_roll_at_or_above_probability_does_not_chase() -> void:
	_next_roll = 0.5
	assert_false(_make().update(0.016, false, true, 0.5))

func test_decision_is_kept_until_the_reroll_interval() -> void:
	var sut := _make()
	_next_roll = 0.1
	assert_true(sut.update(0.016, false, true, 0.5))
	_next_roll = 0.9
	assert_true(sut.update(RandomChaseRoller.REROLL_SECONDS - 0.5, false, true, 0.5))
	assert_false(sut.update(0.6, false, true, 0.5), "rerolled after 5s with a failing roll")

func test_dropping_the_capture_resets_the_cycle() -> void:
	var sut := _make()
	_next_roll = 0.1
	sut.update(0.016, false, true, 0.5)
	sut.update(0.016, false, false, 0.5)
	assert_false(sut.is_active())
	_next_roll = 0.9
	assert_false(sut.update(0.016, false, true, 0.5), "fresh roll on the next capture")

func test_zero_probability_never_chases() -> void:
	_next_roll = 0.0
	assert_false(_make().update(0.016, false, true, 0.0))

func test_default_random_source_works() -> void:
	var sut := RandomChaseRoller.new()
	assert_true(sut.update(0.016, false, true, 2.0), "probability above 1 always wins")
