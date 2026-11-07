class_name RanchTheme
extends RefCounted

const INK: Color = Color("10252d")
const CREAM: Color = Color("fff1d2")
const GOLD: Color = Color("efb950")
const TEAL: Color = Color("35695f")

static func box(fill: Color, border: Color = Color.TRANSPARENT, radius: int = 12) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(2 if border.a > 0.0 else 0)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 16.0
	style.content_margin_right = 16.0
	style.content_margin_top = 10.0
	style.content_margin_bottom = 10.0
	return style

static func create() -> Theme:
	var theme := Theme.new()
	theme.default_font_size = 18
	theme.set_color("font_color", "Label", CREAM)
	theme.set_color("font_color", "Button", CREAM)
	theme.set_color("font_hover_color", "Button", Color.WHITE)
	theme.set_color("font_pressed_color", "Button", INK)
	theme.set_color("font_disabled_color", "Button", Color("8b8f89"))
	theme.set_stylebox("normal", "Button", box(Color("204651"), Color("5c929a")))
	theme.set_stylebox("hover", "Button", box(Color("31616b"), GOLD))
	theme.set_stylebox("pressed", "Button", box(GOLD, CREAM))
	theme.set_stylebox("disabled", "Button", box(Color("17333d"), Color("35545e")))
	theme.set_stylebox("focus", "Button", box(Color(1, 1, 1, 0.04), GOLD))
	theme.set_stylebox("panel", "Panel", box(Color("112d3b"), Color("547e86"), 18))
	theme.set_stylebox("panel", "PanelContainer", box(Color("112d3b"), Color("496f7c"), 18))
	theme.set_stylebox("background", "ProgressBar", box(Color("102733"), Color.TRANSPARENT, 6))
	theme.set_stylebox("fill", "ProgressBar", box(GOLD, Color.TRANSPARENT, 6))
	# AcceptDialog / ConfirmationDialog (Ant 22:50: "Todos los mensajes" con el
	# estilo de los menús — the default gray Godot dialogs clashed).
	theme.set_stylebox("panel", "AcceptDialog", box(Color("112d3b"), Color("547e86"), 18))
	# Embedded window title bar (the gray band Ant flagged in "Salir del juego").
	theme.set_stylebox("embedded_border", "Window", box(Color("0e2a36"), Color("547e86"), 18))
	theme.set_color("title_color", "Window", CREAM)
	theme.set_font_size("title_font_size", "Window", 20)
	return theme

## Applies the menus' palette to a popup dialog (Salir, confirmaciones, avisos).
static func style_dialog(dialog: AcceptDialog) -> void:
	dialog.theme = create()
