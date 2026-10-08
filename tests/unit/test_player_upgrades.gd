extends GutTest

func test_no_progress_gives_baseline() -> void:
	var u := PlayerUpgrades.for_progress(0)
	assert_false(u.tranquilizer_available)
	assert_eq(u.speed_multiplier, 1.0)
	assert_eq(u.stun_duration_multiplier, 1.0)
	assert_eq(u.lasso_travel_time_multiplier, 1.0)
	assert_eq(u.throw_distance_multiplier, 1.0)
	assert_eq(u.max_simultaneous_captures, 1)

func test_level_one_unlocks_only_the_tranquilizer() -> void:
	var u := PlayerUpgrades.for_progress(1)
	assert_true(u.tranquilizer_available)
	assert_eq(u.speed_multiplier, 1.0)

func test_each_unlock_appears_at_its_level() -> void:
	assert_eq(PlayerUpgrades.for_progress(2).speed_multiplier, PlayerUpgrades.SPEED_MULTIPLIER)
	assert_eq(PlayerUpgrades.for_progress(3).stun_duration_multiplier, 1.0)
	assert_eq(PlayerUpgrades.for_progress(4).stun_duration_multiplier, PlayerUpgrades.STUN_DURATION_MULTIPLIER)
	assert_eq(PlayerUpgrades.for_progress(4).max_simultaneous_captures, 1)
	assert_eq(PlayerUpgrades.for_progress(5).max_simultaneous_captures, 2)
	assert_eq(PlayerUpgrades.for_progress(5).lasso_travel_time_multiplier, 1.0)
	assert_eq(PlayerUpgrades.for_progress(6).lasso_travel_time_multiplier, PlayerUpgrades.LASSO_TRAVEL_TIME_MULTIPLIER)
	assert_eq(PlayerUpgrades.for_progress(7).throw_distance_multiplier, 1.0)
	assert_eq(PlayerUpgrades.for_progress(8).throw_distance_multiplier, PlayerUpgrades.THROW_DISTANCE_MULTIPLIER)

func test_progress_is_cumulative() -> void:
	var u := PlayerUpgrades.for_progress(20)
	assert_true(u.tranquilizer_available)
	assert_eq(u.max_simultaneous_captures, 2)
	assert_eq(u.throw_distance_multiplier, PlayerUpgrades.THROW_DISTANCE_MULTIPLIER)
