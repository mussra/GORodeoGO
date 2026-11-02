extends Control

const GRID_COLUMNS: int = 5
@onready var level_grid: GridContainer = $LevelGrid
@onready var quit_button: Button = $QuitButton

func _ready() -> void:
	theme = RanchTheme.create()
	_build_menu()
	quit_button.pressed.connect(_on_quit_pressed)

func _build_menu() -> void:
	var background := ColorRect.new()
	background.color = Color("203e37")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	move_child(background, 0)
	$Title.hide()
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 64)
	margin.add_theme_constant_override("margin_right", 64)
	margin.add_theme_constant_override("margin_top", 26)
	margin.add_theme_constant_override("margin_bottom", 24)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 12)
	margin.add_child(column)
	var kicker := Label.new()
	kicker.text = "EL RANCHO TE ESPERA"
	kicker.add_theme_color_override("font_color", RanchTheme.GOLD)
	kicker.add_theme_font_size_override("font_size", 15)
	column.add_child(kicker)
	var title := Label.new()
	title.text = "GO Rodeo GO"
	title.add_theme_font_size_override("font_size", 44)
	column.add_child(title)
	var description := Label.new()
	description.text = "Apunta el lazo. Calma a tus toros. Guíalos al corral."
	description.add_theme_font_size_override("font_size", 20)
	column.add_child(description)
	var status := Label.new()
	status.text = "%d / %d niveles completados    ·    1-10 Rodeo    /    11-20 Puertas enlazadas" % [SaveData.highest_level_completed, LevelCatalog.MAX_LEVEL]
	status.add_theme_color_override("font_color", Color("b6c9b0"))
	column.add_child(status)
	level_grid.reparent(column)
	level_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	level_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	level_grid.columns = GRID_COLUMNS
	level_grid.add_theme_constant_override("h_separation", 12)
	level_grid.add_theme_constant_override("v_separation", 10)
	for level_number in range(1, LevelCatalog.MAX_LEVEL + 1):
		var button := Button.new()
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		button.custom_minimum_size = Vector2(0, 58)
		var unlocked: bool = LevelProgression.is_unlocked(level_number, SaveData.highest_level_completed, OS.is_debug_build())
		button.disabled = not unlocked
		var marker: String = "COMPLETADO" if level_number <= SaveData.highest_level_completed else ("RODEO" if level_number <= 10 else "PUERTAS")
		button.text = "%02d  ·  %s\n%s" % [level_number, "Nivel", marker] if unlocked else "%02d\nBLOQUEADO" % level_number
		button.add_theme_font_size_override("font_size", 17)
		button.pressed.connect(_on_level_selected.bind(level_number))
		level_grid.add_child(button)
	var help := Label.new()
	help.text = "MÓVIL  Izquierda: mover  ·  Derecha: apuntar y soltar  ·  Doble toque: liberar\nTECLADO  Flechas: mover  ·  Mantén Espacio y suelta: lazo  ·  Esc: pausa"
	help.add_theme_font_size_override("font_size", 16)
	help.add_theme_color_override("font_color", Color("b6c9b0"))
	column.add_child(help)
	quit_button.move_to_front()

func _on_level_selected(level_number: int) -> void:
	GameState.selected_level = level_number
	get_tree().change_scene_to_file("res://src/Presentation/level_0.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_quit_pressed()
