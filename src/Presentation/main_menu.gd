extends Control

@onready var level_grid: GridContainer = $LevelGrid
var level_scroll173:ScrollContainer
@onready var quit_button: Button = $QuitButton
var _settings_button:Button
var _book256:Button
var _hero: Control
var _drawer: Panel
var _play: Button
var _equipment_button:Button
var _world_button:Button
var _equipment_panel:EquipmentPanel
var _missions: Button
var _caption: Label
var _equipment_caption: Label
var _jump_badge:JumpBadge
var _dodge_badge:JumpBadge
var _skill_column189:Control
var _hd_rider: Sprite2D
var _bull: AnimatedSprite2D
var _intro: Tween
var _elapsed: float = 0.0
var _transitioning: bool = false
var _games213:NavigationSheet
var _next_level: int = 1
const GAMES213=[
 {"id":"bulls","icon223":"res://art/ui/game_bulls223.png","title":"Rodeo de toros","hint":"40 niveles · toros y corrales"},
 {"id":"race","icon223":"res://art/ui/game_race223.png","title":"Carreras","hint":"Circuito / Copa · piloto"},
 {"id":"duel","icon223":"res://art/ui/game_duel223.png","title":"Duelo de lazos","hint":"Captura a tu rival"},
 {"id":"joust","icon223":"res://art/ui/game_joust223.png","title":"Justa con lazos","hint":"Cruce a caballo y lazo"},
 {"id":"memory","icon223":"res://art/ui/game_memory223.png","title":"Hípica de memoria","hint":"Mira, recuerda y salta"}]
const ROUTES213={"race":"res://src/Presentation/race190.tscn","duel":"res://src/Presentation/duel193.tscn","joust":"res://src/Presentation/joust196.tscn","memory":"res://src/Presentation/jump_memory207.tscn"}

func _ready() -> void:
	MenuInputGuard.install(self)
	SaveData.end_trial_session() # returning to menu always restores real state
	RanchMusic.set_paused(false)
	RanchMusic.set_enabled(GameState.sound_enabled)
	RanchMusic.play_context("menu")
	GameState.menu_scene = scene_file_path
	theme = RanchTheme.create()
	$Title.hide()
	_next_level = 1 if SaveData.debug_mode else mini(SaveData.highest_level_completed + 1, LevelCatalog.MAX_LEVEL)
	_build_menu()
	ButtonSkin272.tree(self)
	ButtonSkin272.apply(_play,true)
	resized.connect(_layout)
	_layout()
	call_deferred("_begin_brand_intro")

## The logo reveal precedes the existing staggered menu entrance once per process.
func _begin_brand_intro() -> void:
	if GameState.brand_intro_played:
		_after_brand319()
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
	reveal.tween_callback(_after_brand319)

func _label(text: String, font_size: int, color: Color) -> Label:
	var node := Label.new()
	node.text = text
	node.add_theme_font_size_override("font_size",font_size)
	node.add_theme_color_override("font_color",color)
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return node

