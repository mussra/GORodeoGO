extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);SaveData.save_path="user://florist-preview-only.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_edits=[];SaveData.world_position=Vector2(580,500);SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false);world.player.visible=false;world._hud.visible=false
 var camera=Camera2D.new();camera.position=Vector2(650,340);camera.zoom=Vector2(2.5,2.5);world.add_child(camera);camera.make_current()
 await get_tree().create_timer(1).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/florista-tienda-preview83.png")
 camera.position=Vector2(400,310);camera.zoom=Vector2(1.15,1.15)
 await get_tree().create_timer(.5).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/florista-camino-preview83.png")
 camera.position=Vector2(-20,-40);camera.zoom=Vector2(1.5,1.5)
 await get_tree().create_timer(.5).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/road-ranch-junction84.png")
 get_tree().quit()
