extends Node
func _ready():run.call_deferred()
func shot(label_:String):
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/mapa266-"+label_+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");GameState.sound_enabled=false;GameState.brand_intro_played=true;SaveData.save_path="user://qa265scratch.cfg";SaveData.horse_collection.seed_trial();SaveData.equipment_owned.append("scare_whip265");SaveData.equipment_equipped.scare_whip="scare_whip265"
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_position=Vector2(1800,1000)
 var world=load("res://tools/perf_world242.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 if world._arrival244.active:world._arrival244.finish(false)
 world._arrival244.set_process(false);await get_tree().create_timer(3.).timeout
 var controls=world._camera_controls243
 Input.emulate_touch_from_mouse=false
 controls.set_factor(1.,false);await get_tree().create_timer(.2).timeout;await shot("normal")
 var e:=InputEventMouseButton.new();e.position=controls.minus.get_global_rect().get_center();e.button_index=MOUSE_BUTTON_LEFT;e.pressed=true;Input.parse_input_event(e);Input.flush_buffered_events();await get_tree().process_frame;e=e.duplicate();e.pressed=false;Input.parse_input_event(e);Input.flush_buffered_events()
 await get_tree().create_timer(.16).timeout;print("MID266 ",controls.camera.zoom.x);assert(controls.camera.zoom.x>.85 and controls.camera.zoom.x<1.);await shot("intermedio")
 await get_tree().create_timer(1.).timeout;print("END266 ",controls.camera.zoom.x," target=",controls.factor);assert(is_equal_approx(controls.camera.zoom.x,.85));await shot("85")
 controls.reset.pressed.emit();await get_tree().create_timer(1.).timeout;assert(is_equal_approx(controls.camera.zoom.x,1.))
 world.free();get_tree().quit()
