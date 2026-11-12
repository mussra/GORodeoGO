extends Node
const Art=preload("res://src/Presentation/wild_horse_art.gd")
func emit(kind:String,data:Dictionary):data["kind"]=kind;print("AUDIT100 ",JSON.stringify(data))
func _ready():run.call_deferred()
func run():
 SaveData.save_path="user://audit100-only.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=2;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false);world._map_overlay.set_process(false)
 for count in [100,1000,10000,50000]:
  SaveData.world_discovered.clear()
  for i in count:SaveData.world_discovered.append(WorldMap.chunk_key(i,0))
  var map=world._map_overlay;map.expanded=true;map.zoom=1.;map._layout()
  var start=Time.get_ticks_usec()
  for i in 10:map._cells()
  var cells_ms=(Time.get_ticks_usec()-start)/10000.
  start=Time.get_ticks_usec()
  for i in 10:hash([SaveData.world_seed,SaveData.world_discovered,SaveData.world_edits,SaveData.world_pigs,SaveData.world_missions,SaveData.world_tamed,map.size,true,1.,Vector2.ZERO])
  var hash_ms=(Time.get_ticks_usec()-start)/10000.
  start=Time.get_ticks_usec()
  for i in 100:SaveData.world_discovered.has("not-present")
  var has_ms=(Time.get_ticks_usec()-start)/100000.
  SaveData.trial_session_active=false;start=Time.get_ticks_usec();var saved=SaveData.save_progress();var save_ms=(Time.get_ticks_usec()-start)/1000.;SaveData.trial_session_active=true
  var bytes=FileAccess.get_file_as_bytes(SaveData.save_path).size()
  emit("history",{"count":count,"cells_ms":cells_ms,"signature_ms":hash_ms,"membership_ms":has_ms,"save_ms":save_ms,"bytes":bytes,"saved":saved})
  # Real retained draw-command rebuild, measured across rendering frames.
  if false:
   map._terrain_valid=false;start=Time.get_ticks_usec();map._ensure_terrain();map.queue_redraw()
   await RenderingServer.frame_post_draw
   emit("map_rebuild",{"count":count,"elapsed_ms":(Time.get_ticks_usec()-start)/1000.,"cell":map._map_geometry.cell})
 # CPU-only generation at far coordinates and deterministic replay.
 for cx in [0,1000,100000,1000000]:
  var start=Time.get_ticks_usec();var fingerprint:int=0
  for i in 200:fingerprint=hash([fingerprint,WorldMap.generate(752026,cx+i,0),WorldNominal98.graph_for_chunk(752026,Vector2i(cx+i,0))])
  emit("generate",{"cx":cx,"mean_ms":(Time.get_ticks_usec()-start)/200000.,"fingerprint":fingerprint,"repeat_equal":WorldMap.generate(752026,cx,0)==WorldMap.generate(752026,cx,0)})
 for origin in [10000.,100000.,1000000.,10000000.,100000000.,1000000000.]:
  var p=Vector2(origin,470);var step=p+Vector2(260./60.,0)
  emit("precision",{"origin":origin,"actual_gallop_step":step.x-p.x,"expected_step":260./60.,"one_unit":(p+Vector2.RIGHT).x-p.x})
 var edits:Array=[]
 for i in 10000:edits.append({"type":"add_decor","kind":"tree","pos":Vector2(i*1024.,900),"scale":1.})
 var base=WorldMap.generate(752026,0,0);var start=Time.get_ticks_usec()
 for i in 100:WorldEdits.apply(base,edits,0,0)
 emit("edits",{"count":10000,"one_chunk_mean_ms":(Time.get_ticks_usec()-start)/100000.})
 DirAccess.remove_absolute(SaveData.save_path)
 get_tree().quit()
