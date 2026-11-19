extends Control
func _ready():run.call_deferred()
func shot320(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/'+name_+'.png')
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true
 var intro:=StoryIntro319.new();intro.persist319=false;add_child(intro)
 await get_tree().create_timer(3.5).timeout
 await shot320('intro320-waiting')
 intro._process(600.);await get_tree().process_frame
 print('AFTER_TEN_MINUTES_SIMULATED page=',intro.page319,' queued=',intro.is_queued_for_deletion())
 await shot320('intro320-still-waiting')
 intro.next319.pressed.emit()
 await get_tree().create_timer(1.).timeout
 await shot320('intro320-after-continue')
 print('AFTER_CONTINUE page=',intro.page319)
 intro.free();get_tree().quit()
