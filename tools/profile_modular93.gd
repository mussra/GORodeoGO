extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1598,720);SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/modular_world93.tscn").instantiate();add_child(world)
 await get_tree().create_timer(.6).timeout;world.process_mode=Node.PROCESS_MODE_DISABLED
 var kinds={}
 for cell in ModularWorldLayout93.graph():
  var kind=ModularWorldLayout93.piece(ModularWorldLayout93.graph(),cell).kind;kinds[kind]=kinds.get(kind,0)+1
 print("LAYOUT93 ",JSON.stringify(kinds)," tiles=",ModularWorldLayout93.graph().size())
 for mode in [false,true,false,true]:
  world.dark=mode;world._reload_art();world.ground.queue_redraw();world.roads.queue_redraw()
  var frames=[];var draws=[]
  for i in 145:
   var t=Time.get_ticks_usec();await RenderingServer.frame_post_draw;await get_tree().process_frame
   if i>=25:frames.append((Time.get_ticks_usec()-t)/1000.);draws.append(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
  frames.sort();draws.sort()
  print("PERF93 ",JSON.stringify({"dark":mode,"p50_ms":frames[60],"p95_ms":frames[114],"max_ms":frames[-1],"draws":draws[60],"renderer":RenderingServer.get_video_adapter_name(),"texture_mib":Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED)/1048576.}))
 get_tree().quit()
