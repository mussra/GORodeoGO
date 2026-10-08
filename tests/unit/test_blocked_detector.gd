extends GutTest

var sut: BlockedDetector

func before_each() -> void:
	sut = BlockedDetector.new(1.0, 0.25)

func test_free_movement_never_reports_blocked() -> void:
	for i in range(200):
		assert_false(sut.update(0.016, 4.0, 4.0))

func test_reports_once_after_the_threshold_of_continuous_blocking() -> void:
	var reports: int = 0
	for i in range(100):  # 1.6 s blocked at 60 fps
		if sut.update(0.016, 4.0, 0.0):
			reports += 1
	assert_eq(reports, 1)

func test_not_reported_before_the_threshold() -> void:
	for i in range(50):  # 0.8 s
		assert_false(sut.update(0.016, 4.0, 0.0))

func test_a_single_free_frame_resets_the_count() -> void:
	for i in range(50):
		sut.update(0.016, 4.0, 0.0)
	sut.update(0.016, 4.0, 4.0)
	for i in range(50):
		assert_false(sut.update(0.016, 4.0, 0.0))

func test_sliding_along_a_wall_at_more_than_the_ratio_is_not_blocked() -> void:
	for i in range(200):
		assert_false(sut.update(0.016, 4.0, 1.5))

func test_moving_just_under_the_ratio_counts_as_blocked() -> void:
	var reported: bool = false
	for i in range(100):
		reported = sut.update(0.016, 4.0, 0.9) or reported
	assert_true(reported)

func test_zero_intended_distance_is_not_blocked() -> void:
	for i in range(200):
		assert_false(sut.update(0.016, 0.0, 0.0))

func test_reset_clears_progress() -> void:
	for i in range(50):
		sut.update(0.016, 4.0, 0.0)
	sut.reset()
	for i in range(50):
		assert_false(sut.update(0.016, 4.0, 0.0))
