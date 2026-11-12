extends Node
var world:Node2D
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://perf138.dat";SaveData.trial_session_active=true;SaveData.world_generator_version=3;SaveData.world_seed=752026;SaveData.world_flora138=FloristJourney138.fresh([]);SaveData.world_discovered=[];SaveData.world_quests={};SaveData.world_missions={};SaveData.world_edits=[];SaveData.horse_collection.seed_trial()
 var field:Rect2=FloristJourney138.field_rect(SaveData.world_flora138,"red");SaveData.world_position=field.get_center()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false)
 for i in 35:await get_tree().process_frame
 var result:Dictionary={"renderer":"desktop Mesa llvmpipe GL compatibility,1280x720","samples":{}}
 for enabled in [false,true]:
  world._flora_layer138.visible=enabled;world._flora_layer138.set_process(enabled)
  var samples:Array=[];var calls:Array=[];var max_tiles:int=0;var max_flowers:int=0
  world.player.position=field.get_center()-Vector2(400,0)
  for i in 180:
   var start:int=Time.get_ticks_usec();world.player.position.x+=4.
   await get_tree().process_frame;await RenderingServer.frame_post_draw
   if i>20:samples.append((Time.get_ticks_usec()-start)/1000.);calls.append(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
   max_tiles=maxi(max_tiles,world._flora_layer138.tiles.size())
   var count:int=0
   for tile in world._flora_layer138.tiles.values():
    for batch in tile.get_children():count+=batch.multimesh.instance_count
   max_flowers=maxi(max_flowers,count)
  samples.sort();calls.sort()
  result.samples["flowers" if enabled else "same_world_no_flower_layer"]={"frames":samples.size(),"p50_ms":samples[samples.size()/2],"p95_ms":samples[int(samples.size()*.95)],"max_ms":samples[-1],"draw_calls_p95":calls[int(calls.size()*.95)],"max_tiles":max_tiles,"max_visible_flower_instances":max_flowers}
 result.tile_build_max_usec=world._flora_layer138.tile_build_usec
 var f=FileAccess.open("/downloads/florista138-rendimiento.json",FileAccess.WRITE);f.store_string(JSON.stringify(result,"  "));f.close();print("PERF138 ",JSON.stringify(result))
 get_tree().quit()
