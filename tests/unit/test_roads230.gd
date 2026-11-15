extends "res://tests/unit/test_herd_town217.gd"
func test_t_cross_corner_and_diagonal_fork_are_single_merged_road_surfaces():
 var groups:Array=[
 [PackedVector2Array([Vector2(-160,0),Vector2(160,0)]),PackedVector2Array([Vector2(0,0),Vector2(0,-160)])],
 [PackedVector2Array([Vector2(-160,0),Vector2(160,0)]),PackedVector2Array([Vector2(0,160),Vector2(0,-160)])],
 [PackedVector2Array([Vector2(-160,0),Vector2(0,0),Vector2(0,-160)])],
 [PackedVector2Array([Vector2(0,160),Vector2(0,0),Vector2(-130,-130)]),PackedVector2Array([Vector2(0,0),Vector2(130,-130)])]]
 for group in groups:
  var lanes:Array=[]
  for path in group:lanes.append({"points":path,"width":32.})
  var merged:Array=RoadNetwork230.polygons(lanes);assert_eq(merged.size(),1,"No internal strips or independent end caps")
  for path in group:
   for point in path:assert_true(Geometry2D.is_point_in_polygon(point,merged[0]))
  assert_true(Geometry2D.is_point_in_polygon(Vector2.ZERO,merged[0]))
func test_road_geometry_is_deterministic_and_never_mutates_save_or_existing_routes():
 SaveData.world_generator_version=4;SaveData.world_seed=752026;SaveData.world_cousins140=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]));SaveData.world_flora138=FloristJourney138.fresh([])
 var before:=SaveData.world_cousins140.duplicate(true);var flora:=SaveData.world_flora138.duplicate(true);var graph:=WorldNominal98.graph_for_chunk(752026,Vector2i(0,0),4).duplicate(true)
 var first:=RoadNetwork230.geometry(752026,Vector2i(0,0),4);RoadNetwork230.cache.clear();assert_eq(first,RoadNetwork230.geometry(752026,Vector2i(0,0),4));assert_false(first.is_empty())
 assert_eq(SaveData.world_cousins140,before);assert_eq(SaveData.world_flora138,flora);assert_eq(WorldNominal98.graph_for_chunk(752026,Vector2i(0,0),4),graph)
func test_chunk_boundary_union_has_no_gap_at_grid_edge_for_v2_v3_and_v4():
 for version in [2,3,4]:
  SaveData.world_generator_version=version;SaveData.world_seed=752026
  var point:=Vector2(1024,470 if version<4 else 3990)
  var c:=WorldMap.chunk_at(point)
  for side in [c,c+Vector2i.LEFT]:
   var polygons:Array=RoadNetwork230.geometry(752026,side,version)
   assert_true(polygons.any(func(p):return Geometry2D.is_point_in_polygon(point,p)))
