extends GutTest
var old_version:int
func before_each():old_version=SaveData.world_generator_version;SaveData.world_generator_version=6
func after_each():SaveData.world_generator_version=old_version
func brute(point:Vector2,margin:float)->bool:
 var plans:Dictionary=TownEnclosures227.plans(752026)
 var routes:Array=TownNetwork234.roads(752026,plans).duplicate()
 for plan in plans.values():
  routes.append(plan.road);routes.append_array(plan.access_roads318)
 for route in routes:
  for i in route.size()-1:
   if point.distance_to(Geometry2D.get_closest_point_to_segment(point,route[i],route[i+1]))<=22.+margin:return true
 return false
func test_index_matches_original_roads_across_edges_and_focus_changes():
 var surface:=WorldRoadSurface94.new(752026,true,false,true,6)
 var rng:=RandomNumberGenerator.new();rng.seed=246
 for focus in [Vector2.ZERO,Vector2(80000,-30000)]:
  TownNetwork234.ensure_near(752026,focus)
  for i in 450:
   var point:Vector2=focus+Vector2(rng.randf_range(-14000,14000),rng.randf_range(-14000,14000))
   var margin:float=[0.,18.,128.,300.][i%4]
   assert_eq(surface._town_roads246(point,margin),brute(point,margin),'same surface '+str(point))
  var plans:Dictionary=TownEnclosures227.plans(752026)
  for plan in plans.values():
   var gate:Vector2=plan.gate
   for offset in [-40.,-22.,0.,22.,40.]:
    var point:Vector2=gate+Vector2(offset,100.)
    assert_eq(surface._town_roads246(point,18.),brute(point,18.))
 TownNetwork234.ensure_near(752026,Vector2.ZERO)
func test_local_queries_check_only_nearby_segments_and_cache_stays_bounded():
 var surface:=WorldRoadSurface94.new(752026,true,false,true,6)
 for i in 100:surface._town_roads246(Vector2(900+i,650),18.)
 assert_lt(surface.segment_checks246,100*surface._segments246.size()/4)
 assert_lte(surface._buckets246.size(),256)
func test_map_is_opaque_and_flower_source_empty():
 assert_eq(MapAppearance.floor_color('10252d').a,1.)
 var map:=WorldDiscoveryMap159.new();assert_eq(map.flowers159(),{});map.free()
func test_old_frame_cache_evicts_only_cache_ownership_not_live_resource():
 var art=load('res://src/Presentation/wild_horse_art.gd')
 var previous:Dictionary=art.frame_cache.duplicate();art.frame_cache.clear()
 var kept:=SpriteFrames.new();art.remember246('old',kept)
 for i in 40:art.remember246('test'+str(i),SpriteFrames.new())
 assert_lte(art.frame_cache.size(),32);assert_true(is_instance_valid(kept))
 art.frame_cache=previous
