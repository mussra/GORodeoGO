extends Control

@onready var level_grid: GridContainer = $LevelGrid
@onready var quit_button: Button = $QuitButton
var _hero: Control
var _drawer: Panel
var _play: Button
var _missions: Button
var _caption: Label
var _hd_rider: HDRiderIdle
var _rider: AnimatedSprite2D
var _bull: AnimatedSprite2D
var _intro: Tween
var _elapsed: float = 0.0
var _transitioning: bool = false
var _next_level: int = 1

func _ready() -> void:
	RanchMusic.set_paused(false)
	RanchMusic.set_enabled(GameState.sound_enabled)
	RanchMusic.play_context("menu")
	GameState.menu_scene = scene_file_path
	theme = RanchTheme.create()
	$Title.hide()
	_next_level = mini(SaveData.highest_level_completed + 1, LevelCatalog.MAX_LEVEL)
	_build_menu()
	resized.connect(_layout)
	_layout()
	call_deferred("_begin_brand_intro")

## The logo reveal precedes the existing staggered menu entrance once per process.
func _begin_brand_intro() -> void:
	if GameState.brand_intro_played:
		_animate_intro()
		return
	GameState.brand_intro_played = true
	var cover := ColorRect.new()
	cover.color = Color("041940")
	cover.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(cover)
	var image := TextureRect.new()
	image.texture = preload("res://brand/zumbel_splash.png")
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	image.offset_left = size.x * .2
	image.offset_right = -size.x * .2
	image.offset_top = size.y * .03
	image.offset_bottom = -size.y * .03
	image.modulate.a = 0.0
	cover.add_child(image)
	var reveal := create_tween()
	reveal.tween_property(image, "modulate:a", 1.0, .65)
	reveal.tween_interval(1.8)
	reveal.tween_property(cover, "modulate:a", 0.0, .3)
	reveal.tween_callback(cover.queue_free)
	reveal.tween_callback(_animate_intro)

func _label(text: String, font_size: int, color: Color) -> Label:
	var node := Label.new()
	node.text = text
	node.add_theme_font_size_override("font_size",font_size)
	node.add_theme_color_override("font_color",color)
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return node

func _build_menu() -> void:
	var bg := MenuBackdrop.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	move_child(bg,0)
	_hero = Control.new()
	_hero.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_hero)
	var tag := _label("RANCHO // FRONTERA 01",15,Color("7de1cc"))
	tag.name = "Tag"
	_hero.add_child(tag)
	var title := _label("GO RODEO\nGO",74,Color("f8edce"))
	title.name = "Logo"
	title.add_theme_font_override("font",preload("res://art/ui/fonts/RodeoDisplay.ttf"))
	title.add_theme_constant_override("line_spacing",-18)
	_hero.add_child(title)
	var desc := _label("DOMINA EL LAZO.\nASEGURA EL RANCHO.",19,Color("adc5c6"))
	desc.name = "Description"
	_hero.add_child(desc)
	_play = Button.new()
	_play.text = "JUGAR   >   NIVEL %02d" % _next_level
	_play.add_theme_font_size_override("font_size",23)
	_play.add_theme_font_override("font",preload("res://art/ui/fonts/RodeoDisplay.ttf"))
	_play.add_theme_color_override("font_color",Color("10252d"))
	_play.add_theme_stylebox_override("normal",RanchTheme.box(Color("8de8cf"),Color("b3f6df"),8))
	_play.add_theme_stylebox_override("hover",RanchTheme.box(Color("c3ffe9"),Color("ffffff"),8))
	_play.pressed.connect(_on_level_selected.bind(_next_level))
	_hero.add_child(_play)
	_missions = Button.new()
	_missions.text = "EXPLORAR LOS 20 NIVELES"
	_missions.add_theme_font_size_override("font_size",16)
	_missions.pressed.connect(_show_levels)
	_hero.add_child(_missions)
	_caption = _label("%02d / 20 COMPLETADOS     ·     RODEO + CORRALES" % SaveData.highest_level_completed,14,Color("85a9ad"))
	_hero.add_child(_caption)
	if SaveData.highest_level_completed >= PlayerUpgrades.LONG_DODGE_UNLOCK_LEVEL:
		_caption.text += "   ·   REGATE LARGO"
	var rider_host := Node2D.new()
	_hero.add_child(rider_host)
	var p := Polygon2D.new()
	rider_host.add_child(p)
	var swap := SpriteSwap.new(rider_host,p,"res://art/player/",["walk_diag_down"])
	swap.play("walk_diag_down")
	_rider = swap._sprite
	rider_host.name = "Rider"
	_rider.hide()
	_hd_rider = HDRiderIdle.new()
	_hd_rider.texture = preload("res://art/ui/hero/rider_hd.png")
	_hd_rider.position = Vector2(0,0)
	_hd_rider.scale = Vector2.ONE * .51
	rider_host.add_child(_hd_rider)
	var bull_host := Node2D.new()
	_hero.add_child(bull_host)
	var b := Polygon2D.new()
	bull_host.add_child(b)
	var bull_swap := SpriteSwap.new(bull_host,b,"res://art/bull/",["flee_diag_down"])
	bull_swap.play("flee_diag_down")
	_bull = bull_swap._sprite
	bull_host.hide()
	bull_host.name = "Bull"
	var footer := _label("IZQUIERDA  MOVER    /    DERECHA  LAZO    /    DOBLE TOQUE  LIBERAR",13,Color("78979d"))
	footer.name = "Footer"
	add_child(footer)
	quit_button.reparent(self)
	quit_button.text = "SALIR"
	quit_button.pressed.connect(_on_quit_pressed)
	_drawer = Panel.new()
	_drawer.theme = theme
	_drawer.add_theme_stylebox_override("panel",RanchTheme.box(Color("10252e"),Color("47727a"),14))
	add_child(_drawer)
	var heading := _label("ELIGE TU SIGUIENTE RETO",24,Color("f8edce"))
	heading.position = Vector2(24,18)
	_drawer.add_child(heading)
	var close := Button.new()
	close.text = "VOLVER"
	close.position = Vector2(24,62)
	close.size = Vector2(140,44)
	close.pressed.connect(_hide_levels)
	_drawer.add_child(close)
	level_grid.reparent(_drawer)
	level_grid.columns = 5
	level_grid.add_theme_constant_override("h_separation",10)
	level_grid.add_theme_constant_override("v_separation",10)
	for number in range(1,21):
		var button := Button.new()
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		button.custom_minimum_size = Vector2(0,58)
		button.disabled = not LevelProgression.is_unlocked(number,SaveData.highest_level_completed,OS.is_debug_build())
		button.text = "%02d\n%s" % [number,"RODEO" if number <=10 else "CORRALES"]
		button.pressed.connect(_on_level_selected.bind(number))
		level_grid.add_child(button)
	_drawer.hide()
	_hero.modulate.a = 0

