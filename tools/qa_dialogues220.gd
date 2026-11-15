extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(name_:String):
 world._update_chunks()
 while not world._build_queue.is_empty():world._step_chunk_build()
 world._update_chunks()
 for child in world._toasts.get_children():
  if child is CanvasItem:child.visible=false
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/towns215-"+name_+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://towns219-qa.cfg";SaveData._load_valid=true;SaveData.world_garden212=Garden212.fresh()
 SaveData.world_herd_town217={};SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_places144={};SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.country_ledger146={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 var cover=get_tree().root.get_node_or_null("FrontierTransition")
 if cover!=null:cover.free()
 world.visible=true;world.set_process(false);world.player.set_physics_process(false)
 SaveData.world_places144=WorldPlaces144.fresh(752026,3)
 var point:=VillageCousins140.point(SaveData.world_cousins140,"east138")
 world.player.position=point;world._update_chunks()
 while not world._build_queue.is_empty():world._step_chunk_build()
 get_viewport().get_camera_2d().reset_smoothing();world._open_cousin140("east138");await shot("second-town220")
 get_tree().root.size=Vector2i(960,540);await shot("second-town220-960")
 get_tree().root.size=Vector2i(1280,720)
 world._close_npc()
 world.player.position=VillageCousins140.point(SaveData.world_cousins140,"west140")
 get_viewport().get_camera_2d().reset_smoothing();world._open_cousin140("west140")
 get_tree().root.size=Vector2i(960,540);await shot("third-town220-960")
 get_tree().root.size=Vector2i(1280,720)
 world._close_npc();world._toggle_map();await shot("mapa")
 world._toggle_map()
 var samples:Array=[]
 for i in 120:
  var before:int=Time.get_ticks_usec();await get_tree().process_frame
  samples.append(float(Time.get_ticks_usec()-before)/1000.)
 samples.sort();print("VISUAL219_FRAME_MS median=",samples[60]," p95=",samples[114]," max=",samples[-1])
 print("TEACH219 ",SaveData.world_places144.teach217," ",HerdTown217.explanation(SaveData.world_cousins140,"east138"))
 for map_ in [world._chunk_pending,world._chunk_built]:
  for key in map_:world._discard_builder(map_[key])
 world.free();DirAccess.remove_absolute(SaveData.save_path);get_tree().quit()
