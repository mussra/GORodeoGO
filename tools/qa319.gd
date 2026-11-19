extends Control
func _ready():run.call_deferred()
func shot319(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/'+name_+'.png')
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true
 var intro:=StoryIntro319.new();intro.persist319=false;add_child(intro)
 await get_tree().create_timer(.75).timeout
 await shot319('intro319-partial')
 intro.body319.finish319();await get_tree().process_frame;await shot319('intro319-complete')
 intro.page319=1;intro._page319();await get_tree().create_timer(1.5).timeout;await shot319('intro319-horse-a')
 await get_tree().create_timer(1.7).timeout;intro.body319.finish319();await get_tree().process_frame;await shot319('intro319-horse-b')
 intro.page319=4;intro._page319();await get_tree().create_timer(1.1).timeout;intro.body319.finish319();await get_tree().process_frame;await shot319('intro319-hat-a')
 await get_tree().create_timer(.9).timeout;intro.body319.finish319();await get_tree().process_frame;await shot319('intro319-hat-b')
 intro.queue_free();await get_tree().process_frame
 var panel:=NpcDialog.new();panel.setup_story('Granjero','Después de la carrera','Gracias por ayudarme. Habla con los vecinos y sigue los caminos para encontrar nuevos pueblos y descubrir otras pruebas a caballo.');add_child(panel)
 await get_tree().create_timer(.8).timeout;await shot319('dialogue319-partial')
 await get_tree().create_timer(3.).timeout;await shot319('dialogue319-complete')
 panel.queue_free();await get_tree().process_frame
 get_tree().quit()