func _build_menu() -> void:
	var bg := MenuBackdrop.new()
	bg.art_mode300="main"
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	move_child(bg,0)
	_hero = Control.new()
	_hero.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_hero)
	var tag := _label(tr("UI_000"),15,Color("7de1cc"))
	tag.name = "Tag"
	_hero.add_child(tag)
	var title := TextureRect.new()
	title.name="Logo";title.texture=load("res://art/ui/logo304/logo.png");title.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;title.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;title.mouse_filter=Control.MOUSE_FILTER_IGNORE
	_hero.add_child(title)
	var desc := _label(tr("UI_001"),19,Color("adc5c6"))
	desc.name = "Description"
	_hero.add_child(desc)
	_play = Button.new()
	_play.text = "JUEGOS"
	_play.add_theme_font_size_override("font_size",23)
	_play.add_theme_font_override("font",preload("res://art/ui/fonts/RodeoDisplay.ttf"))
	_play.add_theme_color_override("font_color",Color("10252d"))
	_play.add_theme_stylebox_override("normal",RanchTheme.box(Color("8de8cf"),Color("b3f6df"),8))
	_play.add_theme_stylebox_override("hover",RanchTheme.box(Color("c3ffe9"),Color("ffffff"),8))
	_play.text="JUEGOS"
	_play.pressed.connect(_show_games213)
	_hero.add_child(_play)
	_missions = Button.new()
	_missions.text = tr("UI_003");_missions.hide()
	_missions.add_theme_font_size_override("font_size",16)
	_missions.pressed.connect(_show_levels)
	_hero.add_child(_missions)
	_caption = _label("%02d / %02d COMPLETADOS     ·     RODEO DE TOROS" % [SaveData.highest_level_completed,LevelCatalog.MAX_LEVEL],14,Color("85a9ad"))
	_hero.add_child(_caption)
	_equipment_button=Button.new()
	_equipment_button.text=tr("UI_004")
	_equipment_button.pressed.connect(_show_equipment)
	_hero.add_child(_equipment_button)
	_world_button=Button.new()
	_world_button.text=tr("WORLD_ENTER")
	_world_button.add_theme_font_size_override("font_size",18)
	_world_button.pressed.connect(func():
		if _transitioning:return
		_transitioning=true
		FrontierTransition.obtain(get_tree(),false).enter_world())
	_hero.add_child(_world_button)
	MenuEntryArt189.apply(_world_button,"frontier")
	MenuEntryArt189.apply(_missions,"levels")
	_equipment_panel=EquipmentPanel.new()
	_equipment_panel.visible=false
	add_child(_equipment_panel)
	_equipment_panel.closed.connect(_refresh_points_caption)
	_settings_button=Button.new();_settings_button.text=tr("UI_035");_settings_button.position=Vector2(1000,70);_settings_button.size=Vector2(210,48);_settings_button.pressed.connect(_show_settings);_hero.add_child(_settings_button)
	_book256=Button.new();_book256.name="BreedingBook256";_book256.text="Libro de crianza";_book256.position=Vector2(760,70);_book256.size=Vector2(210,48);_hero.add_child(_book256);_book256.pressed.connect(func():add_child(BreedingBook256.new()))
	_refresh_points_caption()
	var rider_host := Node2D.new()
	_hero.add_child(rider_host)
	rider_host.name = "Rider"
	_hd_rider = Sprite2D.new()
	HorsePortrait.apply(_hd_rider,SaveData.horse_collection.find(SaveData.horse_collection.selected).traits,SaveData.hat_color);HorseGalaxyLook.configure_portrait(_hd_rider.material,SaveData.horse_collection.find(SaveData.horse_collection.selected))
	_hd_rider.position = Vector2(0,0)
	_hd_rider.scale = Vector2.ONE * .45
	rider_host.add_child(_hd_rider)
	_skill_column189=Control.new();_skill_column189.name="MountedSkills189";_skill_column189.mouse_filter=Control.MOUSE_FILTER_IGNORE;_hero.add_child(_skill_column189)
	_jump_badge=JumpBadge.new();_jump_badge.position=Vector2.ZERO;_jump_badge.size=Vector2(64,56);_jump_badge.capable=HorseJump.capable(SaveData.horse_collection.find(SaveData.horse_collection.selected));_skill_column189.add_child(_jump_badge)
	_dodge_badge=JumpBadge.new();_dodge_badge.skill="dodge";_dodge_badge.position=Vector2(0,80);_dodge_badge.size=Vector2(64,56);_dodge_badge.capable=HorseTraining.knows(SaveData.horse_collection.find(SaveData.horse_collection.selected),"dodge");_skill_column189.add_child(_dodge_badge)
	_equipment_caption = _label("",16,Color("9cbcc0"))
	_equipment_caption.position=Vector2(690,610)
	_hero.add_child(_equipment_caption)
	_refresh_points_caption()
	var footer := _label(tr("UI_006"),13,Color("78979d"))
	footer.name = "Footer"
	add_child(footer)
	quit_button.reparent(self)
	quit_button.text = tr("UI_007")
	quit_button.pressed.connect(_on_quit_pressed)
	_drawer = Panel.new()
	ButtonSkin272.panel(_drawer)
	_drawer.theme = theme
	_drawer.add_theme_stylebox_override("panel",RanchTheme.box(Color("10252e"),Color("47727a"),14))
	add_child(_drawer)
	var heading := _label(tr("UI_008"),24,Color("f8edce"))
	heading.position = Vector2(24,18)
	_drawer.add_child(heading)
	var close := Button.new()
	close.text = tr("UI_009")
	close.position = Vector2(24,62)
	close.size = Vector2(140,44)
	close.pressed.connect(_hide_levels)
	_drawer.add_child(close)
	level_scroll173=ScrollContainer.new();level_scroll173.name="CampaignScroll173";level_scroll173.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;_drawer.add_child(level_scroll173)
	level_grid.reparent(level_scroll173);level_grid.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	level_grid.columns = 5
	level_grid.add_theme_constant_override("h_separation",10)
	level_grid.add_theme_constant_override("v_separation",10)
	for number in range(1,LevelCatalog.MAX_LEVEL+1):
		var button := Button.new()
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		button.custom_minimum_size = Vector2(0,58)
		button.disabled = not LevelProgression.is_unlocked(number,SaveData.effective_progress())
		button.text = "%02d\n%s" % [number,(tr("UI_010") if button.disabled else (tr("UI_011") if number <=10 else tr("UI_012")))]
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
	_hero.get_node("Logo").position = Vector2(64,98)
	_hero.get_node("Logo").size = Vector2(440,235)
	_hero.get_node("Description").position = Vector2(70,348)
	_play.position = Vector2(68,411)
	_play.size = Vector2(418,70)
	MenuEntryArt189.apply(_play,"levels")
	_world_button.position = Vector2(68,493)
	_world_button.size = Vector2(418,64)
	_world_button.add_theme_font_size_override("font_size",22)
	_missions.position = Vector2(68,569)
	_missions.size = Vector2(270,60)
	_missions.add_theme_font_size_override("font_size",15)
	_missions.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	_equipment_button.position=Vector2(68,569)
	_equipment_button.size=Vector2(418,60)
	_caption.position = Vector2(70,634)
	_hero.get_node("Rider").position = Vector2(912,376)
	_hero.get_node("Rider").scale = Vector2.ONE
	_skill_column189.position=Vector2(1170,245)
	_skill_column189.size=Vector2(64,136)
	var footer: Control = get_node("Footer")
	footer.position = Vector2(32,size.y-35)
	quit_button.position = Vector2(size.x-118,22)
	quit_button.size = Vector2(90,44)
	_drawer.position = Vector2(32,22)
	_drawer.size = size-Vector2(64,68)
	level_scroll173.position = Vector2(24,120)
	level_scroll173.size = _drawer.size-Vector2(48,144)

