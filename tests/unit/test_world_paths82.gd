extends GutTest
func test_accesses_are_deterministic_connected_and_end_at_thresholds():
 for seed in [1,99,752026]:
  var lanes=WorldPaths.access_lanes(seed)
  assert_eq(lanes,WorldPaths.access_lanes(seed));assert_eq(lanes.size(),3)
  assert_eq(lanes[0][-1],WorldPaths.RANCH_DOOR)
  assert_almost_eq(lanes[0][0].y,WorldMap.trail_y_at(seed,lanes[0][0].x),.001)
  assert_eq(lanes[1][-1],WorldPaths.ZONE_DOORS[0]);assert_eq(lanes[2][-1],WorldPaths.ZONE_DOORS[1])
  assert_eq(lanes[1][0],lanes[2][0]);assert_almost_eq(lanes[1][0].x,WorldMap.branch_x_at(seed,480),.001)
  for lane in lanes:
   assert_true(WorldMap.on_trail(seed,lane[-1]))
   for i in lane.size()-1:assert_gt(lane[i].distance_to(lane[i+1]),1.0)
func test_paths_do_not_change_generated_content_or_touch_save_data():
 var before=WorldMap.generate(752026,0,0);var discovered=SaveData.world_discovered.duplicate();var edits=SaveData.world_edits.duplicate(true)
 for seed in [1,2,752026]:WorldPaths.access_lanes(seed)
 assert_eq(WorldMap.generate(752026,0,0),before);assert_eq(SaveData.world_discovered,discovered);assert_eq(SaveData.world_edits,edits)
func test_animal_parcels_keep_clear_of_every_possible_trunk_and_access():
 for seed in [1,2,99,12345,752026,7781]:
  for pen in [WorldTestZone.MEADOW,WorldTestZone.PEN]:
   for x in range(int(pen.position.x),int(pen.end.x)+1,20):
    for y in range(int(pen.position.y),int(pen.end.y)+1,20):
     var pos=WorldTestZone.ZONE_POS+Vector2(x,y)
     assert_gt(WorldMap.trail_distance(seed,pos),64.0)
 for h in WorldTestZone.HORSES:assert_true(WorldTestZone.MEADOW.grow(-60).has_point(h.home))
 for p in WorldTestZone.PIGS:assert_true(WorldTestZone.PEN.grow(-24).has_point(p))
