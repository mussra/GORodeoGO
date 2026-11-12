extends GutTest
func test_256_seeds_connected_tree_long_main_axis_unique_building_spurs():
 var variants={}
 for seed in range(256):
  var plan=ModularWorldLayout93.plan(seed);var g:Dictionary=plan.graph;var edges:int=0
  variants[str(plan.branches)]=true
  for cell in g:
   edges+=g[cell].size()
   for next in g[cell]:
    assert_eq(absi(next.x-cell.x)+absi(next.y-cell.y),1)
    assert_true(g[next].has(cell))
  assert_eq(edges/2,g.size()-1,"tree: no cycles")
  for cell in g:assert_false(ModularWorldLayout93.route(g,Vector2i(0,4),cell).is_empty(),"one connected network")
  var main=ModularWorldLayout93.route(g,plan.landmarks.west_pass,plan.landmarks.east_pass)
  assert_eq(main.size(),15)
  for i in main.size():assert_eq(main[i],Vector2i(i,4),"main road never doubles back")
  for id in plan.doors:
   var door:Vector2i=plan.doors[id]
   assert_eq(g[door].size(),1,"building cannot interrupt through-road")
   assert_false(main.has(door))
   var spur:Dictionary={};ModularWorldLayout93._path(spur,plan.branches[id])
   var attachments:int=0
   for cell in spur:
    if main.has(cell):attachments+=1
   assert_eq(attachments,1,"single-entry building branch")
   assert_lte(ModularWorldLayout93.route(g,plan.branches[id][0],door).size()-1,5,"building close to through-road")
  for target in plan.landmarks.values():
   assert_eq(g[target].size(),1)
   assert_false(ModularWorldLayout93.route(g,plan.doors.ranch,target).is_empty())
  assert_gte((ModularWorldLayout93.route(g,plan.landmarks.west_pass,plan.landmarks.lookout).size()-1)*80,1200,"long exploration route")
 assert_gte(variants.size(),4,"seed changes legal building spurs")
func test_deterministic_local_rng_does_not_change_saved_world():
 var before=SaveData.world_edits.duplicate(true);var pos=SaveData.world_position
 assert_eq(ModularWorldLayout93.plan(42),ModularWorldLayout93.plan(42))
 assert_eq(SaveData.world_edits,before);assert_eq(SaveData.world_position,pos)
