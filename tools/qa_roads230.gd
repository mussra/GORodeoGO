extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(960,540);TranslationServer.set_locale("es");GameState.brand_intro_played=true
 SaveData.save_path="user://roads230-visual.cfg";SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=4;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_quests={};SaveData.world_missions={};SaveData.world_tamed=[];SaveData.world_discovered=[];SaveData.world_garden212=Garden212.fresh();SaveData.world_roaming139={}
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_position=Vector2(1065,4190)
 ProjectSettings.set_setting("road230/after",true)
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(.4).timeout;world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var camera:Camera2D=get_viewport().get_camera_2d();camera.position=Vector2(-200,-200);camera.zoom=Vector2.ONE*1.4
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 var suffix:String="after" if ProjectSettings.get_setting("road230/after",false) else "before"
 get_viewport().get_texture().get_image().save_png("/downloads/roads230-world-"+suffix+"-960.png")
 world.free();get_tree().quit()
