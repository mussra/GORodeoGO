extends GutTest
func test_routes_delivery_persistence_and_no_repeat():
 var state:Dictionary=FloristJourney138.fresh([])
 assert_eq(FloristJourney138.current(state),"red")
 assert_false(FloristJourney138.deliver(state,"red"))
 assert_false(FloristJourney138.begin(state,"violet"))
 assert_true(FloristJourney138.begin(state,"red"))
 assert_true(FloristJourney138.sample(state,"red","direct"))
 assert_false(FloristJourney138.sample(state,"red","field"))
 assert_true(FloristJourney138.deliver(state,"red"))
 assert_false(FloristJourney138.deliver(state,"red"))
 assert_true(FloristJourney138.begin(state,"violet"))
 assert_true(FloristJourney138.sample(state,"violet","field"))
 assert_true(FloristJourney138.deliver(state,"violet"))
 assert_eq(FloristJourney138.current(state),"")
 assert_eq(FloristJourney138.clean(state),state)
 assert_eq(state.fields,{"red":true,"violet":true})
func test_invalid_state_and_no_retroactive_effects():
 for bad in [null,[],{}, {"version":99},{"version":1,"region":-1},{"version":1,"region":1,"quests":[]},{"version":1,"region":1,"fields":[]}]:assert_eq(FloristJourney138.clean(bad),{})
 var state=FloristJourney138.fresh([]);state.fields={"red":true}
 assert_eq(FloristJourney138.clean(state).fields,{})
 state.quests={"red":{"stage":"done","route":"direct"}}
 assert_eq(FloristJourney138.clean(state).fields,{"red":true})
func test_expansion_outside_discovered_positive_regions_and_seed_boundary():
 var state=FloristJourney138.fresh(["0,0","56,-3","-100,5"])
 assert_gt(FloristJourney138.door(state).x,59.*1024.)
 for field in FloristJourney138.descriptors(state,752026):
  var polygon=FloristJourney138.boundary(field)
  assert_eq(polygon,FloristJourney138.boundary(field))
  assert_gt(polygon.size(),4)
  for x in range(0,2049,256):
   for y in range(0,1025,256):assert_true(Geometry2D.is_point_in_polygon(field.rect.position+Vector2(x,y),polygon))
 for species in FloristJourney138.SPECIES:
  assert_false(WorldTerrain103.blocked(752026,FloristJourney138.sample_point(state,species),30.))
 assert_false(WorldTerrain103.blocked(752026,FloristJourney138.door(state),100.))
func test_save_roundtrip_and_failed_delivery_rollback():
 var save=load("res://src/Application/save_data.gd").new()
 save.save_path="user://flora138-unit.dat";save.world_generator_version=3;save.horse_collection.seed_trial()
 save.world_flora138=FloristJourney138.fresh([])
 var next=save.world_flora138.duplicate(true);FloristJourney138.begin(next,"red");FloristJourney138.sample(next,"red","direct")
 assert_true(save.commit_flora138(next,Vector2(4,5)))
 var config=ConfigFile.new();assert_eq(config.load(save.save_path),OK);assert_eq(config.get_value("world","flora138",{}),next)
 save.save_path="user://missing-directory138/progress.dat";var before=save.world_flora138.duplicate(true);var pos=save.world_position
 FloristJourney138.deliver(next,"red");assert_false(save.commit_flora138(next,Vector2(9,9)))
 assert_eq(save.world_flora138,before);assert_eq(save.world_position,pos)
 assert_push_error_count(1)
 save.free();DirAccess.remove_absolute("user://flora138-unit.dat")

func test_many_seeds_routes_cardinal_text_and_field_access():
 var state=FloristJourney138.fresh([])
 for seed_ in range(1,51):
  var route=FloristJourney138.route_from_home(state,seed_)
  var surface=WorldRoadSurface94.new(seed_,true,false,true,3)
  for segment in route.size()-1:
   var a:Vector2=route[segment];var b:Vector2=route[segment+1]
   var steps:int=maxi(1,ceili(a.distance_to(b)/32.))
   for i in range(steps+1):
    var point:Vector2=a.lerp(b,float(i)/steps)
    assert_false(WorldTerrain103.blocked(seed_,point,16.))
    # Core trunk/branches are the old roads; final shop entry is additive.
    if segment<route.size()-2:assert_true(surface.contains(point,5.))
  for species in FloristJourney138.SPECIES:
   assert_false(WorldTerrain103.blocked(seed_,FloristJourney138.sample_point(state,species),60.))
 assert_false(FloristJourney138.hud(state).contains("x "))
