extends "res://tests/unit/test_herd_town217.gd"
func test_new_tree_topology_and_seeded_north_south_office_swap():
 SaveData.world_generator_version=5;var choices:Dictionary={}
 for seed_ in range(752026,752046):
  var doors:=TownEnclosures227.doors(seed_);assert_gt(doors.east138.x,doors.home.x);assert_eq(doors.west140.x,doors.east138.x);assert_eq(doors.east140.x,doors.east138.x)
  assert_almost_eq(absf(doors.west140.y-doors.east138.y),10240.,.01);assert_almost_eq(absf(doors.east140.y-doors.east138.y),10240.,.01)
  assert_lt((doors.west140.y-doors.east138.y)*(doors.east140.y-doors.east138.y),0.);choices[TownEnclosures227.branch_flip231(seed_)]=true
  assert_eq(TownEnclosures227.doors(seed_),doors)
  assert_eq(TownEnclosures227.cousin_ids231(),["west140"])
  var plans:=TownEnclosures227.plans(seed_)
  for id in plans:
   var road:PackedVector2Array=plans[id].road
   for i in road.size()-1:assert_eq(WorldTerrain103.safe_step(seed_,road[i],road[i+1],24.),road[i+1],"Every branch must enter via a gate, not another town wall")
 assert_eq(choices.size(),2)
func test_v4_world_positions_do_not_move_and_flora_cousin_and_services_stay_inside_v5():
 SaveData.world_generator_version=4;assert_eq(TownEnclosures227.doors(752026).west140,Vector2(-9920,358));var old:=TownEnclosures227.plans(752026).duplicate(true)
 SaveData.world_generator_version=5;var towns:=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]));assert_eq(towns.doors,TownEnclosures227.doors(752026));assert_eq(FloristJourney138.door(FloristJourney138.fresh([])),towns.doors.east138)
 for id in ["west140","east140"]:
  var plan:Dictionary=TownEnclosures227.plans(752026)[id]
  for point in [towns.doors[id]+Vector2(110,32),towns.doors[id]+Vector2(-210,-48),towns.doors[id]+Vector2(210,-48),VillageCousins140.point(towns,id)]:assert_true(Geometry2D.is_point_in_polygon(point,plan.polygon));assert_false(WorldTerrain103.blocked(752026,point,40.))
 SaveData.world_generator_version=4;assert_eq(TownEnclosures227.plans(752026),old)
