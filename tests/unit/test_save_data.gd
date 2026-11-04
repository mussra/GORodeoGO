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

func test_record_rejects_levels_outside_the_campaign() -> void:
	var sut: Node = load("res://src/Application/save_data.gd").new()
	assert_false(sut.is_new_record(-1))
	assert_false(sut.is_new_record(0))
	assert_false(sut.is_new_record(LevelCatalog.MAX_LEVEL + 1))
	sut.free()

func test_atomic_save_roundtrip_on_an_isolated_path() -> void:
	var path: String = "user://qa_progress_roundtrip.dat"
	var sut: Node = load("res://src/Application/save_data.gd").new()
	sut.save_path = path
	sut.highest_level_completed = 12
	assert_true(sut.save_progress())
	assert_true(FileAccess.file_exists(path))
	assert_false(FileAccess.file_exists(path + ".tmp"), "temp file was renamed")
	sut.highest_level_completed = 0
	sut.load_progress()
	assert_eq(sut.highest_level_completed, 12)
	DirAccess.remove_absolute(path)
	sut.free()

func test_dual_lasso_intro_flag_roundtrip_on_an_isolated_path() -> void:
	var path: String = "user://qa_dual_lasso_roundtrip.dat"
	var sut: Node = load("res://src/Application/save_data.gd").new()
	sut.save_path = path
	assert_false(sut.dual_lasso_intro_shown)
	sut.mark_dual_lasso_intro_shown()
	assert_true(sut.dual_lasso_intro_shown)
	sut.dual_lasso_intro_shown = false
	sut.load_progress()
	assert_true(sut.dual_lasso_intro_shown, "flag persists across save/load")
	DirAccess.remove_absolute(path)
	sut.free()

func test_dual_lasso_intro_flag_defaults_false_without_save_file() -> void:
	var sut: Node = load("res://src/Application/save_data.gd").new()
	sut.save_path = "user://qa_dual_lasso_missing.dat"
	sut.load_progress()
	assert_false(sut.dual_lasso_intro_shown)
	sut.free()

func test_corrupt_or_missing_save_resets_only_the_test_instance() -> void:
	var path: String = "user://qa_progress_corrupt.dat"
	var sut: Node = load("res://src/Application/save_data.gd").new()
	sut.save_path = path
	var config := ConfigFile.new()
	config.set_value("progress", "highest_level_completed", "not an integer")
	assert_eq(config.save(path), OK)
	sut.highest_level_completed = 8
	sut.load_progress()
	assert_eq(sut.highest_level_completed, 0)
	DirAccess.remove_absolute(path)
	sut.highest_level_completed = 8
	sut.load_progress()
	assert_eq(sut.highest_level_completed, 0)
	sut.free()
