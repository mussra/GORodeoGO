extends Control

## Functional-only menu (no art/design yet — a proper redesign is planned separately).
## All 10 level buttons fit on screen at once in a grid — no scrolling required, which
## sidesteps the touch-drag-vs-button-press conflict a ScrollContainer had (buttons
## consumed the drag gesture before the container ever saw it as a scroll).

const GRID_COLUMNS: int = 5

@onready var level_grid: GridContainer = $LevelGrid
@onready var quit_button: Button = $QuitButton

func _ready() -> void:
	level_grid.columns = GRID_COLUMNS
	for level_number in range(1, LevelCatalog.MAX_LEVEL + 1):
		var button := Button.new()
		button.custom_minimum_size = Vector2(170, 70)
		var unlocked: bool = LevelProgression.is_unlocked(level_number, SaveData.highest_level_completed, OS.is_debug_build())
		button.disabled = not unlocked
		button.text = "Nivel %d" % level_number if unlocked else "Nivel %d\n(bloqueado)" % level_number
		button.pressed.connect(_on_level_selected.bind(level_number))
		level_grid.add_child(button)

	quit_button.pressed.connect(_on_quit_pressed)

func _on_level_selected(level_number: int) -> void:
	GameState.selected_level = level_number
	get_tree().change_scene_to_file("res://src/Presentation/level_0.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

## Android back button on the menu quits (project.godot sets quit_on_go_back=false so the
## level can use the same button for its pause menu).
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_quit_pressed()
