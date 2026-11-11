extends Node
func _ready():run.call_deferred()
func run():
 process_mode=Node.PROCESS_MODE_ALWAYS
 get_tree().root.size=Vector2i(1598,720)
 SaveData.save_path="user://modular93-menu-only.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_edits=[];SaveData.world_position=Vector2(100,180);SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(.7).timeout
 world._open_navigation()
 await get_tree().create_timer(.5,true).timeout
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/mapa-modular93-menu.png")
 get_tree().paused=false;get_tree().quit()
