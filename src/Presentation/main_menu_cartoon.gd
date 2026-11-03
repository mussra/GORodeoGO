extends "res://src/Presentation/main_menu.gd"
var _portrait: TextureRect
var _card: Panel
func _build_menu() -> void:
	super._build_menu()
	get_child(0).queue_free()
	var backdrop := CartoonBackdrop.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)
	move_child(backdrop,0)
	_hero.get_node("Rider").hide()
	_hero.get_node("Bull").hide()
	_portrait = TextureRect.new()
	_portrait.texture = load("res://art/ui/cartoon_hero.png")
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_hero.add_child(_portrait)
	_hero.move_child(_portrait,0)
	_hero.get_node("Tag").text = "TU RANCHO. TU AVENTURA."
	_hero.get_node("Tag").add_theme_color_override("font_color",Color("264451"))
	var logo: Label = _hero.get_node("Logo")
	logo.text = "GO\nRODEO\nGO!"
	logo.add_theme_font_size_override("font_size",54)
	logo.add_theme_color_override("font_color",Color("fff1ba"))
	logo.add_theme_color_override("font_outline_color",Color("263747"))
	logo.add_theme_constant_override("outline_size",14)
	logo.rotation = -.05
	_hero.get_node("Description").hide()
	_play.text = "¡A CABALGAR!\nNIVEL %02d  >" % _next_level
	_missions.text = "MAPA DE NIVELES"
	for button in [_play,_missions,quit_button]:
		button.add_theme_color_override("font_color",Color("253746"))
		button.add_theme_color_override("font_hover_color",Color("253746"))
		button.add_theme_color_override("font_pressed_color",Color("253746"))
		button.add_theme_stylebox_override("normal",_chunky(Color("ffda3b") if button == _play else Color("fff0d0")))
		button.add_theme_stylebox_override("hover",_chunky(Color("fff19a")))
		button.add_theme_stylebox_override("pressed",_chunky(Color("ffc53b"),2))
		button.add_theme_font_override("font",preload("res://art/ui/fonts/RodeoDisplay.ttf"))
	_missions.add_theme_font_size_override("font_size",19)
	_card = Panel.new()
	_card.add_theme_stylebox_override("panel",_chunky(Color("fff0d0"),4))
	_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_hero.add_child(_card)
	_hero.move_child(_card,0)
	_caption.text = "TU PROGRESO\n%02d / 20 RETOS" % SaveData.highest_level_completed
	_caption.add_theme_font_size_override("font_size",18)
	_caption.add_theme_color_override("font_color",Color("304756"))
	get_node("Footer").add_theme_color_override("font_color",Color("455966"))
	_drawer.add_theme_stylebox_override("panel",_chunky(Color("f1e0b7")))
	_drawer.get_child(0).add_theme_color_override("font_color",Color("253746"))
	for button in level_grid.get_children():
		button.add_theme_stylebox_override("normal",_chunky(Color("fff0cf"),3))
		button.add_theme_color_override("font_color",Color("263747"))
		button.add_theme_color_override("font_hover_color",Color("263747"))
		button.add_theme_color_override("font_focus_color",Color("263747"))
		button.add_theme_stylebox_override("hover",_chunky(Color("ffe79b"),3))
func _chunky(fill: Color, shadow_y: int = 7) -> StyleBoxFlat:
	var style: StyleBoxFlat = RanchTheme.box(fill,Color("263747"),24)
	style.set_border_width_all(4)
	style.border_width_bottom = 7
	style.shadow_color = Color("263747")
	style.shadow_size = 2
	style.shadow_offset = Vector2(0,shadow_y)
	return style
func _layout() -> void:
	super._layout()
	if _portrait == null: return
	_portrait.position = Vector2(368,106)
	_portrait.size = Vector2(520,470)
	_hero.get_node("Tag").position = Vector2(40,40)
	_hero.get_node("Logo").position = Vector2(40,116)
	_play.position = Vector2(928,426)
	_play.size = Vector2(306,106)
	_missions.position = Vector2(938,327)
	_missions.size = Vector2(286,70)
	_card.position = Vector2(42,455)
	_card.size = Vector2(236,110)
	_caption.position = Vector2(62,475)
func _animate_intro() -> void:
	super._animate_intro()
	_portrait.pivot_offset = _portrait.size*.5
	_portrait.scale = Vector2(.82,.82)
	create_tween().tween_property(_portrait,"scale",Vector2.ONE,.75).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
