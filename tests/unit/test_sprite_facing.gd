extends GutTest

const DT: float = 0.016
var sut: SpriteFacing

func before_each() -> void:
	sut = SpriteFacing.new()

func _dir(degrees: float) -> Vector2:
	return Vector2.from_angle(deg_to_rad(degrees))

func test_first_update_snaps_to_the_direction() -> void:
	sut.update(_dir(90.0), DT)
	assert_eq(sut.current_sector(), 2)

func test_jitter_around_a_sector_edge_never_changes_the_facing() -> void:
	# Regression: bull sprite flickered near fences/corners. 22.5 deg is the edge between
	# east (0) and south-east (1); alternating either side of it must stay put.
	sut.update(_dir(0.0), DT)
	for i in range(200):
		sut.update(_dir(17.5 if i % 2 == 0 else 27.5), DT)
		assert_eq(sut.current_sector(), 0, "frame %d" % i)

func test_jitter_just_past_the_hysteresis_band_is_still_ignored_inside_it() -> void:
	sut.update(_dir(0.0), DT)
	sut.update(_dir(34.0), DT)  # edge 22.5 + 12 = 34.5 -> still inside the band
	assert_eq(sut.current_sector(), 0)

func test_a_clear_direction_change_switches_sector() -> void:
	sut.update(_dir(0.0), DT)
	sut.update(_dir(90.0), DT)
	assert_eq(sut.current_sector(), 2)

func test_minimum_hold_blocks_a_second_change_until_it_expires() -> void:
	sut.update(_dir(0.0), DT)
	sut.update(_dir(90.0), DT)   # change, hold starts
	sut.update(_dir(270.0), DT)  # too soon
	assert_eq(sut.current_sector(), 2)
	sut.update(_dir(270.0), SpriteFacing.MIN_HOLD_SECONDS + 0.01)
	assert_eq(sut.current_sector(), 6)

func test_zero_direction_keeps_the_facing() -> void:
	sut.update(_dir(135.0), DT)
	sut.update(Vector2.ZERO, DT)
	assert_eq(sut.current_sector(), 3)

func test_wrap_around_at_180_degrees_is_one_sector() -> void:
	sut.update(_dir(179.0), DT)
	assert_eq(sut.current_sector(), 4)
	for i in range(50):
		sut.update(_dir(179.0 if i % 2 == 0 else -179.0), DT)
		assert_eq(sut.current_sector(), 4)

func test_reset_snaps_again_ignoring_the_hold() -> void:
	sut.update(_dir(0.0), DT)
	sut.update(_dir(90.0), DT)  # hold active
	sut.reset()
	sut.update(_dir(270.0), DT)
	assert_eq(sut.current_sector(), 6)

func test_facing_direction_never_sits_on_a_sprite_swap_boundary() -> void:
	var expected: Array = [
		["side", false], ["diag_down", false], ["down", false], ["diag_down", true],
		["side", true], ["diag_up", true], ["up", false], ["diag_up", false],
	]
	for sector in range(SpriteFacing.SECTOR_COUNT):
		var facing := SpriteFacing.new()
		facing.update(_dir(sector * 45.0), DT)
		assert_eq(SpriteSwap.direction_suffix(facing.facing_direction()), expected[sector], "sector %d" % sector)
