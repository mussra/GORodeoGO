extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1598,720)
 SaveData.save_path="user://qa98-only.dat";SaveData.trial_session_active=true;SaveData.world_seed=0;SaveData.world_generator_version=1;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(.8).timeout
 world.player.set_physics_process(false);world.set_process(false);world.set_physics_process(false)
 var camera=get_viewport().get_camera_2d();camera.get_parent().remove_child(camera);world.add_child(camera);camera.position=Vector2(640,340);camera.make_current()
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/mundo-nominal98.png")
 world._toggle_map()
 await get_tree().create_timer(.3,true).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/mapa-nominal98.png")
 get_tree().quit()
