extends GutTest
var world:Node2D
func before_each():
 SaveData.save_path="user://cousins140.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_flora138={};SaveData.world_discovered=[];SaveData.world_quests={};SaveData.world_missions={};SaveData.world_tamed=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world);world.set_physics_process(false)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.player.set_physics_process(false)
func after_each():
 world.free();DirAccess.remove_absolute(SaveData.save_path)
func test_four_real_interactions_journal_persistence_and_no_duplicate():
 assert_eq(SaveData.world_cousins140.known.size(),0)
 for id in VillageCousins140.IDS:
  var p:=VillageCousins140.point(SaveData.world_cousins140,id)
  world.player.position=p;world._open_cousin140(id)
  assert_true(is_instance_valid(world._npc_dialog));assert_true(SaveData.world_cousins140.known.has(id))
  assert_true(world._npc_dialog.body.text.contains(VillageCousins140.clue(id)))
  world._close_npc();world._open_cousin140(id);world._close_npc()
 assert_eq(SaveData.world_cousins140.known.size(),4)
 var before:Dictionary=SaveData.world_cousins140.duplicate(true);SaveData.load_progress();assert_eq(SaveData.world_cousins140,before)
 world._show_journal140();assert_true(is_instance_valid(world._journal140))
func test_out_of_range_and_failed_save_do_not_record_unheard_clue():
 var p:=VillageCousins140.point(SaveData.world_cousins140,"home")
 world.player.position=p+Vector2(500,0);world._open_cousin140("home");assert_null(world._npc_dialog);assert_true(SaveData.world_cousins140.known.is_empty())
 world.player.position=p;var path:String=SaveData.save_path;SaveData.save_path="user://missing140/save.dat"
 world._open_cousin140("home");assert_push_error_count(1);assert_true(SaveData.world_cousins140.known.is_empty());assert_null(world._npc_dialog);SaveData.save_path=path
func settle(p:Vector2):
 world.player.position=p;world._update_chunks()
 while not world._build_queue.is_empty():world._drain_chunk_builds();await get_tree().process_frame
 world.player.set_physics_process(false);await get_tree().physics_frame
func test_actual_continuous_trunk_and_access_to_all_four_cousins():
 var state:Dictionary=SaveData.world_cousins140;var paths:Array=[]
 var left:int=floori((state.doors.west140.x-80.)/5120.)
 var right:int=floori((state.doors.east140.x-80.)/5120.)
 for region in range(left,right+1):
  var path:=PackedVector2Array()
  for cell in WorldTerrain103.trunk(752026,region):path.append(ModularWorldLayout93.world(cell))
  paths.append(path)
 for id in VillageCousins140.IDS:
  var p:=VillageCousins140.point(state,id);paths.append(PackedVector2Array([Vector2(p.x,470),p]))
 var chunk:=Vector2i(999,999);var checked:int=0
 for points in paths:
  for i in points.size()-1:
   var a:Vector2=points[i];var b:Vector2=points[i+1];var count:int=maxi(1,ceili(a.distance_to(b)/24.))
   for j in range(count+1):
    var p:Vector2=a.lerp(b,float(j)/count)
    if WorldMap.chunk_at(p)!=chunk:chunk=WorldMap.chunk_at(p);await settle(p)
    world.player.position=p
    assert_false(WorldTerrain103.blocked(752026,p,14.))
    assert_true(world._get_surface98().contains(p,2.))
    assert_false(world.player.test_move(world.player.global_transform,(b-a).normalized()*4.),"Blocked cousin route at "+str(p))
    checked+=1
 assert_gt(checked,700)
func test_arrival_from_actual_previous_side_not_camera_and_stream_no_duplicates():
 var layer=world._cousin_layer140;layer.set_process(false)
 var point:=VillageCousins140.point(SaveData.world_cousins140,"home")
 for pair in [[Vector2.LEFT,"oeste"],[Vector2.RIGHT,"este"],[Vector2.UP,"norte"],[Vector2.DOWN,"sur"]]:
  layer.previous=point+pair[0]*610.;world.player.position=point+pair[0]*590.;layer._process(.016)
  assert_eq(SaveData.world_cousins140.arrivals.home,pair[1])
 layer.previous=point;world.player.position=point;SaveData.world_cousins140.arrivals.clear();layer._process(.016)
 assert_false(SaveData.world_cousins140.arrivals.has("home"),"Loading inside town does not invent travel direction")
 var before=layer.nodes.home;layer._process(.016);assert_eq(layer.nodes.home,before)
 world.player.position=Vector2(20000,20000);layer._process(.016);assert_false(layer.nodes.has("home"))
 world.player.position=point;layer._process(.016);assert_true(layer.nodes.has("home"))
 var art:Sprite2D=layer.nodes.home.get_node("CousinArt");assert_eq(art.scale,Vector2.ONE*.625)
 assert_eq(art.texture.get_size(),Vector2(192,192))
 SaveData.horse_collection.find(SaveData.horse_collection.selected).species="unicorn";layer._process(.016)
 assert_true(art.texture.resource_path.contains("sorpresa"))
func test_legacy_world_does_not_add_primos():
 world.free();world=null;SaveData.world_generator_version=1;SaveData.world_cousins140={};SaveData.world_flora138={}
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);assert_null(world._cousin_layer140);assert_true(SaveData.world_cousins140.is_empty());assert_eq(world._npcs98().size(),2)
