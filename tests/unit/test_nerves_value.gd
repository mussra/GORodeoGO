extends GutTest

func test_default_is_max() -> void:
	var sut := NervesValue.new()
	assert_eq(sut.current, NervesValue.MAX_VALUE)
	assert_false(sut.is_controlled())

func test_reduce_by_decreases_value() -> void:
	var sut := NervesValue.new(100.0)
	sut.reduce_by(30.0)
	assert_eq(sut.current, 70.0)

func test_reduce_by_clamps_at_min() -> void:
	var sut := NervesValue.new(10.0)
	sut.reduce_by(50.0)
	assert_eq(sut.current, NervesValue.MIN_VALUE)

func test_reduce_by_reaching_zero_sets_is_controlled() -> void:
	var sut := NervesValue.new(5.0)
	sut.reduce_by(5.0)
	assert_true(sut.is_controlled())

func test_increase_by_clamps_at_max() -> void:
	var sut := NervesValue.new(90.0)
	sut.increase_by(50.0)
	assert_eq(sut.current, NervesValue.MAX_VALUE)

func test_constructor_initial_above_max_clamps() -> void:
	var sut := NervesValue.new(500.0)
	assert_eq(sut.current, NervesValue.MAX_VALUE)

func test_force_calm_sets_to_min_regardless_of_starting_value() -> void:
	var sut := NervesValue.new(75.0)
	sut.force_calm()
	assert_eq(sut.current, NervesValue.MIN_VALUE)
	assert_true(sut.is_controlled())
