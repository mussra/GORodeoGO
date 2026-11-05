extends SceneTree
func _initialize()->void:call_deferred("setup")
func setup()->void:
 var save=root.get_node("SaveData")
 var old:int=save.highest_level_completed
 save.highest_level_completed=0
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();root.add_child(menu)
 await create_timer(3.5).timeout
 menu._show_levels()
 await create_timer(.4).timeout
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/gorodeo/whip-level-locks.png")
 menu.free();save.highest_level_completed=10
 menu=load("res://src/Presentation/main_menu.tscn").instantiate();root.add_child(menu)
 await create_timer(3.5).timeout
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/gorodeo/whip-earned-menu.png")
 save.highest_level_completed=old
 quit()
