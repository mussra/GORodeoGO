extends GutTest
func test_both_leafs_keep_uniform_scale():
 for left in [true,false]:
  var r:=TownGateArt316.rect(Vector2(160,200),left)
  assert_almost_eq(r.size.x/r.size.y,614./562.,.00001)
  assert_eq(r.size.y,90.)
func test_leafs_never_enter_existing_320_unit_gate():
 var plans:=TownEnclosures227.plans(752026)
 for plan in plans.values():
  for post in plan.posts:
   var left:bool=post.x<plan.gate.x
   var r:=TownGateArt316.rect(post,left)
   if left:assert_lt(r.end.x,plan.gate.x-160.)
   else:assert_gt(r.position.x,plan.gate.x+160.)
func test_art_has_matching_crops_and_no_physics_nodes():
 assert_eq(TownGateArt316.LEFT.get_size(),Vector2(614,562))
 assert_eq(TownGateArt316.RIGHT.get_size(),Vector2(614,562))
 assert_eq(TownEnclosures227.GATE_WIDTH,320.)
