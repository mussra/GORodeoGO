extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://perf-grass87-only.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_position=Vector2(100,180);SaveData.world_edits=[];SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.process_mode=Node.PROCESS_MODE_DISABLED
 var camera=Camera2D.new();world.add_child(camera);camera.make_current();camera.position=Vector2(300,220)
 var grass=[];find_grass(world,grass)
 for mode in ["textured","flat","textured","flat"]:
  for item in grass:
   item.visible=mode=="textured"
   if not item.has_meta("flat"):
    var flat=ColorRect.new();flat.position=Vector2(item.c)*WorldMap.CHUNK_SIZE;flat.size=Vector2.ONE*WorldMap.CHUNK_SIZE;flat.color=Color("2f603a");flat.z_index=-9;item.get_parent().add_child(flat);item.set_meta("flat",flat)
   item.get_meta("flat").visible=mode=="flat"
  var samples=[];var draws=[]
  for i in 145:
   var t=Time.get_ticks_usec();await RenderingServer.frame_post_draw;await get_tree().process_frame
   if i>=25:samples.append((Time.get_ticks_usec()-t)/1000.0);draws.append(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
  samples.sort();draws.sort()
  print("GRASS87 ",JSON.stringify({"mode":mode,"n":samples.size(),"p50_ms":samples[60],"p95_ms":samples[114],"max_ms":samples[-1],"draw_calls_p50":draws[60],"grass_chunks":grass.size(),"renderer":RenderingServer.get_video_adapter_name()}))
 get_tree().quit()
func find_grass(node:Node,result:Array):
 if node is WorldGrassTexture:result.append(node)
 for child in node.get_children():find_grass(child,result)
