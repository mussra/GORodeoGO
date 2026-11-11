extends GutTest
## Fixed test-map zone near the ranch (Ant, 7-nov-2026 13:09): two wild horses
## with fixed distinct genotypes, trees, cacti, houses, trails, pigs and fences;
## pure overlay data, seed generation and streaming untouched.

const Zone := preload("res://src/Presentation/world_test_zone.gd")

func test_two_horses_with_fixed_distinct_genotypes():
 assert_eq(Zone.HORSES.size(),2)
 var a:Dictionary=Zone.HORSES[0]["traits"]
 var b:Dictionary=Zone.HORSES[1]["traits"]
 assert_ne(a,b)
 assert_ne(int(a.get("coat",-1)),int(b.get("coat",-1)))

func test_zone_has_all_requested_elements():
 assert_eq(Zone.TREES.size(),2)
 assert_eq(Zone.CACTI.size(),2)
 assert_eq(Zone.HOUSES.size(),2)
 assert_eq(WorldPaths.access_lanes(752026).slice(1,3).size(),2) # shared door accesses replace the two disconnected trails
 assert_eq(Zone.PIGS.size(),2)
 assert_true(Zone.MEADOW.has_area())
 assert_true(Zone.PEN.has_area())

func test_zone_sits_near_ranch_inside_home_chunk():
 assert_lt(Zone.ZONE_POS.distance_to(Vector2.ZERO),WorldMap.CHUNK_SIZE)
 assert_true(WorldMap.is_ranch_chunk(int(Zone.ZONE_POS.x/WorldMap.CHUNK_SIZE),int(Zone.ZONE_POS.y/WorldMap.CHUNK_SIZE)))

func test_horses_stay_inside_the_meadow():
 for h in Zone.HORSES:
  var home:Vector2=h["home"]
  assert_true(Zone.MEADOW.grow(-60.0).has_point(home))
