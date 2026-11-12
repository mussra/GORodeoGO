extends GutTest
func test_new_world_picks_v3_but_seeded_world_keeps_legacy():
 var script=load("res://src/Application/save_data.gd");var save=script.new();add_child_autofree(save)
 save.save_path="user://nominal98-only.dat";save.trial_session_active=true
 save.world_seed=777;save.world_generator_version=1
 assert_eq(save.ensure_world_seed(),777);assert_eq(save.world_generator_version,1)
 save.world_seed=0
 assert_gt(save.ensure_world_seed(),0);assert_eq(save.world_generator_version,3)
 assert_eq(save.world_position,ModularWorldLayout93.world(WorldTerrain103.plan(save.world_seed).doors.ranch)+Vector2(0,70))
func test_version_roundtrip_legacy_default_unknown_rejected():
 var script=load("res://src/Application/save_data.gd");var save=script.new();add_child_autofree(save)
 save.save_path="user://nominal98-version-only.dat";save.world_seed=12345;save.world_generator_version=2;save.trial_session_active=false;save.world_missions={"herd_1,0":"done"};save.world_tamed.assign(["herd_1,0#0"]);save.world_position=Vector2(4567,470)
 assert_true(save.save_progress());save.world_generator_version=1;save.load_progress();assert_eq(save.world_generator_version,2);assert_eq(save.world_seed,12345)
 assert_eq(save.world_missions,{"herd_1,0":"done"});assert_eq(save.world_tamed,["herd_1,0#0"]);assert_eq(save.world_position,Vector2(4567,470))
 var config=ConfigFile.new();assert_eq(config.load(save.save_path),OK);config.erase_section_key("world","generator_version");config.save(save.save_path)
 var old_bytes:PackedByteArray=FileAccess.get_file_as_bytes(save.save_path)
 save.load_progress();assert_eq(save.world_generator_version,1);assert_eq(save.world_seed,12345)
 assert_eq(save.ensure_world_seed(),12345);assert_eq(FileAccess.get_file_as_bytes(save.save_path),old_bytes)
 config.set_value("world","generator_version",99);config.save(save.save_path);save.load_progress();assert_false(save._load_valid);assert_false(save.save_progress())
 DirAccess.remove_absolute(save.save_path)
func test_infinite_trunk_cells_and_surface_are_consistent():
 for seed in [1,42,752026]:
  var surface=WorldRoadSurface94.new(seed,true,false,true)
  for cx in range(-6,7):
   var g=WorldNominal98.graph_for_chunk(seed,Vector2i(cx,0))
   for cell in g:
    if cell.y!=4:continue
    assert_true(g[cell].has(cell+Vector2i.LEFT));assert_true(g[cell].has(cell+Vector2i.RIGHT))
    assert_true(surface.contains(ModularWorldLayout93.world(cell)))
    assert_false(ModularWorldLayout93.piece(g,cell).is_empty())

func test_nominal_region_no_chunk_seam_cycle_or_building_dead_end_in_main():
 for seed in range(32):
  var graph:Dictionary={}
  for cx in range(-3,4):
   for cy in range(-1,2):graph.merge(WorldNominal98.graph_for_chunk(seed,Vector2i(cx,cy)),true)
  var count:int=0
  for cell in graph:
   for next in graph[cell]:
    if graph.has(next):count+=1;assert_true(graph[next].has(cell))
  assert_eq(count/2,graph.size()-1)
  var start=graph.keys()[0]
  for door in ModularWorldLayout93.DOORS.values():assert_false(ModularWorldLayout93.route(graph,start,door).is_empty())
  for cell in graph:
   if cell.y==4:assert_eq(ModularWorldLayout93.piece(graph,cell).ports[1],1);assert_eq(ModularWorldLayout93.piece(graph,cell).ports[3],1)
