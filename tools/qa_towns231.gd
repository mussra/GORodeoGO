extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(id:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/towns231-"+id+"-960.png")
func run():
 get_tree().root.size=Vector2i(960,540);TranslationServer.set_locale("es");GameState.brand_intro_played=true
 SaveData.save_path="user://towns231-visual-only.cfg";SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=5
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_quests={};SaveData.world_missions={};SaveData.world_tamed=[];SaveData.world_roaming139={};SaveData.world_herd_town217={};SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_garden212=Garden212.fresh();SaveData.world_discovered=[]
 SaveData.world_position=WorldNominal98.home();world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.).timeout
 var camera:Camera2D=get_viewport().get_camera_2d();world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var plans:=TownEnclosures227.plans(752026)
 for id in ["home","east138","west140","east140"]:
  var plan:Dictionary=plans[id];world.player.position=plan.center;camera.position=Vector2.ZERO
  var low:=WorldMap.chunk_at(plan.bounds.position-Vector2(100,100));var high:=WorldMap.chunk_at(plan.bounds.end+Vector2(100,100))
  for cx in range(low.x,high.x+1):
   for cy in range(low.y,high.y+1):world._activate_or_queue(cx,cy)
  while not world._build_queue.is_empty():world._step_chunk_build()
  for key in world._chunk_built.keys():world._activate_built(key)
  await get_tree().create_timer(.4).timeout
  camera.zoom=Vector2.ONE*minf(1180./plan.bounds.size.x,600./plan.bounds.size.y)*.85
  world._npc_button.visible=false;world._board_button.visible=false
  await shot(id+"-overview")
  world.player.position=plan.gate+Vector2(0,280);camera.position=Vector2.ZERO;camera.zoom=Vector2.ONE*.85
  await shot(id+"-gate")
  print("QA231 ",id," ",plan.shape_name," gate ",plan.gate," bounds ",plan.bounds," content ",plan.contents)
 world._open_service231("east140");await shot("guarnicionero-panel");world._close_npc()
 world._toggle_map();await shot("map")
 world.free();get_tree().quit()