func _animate_intro() -> void:
	# Ant 22:50 ("que aparezca todo homogéneo"): ONE shared entrance for the whole
	# menu — every element fades in together over the same .6s, same easing, no
	# staggered delays; the hero block keeps a single gentle group slide.
	modulate.a = 0.0
	_hero.modulate.a = 0.0
	_intro = create_tween().set_parallel(true)
	_intro.tween_property(self,"modulate:a",1.0,.6)
	_intro.tween_property(_hero,"modulate:a",1.0,.6)
	var target: Vector2 = _hero.position
	_hero.position.x -= 90
	_intro.tween_property(_hero,"position",target,.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _process(delta: float) -> void:
	_elapsed += delta
	if is_instance_valid(_bull):
		_bull.position.y = sin(_elapsed*2+.8)*2

func _show_levels() -> void:
	if not SaveData.mode_open240("bulls"):_show_games213();return
	_drawer.show()
	_drawer.modulate.a = 0
	create_tween().tween_property(_drawer,"modulate:a",1.0,.22)
	var target:int=clampi(_next_level-1,0,level_grid.get_child_count()-1)
	var next:Control=level_grid.get_child(target)
	level_scroll173.ensure_control_visible.call_deferred(next)
	if next.focus_mode!=Control.FOCUS_NONE and not next.disabled:next.grab_focus()
func _hide_levels() -> void:
	_drawer.hide()
	_show_games213()
func _on_level_selected(number: int) -> void:
	if not SaveData.mode_open240("bulls"):return
	if _transitioning or not LevelProgression.is_unlocked(number, SaveData.effective_progress()): return
	_transitioning = true
	GameState.selected_level = number
	get_tree().change_scene_to_file("res://src/Presentation/level_0.tscn")
func _on_quit_pressed()->void:GameState.confirm_exit()
func navigate_back()->void:
	if is_instance_valid(_games213):_games213.queue_free();_games213=null
	elif is_instance_valid(_drawer) and _drawer.visible:_hide_levels()
	else:GameState.confirm_exit()

func _refresh_points_caption()->void:
	if is_instance_valid(_dodge_badge):
		_dodge_badge.capable=HorseTraining.knows(SaveData.horse_collection.find(SaveData.horse_collection.selected),"dodge");_dodge_badge.queue_redraw()
	if is_instance_valid(_jump_badge):
		_jump_badge.capable=HorseJump.capable(SaveData.horse_collection.find(SaveData.horse_collection.selected));_jump_badge.queue_redraw()
	if is_instance_valid(_equipment_caption):
		var id:String=SaveData.equipment_equipped.get("whip","")
		_equipment_caption.text=tr("UI_013")+(str(EquipmentCatalog.ITEMS[id].name) if EquipmentCatalog.ITEMS.has(id) else tr("UI_014"))
	if is_instance_valid(_hd_rider):HorsePortrait.apply(_hd_rider,SaveData.horse_collection.find(SaveData.horse_collection.selected).traits,SaveData.hat_color);HorseGalaxyLook.configure_portrait(_hd_rider.material,SaveData.horse_collection.find(SaveData.horse_collection.selected))
	_caption.text="%02d / %02d COMPLETADOS · %d PUNTOS"%[SaveData.highest_level_completed,LevelCatalog.MAX_LEVEL,SaveData.equipment_points]

func _show_equipment()->void:
	_equipment_panel.refresh()
	_equipment_panel.show()

func _show_settings()->void:
	var panel:=Control.new();panel.name="Settings213";panel.set_meta("background300","content");MenuInputGuard.install(panel);panel.set_meta("back_closes",true);panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);panel.z_index=90;add_child(panel)
	var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);panel.add_child(bg)
	var content:=Control.new();var k:=minf(size.x/1280.,size.y/720.);content.scale=Vector2.ONE*k;content.position=(size-Vector2(1280,720)*k)*.5;panel.add_child(content)
	var scroll:=ScrollContainer.new();scroll.position=Vector2(60,40);scroll.size=Vector2(1160,640);content.add_child(scroll)
	var box:=VBoxContainer.new();box.custom_minimum_size=Vector2(700,0);box.add_theme_constant_override("separation",14);scroll.add_child(box)
	var title:=Label.new();title.text=tr("UI_035");title.add_theme_font_size_override("font_size",30);box.add_child(title)
	var language:=Label.new();language.text=tr("UI_036");box.add_child(language)
	var pick:=OptionButton.new();pick.custom_minimum_size=Vector2(400,56);box.add_child(pick)
	for text in [tr("UI_037"),"Español","English"]:pick.add_item(text)
	pick.selected=["auto","es","en"].find(Localization.choice)
	var note:=Label.new();note.text=tr("UI_040");box.add_child(note)
	var movement_title:=Label.new();movement_title.text="Control de movimiento";box.add_child(movement_title)
	var movement:=OptionButton.new();movement.name="MovementMode258";movement.custom_minimum_size=Vector2(700,56);movement.add_item("Actual · el mando sigue al dedo");movement.add_item("Anclado · centro fijo donde tocas");movement.selected=1 if GameState.anchored_movement258 else 0;box.add_child(movement)
	var movement_note:=Label.new();movement_note.text="Anclado: arrastra desde el toque inicial. Suelta para parar.
