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
	# Ant 14:55/15:00: wide margins + the rounded panel is the whole frame.
	var dialog_panel := box(Color("112d3b"), Color("547e86"), 18)
	dialog_panel.content_margin_left = 28.0
	dialog_panel.content_margin_right = 28.0
	dialog_panel.content_margin_top = 20.0
	dialog_panel.content_margin_bottom = 18.0
	theme.set_stylebox("panel", "AcceptDialog", dialog_panel)
	theme.set_icon("arrow","OptionButton",AntIcons187.sized(63,Vector2i(12,12)))
	# Keep the old12px dropdown footprint despite the larger supplied crop.
	theme.set_constant("arrow_margin","OptionButton",4)
	# 3.0.43 (Ant): los desplegables (OptionButton) abrian un PopupMenu gris basico. Mismo marco,
	# colores y altura tactil que los botones del juego.
	var popup_panel := box(Color("112d3b"), GOLD, 14)
	popup_panel.content_margin_left = 8.0
	popup_panel.content_margin_right = 8.0
	popup_panel.content_margin_top = 8.0
	popup_panel.content_margin_bottom = 8.0
	theme.set_stylebox("panel", "PopupMenu", popup_panel)
	var popup_hover := box(Color("31616b"), GOLD, 10)
	popup_hover.content_margin_top = 4.0
	popup_hover.content_margin_bottom = 4.0
	theme.set_stylebox("hover", "PopupMenu", popup_hover)
	theme.set_stylebox("separator", "PopupMenu", box(Color("496f7c"), Color.TRANSPARENT, 2))
	theme.set_color("font_color", "PopupMenu", CREAM)
	theme.set_color("font_hover_color", "PopupMenu", Color.WHITE)
	theme.set_color("font_disabled_color", "PopupMenu", Color("8b8f89"))
	theme.set_color("font_separator_color", "PopupMenu", GOLD)
	theme.set_font_size("font_size", "PopupMenu", 24)
	theme.set_constant("v_separation", "PopupMenu", 18)
	theme.set_constant("item_start_padding", "PopupMenu", 12)
	theme.set_constant("item_end_padding", "PopupMenu", 12)
	return theme

## Applies the menus' palette to a popup dialog (Salir, confirmaciones, avisos).
## Ant 15:00: no X close button and no dark rectangle behind the corners, so
## every styled dialog is borderless and transparent; with show_title the
## window title (hidden when borderless) is folded into the body as a header
## line so it stays inside the rounded panel.
static func style_dialog(dialog: AcceptDialog, show_title: bool = false) -> void:
	dialog.theme = create()
	var frame := ButtonSkin272.style("normal").duplicate() as StyleBoxTexture
	frame.content_margin_left=32;frame.content_margin_right=32;frame.content_margin_top=28;frame.content_margin_bottom=28
	dialog.theme.set_stylebox("panel","AcceptDialog",frame)
	for state in ["normal","hover","pressed","disabled"]:dialog.theme.set_stylebox(state,"Button",ButtonSkin272.style(state))
	dialog.theme.set_color("font_pressed_color","Button",CREAM)
	dialog.theme.set_constant("buttons_separation","AcceptDialog",24)
	dialog.get_ok_button().custom_minimum_size=Vector2(144,52)
	ButtonSkin272.apply(dialog.get_ok_button())
	if dialog is ConfirmationDialog:
		dialog.get_cancel_button().custom_minimum_size=Vector2(160,52)
		ButtonSkin272.apply(dialog.get_cancel_button())
	dialog.set_meta("dialog_skin305",true)
	dialog.borderless = true
	dialog.transparent_bg = true
	if show_title and not dialog.title.is_empty() and not dialog.dialog_text.begins_with(dialog.title):
		dialog.dialog_text = dialog.title + "\n\n" + dialog.dialog_text
