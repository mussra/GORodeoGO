extends GutTest
func test_chains_join_unsorted_segments_at_both_ends_without_changing_source():
 var segments:Array=[{'a':Vector2(10,0),'b':Vector2(10,10)},{'a':Vector2(0,0),'b':Vector2(10,0)},{'a':Vector2(0,10),'b':Vector2(10,10)}]
 var before:Array=segments.duplicate(true);var paths:Array=TownWallArt242.chains(segments)
 assert_eq(paths.size(),1);assert_eq(paths[0].size(),4);assert_eq(segments,before)
func test_six_town_shapes_have_closed_visual_corners_without_mutating_physics():
 var old:int=SaveData.world_generator_version;SaveData.world_generator_version=6
 var plans:Dictionary=TownEnclosures227.plans(752026);var seen:Dictionary={}
 for plan in plans.values():
  if seen.has(plan.shape):continue
  seen[plan.shape]=true
  var before:Dictionary=plan.duplicate(true);var geometry:Dictionary=TownWallArt242.geometry(plan)
  assert_false(geometry.outer.is_empty());assert_false(geometry.surface.is_empty());assert_false(geometry.inset.is_empty())
  assert_eq(TownWallArt242.chains(plan.segments).size(),4,'Four cardinal openings separate four wall chains')
  for segment in plan.segments:
   var middle:Vector2=(segment.a+segment.b)*.5
   assert_true(geometry.surface.any(func(poly):return Geometry2D.is_point_in_polygon(middle,poly)))
  assert_eq(plan,before,'Drawing does not move gate, collision segments, paths or buildings')
 assert_eq(seen.size(),6);SaveData.world_generator_version=old
func test_visual_gap_at_gate_is_not_filled():
 var old:int=SaveData.world_generator_version;SaveData.world_generator_version=6
 for plan in TownEnclosures227.plans(752026).values():
  var geometry:Dictionary=TownWallArt242.geometry(plan)
  assert_false(geometry.surface.any(func(poly):return Geometry2D.is_point_in_polygon(plan.gate,poly)))
 SaveData.world_generator_version=old
