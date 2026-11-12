extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/siesta144-"+name_+".png")
func run():
 process_mode=Node.PROCESS_MODE_ALWAYS;get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa144.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_places144={};SaveData.world_discovered=[];SaveData.world_roaming139={};SaveData.world_tamed=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false);world.set_physics_process(false)
 await get_tree().create_timer(.7,true).timeout
 # A physical visit, not discovery, unlocks the destination.
 var site:Dictionary=world._travel144.candidates()[1];world.player.position=site.pos;world._travel144.visit_clock=0.;world._travel144.record_visits();world.player.position=WorldNominal98.home()
 world._toggle_map();world._travel144.show_sites();await get_tree().create_timer(.25,true).timeout;await shot("sitios")
 world._travel144.sites_panel.queue_free();world._travel144.sites_panel=null
 world._travel144.choose(site.id);await shot("confirmar")
 get_tree().root.size=Vector2i(960,540);await get_tree().process_frame;await shot("confirmar-960")
 get_tree().root.size=Vector2i(1280,720);await get_tree().process_frame
 world._travel144.close_confirmation()
 var timer:=get_tree().create_timer(.25,true);timer.timeout.connect(func():shot("viaje"))
 assert(await world._travel144.start(site.id));world.player.set_physics_process(false);await shot("llegada")
 world._toggle_map();await shot("mapa")
 print("SIESTA144_VISUAL_OK destination=",world.player.position," visited=",SaveData.world_places144.visited)
 get_tree().quit()
