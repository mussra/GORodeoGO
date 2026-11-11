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
