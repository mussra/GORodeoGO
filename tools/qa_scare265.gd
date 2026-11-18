extends Node
func _ready():run.call_deferred()
func shot(label_:String):
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/scare265-"+label_+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");GameState.sound_enabled=false;GameState.brand_intro_played=true;SaveData.save_path="user://qa265scratch.cfg";SaveData.horse_collection.seed_trial();SaveData.equipment_owned.append("scare_whip265");SaveData.equipment_equipped.scare_whip="scare_whip265"
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_position=Vector2(1800,1000)
 var world=load("res://tools/perf_world242.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 if world._arrival244.active:world._arrival244.finish(false)
 world._arrival244.set_process(false);await get_tree().create_timer(3.).timeout
 var button:ScareButton265=world._hud.get_node("ScareButton265");assert(button.visible);await shot("ready")
 var e:=InputEventMouseButton.new();e.position=button.get_global_rect().get_center();e.button_index=MOUSE_BUTTON_LEFT;e.pressed=true;Input.parse_input_event(e);Input.flush_buffered_events();await get_tree().process_frame;e=e.duplicate();e.pressed=false;Input.parse_input_event(e);Input.flush_buffered_events();await get_tree().create_timer(.2).timeout;assert(button.cooldown265>0.);await shot("cooldown")
 world.free();get_tree().quit()
