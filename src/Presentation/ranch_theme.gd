class_name RanchTheme
extends RefCounted

const INK: Color = Color("332b28")
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
	theme.set_stylebox("normal", "Button", box(Color("395b53"), Color("698579")))
	theme.set_stylebox("hover", "Button", box(Color("48776b"), GOLD))
	theme.set_stylebox("pressed", "Button", box(GOLD, CREAM))
	theme.set_stylebox("disabled", "Button", box(Color("293d39"), Color("3b4c45")))
	theme.set_stylebox("focus", "Button", box(Color(1, 1, 1, 0.04), GOLD))
	theme.set_stylebox("panel", "Panel", box(Color("223e38"), Color("8b9a75"), 18))
	theme.set_stylebox("panel", "PanelContainer", box(Color("223e38"), Color("6c8070"), 18))
	theme.set_stylebox("background", "ProgressBar", box(Color("1d302c"), Color.TRANSPARENT, 6))
	theme.set_stylebox("fill", "ProgressBar", box(GOLD, Color.TRANSPARENT, 6))
	return theme
