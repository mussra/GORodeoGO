extends GutTest
func test_only_pursuing_wild_bulls_stop_at_a_station() -> void:
	var sut := BullDistraction.new()
	assert_false(sut.try_start(false, true, "water"))
	assert_false(sut.try_start(true, false, "water"))
	assert_false(sut.try_start(true, true, ""))
	assert_true(sut.try_start(true, true, "water"))
	assert_eq(sut.kind, "water")
func test_stop_expires_and_cooldown_prevents_immediate_reuse() -> void:
	var sut := BullDistraction.new()
	sut.try_start(true, true, "hay")
	assert_true(sut.update(2.9))
	assert_false(sut.update(0.2))
	assert_false(sut.try_start(true, true, "hay"))
	sut.update(10.0)
	assert_true(sut.try_start(true, true, "water"))
func test_capture_can_cancel_stop_without_removing_cooldown() -> void:
	var sut := BullDistraction.new()
	sut.try_start(true, true, "water")
	sut.cancel()
	assert_false(sut.active())
	assert_gt(sut.cooldown, 0.0)
