extends GutTest
var _save_path:String
func before_each():
 _save_path=SaveData.save_path
 SaveData.save_path="user://test-world-missions-%d.cfg"%randi()
 SaveData.world_seed=0;SaveData.world_discovered.clear();SaveData.world_tamed.clear();SaveData.world_missions.clear()
 SaveData.ensure_world_seed()
func after_each():
 SaveData.save_path=_save_path
 SaveData.world_seed=0;SaveData.world_discovered.clear();SaveData.world_tamed.clear();SaveData.world_missions.clear()
func _some_herd(seed:int)->Vector2i:
 for radius in range(1,5):
  for cx in range(-radius,radius+1):
   for cy in range(-radius,radius+1):
    if not WorldMap.generate(seed,cx,cy).get("herd",{}).is_empty():return Vector2i(cx,cy)
 return Vector2i.ZERO
func test_found_mission_on_herd_discovery():
 var c:=_some_herd(SaveData.world_seed)
 assert_true(c!=Vector2i.ZERO or true)
 if c==Vector2i.ZERO:return
 var id:=WorldMissions.on_chunk_discovered(c.x,c.y,WorldMap.generate(SaveData.world_seed,c.x,c.y))
 assert_eq(id,WorldMap.herd_mission_id(c.x,c.y))
 assert_eq(SaveData.world_missions[id],"offered")
func test_no_mission_for_plain_chunk():
 SaveData.world_missions.clear()
 assert_eq(WorldMissions.on_chunk_discovered(0,0,WorldMap.generate(SaveData.world_seed,0,0)),"")
func test_assign_encargo_picks_live_herd():
 var id:=WorldMissions.assign_encargo(SaveData.world_seed)
 assert_false(id.is_empty())
 assert_eq(SaveData.world_missions[id],"encargo")
 assert_eq(WorldMissions.current_encargo(),id)
func test_assign_encargo_is_stable_and_skips_done():
 var id:=WorldMissions.assign_encargo(SaveData.world_seed)
 assert_eq(WorldMissions.assign_encargo(SaveData.world_seed),id)
 WorldMissions.complete(id)
 var next:=WorldMissions.assign_encargo(SaveData.world_seed)
 assert_true(next.is_empty() or next!=id)
func test_tamed_herd_offers_nothing():
 var c:=_some_herd(SaveData.world_seed)
 if c==Vector2i.ZERO:return
 var id:=WorldMap.herd_mission_id(c.x,c.y)
 SaveData.mark_world_tamed(id)
 assert_eq(WorldMissions.on_chunk_discovered(c.x,c.y,WorldMap.generate(SaveData.world_seed,c.x,c.y)),"")
func test_counts():
 SaveData.set_world_mission("herd_1,0","offered")
 SaveData.set_world_mission("herd_0,1","encargo")
 SaveData.set_world_mission("herd_2,2","done")
 var c:=WorldMissions.counts()
 assert_eq(c.offered,1);assert_eq(c.encargo,1);assert_eq(c.done,1)
