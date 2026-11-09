extends GutTest
func test_every_wild_pose_has_body_map_and_idle_matches_side():
 for view in ["side","up","down","diag_down","diag_up"]:
  for i in 12:
   var uv:Image=HorseAppearance.pose_uv("wild_walk_"+view,i)
   assert_not_null(uv);assert_eq(uv.get_size(),Vector2i(96,96))
 assert_eq(HorseAppearance.pose_uv("wild_side",0).get_data(),HorseAppearance.pose_uv("wild_walk_side",0).get_data())
func test_head_centres_stay_in_head_island_when_turning():
 var heads:Dictionary={"side":Vector2i(78,35),"down":Vector2i(48,28),"up":Vector2i(48,23),"diag_down":Vector2i(69,23),"diag_up":Vector2i(70,20)}
 for view in heads:
  var p:Vector2i=heads[view]
  var mapped:Vector2=HorseAppearance.body_point(HorseAppearance.pose_uv("wild_walk_"+view,0),p.x,p.y,0)
  assert_between(mapped.x,73.0,84.0,view+" head stays head not neck")
  assert_between(mapped.y,28.0,42.0)
func test_fallback_and_caches_do_not_change_unmapped_animations():
 assert_null(HorseAppearance.pose_uv("foal",0))
 assert_eq(HorseAppearance.body_point(null,60,40,3),Vector2(60,37))
 assert_eq(HorseAppearance.pose_uv("wild_walk_side",2),HorseAppearance.pose_uv("wild_walk_side",2))
func test_spot_edges_are_blended_and_layout_deterministic():
 var spot:Vector4=HorseAppearance.spots()[0]
 var p:Vector2=Vector2(spot.x,spot.y)+Vector2(spot.z,0).rotated(-spot.w)
 assert_almost_eq(HorseAppearance.natural_spot_coverage(p),.5,.001)
 assert_eq(HorseAppearance.natural_spot_coverage(Vector2(spot.x,spot.y)),1.0)
