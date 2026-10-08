extends GutTest

func test_level_one_is_always_unlocked() -> void:
	assert_true(LevelProgression.is_unlocked(1, 0))

func test_next_level_unlocks_after_completing_previous() -> void:
	assert_false(LevelProgression.is_unlocked(3, 1))
	assert_true(LevelProgression.is_unlocked(3, 2))

func test_completed_levels_stay_unlocked() -> void:
	assert_true(LevelProgression.is_unlocked(2, 7))

func test_cannot_skip_to_the_last_level() -> void:
	assert_false(LevelProgression.is_unlocked(LevelCatalog.MAX_LEVEL, 0))

func test_unlock_all_overrides_progress() -> void:
	assert_true(LevelProgression.is_unlocked(LevelCatalog.MAX_LEVEL, 0, true))

func test_out_of_range_levels_are_never_unlocked() -> void:
	assert_false(LevelProgression.is_unlocked(0, 5, true))
	assert_false(LevelProgression.is_unlocked(LevelCatalog.MAX_LEVEL + 1, 99, true))

func test_sanitize_accepts_valid_int() -> void:
	assert_eq(LevelProgression.sanitize_highest_completed(7), 7)

func test_sanitize_clamps_out_of_range() -> void:
	assert_eq(LevelProgression.sanitize_highest_completed(-3), 0)
	assert_eq(LevelProgression.sanitize_highest_completed(999), LevelCatalog.MAX_LEVEL)

func test_sanitize_rejects_non_int_values() -> void:
	assert_eq(LevelProgression.sanitize_highest_completed("12"), 0)
	assert_eq(LevelProgression.sanitize_highest_completed(null), 0)
	assert_eq(LevelProgression.sanitize_highest_completed(4.5), 0)
