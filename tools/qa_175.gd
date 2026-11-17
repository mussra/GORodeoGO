extends Node
func _ready():run.call_deferred()
func shot(label_:String):
 for i in 8:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/qa175-'+label_+'.png')
func run():
 TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path='user://qa175.dat';SaveData.highest_level_completed=0;SaveData.rodeo_intro240=false
 var menu=load('res://src/Presentation/main_menu.tscn').instantiate();add_child(menu)
 await get_tree().create_timer(1.).timeout
 await shot('menu');menu._show_settings();await shot('settings')
 SaveData.debug_mode=false
 var mode_:bool=SaveData.debug_mode
 GameState.set_performance_osd245(true)
 print('OSD_SAVE_UNCHANGED ',mode_==SaveData.debug_mode)
 menu.free()
 SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.world_position=Vector2(1300,850);SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_quests={};SaveData.horse_collection.seed_trial()
 var world=load('res://tools/perf_world242.gd').new();add_child(world)
 get_tree().current_scene=self
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(2.).timeout
 var arrival=world._arrival244
 if arrival.active:arrival.finish(false)
 arrival.set_process(false)
 world._open_navigation();await shot('world-menu')
 world._navigation.queue_free();world._navigation_selected('performance245');await shot('osd-off')
 world._open_navigation();world._navigation.queue_free();world._navigation_selected('performance245')
 await get_tree().create_timer(.8).timeout;await shot('osd-on')
 GameState.set_performance_osd245(false)
 var plan:Dictionary=TownEnclosures227.plans(752026).town1
 world.player.position=plan.gate+Vector2(0,250);world._update_chunks()
 while not world._build_queue.is_empty():world._step_chunk_build()
 for i in 25:await get_tree().process_frame
 arrival.begin(plan)
 var samples:Array=[]
 for i in 103:
  arrival.elapsed=i/30.;arrival.apply_frame()
  await get_tree().process_frame;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png('/downloads/cine175-%03d.png'%i)
  samples.append({'t':arrival.elapsed,'zoom':arrival.camera.zoom.x,'chunks':world._chunks.size()})
 arrival.finish(false)
 var f=FileAccess.open('/downloads/cine175.json',FileAccess.WRITE);f.store_string(JSON.stringify(samples,'  '));f.close()
 world.free();get_tree().quit()
