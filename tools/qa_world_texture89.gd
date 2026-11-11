extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://world-texture89-only.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_edits=[];SaveData.world_position=Vector2(100,180);SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(.4).timeout
 world.process_mode=Node.PROCESS_MODE_DISABLED;world._hud.visible=false;world._marker.visible=false
 var camera=Camera2D.new();world.add_child(camera);camera.make_current();camera.position=Vector2(300,220);camera.zoom=Vector2.ONE
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/mundo-textura89-"+OS.get_environment("TEXTURE_LABEL")+".png")
 camera.position=Vector2(500,400);camera.zoom=Vector2.ONE*1.6
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/mundo-textura89-cerca-"+OS.get_environment("TEXTURE_LABEL")+".png")
 get_tree().quit()
