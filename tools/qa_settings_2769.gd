extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 root.size=Vector2i(1280,720)
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();root.add_child(menu)
 await process_frame
 menu._show_settings()
 await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/settings2769.png")
 quit()
