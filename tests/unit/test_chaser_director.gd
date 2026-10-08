extends GutTest

const DELAY: float = 1.0
var sut: ChaserDirector

func before_each() -> void:
	sut = ChaserDirector.new(DELAY)

func test_no_chaser_when_nothing_is_held() -> void:
	assert_eq(sut.update(5.0, false, {0: 10.0}), ChaserDirector.NO_CHASER)

func test_nearest_wild_bull_becomes_chaser_only_after_the_delay() -> void:
	var wild := {0: 300.0, 1: 100.0}
	assert_eq(sut.update(0.5, true, wild), ChaserDirector.NO_CHASER)
	assert_eq(sut.update(0.5, true, wild), 1)

func test_chaser_is_kept_even_if_another_bull_gets_closer() -> void:
	sut.update(DELAY, true, {0: 300.0, 1: 100.0})
	assert_eq(sut.update(0.1, true, {0: 10.0, 1: 100.0}), 1)

func test_handover_to_nearest_remaining_wild_bull_after_delay() -> void:
	sut.update(DELAY, true, {0: 300.0, 1: 100.0})
	assert_eq(sut.update(0.5, true, {0: 300.0}), ChaserDirector.NO_CHASER)
	assert_eq(sut.update(0.5, true, {0: 300.0}), 0)

func test_dropping_the_capture_clears_the_chaser_and_restarts_the_delay() -> void:
	sut.update(DELAY, true, {0: 50.0})
	assert_eq(sut.update(0.1, false, {0: 50.0}), ChaserDirector.NO_CHASER)
	assert_eq(sut.update(0.5, true, {0: 50.0}), ChaserDirector.NO_CHASER)

func test_no_wild_bulls_means_no_chaser() -> void:
	assert_eq(sut.update(5.0, true, {}), ChaserDirector.NO_CHASER)

func test_changing_nearest_before_engaging_restarts_the_delay() -> void:
	sut.update(0.8, true, {0: 100.0, 1: 200.0})
	assert_eq(sut.update(0.8, true, {0: 300.0, 1: 200.0}), ChaserDirector.NO_CHASER)
	assert_eq(sut.update(0.3, true, {0: 300.0, 1: 200.0}), 1)

func test_at_most_one_chaser_is_ever_reported() -> void:
	var id: int = sut.update(DELAY, true, {0: 10.0, 1: 10.0, 2: 10.0})
	assert_eq(id, 0, "ties resolve to the first bull, deterministically")

var _next_roll: float = 0.0

func _fixed_roll() -> float:
	return _next_roll

func _director_with_chaser(wild: Dictionary) -> ChaserDirector:
	var director := ChaserDirector.new(DELAY, _fixed_roll)
	director.update(DELAY, true, wild)
	return director

func test_hand_over_picks_a_random_other_wild_bull() -> void:
	var wild := {0: 10.0, 1: 50.0, 2: 90.0}
	var director := _director_with_chaser(wild)
	assert_eq(director.chaser_id(), 0)
	_next_roll = 0.0
	assert_eq(director.hand_over_randomly(wild), 1, "first candidate other than the old chaser")

func test_hand_over_never_returns_the_blocked_chaser_when_others_exist() -> void:
	var wild := {0: 10.0, 1: 50.0, 2: 90.0}
	for roll in [0.0, 0.3, 0.5, 0.7, 0.999]:
		var director := _director_with_chaser(wild)
		_next_roll = roll
		assert_ne(director.hand_over_randomly(wild), 0, "roll %s" % roll)

func test_hand_over_roll_selects_among_the_candidates() -> void:
	var wild := {0: 10.0, 1: 50.0, 2: 90.0}
	var director := _director_with_chaser(wild)
	_next_roll = 0.99
	assert_eq(director.hand_over_randomly(wild), 2)

func test_hand_over_is_immediate_no_engage_delay() -> void:
	var wild := {0: 10.0, 1: 50.0}
	var director := _director_with_chaser(wild)
	director.hand_over_randomly(wild)
	assert_eq(director.update(0.016, true, wild), 1)

func test_hand_over_keeps_the_chaser_when_it_is_the_only_wild_bull() -> void:
	var wild := {0: 10.0}
	var director := _director_with_chaser(wild)
	assert_eq(director.hand_over_randomly(wild), 0)

func test_hand_over_without_a_chaser_does_nothing() -> void:
	assert_eq(sut.hand_over_randomly({0: 10.0, 1: 20.0}), ChaserDirector.NO_CHASER)
