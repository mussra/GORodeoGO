extends GutTest

## Tests the pure decision logic only (is_new_record) - never calls record_level_completed
## directly, since that triggers a real write to the user's actual user save file. A test
## silently corrupting real save progress would be worse than the bug it's checking for.

func test_is_new_record_true_when_higher() -> void:
	var sut: Node = load("res://src/Application/save_data.gd").new()
	sut.highest_level_completed = 2
	assert_true(sut.is_new_record(5))
	sut.free()

func test_is_new_record_false_when_lower_or_equal() -> void:
	var sut: Node = load("res://src/Application/save_data.gd").new()
	sut.highest_level_completed = 5
	assert_false(sut.is_new_record(3))
	assert_false(sut.is_new_record(5))
	sut.free()
