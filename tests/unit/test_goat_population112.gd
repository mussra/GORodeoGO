extends GutTest
func test_v1_v2_frozen_v3_deterministic_unbounded_and_offroad_rock():
 assert_eq(WorldGoatPopulation112.members(4,Vector2i(1,1),1),[]);assert_eq(WorldGoatPopulation112.members(4,Vector2i(1,1),2),[])
 var seed_:int=752026;var road=WorldRoadSurface94.new(seed_,true,false,true,3);var ids:Dictionary={};var count_:int=0
 for x in range(-6,7):
  for y in range(-6,7):
   var c=Vector2i(x,y);var a=WorldGoatPopulation112.members(seed_,c,3,road)
   assert_eq(a,WorldGoatPopulation112.members(seed_,c,3,road))
   for goat in a:
    count_+=1;assert_false(ids.has(goat.id));ids[goat.id]=true
    assert_false(road.contains(goat.pos,45.));assert_false(WorldTerrain103.blocked(seed_,goat.pos,45.))
    assert_eq(WorldMap.chunk_at(goat.pos),c)
 assert_gt(count_,50)
 var far:int=0
 for x in range(1000000,1000020):far+=WorldGoatPopulation112.members(seed_,Vector2i(x,9),3,road).size()
 assert_gt(far,0,"no global population cap at distant chunks")
