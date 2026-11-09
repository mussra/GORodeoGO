extends CanvasLayer

signal pause_toggle_requested
signal sound_toggled(enabled: bool)
signal next_requested
signal restart_requested
signal quit_requested
signal pause_requested
signal resume_requested
signal tranquilizer_requested
## The player acknowledged the one-shot "¡Has conseguido el doble lazo!" intro overlay.
signal dual_lasso_intro_accepted

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
var _dual_lasso_panel: Panel
var _toasts:ToastStack
var _hint_label: Label
var _level_label: Label
var _pause_button: Button
var _next_button: Button
var _level_number: int = 1

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # buttons must keep working while the tree is paused
	_toasts=ToastStack.new();_toasts.top_offset=112.0;add_child(_toasts)
	_build_pause_panel()
	_apply_ranch_ui()
	nerves_group.visible = false
	nerves_group_2.visible = false
	end_panel.visible = false
	tranquilizer_button.text = tr("Usar Tranquilizante")
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
	bull_count_label.text = tr("UI_016") % [returned, total]

func set_level(number: int) -> void:
	_level_number = number
	_level_label.text = tr("UI_017") % number
	_hint_label.text = tr("UI_018") if number >= 11 else tr("UI_019")

func update_timer(seconds_remaining: float) -> void:
	var whole_seconds: int = max(0, int(ceil(seconds_remaining)))
	timer_label.text = "%d:%02d" % [whole_seconds / 60, whole_seconds % 60]
	timer_label.modulate = Color("ffbd85") if whole_seconds <= 15 else Color.WHITE

func show_win() -> void:
	tranquilizer_button.hide()
	nerves_group.hide()
	nerves_group_2.hide()
	_pause_button.hide()
	_hint_label.hide()
	_toasts.clear()
	_next_button.visible = GameState.selected_level < LevelCatalog.MAX_LEVEL
	restart_button.visible = not _next_button.visible
	end_label.text = tr("UI_020")
	end_panel.visible = true

func show_lose(reason: String) -> void:
	tranquilizer_button.hide()
	nerves_group.hide()
	nerves_group_2.hide()
	_pause_button.hide()
	_hint_label.hide()
	_toasts.clear()
	end_label.text = tr("UI_021") % reason
	end_panel.visible = true

func show_pause() -> void:
	_pause_panel.visible = true
	_pause_button.disabled = true
	tranquilizer_button.disabled = true

func hide_pause() -> void:
	_pause_panel.visible = false
	_pause_button.disabled = false
	tranquilizer_button.disabled = false

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
	title.text = tr("UI_022")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.offset_left = 20.0
	title.offset_right = 492.0
	title.offset_top = 20.0
	title.offset_bottom = 70.0
	_pause_panel.add_child(title)

	var resume_button := Button.new()
	resume_button.text = tr("UI_023")
	resume_button.offset_left = 40.0
	resume_button.offset_right = 240.0
	resume_button.offset_top = 120.0
	resume_button.offset_bottom = 170.0
	resume_button.pressed.connect(func(): resume_requested.emit())
	_pause_panel.add_child(resume_button)

	var sound_button := CheckButton.new()
	sound_button.text = tr("UI_024")
	sound_button.button_pressed = GameState.sound_enabled
	sound_button.position = Vector2(185, 65)
	sound_button.toggled.connect(func(value: bool): sound_toggled.emit(value))
	_pause_panel.add_child(sound_button)

	var menu_button := Button.new()
	menu_button.text = tr("UI_025")
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
	_next_button.text = tr("UI_026")
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
	_pause_button.text = tr("UI_022")
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
	_hint_label.offset_top = -62
	_hint_label.offset_bottom = -8
	_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hint_label.add_theme_font_size_override("font_size", 17)
	_hint_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ToastStack.backdrop(_hint_label)
	add_child(_hint_label)
	for group: VBoxContainer in [nerves_group, nerves_group_2]:
		group.modulate = Color("fff1d2")
	for bar: ProgressBar in [nerves_bar, nerves_bar_2]:
		bar.show_percentage = false
	$NervesGroup/NervesLabel.text = tr("UI_027")
	$NervesGroup2/NervesLabel.text = tr("UI_028")

