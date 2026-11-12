extends GutTest
func test_flowers_far_spread_seeded_and_in_local_clear_wilderness():
 for version in [1,2,3]:
  for seed_ in range(100):
   var door:Vector2=FloristJourney138.home_door(seed_) if version==3 else ModularWorldLayout93.world(ModularWorldLayout93.DOORS.florist) if version==2 else WorldPaths.FLORIST_DOOR
   var all_:Array[Vector2]=[];var chunks:Array[Vector2i]=[]
   var surface:=WorldRoadSurface94.new(seed_,version>=2,false,version>=2,version)
   for id in WorldFlowers105.IDS:
    var points:=WorldFlowers105.positions(seed_,version,door,id)
    assert_eq(points,WorldFlowers105.positions(seed_,version,door,id))
    assert_eq(points.size(),3)
    for p in points:
     assert_gt(p.distance_to(door),900.);assert_lt(p.distance_to(door),2500.)
     assert_true(p.is_finite());assert_false(surface.contains(p,65.),str([seed_,version,p]));assert_true(WorldFlowers105.clear_ground(seed_,p))
     if version==3:assert_false(WorldTerrain103.blocked(seed_,p,28.))
     for other in all_:assert_gt(other.distance_to(p),600.)
     # Each slot has its own location; adjacent chunks may meet at a boundary.
     all_.append(p);chunks.append(WorldMap.chunk_at(p))
func test_new_field_samples_far_from_shop_inside_fields_and_connected():
 var state:=FloristJourney138.fresh([])
 for species in FloristJourney138.SPECIES:
  var p:=FloristJourney138.sample_point(state,species)
  assert_gt(p.distance_to(FloristJourney138.door(state)),1200.)
  assert_true(FloristJourney138.field_rect(state,species).has_point(p))
  assert_true(FloristJourney138.on_lane(state,p))
func test_collected_slots_survive_new_locations():
 var quests:Dictionary={};var id:String=WorldFlowers105.IDS[0]
 NpcQuests.accept(quests,id);NpcQuests.record(quests,"collect_flower",id,WorldFlowers105.event_id(id,0))
 var saved:Dictionary=quests.duplicate(true)
 assert_eq(saved[id].count,1);assert_true(saved[id].events.has(WorldFlowers105.event_id(id,0)))
