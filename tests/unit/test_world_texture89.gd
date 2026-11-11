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
