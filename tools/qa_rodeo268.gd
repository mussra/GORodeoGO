extends Node
func _ready():run.call_deferred()
func shot(label_:String):
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/rodeo268-"+label_+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");GameState.sound_enabled=false;GameState.brand_intro_played=true;SaveData.save_path="user://qa265scratch.cfg";SaveData.horse_collection.seed_trial();SaveData.equipment_owned.append("scare_whip265");SaveData.equipment_equipped.scare_whip="scare_whip265"
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_position=Vector2(1800,1000)
 var world=load("res://tools/perf_world242.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 if world._arrival244.active:world._arrival244.finish(false)
 world._arrival244.set_process(false);await get_tree().create_timer(3.).timeout
 SaveData.world_quests={"farmer_pigs":{"status":"done","count":3,"events":["a","b","c"]}};SaveData.rodeo_intro240=false
 world._maybe_offer_rodeo268();assert(world._npc_dialog is RodeoOffer268)
 await get_tree().create_timer(.3).timeout;await shot("dialogo")
 world._npc_dialog.closed.emit();assert(SaveData.mode_open240("bulls"));await get_tree().create_timer(.3).timeout;await shot("aceptado")
 world.free();get_tree().quit()
