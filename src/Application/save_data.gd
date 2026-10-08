extends Node

## Persistent progression (Autoload — see project.godot [autoload]).
## Single tracked value: highest level completed. Every unlock is derived from this —
## no currency, no shop (PROJECT_SPEC.md explicitly excludes a complex economy from MVP).
## Persisted data is validated on load (LevelProgression.sanitize_highest_completed) and
## written atomically (temp file + rename) so an interrupted write cannot corrupt the save.

const SAVE_PATH: String = "user://save.dat"
const SAVE_VERSION: int = 1  ## bump when the file layout changes, to allow migrations

var highest_level_completed: int = 0

func _ready() -> void:
	load_progress()

func record_level_completed(level_number: int) -> void:
	if is_new_record(level_number):
		highest_level_completed = level_number
		save_progress()

## Pure decision logic, no side effects — split out so tests can verify it without
## triggering a real disk write to the user's actual save file.
func is_new_record(level_number: int) -> bool:
	return level_number > highest_level_completed

func save_progress() -> bool:
	var config := ConfigFile.new()
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("progress", "highest_level_completed", highest_level_completed)
	var temp_path: String = SAVE_PATH + ".tmp"
	var err: Error = config.save(temp_path)
	if err == OK:
		err = DirAccess.rename_absolute(temp_path, SAVE_PATH)
	if err != OK:
		push_error("SaveData: could not save progress (error %d)." % err)
		return false
	return true

func load_progress() -> void:
	var config := ConfigFile.new()
	var err: Error = config.load(SAVE_PATH)
	if err != OK:
		highest_level_completed = 0  # first run (no file) or unreadable file
		return
	highest_level_completed = LevelProgression.sanitize_highest_completed(
		config.get_value("progress", "highest_level_completed", 0)
	)
