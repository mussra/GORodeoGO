extends GutTest

func test_zero_vector_defaults_to_down() -> void:
	var result: Array = SpriteSwap.direction_suffix(Vector2.ZERO)
	assert_eq(result[0], "down")
	assert_false(result[1])

func test_east_is_side_no_flip() -> void:
	var result: Array = SpriteSwap.direction_suffix(Vector2(1, 0))
	assert_eq(result[0], "side")
	assert_false(result[1])

func test_west_is_side_flipped() -> void:
	var result: Array = SpriteSwap.direction_suffix(Vector2(-1, 0))
	assert_eq(result[0], "side")
	assert_true(result[1])

func test_south_is_down_no_flip() -> void:
	var result: Array = SpriteSwap.direction_suffix(Vector2(0, 1))
	assert_eq(result[0], "down")
	assert_false(result[1])

func test_north_is_up_no_flip() -> void:
	var result: Array = SpriteSwap.direction_suffix(Vector2(0, -1))
	assert_eq(result[0], "up")
	assert_false(result[1])

func test_southeast_is_diag_down_no_flip() -> void:
	var result: Array = SpriteSwap.direction_suffix(Vector2(1, 1))
	assert_eq(result[0], "diag_down")
	assert_false(result[1])

func test_southwest_is_diag_down_flipped() -> void:
	var result: Array = SpriteSwap.direction_suffix(Vector2(-1, 1))
	assert_eq(result[0], "diag_down")
	assert_true(result[1])

func test_northeast_is_diag_up_no_flip() -> void:
	var result: Array = SpriteSwap.direction_suffix(Vector2(1, -1))
	assert_eq(result[0], "diag_up")
	assert_false(result[1])

func test_northwest_is_diag_up_flipped() -> void:
	var result: Array = SpriteSwap.direction_suffix(Vector2(-1, -1))
	assert_eq(result[0], "diag_up")
	assert_true(result[1])
