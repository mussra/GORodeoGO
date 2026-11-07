extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 root.size=Vector2i(1599,719)
 var SD:Node=root.get_node("SaveData")
 SD.save_path="user://emblem-panel-save.dat"
 var c=SD.horse_collection
 c.seed_trial()
 var ep:Control=(load("res://src/Presentation/emblem_panel.gd") as GDScript).new();ep.horse_id=c.horses[0].id
 root.add_child(ep)
 await create_timer(.3).timeout;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/emblem-panel-overflow.png")
 ep.config["letters"]="ALV";ep.config["letters_font"]=0;ep.build()
 await create_timer(.2).timeout;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/emblem-panel-letters.png")
 quit()
