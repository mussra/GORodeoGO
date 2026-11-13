extends GutTest
var world:Node2D
var original:Dictionary={}
func before_all():
 for key in ["save_path","trial_session_active","_load_valid","world_generator_version","world_seed","world_position","world_edits","world_quests","world_flora138","world_discovered","world_missions","horse_collection","world_pigs","world_tamed","world_pig_captures","world_pigs_sold","world_goat_captures","world_notes106","world_notes_revision106"]:
  var value:Variant=SaveData.get(key)
  original[key]=value.duplicate(true) if value is Dictionary or value is Array else value
func after_all():
 for key in original:SaveData.set(key,original[key])
func before_each():
 SaveData.save_path="user://flora138-integration.dat";SaveData.trial_session_active=false;SaveData._load_valid=true;SaveData.world_generator_version=3;SaveData.world_seed=752026;SaveData.world_position=WorldNominal98.home();SaveData.world_edits=[];SaveData.world_quests={};SaveData.world_flora138={};SaveData.world_discovered=[];SaveData.world_missions={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
func after_each():
 if is_instance_valid(world):world.free()
 SaveData.world_flora138={};SaveData.world_quests={};SaveData.world_discovered=[]
 DirAccess.remove_absolute(SaveData.save_path)
func create_world():
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 var frames:int=0
 while world._loading_world and frames<1000:await wait_process_frames(1);frames+=1
 assert_false(world._loading_world)
 world.player.set_physics_process(false);world.set_physics_process(false);world.set_process(false)
func settle_at(p:Vector2):
 world.player.position=p;world._update_chunks()
 var limit:int=0
 while not world._build_queue.is_empty() and limit<1000:world._drain_chunk_builds();await wait_process_frames(1);limit+=1
 world.player.set_physics_process(false)
 await wait_physics_frames(2)
func finish_old():
 for id in ["florist_blue105","florist_gold105"]:SaveData.world_quests[id]={"status":"done","count":3,"events":["a","b","c"],"thanked":true}
func test_real_world_both_routes_atomic_deliver_reload_and_no_repeat():
 await create_world()
 var home:Vector2=FloristJourney138.home_door(752026)+Vector2(110,-20)
 var state=SaveData.world_flora138.duplicate(true);var remote:Vector2=FloristJourney138.door(state)+Vector2(110,32)
 await settle_at(home)
 world._journey_action138("begin","red");assert_eq(SaveData.world_flora138.quests,{})
 finish_old();var old:Dictionary=SaveData.world_quests.duplicate(true)
 world._journey_action138("begin","red");assert_eq(FloristJourney138.stage(SaveData.world_flora138,"red"),"active")
 world._journey_action138("sample","red");assert_eq(FloristJourney138.stage(SaveData.world_flora138,"red"),"active","Cannot obtain remote sample from home")
 await settle_at(remote);world._journey_action138("hint","red")
 assert_eq(FloristJourney138.stage(SaveData.world_flora138,"red"),"active")
 await settle_at(FloristJourney138.sample_point(state,"red"));world._tick_flora138()
 assert_eq(FloristJourney138.stage(SaveData.world_flora138,"red"),"sample")
 world._tick_flora138();assert_false(SaveData.world_flora138.fields.has("red"))
 await settle_at(home);world._journey_action138("deliver","red")
 assert_eq(SaveData.world_flora138.fields,{"red":true});world._journey_action138("deliver","red");assert_eq(SaveData.world_flora138.fields.size(),1)
 world._journey_action138("begin","violet");await settle_at(remote);world._journey_action138("sample","violet")
 assert_eq(FloristJourney138.stage(SaveData.world_flora138,"violet"),"sample")
 await settle_at(home);var path:String=SaveData.save_path;SaveData.save_path="user://missing-integration138/save.dat"
 world._journey_action138("deliver","violet");assert_false(SaveData.world_flora138.fields.has("violet"));assert_eq(FloristJourney138.stage(SaveData.world_flora138,"violet"),"sample");assert_push_error_count(1)
 SaveData.save_path=path;world._journey_action138("deliver","violet");var done=SaveData.world_flora138.duplicate(true)
 SaveData.load_progress();assert_eq(SaveData.world_flora138,done);assert_eq(done.fields.size(),2);assert_eq(SaveData.world_quests,old)
func test_crops_access_destination_and_camera_tile_retention():
 await create_world();var home:Vector2=FloristJourney138.home_door(752026)
 await settle_at(home+Vector2(0,90))
 for y in range(0,201,8):
  world.player.position=home+Vector2(0,y)
  assert_false(world.player.test_move(world.player.global_transform,Vector2(0,-4)),"Door approach not fenced off")
 var state=SaveData.world_flora138;var door=FloristJourney138.door(state)
 # The main east-west road passes right in front of the destination town.
 await settle_at(door+Vector2(0,112))
 for x in range(-400,401,8):
  world.player.position=Vector2(door.x+x,470)
  assert_false(world.player.test_move(world.player.global_transform,Vector2(4,0)),"Town road remains clear")
 await settle_at(FloristJourney138.sample_point(state,"red")+Vector2(50,0))
 var layer=world._flora_layer138
 for i in 25:layer._process(.016)
 assert_lte(layer.tiles.size(),96) # Bounded preload and retention rings, no full-field render.
 var previous:Dictionary=layer.tiles.duplicate();world.player.position+=Vector2(512,0);layer._process(.016)
 var shared:int=0
 for key in previous:
  if layer.tiles.has(key):assert_eq(previous[key],layer.tiles[key]);shared+=1
 assert_gt(shared,0,"Retains overlapping tiles rather than flashing entire field")
func test_legacy_generators_no_new_fields_or_npcs():
 SaveData.world_generator_version=1
 await create_world()
 assert_true(SaveData.world_flora138.is_empty());assert_eq(world._npcs98().size(),2);assert_null(world._flora_layer138)

func test_follow_continuous_real_road_from_origin_to_destination_and_fields():
 await create_world()
 var state:Dictionary=SaveData.world_flora138
 var route:PackedVector2Array=FloristJourney138.route_from_home(state,752026)
 var checked:int=0;var streamed:Vector2i=Vector2i(999,999)
 for segment in route.size()-1:
  var a:Vector2=route[segment];var b:Vector2=route[segment+1]
  var steps:int=maxi(1,ceili(a.distance_to(b)/12.))
  for step in steps:
   var p:Vector2=a.lerp(b,float(step)/steps)
   if WorldMap.chunk_at(p)!=streamed:
    await settle_at(p);streamed=WorldMap.chunk_at(p)
   world.player.position=p
   var move:Vector2=(b-a).normalized()*4.
   assert_false(WorldTerrain103.blocked(752026,p,14.),"No ridge blocks the continuous road")
   assert_true(world._get_surface98().contains(p,4.),"Same visible and gameplay road at"+str(p))
   assert_false(world.player.test_move(world.player.global_transform,move),"Can follow road at"+str(p))
   checked+=1
 assert_gt(checked,300)
 assert_lt(route[-1].distance_to(FloristJourney138.door(state)+Vector2(110,32)),155.)
 # From the town, north and south spurs lead to the actual samples.
 for species in FloristJourney138.SPECIES:
  var goal:Vector2=FloristJourney138.sample_point(state,species);var start:=Vector2(goal.x,470)
  var steps:int=ceili(start.distance_to(goal)/12.)
  for i in range(steps+1):
   var p:Vector2=start.lerp(goal,float(i)/steps)
   if WorldMap.chunk_at(p)!=streamed:await settle_at(p);streamed=WorldMap.chunk_at(p)
   world.player.position=p
   assert_false(world.player.test_move(world.player.global_transform,(goal-start).normalized()*4.),"Field spur clear")
   assert_true(world._get_surface98().contains(p,0.),"Field guidance follows actual path")

func test_initial_field_is_ready_before_world_is_revealed_and_batches_stay_upright():
 SaveData.world_flora138=FloristJourney138.fresh([])
 SaveData.world_position=FloristJourney138.field_rect(SaveData.world_flora138,"red").get_center()
 await create_world()
 var layer:FlowerExpansion138=world._flora_layer138
 assert_true(layer.visible_ready180());assert_true(world.visible)
 for c in layer.visible_tiles180:assert_true(layer.tiles.has(c))
 var batches:int=0
 for tile in layer.tiles.values():
  for batch in tile.get_children():
   if batch.multimesh.instance_count>0:
    batches+=1
    if DisplayServer.get_name()!="headless":assert_lt(batch.multimesh.get_instance_transform_2d(0).y.y,0.,"QuadMesh UV correction keeps petals above leaves")
 assert_gt(batches,0)
