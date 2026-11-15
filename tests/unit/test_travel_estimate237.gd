extends GutTest
func test_estimate_uses_actual_speed_power_energy_and_rest_instead_of_distance_divided_by_speed():
 var slow:Dictionary={"stats":{"speed":240.,"power":.5}};var fast:Dictionary={"stats":{"speed":300.,"power":.9}}
 var a:=TravelEstimate237.seconds(24000.,slow);var b:=TravelEstimate237.seconds(24000.,fast)
 assert_gt(a,b);assert_gt(a,100.);assert_gt(b,80.);assert_gt(TravelEstimate237.seconds(24000.,slow,{"value":0.,"max":100.,"forced_left":4.}),a)
 assert_gt(TravelEstimate237.seconds(48000.,fast),b)
 assert_lte(TravelEstimate237.seconds(24000.,fast,{},.85),b)
func test_route_sum_uses_shared_physical_road_path_and_intermediate_village():
 SaveData.world_generator_version=6;SaveData.world_seed=752026;TownNetwork234.ensure_near(752026,Vector2.ZERO)
 var checked:bool=false
 for node in TownNetwork234.base_nodes(752026).values():
  for role in node.targets:
   var route:=TravelEstimate237.route(752026,node.id,role);assert_gte(route.hops,1);assert_gt(route.distance,0.)
   var plans:=TownEnclosures227.plans(752026)
   for i in route.paths.size():assert_eq(route.paths[i],TownNetwork234.link_path(752026,route.ids[i],route.ids[i+1],plans))
   if route.hops==2:checked=true
 assert_true(checked)
 SaveData.world_generator_version=4
