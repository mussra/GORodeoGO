extends CanvasLayer

signal sound_toggled(enabled: bool)
signal next_requested
signal restart_requested
signal quit_requested
signal pause_requested
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
var _hint_label: Label
var _level_label: Label
var _pause_button: Button
var _next_button: Button

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # buttons must keep working while the tree is paused
	_build_pause_panel()
	_apply_ranch_ui()
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

func set_level(number: int) -> void:
	_level_label.text = "NIVEL %02d" % number
	_hint_label.text = "Acércate a una puerta y quédate quieto para abrirla" if number >= 11 else "Laza un toro, espera a que se calme y llévalo al CORRAL"

func update_timer(seconds_remaining: float) -> void:
	var whole_seconds: int = max(0, int(ceil(seconds_remaining)))
	timer_label.text = "%d:%02d" % [whole_seconds / 60, whole_seconds % 60]
	timer_label.modulate = Color("ffbd85") if whole_seconds <= 15 else Color.WHITE

func show_win() -> void:
	_pause_button.hide()
	_hint_label.hide()
	_next_button.visible = GameState.selected_level < LevelCatalog.MAX_LEVEL
	restart_button.visible = not _next_button.visible
	end_label.text = "¡Rancho asegurado!\nTodos los toros en el corral."
	end_panel.visible = true

func show_lose(reason: String) -> void:
	_pause_button.hide()
	_hint_label.hide()
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

	var sound_button := CheckButton.new()
	sound_button.text = "Sonido"
	sound_button.button_pressed = true
	sound_button.position = Vector2(185, 65)
	sound_button.toggled.connect(func(value: bool): sound_toggled.emit(value))
	_pause_panel.add_child(sound_button)

	var menu_button := Button.new()
	menu_button.text = "Menú principal"
	menu_button.offset_left = 272.0
	menu_button.offset_right = 472.0
	menu_button.offset_top = 120.0
	menu_button.offset_bottom = 170.0
	menu_button.pressed.connect(func(): quit_requested.emit())
	_pause_panel.add_child(menu_button)

	add_child(_pause_panel)

func _apply_ranch_ui() -> void:
	var ranch_theme: Theme = RanchTheme.create()
	_next_button = Button.new()
	_next_button.text = "Siguiente nivel"
	_next_button.position = restart_button.position
	_next_button.size = restart_button.size
	_next_button.visible = false
	_next_button.pressed.connect(func(): next_requested.emit())
	end_panel.add_child(_next_button)
	for child in get_children():
		if child is Control:
			child.theme = ranch_theme
	# A thin HUD band keeps numbers off the playing area.
	var band := Panel.new()
	band.theme = ranch_theme
	band.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	band.offset_bottom = 68
	band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(band)
	move_child(band, 0)
	_level_label = Label.new()
	_level_label.position = Vector2(26, 12)
	_level_label.add_theme_font_size_override("font_size", 15)
	_level_label.modulate = RanchTheme.GOLD
	band.add_child(_level_label)
	bull_count_label.position = Vector2(26, 32)
	bull_count_label.add_theme_font_size_override("font_size", 18)
	timer_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	timer_label.offset_left = -48
	timer_label.offset_right = 48
	timer_label.offset_top = 18
	timer_label.offset_bottom = 54
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	timer_label.add_theme_font_size_override("font_size", 26)
	_pause_button = Button.new()
	_pause_button.theme = ranch_theme
	_pause_button.text = "Pausa"
	_pause_button.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	_pause_button.offset_left = -120
	_pause_button.offset_right = -20
	_pause_button.offset_top = 12
	_pause_button.offset_bottom = 56
	_pause_button.pressed.connect(func(): pause_requested.emit())
	add_child(_pause_button)
	tranquilizer_button.offset_left = -360
	tranquilizer_button.offset_right = -136
	_hint_label = Label.new()
	_hint_label.theme = ranch_theme
	_hint_label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_hint_label.offset_top = -34
	_hint_label.offset_bottom = -8
	_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hint_label.add_theme_font_size_override("font_size", 17)
	_hint_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_hint_label)
	for group: VBoxContainer in [nerves_group, nerves_group_2]:
		group.modulate = Color("fff1d2")
	for bar: ProgressBar in [nerves_bar, nerves_bar_2]:
		bar.show_percentage = false
	$NervesGroup/NervesLabel.text = "Calmando al toro..."
	$NervesGroup2/NervesLabel.text = "Calmando al segundo..."
