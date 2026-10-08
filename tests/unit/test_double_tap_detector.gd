extends GutTest

var sut: DoubleTapDetector

func before_each() -> void:
	sut = DoubleTapDetector.new(0.4)

func test_a_single_tap_is_not_a_double_tap() -> void:
	assert_false(sut.register_tap(1.0))

func test_two_taps_inside_the_window_are_a_double_tap() -> void:
	sut.register_tap(1.0)
	assert_true(sut.register_tap(1.3))

func test_two_taps_outside_the_window_are_not() -> void:
	sut.register_tap(1.0)
	assert_false(sut.register_tap(1.5))

func test_the_window_boundary_counts() -> void:
	sut.register_tap(1.0)
	assert_true(sut.register_tap(1.4))

func test_a_third_quick_tap_starts_a_new_pair() -> void:
	sut.register_tap(1.0)
	sut.register_tap(1.2)
	assert_false(sut.register_tap(1.3))
	assert_true(sut.register_tap(1.5))

func test_reset_breaks_the_pair() -> void:
	sut.register_tap(1.0)
	sut.reset()
	assert_false(sut.register_tap(1.1))
