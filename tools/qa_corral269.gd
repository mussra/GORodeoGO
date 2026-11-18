extends Node
func _ready():run.call_deferred()
func shot(label_:String):
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/toros269-"+label_+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");GameState.sound_enabled=false;GameState.brand_intro_played=true;SaveData.save_path="user://qa265scratch.cfg";SaveData.horse_collection.seed_trial();SaveData.equipment_owned.append("scare_whip265");SaveData.equipment_equipped.scare_whip="scare_whip265"
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_position=Vector2(1800,1000)
 var world=load("res://tools/perf_world242.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 if world._arrival244.active:world._arrival244.finish(false)
 world._arrival244.set_process(false);await get_tree().create_timer(3.).timeout
 world._rodeo_offer_shown268=true;SaveData.rodeo_intro240=true
 for i in 9:assert(SaveData.record_bull_return269(10,i))
 var pen:FarmerCorral269=world.get_node("FarmerCorral269");pen.refresh();world.player.position=pen.center+Vector2(-270,220)
 var camera:Camera2D=get_viewport().get_camera_2d();camera.global_position=pen.center+Vector2(60,70);camera.position_smoothing_enabled=false
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 await get_tree().create_timer(.5).timeout;await shot("corral")
 SaveData.load_progress();pen.refresh();assert(pen.actors.size()==6)
 await get_tree().create_timer(.3).timeout;await shot("guardado")
 world.free();get_tree().quit()
