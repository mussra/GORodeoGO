extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1598,720)
 SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/modular_world93.tscn").instantiate();add_child(world)
 await get_tree().create_timer(.8).timeout
 world.process_mode=Node.PROCESS_MODE_DISABLED
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/mapa-modular93-"+("oscuro" if world.dark else "claro")+".png")
 get_tree().quit()
