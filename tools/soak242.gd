extends Node
var world:Node
var data:Array=[]
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);GameState.sound_enabled=false
 SaveData.save_path='user://soak242-only.cfg';SaveData.normal_mode_path=SaveData.save_path;SaveData.trial_session_active=false;SaveData.debug_mode=false;SaveData._load_valid=true
 SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.world_position=Vector2(1000,358);SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_quests={};SaveData.world_missions={};SaveData.world_roaming139={};SaveData.world_herd_town217={};SaveData.world_cousins140={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load('res://src/Presentation/frontier_world.tscn').instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false)
 var second:Vector2=TownNetwork234.nodes(752026).town1.door
 var start:int=Time.get_ticks_msec()
 for phase in 6:
  world.player.position=second+Vector2(0,650) if phase in [1,2,3,4] else Vector2(1000,900)
  var times:Array=[];var end:int=Time.get_ticks_msec()+10000
  while Time.get_ticks_msec()<end:
   var t:int=Time.get_ticks_usec();await get_tree().process_frame;await RenderingServer.frame_post_draw;times.append((Time.get_ticks_usec()-t)/1000.)
  times.sort()
  var row:Dictionary={'elapsed_sec':(Time.get_ticks_msec()-start)/1000.,'phase':phase,'nodes':Performance.get_monitor(Performance.OBJECT_NODE_COUNT),'objects':Performance.get_monitor(Performance.OBJECT_COUNT),'memory_mb':Performance.get_monitor(Performance.MEMORY_STATIC)/1048576.,'resources':Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT),'chunks':world._chunks.size(),'pending':world._build_queue.size(),'flowers':world._flower_nodes105.size(),'herds':world._herd_horses.size(),'roaming':SaveData.world_roaming139.get('horses',{}).size(),'frame_p50':times[times.size()/2],'frame_p95':times[int(times.size()*.95)],'saves':SaveData.save_metrics242.duplicate(true)}
  data.append(row);print('SOAK242 ',JSON.stringify(row))
  var f=FileAccess.open('/downloads/soak242.json',FileAccess.WRITE);f.store_string(JSON.stringify(data,'  '));f.close()
 world.free();get_tree().quit()
