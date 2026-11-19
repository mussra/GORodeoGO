extends GutTest
func test_four_cardinal_passages_follow_every_shape_and_remain_walkable():
 var old:int=SaveData.world_generator_version
 var seen:Dictionary={}
 for version in [4,5,6]:
  SaveData.world_generator_version=version
  for seed_ in [752026,7781,9991]:
   for plan in TownEnclosures227.plans(seed_).values():
    seen[plan.shape]=true
    assert_eq(plan.gates.size(),4)
    assert_eq(plan.posts.size(),8)
    for name_ in ["north","south","east","west"]:
     var entry:Dictionary=plan.gates[name_];var normal:Vector2=entry.outward
     var tangent:=normal.orthogonal()
     assert_eq(entry.posts.size(),2)
     assert_almost_eq(absf((entry.posts[1]-entry.posts[0]).dot(tangent)),320.,.01)
     for offset in [-90.,0.,90.]:
      for distance in [-360.,-180.,0.,180.,360.]:
       var point:Vector2=entry.point+normal*distance+tangent*offset
       assert_false(TownEnclosures227.blocked(seed_,point,22.),str(plan.shape_name,' ',name_,' ',point))
     var geometry:Dictionary=TownWallArt242.geometry(plan)
     assert_false(geometry.outer.any(func(poly):return Geometry2D.is_point_in_polygon(entry.point,poly)))
    assert_eq(plan.gate,plan.gates.south.point,'Existing south anchor retained')
    assert_eq(plan.access_roads318.size(),3)
 assert_eq(seen.size(),6)
 SaveData.world_generator_version=old
func test_mouth_segments_do_not_enter_any_of_the_four_cut_strips():
 var old:int=SaveData.world_generator_version;SaveData.world_generator_version=6
 for plan in TownEnclosures227.plans(752026).values():
  for segment in plan.segments:
   var midpoint:Vector2=(segment.a+segment.b)*.5
   for entry in plan.gates.values():assert_false((entry.cut as Rect2).grow(-.1).has_point(midpoint))
 SaveData.world_generator_version=old
func test_content_bounds_are_measured_from_real_outdoor_components():
 var old:int=SaveData.world_generator_version;SaveData.world_generator_version=6
 var seed_:int=752026
 for plan in TownEnclosures227.plans(seed_).values():
  for box in TownContent318.boxes(seed_,plan.id,TownEnclosures227.doors(seed_)[plan.id]):
   assert_true((plan.contents as Rect2).grow(.1).encloses(box))
  if plan.id!="home":
   assert_lt(plan.contents.size.x,1550.)
   assert_lt(plan.contents.size.y,1120.)
 SaveData.world_generator_version=old
