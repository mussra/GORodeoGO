extends Control
func shot323(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/'+name_+'.png')
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true;SaveData.save_path='user://qa323-guides-only.cfg';SaveData.story_intro319=true;SaveData.rodeo_intro240=true
 SaveData.world_quests={'farmer_pigs':{'status':'done','count':3,'events':['a','b','c']}};GameState.rodeo_guide323=false
 var menu=load('res://src/Presentation/main_menu.tscn').instantiate();add_child(menu)
 await get_tree().create_timer(1.).timeout;menu._rodeo_menu323();await get_tree().create_timer(.4).timeout;await shot323('tutorial323-games')
 var guide:TutorialGuide323
 for child in menu.get_children():
  if child is TutorialGuide323:guide=child
 guide.go323.pressed.emit();await get_tree().create_timer(.7).timeout;await shot323('tutorial323-rodeo')
 for child in menu.get_children():
  if child is TutorialGuide323:guide=child
 guide.go323.pressed.emit();await get_tree().create_timer(.7).timeout;await shot323('tutorial323-level1')
 menu.free()
 SaveData.world_quests={};SaveData.country_ledger146={};SaveData.world_generator_version=3;SaveData.world_seed=752026;SaveData.world_position=WorldNominal98.home()
 var world=load('res://src/Presentation/frontier_world.tscn').instantiate();GameState.controls_world323=true;add_child(world)
 await get_tree().create_timer(10.).timeout;await shot323('tutorial323-encargos');world.free();get_tree().quit()
