extends GutTest
func test_1000_seeds_connected_tree_doors_passes_deterministic():
 var structures:Dictionary={};var buildings:Dictionary={}
 for seed in range(1000):
  var plan:Dictionary=WorldTerrain103.plan(seed);var graph:Dictionary={}
  assert_eq(plan,WorldTerrain103.plan(seed))
  for region in range(-2,3):ModularWorldLayout93._path(graph,WorldTerrain103.trunk(seed,region))
  for cell in plan.graph:
   if not graph.has(cell):graph[cell]=[]
   for next in plan.graph[cell]:
    if not graph[cell].has(next):graph[cell].append(next)
  var edges:int=0
  for cell in graph:
   for next in graph[cell]:
    assert_true(graph.has(next));assert_true(graph[next].has(cell));edges+=1
  assert_eq(edges/2,graph.size()-1)
  for door in plan.doors.values():
   assert_false(ModularWorldLayout93.route(graph,Vector2i.ZERO+Vector2i(0,4),door).is_empty())
   assert_false(WorldTerrain103.blocked(seed,ModularWorldLayout93.world(door),32.))
  structures[hash(var_to_str(plan.graph))]=true;buildings[hash(var_to_str(plan.doors))]=true
  for region in [-7,0,1,1000]:
   for band in [-7,0,1,1000]:
    var ridge:Dictionary=WorldTerrain103.ridge(seed,region,band)
    var a:Vector2=ridge.port-Vector2(300,0);var b:Vector2=ridge.port+Vector2(300,0)
    assert_false(WorldTerrain103.blocked(seed,ridge.port,28.))
    var blocked_a:Vector2=ridge.port+Vector2(-300,150);var blocked_b:Vector2=ridge.port+Vector2(300,150)
    assert_true(WorldTerrain103.blocked(seed,ridge.port+Vector2(0,150),18.))
    assert_false(WorldTerrain103.blocked(seed,WorldTerrain103.clear_spawn(seed,ridge.boxes[0].get_center()),20.))
 print("MOUNTAINS103 measured seeds=1000 core_graphs=",structures.size()," building_layouts=",buildings.size())
 assert_gt(structures.size(),8);assert_gt(buildings.size(),1)
func test_chunk_clipping_and_road_consistency():
 for seed in [1,42,752026]:
  var surface=WorldRoadSurface94.new(seed,true,false,true,3)
  for cx in range(-8,9):
   for cy in range(-3,4):
    var chunk=Vector2i(cx,cy);var graph=WorldTerrain103.graph_for_chunk(seed,chunk)
    for cell in graph:
     assert_false(ModularWorldLayout93.piece(graph,cell).is_empty())
     for next in graph[cell]:assert_true(surface.contains(ModularWorldLayout93.world(cell)+Vector2(next-cell)*39.))
     assert_false(WorldTerrain103.blocked(seed,ModularWorldLayout93.world(cell),28.))
    var bounds:Rect2=Rect2(Vector2(chunk)*1024.,Vector2.ONE*1024.)
    for item in WorldTerrain103.ridges_for_chunk(seed,chunk):
     assert_true(bounds.encloses(item.box));assert_true(item.box.has_area())
func test_legacy_generate_unchanged_and_v3_origins_clear():
 var old:int=SaveData.world_generator_version
 for version in [1,2,3]:
  SaveData.world_generator_version=version
  for cx in range(-4,5):
   for cy in range(-3,4):
    var data=WorldMap.generate(42,cx,cy)
    if version<3:assert_eq(data,WorldMap.generate_legacy(42,cx,cy))
    else:
     for key in ["herd","pigs"]:
      if data.has(key) and not data[key].is_empty():assert_false(WorldTerrain103.blocked(42,data[key].pos,20.))
 SaveData.world_generator_version=old
func test_swept_motion_cannot_tunnel_and_free_space_unaffected():
 var ridge=WorldTerrain103.ridge(42,0)
 for distance in [1.,20.,100.,5000.]:
  var a:Vector2=ridge.port+Vector2(-200,200);var b:Vector2=a+Vector2(distance,0)
  assert_false(WorldTerrain103.blocked(42,WorldTerrain103.safe_step(42,a,b),18.))
 var a:Vector2=Vector2(500,2000);var b:Vector2=Vector2(700,2100)
 assert_eq(WorldTerrain103.safe_step(42,a,b),b)
