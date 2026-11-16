extends Node
var results:Dictionary={}
func _ready():run.call_deferred()
func stats(values:Array)->Dictionary:
 values.sort();var sum:float=0.
 for v in values:sum+=v
 return {'n':values.size(),'mean_ms':sum/values.size(),'p50_ms':values[values.size()/2],'p95_ms':values[int(values.size()*.95)],'max_ms':values[-1]}
func batch(label:String,world:Node,frames:int,move:bool=false):
 var times:Array=[];var node0=Performance.get_monitor(Performance.OBJECT_NODE_COUNT);var mem0=Performance.get_monitor(Performance.MEMORY_STATIC);var calls:Array=[]
 if world!=null:world.samples242={}
 for i in frames:
  if move:world.player.position.x+=6. if i<frames/2 else -6.
  var t=Time.get_ticks_usec();await get_tree().process_frame;await RenderingServer.frame_post_draw
  times.append((Time.get_ticks_usec()-t)/1000.);calls.append(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
 var out:Dictionary={'frame':stats(times),'nodes_start':node0,'nodes_end':Performance.get_monitor(Performance.OBJECT_NODE_COUNT),'memory_start_mb':mem0/1048576.,'memory_end_mb':Performance.get_monitor(Performance.MEMORY_STATIC)/1048576.}
 calls.sort();out.draw_calls_p95=calls[int(calls.size()*.95)]
 if world!=null:
  out.sections={}
  for key in world.samples242:
   var ms:Array=[]
   for v in world.samples242[key]:ms.append(v/1000.)
   if not ms.is_empty():out.sections[key]=stats(ms)
  out.chunks=world._chunks.size();out.map_rebuilds=world._map_overlay.terrain_rebuilds
 results[label]=out;print('PERF242 ',label,' ',JSON.stringify(out))
func run():
 get_tree().root.size=Vector2i(1280,720)
 TranslationServer.set_locale('es');GameState.sound_enabled=false
 SaveData.save_path='user://perf242-only.dat';SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.world_position=Vector2(1300,850);SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_quests={};SaveData.horse_collection.seed_trial()
 for x in range(-5,15):
  for y in range(-5,15):SaveData.world_discovered.append(WorldMap.chunk_key(x,y))
 var world=load('res://tools/perf_world242.gd').new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false)
 for i in 40:await get_tree().process_frame
 get_tree().current_scene=self
 var arrival=world._arrival244
 arrival.set_process(false)
 var plans:Dictionary=TownEnclosures227.plans(752026)
 var plan:Dictionary=plans.town1
 world.player.position=plan.gate+Vector2(0,250);world._update_chunks()
 while not world._build_queue.is_empty():world._step_chunk_build()
 for i in 40:await get_tree().process_frame
 world.player.set_physics_process(true)
 arrival.begin(plan)
 var track:Array=[];var start:int=Time.get_ticks_usec();var shot_index:int=0
 while arrival.active:
  arrival._process(get_process_delta_time())
  await get_tree().process_frame;await RenderingServer.frame_post_draw
  track.append({'sec':(Time.get_ticks_usec()-start)/1000000.,'zoom':arrival.camera.zoom.x,'chunks':world._chunks.size(),'nodes':Performance.get_monitor(Performance.OBJECT_NODE_COUNT)})
  if shot_index<3 and arrival.elapsed>[.60,1.1,2.1][shot_index]:
   get_viewport().get_texture().get_image().save_png('/downloads/arrival244-timeline-'+str(shot_index)+'.png');shot_index+=1
 var f=FileAccess.open('/downloads/arrival244-timeline.json',FileAccess.WRITE);f.store_string(JSON.stringify(track,'  '));f.close()
 for i in 10:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png('/downloads/arrival244-return.png')
 world.free();get_tree().quit()
