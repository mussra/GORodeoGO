extends GutTest
func after_each():SaveData.world_generator_version=4
func test_fifty_seeds_form_cardinal_trees_with_four_distinct_root_recommendations():
 var skipped:int=0
 for seed_ in range(752026,752076):
  var nodes:=TownNetwork234.base_nodes(seed_);assert_gt(nodes.size(),10);assert_eq(nodes.home.roles.size(),4);assert_eq(nodes.home.targets.size(),4)
  var seen:Dictionary={};var edges:int=0
  for node in nodes.values():
   assert_false(seen.has(node.cell));seen[node.cell]=true;assert_gte(node.roles.size(),2)
   if not node.parent.is_empty():edges+=1
   var directions:Dictionary={}
   for role in node.targets:
    var child:Dictionary=nodes[node.targets[role]];assert_true(child.roles.has(role));assert_gt(child.depth,node.depth)
    var gap:Vector2i=child.cell-node.cell;assert_true(gap.x==0 or gap.y==0);var unit:Vector2i=Vector2i(signi(gap.x),signi(gap.y));assert_false(directions.has(unit));directions[unit]=true
    assert_ne(child.id,node.parent)
    var path:=TownNetwork234.recommendation_path(seed_,node.id,role);assert_eq(path[-1],child.id);assert_eq(path.size()-1,absi(gap.x)+absi(gap.y))
    if path.size()>2:skipped+=1
   if not node.parent.is_empty():assert_false(directions.has(nodes[node.parent].cell-node.cell))
  assert_eq(edges,nodes.size()-1);assert_eq(nodes,TownNetwork234.base_nodes(seed_))
 assert_gt(skipped,0)
func test_all_visual_roads_clear_walls_and_services_are_inside_for_three_seeds():
 SaveData.world_generator_version=6
 for seed_ in [752026,752027,752028]:
  SaveData.world_seed=seed_;TownNetwork234.ensure_near(seed_,Vector2(1000,358));var plans:=TownEnclosures227.plans(seed_)
  for node in TownNetwork234.nodes(seed_).values():
   for role in node.roles:assert_true(Geometry2D.is_point_in_polygon(TownNetwork234.point(seed_,node.id,role),plans[node.id].polygon))
  for path in TownNetwork234.roads(seed_,plans):
   for i in path.size()-1:
    for j in range(21):assert_false(TownEnclosures227.blocked(seed_,path[i].lerp(path[i+1],j/20.),30.))
func test_infinite_far_coordinates_reproduce_positions_identity_offices_and_variable_distances():
 SaveData.world_generator_version=6;var seed_:int=752026;var distances:Dictionary={}
 for cell in [Vector2i(30,40),Vector2i(-40,80),Vector2i(2000,-900)]:
  var point:=TownNetwork234.position_for(seed_,cell);TownNetwork234.ensure_near(seed_,point);var node:=TownNetwork234.cell_node(seed_,cell)
  assert_true(TownNetwork234.nodes(seed_).has(node.id));assert_eq(TownNetwork234.cell_at(seed_,point),cell);assert_eq(TownNetwork234.point(seed_,node.id,node.roles[0]),node.door+Vector2(-220,30));assert_eq(node.roles.size(),2)
  var look:=TownIdentity215.look236(seed_,node.id);TownNetwork234.ensure_near(seed_,Vector2.ZERO);assert_eq(TownNetwork234.node_for(seed_,node.id),node);assert_eq(TownIdentity215.look236(seed_,node.id),look)
  distances[roundi(point.distance_to(TownNetwork234.position_for(seed_,cell+Vector2i.RIGHT)))]=true
 assert_gt(distances.size(),1)
