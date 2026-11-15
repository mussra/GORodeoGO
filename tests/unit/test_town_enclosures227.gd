extends "res://tests/unit/test_herd_town217.gd"
func test_all_shapes_enclose_all_owned_contents_and_have_one_walkable_entrance():
 SaveData.world_generator_version=4
 var seen:Dictionary={};var towns:int=0
 for seed_ in range(752026,752046):
  var plans:=TownEnclosures227.plans(seed_);assert_eq(plans.size(),4)
  for id in VillageCousins140.IDS:
   var plan:Dictionary=plans[id];seen[plan.shape]=true;towns+=1
   assert_eq(plan.posts.size(),2,"Exactly two ends of one doorway")
   for x in 5:
    for y in 5:
     var point:Vector2=plan.contents.position+plan.contents.size*Vector2(x/4.,y/4.)
     assert_true(Geometry2D.is_point_in_polygon(point,plan.polygon),"Owned content must stay inside")
     assert_false(WorldTerrain103.blocked(seed_,point,45.),"Owned content must not overlap wall")
   assert_false(WorldTerrain103.blocked(seed_,plan.gate,22.),"Gate is physically open")
   assert_eq(WorldTerrain103.safe_step(seed_,plan.gate-Vector2(0,260),plan.gate+Vector2(0,260)),plan.gate+Vector2(0,260),"Gate can be crossed in both directions")
   for segment in plan.segments:
    var mid:Vector2=(segment.a+segment.b)*.5;assert_true(WorldTerrain103.blocked(seed_,mid),"Walls block everywhere except gate")
   var road:PackedVector2Array=plan.road
   for i in road.size()-1:assert_eq(WorldTerrain103.safe_step(seed_,road[i],road[i+1],24.),road[i+1],"Gate road cannot cross wall")
 assert_eq(seen.size(),6);assert_eq(towns,80)
func test_towns_are_separated_and_seeded_not_rerolled_on_reload():
 SaveData.world_generator_version=4
 for seed_ in [7781,752026,9991]:
  var plans:=TownEnclosures227.plans(seed_);var before:=plans.duplicate(true);TownEnclosures227.cache.clear();assert_eq(TownEnclosures227.plans(seed_),before)
  for i in 4:
   for j in range(i+1,4):
    var a:Dictionary=plans[VillageCousins140.IDS[i]];var b:Dictionary=plans[VillageCousins140.IDS[j]]
    assert_false((a.bounds as Rect2).grow(500).intersects(b.bounds));assert_gt((a.center as Vector2).distance_to(b.center),9000.)
func test_legacy_terrain_and_registry_are_unchanged_and_v4_registry_matches_geometry():
 SaveData.world_generator_version=3
 var old_flora:=FloristJourney138.fresh([]);var old_towns:=VillageCousins140.fresh(752026,[],old_flora);assert_eq(old_towns.doors.east138,Vector2(5440,358))
 assert_false(WorldTerrain103.ridges_for_chunk(752026,Vector2i(1,0))[0].has("town227"));var ridge:=WorldTerrain103.ridge(752026,0);assert_true(WorldTerrain103.blocked(752026,ridge.boxes[0].get_center()))
 SaveData.world_generator_version=4
 var flora:=FloristJourney138.fresh([]);var towns:=VillageCousins140.fresh(752026,[],flora)
 assert_eq(flora.region,2);assert_eq(FloristJourney138.door(flora),towns.doors.east138);assert_eq(towns.doors,TownEnclosures227.doors(752026))
 assert_ne(towns.doors,old_towns.doors);assert_eq(VillageCousins140.clean(towns,752026),towns)
func test_wild_populations_and_decor_are_not_generated_inside_new_towns():
 SaveData.world_generator_version=4;SaveData.world_seed=752026
 var surface:=WorldRoadSurface94.new(752026,true,false,true,4);var checked:int=0
 for cx in range(-2,4):
  for cy in range(-2,3):
   var data:Dictionary=WorldMap.generate(752026,cx,cy)
   for key in ["herd","pigs"]:
    if data.has(key) and not data[key].is_empty():assert_false(TownEnclosures227.inside(752026,data[key].pos,180.));checked+=1
   for goat in WorldGoatPopulation112.members(752026,Vector2i(cx,cy),4,surface):assert_false(TownEnclosures227.inside(752026,goat.pos,100.))
   for decor in data.decor:
    if TownEnclosures227.inside(752026,decor.pos,90.):assert_false(WorldNominal98.keep_decor(decor,surface))
 assert_gt(checked,0)
func test_flower_samples_and_road_routes_stay_outside_owned_enclosure_and_do_not_cross_walls():
 SaveData.world_generator_version=4;SaveData.world_seed=752026;SaveData.world_flora138=FloristJourney138.fresh([])
 var state:Dictionary=SaveData.world_flora138
 for species in FloristJourney138.SPECIES:assert_false(TownEnclosures227.inside(752026,FloristJourney138.sample_point(state,species)))
 for lane in FloristJourney138.lanes(state):
  for i in lane.size()-1:assert_eq(WorldTerrain103.safe_step(752026,lane[i],lane[i+1],22.),lane[i+1])
 var route:=FloristJourney138.route_from_home(state,752026)
 for i in route.size()-1:assert_eq(WorldTerrain103.safe_step(752026,route[i],route[i+1],22.),route[i+1])

func test_circles_are_round_and_map_access_roads_are_clipped_to_discovered_chunk():
 SaveData.world_generator_version=4
 var circles:int=0
 for seed_ in range(752026,752036):
  for plan in TownEnclosures227.plans(seed_).values():
   if plan.shape==3:assert_almost_eq(plan.bounds.size.x,plan.bounds.size.y,.01);circles+=1
  for cx in range(-1,4):
   for cy in range(0,4):
    var c:=Vector2i(cx,cy);var bounds:=Rect2(Vector2(c)*1024.,Vector2.ONE*1024.).grow(.01)
    for road in TownEnclosures227.roads_in_chunk(seed_,c):assert_true(bounds.has_point(road.a));assert_true(bounds.has_point(road.b))
 assert_gt(circles,0)
