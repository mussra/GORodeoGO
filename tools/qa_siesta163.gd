extends Node
var world:Node2D
var running:bool=false
var completed:bool=false
var ok:bool=false
func _ready():run.call_deferred()
func travel(country:bool):
 running=true;ok=await world.start_siesta("source") if country else await world._travel144.start("east138");completed=true;running=false
func shot(name_:String):
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/siesta163-"+name_+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 for country in [false,true]:
  SaveData.save_path="user://qa-siesta163-%s.dat"%country;SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_position=WorldNominal98.home();SaveData.world_edits=[];SaveData.world_roaming139={};SaveData.country_ledger146={};SaveData.world_missions={};SaveData.world_quests={};SaveData.world_discovered=[];SaveData.world_places144={};SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
  if country:
   world=CountrySession152.new();world.session_state=CountryLedger146.enter(CountryLedger146.fresh(752026,3),SaveData.world_position,752026);add_child(world);await get_tree().physics_frame;world.activate152()
   for path in [world.data.approach,world.data.upstream]:
    for i in range(1,path.size()):
     for j in ceili(path[i-1].distance_to(path[i])/100.)+1:CountryExploration148.reveal(world.visited_cells,path[i-1].move_toward(path[i],j*100.))
   world.ledger.maps.water146.visited.source=true;world.player.set_physics_process(false);world.save_now152()
  else:
   world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
   while world._loading_world:await get_tree().process_frame
   for x in range(-1,8):
    for y in range(-1,2):SaveData.world_discovered.append(WorldMap.chunk_key(x,y))
   var state:=WorldPlaces144.clean(SaveData.world_places144,SaveData.world_seed,3);state.visited.east138=true;SaveData.commit_places144(state,world.player.position);world.player.set_physics_process(false)
  await get_tree().create_timer(1.2).timeout
  var origin:Vector2=world.player.position;var country_id:String="pais" if country else "frontera";var before:Dictionary=SaveData.world_quests.duplicate(true)
  await shot(country_id+"-antes");completed=false;travel.call_deferred(country)
  await get_tree().create_timer(.25,true).timeout
  assert(not world.player.is_physics_processing());assert(world.player.position.distance_to(origin)>1.);await shot(country_id+"-cerrando")
  Input.action_press("move_left");Input.action_press("move_down")
  await get_tree().create_timer(.5,true).timeout;await shot(country_id+"-casi-cerrado")
  Input.action_release("move_left");Input.action_release("move_down")
  while not completed:await get_tree().process_frame
  assert(ok);assert(SaveData.world_quests==before);await get_tree().create_timer(1.,true).timeout;await shot(country_id+"-despues");print("SIESTA163_QA_OK ",country_id," from=",origin," to=",world.player.position)
  world.queue_free();await get_tree().process_frame
 get_tree().quit()