## One-shot unlock celebration (Ant, 4-nov: "que se vea una animación chula diciendo has
## conseguido el doble lazo y que te explique cómo usarlo"). Shown by Level0 with the tree
## paused; this CanvasLayer is PROCESS_MODE_ALWAYS, so the entrance tween still plays.
func show_dual_lasso_intro() -> void:
	if _dual_lasso_panel == null:
		_build_dual_lasso_panel()
	_dual_lasso_panel.visible = true
	_dual_lasso_panel.pivot_offset = _dual_lasso_panel.size / 2.0
	_dual_lasso_panel.scale = Vector2.ZERO
	_dual_lasso_panel.rotation = -0.12
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(_dual_lasso_panel, "scale", Vector2.ONE, 0.5)
	tween.tween_property(_dual_lasso_panel, "rotation", 0.0, 0.5)

func _build_dual_lasso_panel() -> void:
	_dual_lasso_panel = Panel.new()
	_dual_lasso_panel.theme = RanchTheme.create()
	_dual_lasso_panel.anchor_left = 0.5
	_dual_lasso_panel.anchor_right = 0.5
	_dual_lasso_panel.anchor_top = 0.5
	_dual_lasso_panel.anchor_bottom = 0.5
	_dual_lasso_panel.offset_left = -280.0
	_dual_lasso_panel.offset_right = 280.0
	_dual_lasso_panel.offset_top = -190.0
	_dual_lasso_panel.offset_bottom = 190.0
	_dual_lasso_panel.visible = false

	var icon := Control.new()
	icon.position = Vector2(230, 18)
	icon.size = Vector2(100, 70)
	icon.draw.connect(_draw_dual_lasso_icon.bind(icon))
	_dual_lasso_panel.add_child(icon)
	# Gentle golden pulse on the loops so the reward reads "chula" without new art.
	var pulse: Tween = create_tween().set_loops()
	pulse.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	pulse.tween_property(icon, "modulate", Color(1.25, 1.15, 0.9), 0.6)
	pulse.tween_property(icon, "modulate", Color.WHITE, 0.6)

	var title := Label.new()
	title.text = tr("UI_029")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.offset_left = 20.0
	title.offset_right = 540.0
	title.offset_top = 92.0
	title.offset_bottom = 132.0
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", RanchTheme.GOLD)
	_dual_lasso_panel.add_child(title)

	var explanation := Label.new()
	explanation.text = tr("UI_030")
	explanation.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	explanation.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	explanation.offset_left = 40.0
	explanation.offset_right = 520.0
	explanation.offset_top = 140.0
	explanation.offset_bottom = 260.0
	_dual_lasso_panel.add_child(explanation)

	var accept_button := Button.new()
	accept_button.text = tr("UI_031")
	accept_button.offset_left = 180.0
	accept_button.offset_right = 380.0
	accept_button.offset_top = 300.0
	accept_button.offset_bottom = 350.0
	accept_button.pressed.connect(_on_dual_lasso_accept_pressed)
	_dual_lasso_panel.add_child(accept_button)

	add_child(_dual_lasso_panel)

## Two crossed lasso loops in the ranch gold — pure HUD vector drawing, no art dependency.
func _draw_dual_lasso_icon(icon: Control) -> void:
	icon.draw_arc(Vector2(32, 36), 22, 0.0, TAU, 40, RanchTheme.GOLD, 5.0, true)
	icon.draw_arc(Vector2(68, 36), 22, 0.0, TAU, 40, RanchTheme.CREAM, 5.0, true)
	icon.draw_line(Vector2(32, 14), Vector2(24, 2), RanchTheme.GOLD, 4.0, true)
	icon.draw_line(Vector2(68, 14), Vector2(76, 2), RanchTheme.CREAM, 4.0, true)

func _on_dual_lasso_accept_pressed() -> void:
	_dual_lasso_panel.visible = false
	dual_lasso_intro_accepted.emit()

## HUD keeps processing while paused; the level intentionally does not.

## Transient override for update_guidance (which refreshes every frame): a blocked lasso
## throw explains itself here instead of failing silently.
func flash_hint(text: String, seconds: float = 1.8) -> void:
	_toasts.push(text,seconds)

func update_guidance(held_count: int, ready_count: int, has_closed_doors: bool) -> void:
	if ready_count > 0:
		_hint_label.text = tr("UI_032")
	elif held_count > 0:
		_hint_label.text = tr("UI_033")
	elif _level_number >= 11 and has_closed_doors:
		_hint_label.text = tr("UI_018")
	elif _level_number >= 3:
		_hint_label.text = tr("UI_034")
	else:
		_hint_label.text = tr("UI_019")
