extends "res://tools/qa_flowers139.gd"
func shot_herd(name_:String,text:String):
 title.text=text
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/manada139-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa-herd139.dat";SaveData.trial_session_active=false;SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_flora138={};SaveData.world_roaming139={};SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_tamed=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world);world.set_physics_process(false)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var layer:=CanvasLayer.new();layer.layer=200;add_child(layer)
 var bar:=ColorRect.new();bar.color=Color("10252d");bar.size=Vector2(1280,56);layer.add_child(bar)
 title=Label.new();title.position=Vector2(18,16);title.add_theme_font_size_override("font_size",23);layer.add_child(title)
 var first=world._herd_horses.values()[0];var origin:Vector2i=first.get_meta("c");var family:Array=[]
 for horse in world._herd_horses.values():
  horse.set_physics_process(false)
  if horse!=first and horse.get_meta("c")==origin:family.append(horse)
 world._deliver_horse(origin,first)
 var center:=Vector2(500,3700);var saved:Dictionary={}
 for i in family.size():
  family[i].position=center+Vector2((i%2)*115,(i/2)*115);saved[family[i].herd.member_id]=family[i].position
 await move_to(center+Vector2(-180,90));world._snapshot_roaming139();world._toasts.clear();world._toasts.visible=false
 await shot_herd("antes","Simulación: supervivientes lejos del origen · identidades y posiciones reales")
 world.player.position=Vector2(20000,20000);world._update_chunks();await get_tree().process_frame
 world.free();SaveData.world_roaming139={};SaveData.load_progress()
 SaveData.world_position=center+Vector2(-180,90)
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world);world.set_physics_process(false)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false);world._toasts.visible=false
 for horse in world._herd_horses.values():
  horse.set_physics_process(false)
  if saved.has(horse.herd.member_id):assert(horse.position==saved[horse.herd.member_id])
 await get_tree().create_timer(1.2).timeout
 await shot_herd("despues","Tras alejarse, guardar, destruir la escena y cargar: siguen en el mismo lugar")
 # Measure current-chunk lookup with many dormant records, not an all-world scan.
 var index:=WorldHerdPositions139.new();index.setup({},752026)
 for i in 4000:
  var c:=Vector2i(i,12);index.put(WorldHerd.member_id(c.x,c.y,0),c,0,Vector2(c)*1024.)
 var samples:Array[int]=[]
 for i in 1000:
  var start:int=Time.get_ticks_usec()
  for dx in range(-1,2):
   for dy in range(-1,2):index.in_chunk(Vector2i(2000+dx,12+dy))
  samples.append(Time.get_ticks_usec()-start)
 samples.sort()
 var report:Dictionary={"desktop_only":true,"records":4000,"lookups_per_sample":9,"samples":1000,"median_usec":samples[500],"p95_usec":samples[950],"max_usec":samples[-1],"restored_individuals":saved.size(),"last_positions":str(saved)}
 var file:=FileAccess.open("/downloads/manada139-rendimiento.json",FileAccess.WRITE);file.store_string(JSON.stringify(report,"  "));file.close()
 print("HERD139_QA ",report)
 get_tree().quit()
