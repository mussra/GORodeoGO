extends Control
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true;SaveData.save_path='user://qa324-only.cfg'
 var intro:=StoryIntro319.new();intro.persist319=false;add_child(intro)
 await get_tree().create_timer(3.).timeout;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png('/downloads/hoof324-intro.png');intro.free()
 var menu=load('res://src/Presentation/main_menu.tscn').instantiate();SaveData.story_intro319=true;GameState.rodeo_guide323=false;add_child(menu)
 await get_tree().create_timer(1.).timeout;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png('/downloads/hoof324-menu.png');menu.free()
 var panel:=HorsePanel.new();panel.page='breed';SaveData.horse_collection.add_trial_parents();panel.parent_a='trial_a';panel.parent_b='trial_b';add_child(panel)
 await get_tree().create_timer(1.).timeout;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png('/downloads/hoof324-breed.png');get_tree().quit()
