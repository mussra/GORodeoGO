extends Node
func _ready():run.call_deferred()
func stats(label:String,values:Array):
 values.sort();return {"label":label,"n":values.size(),"p50_ms":values[int(values.size()*.5)],"p95_ms":values[int(values.size()*.95)],"max_ms":values[-1]}
func run():
 SaveData.save_path="user://perf84-only.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_position=Vector2(310,270);SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_quests={};SaveData.horse_collection.seed_trial()
 for side in [3,10,20]:
  var cells=[]
  for x in side:
   for y in side:cells.append(Vector2i(x,y))
  var samples=[];var objects=0
  for iteration in 25:
   var t=Time.get_ticks_usec()
   for c in cells:
    var d=WorldEdits.apply(WorldMap.generate(SaveData.world_seed,c.x,c.y),SaveData.world_edits,c.x,c.y)
    objects+=d.get("decor",[]).size()
   samples.append((Time.get_ticks_usec()-t)/1000.0)
  print("PERF84 minimap_regeneration ",JSON.stringify(stats(str(side*side)+" cells",samples))," decor_per_redraw=",objects/25)
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false);world.set_physics_process(false);world.set_process(false)
 world.process_mode=Node.PROCESS_MODE_DISABLED
 var map=world._map_overlay;map.set_process(false)
 for side in [3,10,20]:
  SaveData.world_discovered=[]
  for x in side:
   for y in side:SaveData.world_discovered.append(WorldMap.chunk_key(x,y))
  var samples=[]
  for iteration in 65:
   var t=Time.get_ticks_usec();map.queue_redraw();await RenderingServer.frame_post_draw
   if iteration>4:samples.append((Time.get_ticks_usec()-t)/1000.0)
  print("PERF84 rendered ",JSON.stringify(stats(str(side*side)+" cells",samples))," process_ms=",Performance.get_monitor(Performance.TIME_PROCESS)*1000," draw_calls=",Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)," nodes=",Performance.get_monitor(Performance.OBJECT_NODE_COUNT)," terrain_rebuilds=",map.get("terrain_rebuilds")," texture_mib=",Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED)/1048576.0)
  if side==10:get_viewport().get_texture().get_image().save_png("/downloads/frontier84-minimap-"+OS.get_environment("PERF_LABEL")+".png")
 map.expanded=true;map.zoom=1.4;map.pan=Vector2(40,20);map._process(0);map._pulse=0;map.queue_redraw()
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/frontier84-expanded-"+OS.get_environment("PERF_LABEL")+".png")
 get_tree().quit()
