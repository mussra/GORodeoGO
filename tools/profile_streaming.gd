extends Node
var world
func _ready():run.call_deferred()
func metrics(label:String,values:Array):
 values.sort();print("STREAM ",label," n=",values.size()," p50_ms=",values[int(values.size()*.5)]," p95_ms=",values[int(values.size()*.95)]," max_ms=",values[-1])
func run():
 SaveData.save_path="user://streaming-profile.cfg";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_position=Vector2(310,270);SaveData.world_discovered=[];SaveData.world_quests={}
 var cover=FrontierTransition.obtain(get_tree());var warm=Time.get_ticks_usec();await cover._warm_showcase();print("STREAM showcase_warm_ms=",(Time.get_ticks_usec()-warm)/1000.0)
 var start=Time.get_ticks_usec();world=load("res://src/Presentation/frontier_world.gd").new();add_child(world);world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 print("STREAM ready_ms=",(Time.get_ticks_usec()-start)/1000.0)
 var samples=[];var iterations=0
 while world._loading_world:
  var t=Time.get_ticks_usec();world._process(1.0/60);samples.append((Time.get_ticks_usec()-t)/1000.0);iterations+=1
  await get_tree().process_frame
 print("STREAM initial_elapsed_ms=",(Time.get_ticks_usec()-start)/1000.0," iterations=",iterations," active=",world._chunks.size())
 metrics("initial",samples);world.player.set_physics_process(false);samples=[]
 var misses=0;var maxqueue=0
 for i in 1200:
  world.player.velocity=Vector2(500,0);world.player.position+=Vector2(500.0/60,0)
  var t=Time.get_ticks_usec();world._process(1.0/60);samples.append((Time.get_ticks_usec()-t)/1000.0)
  var c=WorldMap.chunk_at(world.player.position)
  if not world._chunks.has(WorldMap.chunk_key(c.x,c.y)):misses+=1
  maxqueue=maxi(maxqueue,world._build_queue.size());await get_tree().process_frame
 metrics("travel",samples);print("STREAM missing_current_frames=",misses," max_queue=",maxqueue," active=",world._chunks.size()," cached=",world._chunk_built.size())
 get_tree().quit()
