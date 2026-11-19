extends Control
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false
 SaveData.save_path='user://qa321-only.cfg'
 var book:=BreedingBook256.new();book.page=4;add_child(book)
 await get_tree().create_timer(6.).timeout
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/alma321-real-horses.png')
 book.free();get_tree().quit()
