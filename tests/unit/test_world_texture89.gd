extends GutTest
func test_grass_variant_is_deterministic_and_has_all_three():
 var found={}
 for y in range(-6,7):
  for x in range(-6,7):
   var cell=Vector2i(x,y);var a=WorldGrassTexture.variant(752026,cell)
   assert_eq(a,WorldGrassTexture.variant(752026,cell));assert_between(a,0,2);found[a]=true
 assert_eq(found.size(),3)
func test_rounding_preserves_endpoints_and_finite_path():
 for lane in WorldPaths.access_lanes(752026):
  var result=ContinuousRoadArt.rounded(lane,32)
  assert_eq(result[0],lane[0]);assert_eq(result[-1],lane[-1])
  for p in result:assert_true(p.is_finite())
func test_texture_presentation_does_not_change_generated_content_or_distances():
 var before=WorldMap.generate(752026,0,0);var distance=WorldMap.trail_distance(752026,Vector2(200,500))
 var a=WorldGrassTexture.new();a.c=Vector2i.ZERO;add_child_autofree(a)
 assert_eq(WorldMap.generate(752026,0,0),before)
 assert_eq(WorldMap.trail_distance(752026,Vector2(200,500)),distance)
 assert_eq(a.get_child_count(),0,"no collision nodes added")
func test_actual_world_junctions_use_two_crosses_and_two_tees():
 for seed in [752026,1,42,987654]:
  var junctions=WorldRoadJunctions.layout(seed)
  assert_eq(junctions.size(),4)
  assert_eq(junctions[0].kind,"cross");assert_eq(junctions[1].kind,"t")
  assert_eq(junctions[2].kind,"cross");assert_eq(junctions[3].kind,"t")
  var crossing:Vector2=junctions[0].center
  assert_almost_eq(crossing.y,WorldMap.trail_y_at(seed,crossing.x),.01)
  assert_almost_eq(crossing.x,WorldMap.branch_x_at(seed,crossing.y),.01)
  var lanes=WorldPaths.access_lanes(seed)
  assert_eq(junctions[1].center,lanes[0][0])
  assert_eq(junctions[2].center,lanes[1][0]);assert_eq(junctions[2].center,lanes[2][0])
  assert_eq(junctions[3].center,lanes[3][0])
  assert_gt(junctions[3].center.y-junctions[3].half.y,junctions[2].center.y+junctions[2].half.y)
func test_ribbon_clipping_keeps_only_real_intersections():
 assert_eq(ContinuousRoadArt._inside_interval(Vector2(-100,0),Vector2(100,0),Vector2(30,20)),[.35,.65])
 assert_eq(ContinuousRoadArt._inside_interval(Vector2(-100,40),Vector2(100,40),Vector2(30,20)),[])
 assert_eq(ContinuousRoadArt._inside_interval(Vector2(0,-100),Vector2(0,100),Vector2(30,20)),[.4,.6])
