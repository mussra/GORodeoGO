extends Node
func _ready()->void:
 process_mode=Node.PROCESS_MODE_ALWAYS;call_deferred("run")
func capture(path:String)->void:
 await get_tree().create_timer(.8).timeout
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png(path)
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 await get_tree().create_timer(1.2).timeout
 await capture("/downloads/frontier2746-hud.png")
 world._open_navigation()
 await capture("/downloads/frontier2746-menu.png")
 var sheet=world._navigation
 world._navigation_selected("map");sheet.queue_free()
 await capture("/downloads/frontier2746-map.png")
 world._toggle_map();world._toggle_edit()
 await capture("/downloads/frontier2746-editor.png")
 world._open_edit_tools()
 await capture("/downloads/frontier2746-tools.png")
 get_tree().quit()
