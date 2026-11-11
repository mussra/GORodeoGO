extends GutTest
func test_map_retains_terrain_and_invalidates_all_persisted_inputs():
 SaveData.world_seed=752026;SaveData.world_discovered=["0,0"];SaveData.world_edits=[];SaveData.world_pigs=[];SaveData.world_missions={};SaveData.world_tamed=[]
 var map=load("res://src/Presentation/frontier_world.gd").DiscoveryMap.new()
 map.world=Node2D.new();map.world.set_script(null)
 # No input path is used; only the cache and drawing data are under test.
 map.size=Vector2(180,112)
 map._ensure_terrain();assert_eq(map.terrain_rebuilds,1)
 for i in 120:map._pulse+=.016;map._ensure_terrain()
 assert_eq(map.terrain_rebuilds,1,"rider animation does not rebuild terrain")
 SaveData.world_discovered.append("1,0");map._ensure_terrain();assert_eq(map.terrain_rebuilds,2)
 SaveData.world_discovered[1]="2,0";map._ensure_terrain();assert_eq(map.terrain_rebuilds,3,"same-length replacement must invalidate")
 SaveData.world_edits.append({"type":"add_decor","kind":"flower","pos":Vector2(10,20),"scale":1.});map._ensure_terrain();assert_eq(map.terrain_rebuilds,4)
 SaveData.world_edits[0].pos=Vector2(20,30);map._ensure_terrain();assert_eq(map.terrain_rebuilds,5)
 SaveData.world_missions["herd_0,0"]="offered";map._ensure_terrain();assert_eq(map.terrain_rebuilds,6)
 SaveData.world_missions["herd_0,0"]="done";map._ensure_terrain();assert_eq(map.terrain_rebuilds,7)
 SaveData.world_tamed.append("herd_0,0");map._ensure_terrain();assert_eq(map.terrain_rebuilds,8)
 SaveData.world_pigs.append("pig_1_0");map._ensure_terrain();assert_eq(map.terrain_rebuilds,9)
 SaveData.world_seed+=1;map._ensure_terrain();assert_eq(map.terrain_rebuilds,10)
 map.expanded=true;map.zoom=2;map.size=Vector2(700,410);map._ensure_terrain();assert_eq(map.terrain_rebuilds,11)
 map.pan=Vector2(100000,100000);map._ensure_terrain();var builds=map.terrain_rebuilds;map._ensure_terrain();assert_eq(map.terrain_rebuilds,builds,"normalized pan must not rebuild again")
 map.world.free();map.free()
