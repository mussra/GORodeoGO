extends GutTest
## 3.0.43: los desplegables usan el marco y colores del tema del juego.
func test_ranch_theme_styles_popup_menus_for_touch()->void:
	var theme:Theme=RanchTheme.create()
	assert_true(theme.has_stylebox("panel","PopupMenu"))
	assert_true(theme.has_stylebox("hover","PopupMenu"))
	assert_gte(theme.get_font_size("font_size","PopupMenu"),22)
	assert_gte(theme.get_constant("v_separation","PopupMenu"),14,"filas lo bastante altas para el dedo")
	var panel:StyleBoxFlat=theme.get_stylebox("panel","PopupMenu")
	assert_eq(panel.border_color,RanchTheme.GOLD)
func test_option_button_popup_inherits_the_theme()->void:
	var host:=Control.new();host.theme=RanchTheme.create();add_child_autofree(host)
	var pick:=OptionButton.new();pick.add_item("Original");pick.add_item("Negro");host.add_child(pick)
	var popup:PopupMenu=pick.get_popup()
	assert_eq((popup.get_theme_stylebox("panel") as StyleBoxFlat).border_color,RanchTheme.GOLD)
