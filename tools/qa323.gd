extends Control
func _ready():run.call_deferred()
func shot323(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/'+name_+'.png')
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path='user://qa323-only.cfg'
 var intro:=StoryIntro319.new();intro.persist319=false;add_child(intro)
 await get_tree().create_timer(.8).timeout
 intro.page319=6;intro._page319()
 await get_tree().create_timer(6.).timeout;await shot323('tutorial323-left')
 intro.tutorial323.press323(Vector2(90,220));intro.tutorial323.drag323(Vector2(140,190));await get_tree().create_timer(.6).timeout;intro.tutorial323.release323()
 intro.next319.pressed.emit()
 await get_tree().create_timer(6.).timeout;await shot323('tutorial323-right')
 intro.tutorial323.press323(Vector2(280,225));intro.tutorial323.drag323(Vector2(365,180));await get_tree().create_timer(.5).timeout;await shot323('tutorial323-aim');intro.tutorial323.release323()
 await get_tree().create_timer(1.).timeout;intro.free()
 var menu=load('res://src/Presentation/main_menu.tscn').instantiate();SaveData.story_intro319=true;GameState.rodeo_guide323=false;add_child(menu)
 await get_tree().create_timer(.8).timeout;menu._frontier_guide323()
 await get_tree().create_timer(.5).timeout;await shot323('tutorial323-frontier')
 menu.free();get_tree().quit()