El lazo sigue disponible con el otro dedo.";box.add_child(movement_note)
	movement.item_selected.connect(func(i:int):
		if not GameState.set_movement258(i==1):movement_note.text="No se pudo guardar el control. Inténtalo de nuevo.")
	if GameState.trial_tools_enabled():
		var osd:=CheckButton.new();osd.name="PerformanceToggle245";osd.text="Mostrar rendimiento (OSD)";osd.custom_minimum_size.y=56;osd.button_pressed=GameState.performance_osd245;box.add_child(osd);osd.toggled.connect(GameState.set_performance_osd245)
		var debug:=Button.new();debug.text="Herramientas DEBUG";debug.custom_minimum_size.y=56;box.add_child(debug);debug.pressed.connect(_show_debug213)
	var replay319:=Button.new();replay319.text="Volver a ver la introducción";replay319.custom_minimum_size.y=52;box.add_child(replay319);replay319.pressed.connect(func():_show_story319(false))
	var close:=Button.new();close.text=tr("UI_009");close.custom_minimum_size.y=52;box.add_child(close);close.pressed.connect(panel.queue_free)
	ButtonSkin272.tree(panel)
	pick.item_selected.connect(func(i:int):
		if Localization.set_choice(["auto","es","en"][i]):get_tree().reload_current_scene()
		else:note.text=tr("UI_041"))

