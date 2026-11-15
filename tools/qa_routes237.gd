extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(name_:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/routes237-"+name_+"-960.png")
func run():
 get_tree().root.size=Vector2i(960,540);TranslationServer.set_locale("es");GameState.brand_intro_played=true
 SaveData.save_path="user://routes237-visual-only.cfg";SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.debug_mode=false
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents();SaveData.horse_collection.find("trial_a").stats={"speed":240.,"power":.5};SaveData.horse_collection.find("trial_a").name="Lento";SaveData.horse_collection.find("trial_b").stats={"speed":300.,"power":.9};SaveData.horse_collection.find("trial_b").name="Rápido"
 SaveData.world_quests={};SaveData.world_missions={};SaveData.world_tamed=[];SaveData.world_roaming139={};SaveData.world_herd_town217={};SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_garden212=Garden212.fresh();SaveData.world_discovered=[]
 SaveData.world_position=WorldNominal98.home();world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.).timeout;world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var town:String="home";var role:String="loco";var found:bool=false
 for node in TownNetwork234.base_nodes(752026).values():
  if found:break
  for key in node.targets:
   if node.get("via",{}).has(key):town=node.id;role=key;found=true;break
 for horse in ["trial_a","trial_b"]:
  SaveData.horse_collection.selected=horse;world._stamina=WorldStamina.new_state(HorseStats.read(SaveData.horse_collection.find(horse)).power);world.player.position=TownNetwork234.point(752026,town,role)
  world._open_town234({"town234":town,"role234":role,"position":world.player.position});await shot(horse);world._close_npc()
 SaveData.debug_mode=true;world._open_network234();await shot("debug-in-game");world._close_npc();SaveData.debug_mode=false
 for seed_ in [752026,752027,752028]:
  var map:=TownMap234.new();map.seed_=seed_;map.show_all=true;world._hud.add_child(map);await shot("network-"+str(seed_));map.free()
 var far:=Vector2i(30,40);var point:=TownNetwork234.position_for(752026,far);TownNetwork234.ensure_near(752026,point);var node:=TownNetwork234.cell_node(752026,far);world.player.position=point
 var c:=WorldMap.chunk_at(point)
 for x in range(c.x-2,c.x+3):
  for y in range(c.y-2,c.y+3):world._activate_or_queue(x,y)
 while not world._build_queue.is_empty():world._step_chunk_build()
 for key in world._chunk_built.keys():world._activate_built(key)
 await get_tree().create_timer(.5).timeout
 get_viewport().get_camera_2d().zoom=Vector2.ONE*.35
 world._npc_button.hide();world._board_button.hide()
 await shot("far-village")
 print("QA237 infinite village ",node.id," ",point," identity ",TownIdentity215.look236(752026,node.id))
 world.free();get_tree().quit()
