extends Node
var results:Dictionary={}
var world:Node2D
func _ready():run.call_deferred()
func stats(a:Array)->Dictionary:
 a.sort();var sum_:float=0.
 for v in a:sum_+=v
 return {'n':a.size(),'mean_ms':sum_/maxi(1,a.size()),'p95_ms':a[int(a.size()*.95)],'max_ms':a[-1]}
func sample(label_:String,n:int,until_ready:bool=false):
 var frames:Array=[];var phys:Array=[];var cpu:Array=[];var steps:int=0
 var start:int=Time.get_ticks_usec();var saved:Dictionary=SaveData.save_metrics242.duplicate(true)
 while steps<n:
  var t:int=Time.get_ticks_usec();await get_tree().process_frame;await RenderingServer.frame_post_draw
  frames.append((Time.get_ticks_usec()-t)/1000.);phys.append(Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)*1000.);cpu.append(Performance.get_monitor(Performance.TIME_PROCESS)*1000.);steps+=1
  var radius:int=world._spawn_radius249()
  if until_ready and steps>60 and world._chunks.size()>=(2*radius+1)*(2*radius+1) and world._chunk_pending.is_empty():break
 var pigs:int=0
 for node in world._chunks.values():
  if node.has_node('pigs'):pigs+=node.get_node('pigs').get_child_count()
 results[label_]={'frame':stats(frames),'physics_monitor':stats(phys),'process_monitor':stats(cpu),'elapsed_s':(Time.get_ticks_usec()-start)/1000000.,'zoom':world._camera_controls243.factor,'radius':world._spawn_radius249(),'chunks':world._chunks.size(),'queue':world._build_queue.size(),'horses':world._herd_horses.size(),'pigs':pigs,'goats':world._prototype_goats.get_child_count(),'nodes':Performance.get_monitor(Performance.OBJECT_NODE_COUNT),'memory_mib':Performance.get_monitor(Performance.MEMORY_STATIC)/1048576.,'draw_calls':Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),'discovered':SaveData.world_discovered.size(),'save_calls_delta':SaveData.save_metrics242.calls-saved.calls}
 print('PERF249 ',label_,' ',JSON.stringify(results[label_]))
 var f:=FileAccess.open('/downloads/perf249.json',FileAccess.WRITE);f.store_string(JSON.stringify(results,'  '));f.close()
func run():
 get_tree().root.size=Vector2i(1280,720);DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED);Engine.max_fps=0;GameState.sound_enabled=false
 SaveData.save_path='user://perf249-scratch.dat';SaveData.trial_session_active=true;SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.world_position=Vector2(1300,850);SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_quests={};SaveData.world_jobs249={};SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_garden212=Garden212.fresh();SaveData.horse_collection.seed_trial()
 world=load('res://tools/perf_world249.gd').new();add_child(world);get_tree().current_scene=self
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.).timeout
 if world._arrival244.active:world._arrival244.finish(false)
 world._arrival244.set_process(false);world.player.set_physics_process(false)
 world.radius_override249=1;world._camera_controls243.set_factor(.25,false)
 await sample('25pct_radius1_warm',240,true);await sample('25pct_radius1_steady',150)
 world.radius_override249=-1;world._camera_controls243.set_factor(.25,false)
 await sample('25pct_radius2_expansion',1800,true);await sample('25pct_radius2_steady',150)
 world._camera_controls243.set_factor(.05,false)
 await sample('5pct_radius3_expansion',2400,true);await sample('5pct_radius3_steady',150)
 get_viewport().get_texture().get_image().save_png('/downloads/qa249-zoom5-settled.png')
 world.free();await get_tree().process_frame;get_tree().quit()
