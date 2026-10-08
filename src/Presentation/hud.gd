extends CanvasLayer

signal restart_requested
signal quit_requested
signal resume_requested
signal tranquilizer_requested

@onready var bull_count_label: Label = $BullCountLabel
@onready var timer_label: Label = $TimerLabel
@onready var nerves_group: VBoxContainer = $NervesGroup
@onready var nerves_bar: ProgressBar = $NervesGroup/NervesBar
@onready var nerves_group_2: VBoxContainer = $NervesGroup2
@onready var nerves_bar_2: ProgressBar = $NervesGroup2/NervesBar
@onready var end_panel: Panel = $EndPanel
@onready var end_label: Label = $EndPanel/EndLabel
@onready var restart_button: Button = $EndPanel/RestartButton
@onready var quit_button: Button = $EndPanel/QuitButton
@onready var tranquilizer_button: Button = $TranquilizerButton

var _pause_panel: Panel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # buttons must keep working while the tree is paused
	_build_pause_panel()
	nerves_group.visible = false
	nerves_group_2.visible = false
	end_panel.visible = false
	tranquilizer_button.visible = false
	restart_button.pressed.connect(func(): restart_requested.emit())
	quit_button.pressed.connect(func(): quit_requested.emit())
	tranquilizer_button.pressed.connect(func(): tranquilizer_requested.emit())

func set_tranquilizer_available(available: bool) -> void:
	tranquilizer_button.visible = available

## slot 0 or 1 — supports up to 2 simultaneous captures (Level 10 unlock: dual capture).
func update_nerves_slot(slot: int, value: float) -> void:
	if slot == 0:
		nerves_group.visible = true
		nerves_bar.value = value
	else:
		nerves_group_2.visible = true
		nerves_bar_2.value = value

func hide_nerves_slot(slot: int) -> void:
	if slot == 0:
		nerves_group.visible = false
	else:
		nerves_group_2.visible = false

func update_bull_count(returned: int, total: int) -> void:
	bull_count_label.text = "Toros en el corral: %d/%d" % [returned, total]

func update_timer(seconds_remaining: float) -> void:
	var whole_seconds: int = max(0, int(ceil(seconds_remaining)))
	timer_label.text = "Tiempo: %d" % whole_seconds

func show_win() -> void:
	end_label.text = "¡Rancho asegurado!\nTodos los toros en el corral."
	end_panel.visible = true

func show_lose(reason: String) -> void:
	end_label.text = "Nivel fallido.\n%s" % reason
	end_panel.visible = true

func show_pause() -> void:
	_pause_panel.visible = true

func hide_pause() -> void:
	_pause_panel.visible = false

## Built in code (like the level's obstacles/doors) to keep level_0.tscn untouched.
func _build_pause_panel() -> void:
	_pause_panel = Panel.new()
	_pause_panel.anchor_left = 0.5
	_pause_panel.anchor_right = 0.5
	_pause_panel.anchor_top = 0.5
	_pause_panel.anchor_bottom = 0.5
	_pause_panel.offset_left = -256.0
	_pause_panel.offset_right = 256.0
	_pause_panel.offset_top = -110.0
	_pause_panel.offset_bottom = 110.0
	_pause_panel.visible = false

	var title := Label.new()
	title.text = "Pausa"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.offset_left = 20.0
	title.offset_right = 492.0
	title.offset_top = 20.0
	title.offset_bottom = 70.0
	_pause_panel.add_child(title)

	var resume_button := Button.new()
	resume_button.text = "Continuar"
	resume_button.offset_left = 40.0
	resume_button.offset_right = 240.0
	resume_button.offset_top = 120.0
	resume_button.offset_bottom = 170.0
	resume_button.pressed.connect(func(): resume_requested.emit())
	_pause_panel.add_child(resume_button)

	var menu_button := Button.new()
	menu_button.text = "Menú principal"
	menu_button.offset_left = 272.0
	menu_button.offset_right = 472.0
	menu_button.offset_top = 120.0
	menu_button.offset_bottom = 170.0
	menu_button.pressed.connect(func(): quit_requested.emit())
	_pause_panel.add_child(menu_button)

	add_child(_pause_panel)
