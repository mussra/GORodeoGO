extends GutTest
func test_original_supplied_images_are_full_size_and_path_reaches_door():
 assert_eq(WorldFloristShop.SHOP.get_size(),Vector2(1536,1024));assert_eq(WorldFloristShop.FLORIST.get_size(),Vector2(1024,1536))
 assert_eq(WorldPaths.FLORIST_DOOR,WorldFloristShop.DOOR)
 for seed in [1,2,99,752026,7781]:
  var lane=WorldPaths.florist_lane(seed)
  assert_eq(lane[-1],WorldFloristShop.DOOR)
  assert_eq(lane[0],Vector2(WorldMap.branch_x_at(seed,530),530))
  assert_true(WorldMap.on_trail(seed,WorldFloristShop.DOOR))
  for i in lane.size()-1:
   for n in 21:assert_false(WorldFloristShop.BODY.grow(16).has_point(lane[i].lerp(lane[i+1],n/20.)))
func test_fixed_site_only_hides_seeded_decor_never_edits_or_mutates_source():
 var d={"kind":"tree","pos":WorldFloristShop.BASE,"scale":1.};var old=d.duplicate(true)
 assert_false(WorldFloristShop.keep_decor(d,752026));assert_eq(d,old)
 d["edited"]=true;assert_true(WorldFloristShop.keep_decor(d,752026))
 var lane=WorldPaths.florist_lane(752026)
 assert_false(WorldFloristShop.keep_decor({"kind":"tree","pos":lane[0].lerp(lane[1],.7),"scale":1.},752026))
 assert_true(WorldFloristShop.keep_decor({"kind":"tree","pos":Vector2(10000,10000),"scale":1.},752026))