func _show_games213()->void:
	if is_instance_valid(_games213):return
	_games213=NavigationSheet.new();_games213.title="JUEGOS";_games213.entries=GAMES213.duplicate(true)
	for entry in _games213.entries:
		if not SaveData.mode_open240(entry.id):
			entry.hint=ModeAccess240.current_card268(entry.id,SaveData.world_quests)
			entry.locked251=true
			_games213.keep_open250.append(entry.id)
		entry.compact250=true
	_games213.entries.append({"id":"crowns240","icon223":"res://art/ui/crowns241/round/cup.png","compact250":true,"title":"Coronas y victorias","hint":"Tus resultados · tipos de corona"})
	var next240:String="Todos los modos disponibles. Completa tus coronas."
	for mode in ["bulls","race","duel","joust","memory"]:
		if not SaveData.mode_open240(mode):next240="Siguiente paso: "+ModeAccess240.current_requirement268(mode,SaveData.world_quests);break
	_games213.access_note239=next240+"\nParámetros de progresión en prueba. Coronas y victorias: sexta tarjeta."
	_games213.tree_exited.connect(_guard_recheck213);_games213.selected.connect(_choose_game213);_games213.closed.connect(func():_games213=null);add_child(_games213)
func _choose_game213(id:String)->void:
	if id!="crowns240" and not SaveData.mode_open240(id):
		_games213.show_requirement250(ModeAccess240.current_requirement268(id,SaveData.world_quests));return
	_games213=null
	if id=="crowns240":add_child(ModeCrowns240.new());return
	if not SaveData.mode_open240(id):_show_games213();return
	if id=="bulls":_show_levels();return
	if ROUTES213.has(id):_launch213(ROUTES213[id])
func _launch213(path:String)->void:
	if _transitioning:return
	_transitioning=true;get_tree().change_scene_to_file(path)
func _show_debug213()->void:
	if not GameState.trial_tools_enabled():return
	var panel:=NavigationSheet.new();panel.title="DEBUG · herramientas separadas"
	panel.entries=[{"id":"mode","title":"Cambiar modo","hint":"Actual: "+("DEBUG" if SaveData.debug_mode else "normal")},{"id":"tools","title":"Caballos y niveles","hint":"Solo en modo DEBUG"}]
	panel.selected.connect(func(id:String):
		if id=="mode":
			if SaveData.switch_mode(not SaveData.debug_mode):get_tree().reload_current_scene()
		elif id=="tools" and SaveData.debug_mode:add_child(load("res://src/Presentation/trial_panel.gd").new()))
	add_child(panel)

func _guard_recheck213()->void:
	for child in get_children():
		if child is MenuInputGuard:child._mark()

func _after_brand319()->void:
	_animate_intro()
	if not SaveData.story_intro319:_show_story319(true)
func _show_story319(persist_:bool=false)->void:
	if get_node_or_null("StoryIntro319")!=null:return
	var intro319:=StoryIntro319.new();intro319.persist319=persist_;add_child(intro319)