func _layout() -> void:
	if _hero == null: return
	var k: float = minf(size.x/1280.0,size.y/720.0)
	_hero.position = Vector2((size.x-1280*k)/2, (size.y-720*k)/2)
	_hero.scale = Vector2.ONE*k
	_hero.size = Vector2(1280,720)
	_hero.get_node("Tag").position = Vector2(68,70)
	_hero.get_node("Logo").position = Vector2(64,112)
	_hero.get_node("Description").position = Vector2(70,310)
	_play.position = Vector2(68,411)
	_play.size = Vector2(418,70)
	_missions.position = Vector2(68,498)
	_missions.size = Vector2(418,54)
	_caption.position = Vector2(70,580)
	_hero.get_node("Rider").position = Vector2(912,355)
	_hero.get_node("Rider").scale = Vector2.ONE
	_hero.get_node("Bull").position = Vector2(1056,466)
	_hero.get_node("Bull").scale = Vector2(2.3,2.3)
	var footer: Control = get_node("Footer")
	footer.position = Vector2(32,size.y-35)
	quit_button.position = Vector2(size.x-118,22)
	quit_button.size = Vector2(90,44)
	_drawer.position = Vector2(32,22)
	_drawer.size = size-Vector2(64,68)
	level_grid.position = Vector2(24,120)
	level_grid.size = _drawer.size-Vector2(48,144)

func _animate_intro() -> void:
	_intro = create_tween().set_parallel(true)
	_intro.tween_property(_hero,"modulate:a",1.0,.6)
	var target: Vector2 = _hero.position
	_hero.position.x -= 90
	_intro.tween_property(_hero,"position",target,.85).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	for index in range(2):
		var animal: Node2D = _hero.get_node("Rider" if index == 0 else "Bull")
		animal.modulate.a = 0.0
		_intro.tween_property(animal, "modulate:a", 1.0, .55).set_delay(.2 + index * .18)
	for index in range(2):
		var button: Button = _play if index == 0 else _missions
		var final: Vector2 = button.position
		button.position.x -= 200
		button.modulate.a = 0
		_intro.tween_property(button,"position",final,.65).set_delay(.25+index*.13).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		_intro.tween_property(button,"modulate:a",1.0,.5).set_delay(.25+index*.13)

func _process(delta: float) -> void:
	_elapsed += delta
	if is_instance_valid(_bull):
		_bull.position.y = sin(_elapsed*2+.8)*2

func _show_levels() -> void:
	_drawer.show()
	_drawer.modulate.a = 0
	create_tween().tween_property(_drawer,"modulate:a",1.0,.22)
	level_grid.get_child(0).grab_focus()
func _hide_levels() -> void:
	_drawer.hide()
	_missions.grab_focus()
func _on_level_selected(number: int) -> void:
	if _transitioning: return
	_transitioning = true
	GameState.selected_level = number
	get_tree().change_scene_to_file("res://src/Presentation/level_0.tscn")
func _on_quit_pressed() -> void: get_tree().quit()
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if is_instance_valid(_drawer) and _drawer.visible: _hide_levels()
		else: _on_quit_pressed()
