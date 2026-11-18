extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");GameState.sound_enabled=false
 var room:=FloristRoom262.new();add_child(room);await get_tree().create_timer(.2).timeout
 room.objects.get_child(0).pressed.emit();await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/floristeria262-prototipo.png")
 room._talk();await get_tree().create_timer(.1).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/floristeria262-conversacion.png")
 room.finish();await get_tree().process_frame;get_tree().quit()
