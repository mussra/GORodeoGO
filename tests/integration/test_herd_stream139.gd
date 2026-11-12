extends GutTest
var world:Node2D
func before_each():
 SaveData.save_path="user://herd-stream139.dat";SaveData.trial_session_active=false;SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_flora138={};SaveData.world_tamed=[];SaveData.world_roaming139={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 for horse in world._herd_horses.values():horse.set_physics_process(false)
func after_each():
 world.free();DirAccess.remove_absolute(SaveData.save_path)
func test_fled_herd_keeps_live_identity_when_original_chunk_is_evicted():
 var first=world._herd_horses.values()[0];var origin:Vector2i=first.get_meta("c");var source_key:=WorldMap.chunk_key(origin.x,origin.y)
 var survivors:Array=[]
 for horse in world._herd_horses.values():
  if horse.get_meta("c")==origin and horse!=first:survivors.append(horse)
 assert_gte(survivors.size(),2)
 world._deliver_horse(origin,first)
 # Simulate a long flight after capture, far enough to leave the original
 # chunk's retention radius. Rider follows 300px behind the visible survivors.
 var horse=survivors[0];var member_id:String=horse.herd.member_id
 horse.player_ref=world.player;horse.set_meta("escape_left110",20.)
 horse.set_physics_process(true)
 for i in 900:
  horse.flee_velocity(Vector2(0,350),true)
  await get_tree().physics_frame
 horse.set_physics_process(false)
 world.player.position=horse.position-Vector2(0,300)
 assert_gt(absi(WorldMap.chunk_at(world.player.position).y-origin.y),2)
 assert_lt(horse.position.distance_to(world.player.position),400.)
 world._update_chunks()
 assert_false(world._chunks.has(source_key))
 assert_false(horse.is_queued_for_deletion(),"Visible fleeing horse must not be deleted with its old terrain chunk")
 assert_true(world._herd_horses.values().has(horse),"Still a real tamable entity")
 if horse.is_queued_for_deletion():return
 await get_tree().process_frame
 assert_true(is_instance_valid(horse))
 # Revisit the source while this survivor is roped. It must not duplicate.
 horse.roped=true
 world.player.position=Vector2(origin)*1024.+Vector2(400,400);world._update_chunks()
 while not world._build_queue.is_empty():world._drain_chunk_builds();await get_tree().process_frame
 var copies:int=0
 for live in world._herd_horses.values():
  if is_instance_valid(live) and not live.is_queued_for_deletion() and live.herd.member_id==member_id:copies+=1
 assert_eq(copies,1,"Source chunk rebuild must not respawn retained individual")
 assert_true(is_instance_valid(horse));assert_true(horse.roped)
 horse.roped=false;world.player.position=Vector2(20000,20000);world._update_chunks()
 assert_true(horse.is_queued_for_deletion(),"Offscreen detached herd is cleaned up, not kept forever")

func test_park_leave_reload_and_revisit_last_position_without_origin_respawn():
 var horse=world._herd_horses.values()[0];var origin:Vector2i=horse.get_meta("c");var id:String=horse.herd.member_id;var key:=WorldHerdPositions139.live_key(origin,horse.herd.member_index)
 var last:Vector2=horse.position+Vector2(0,4200)
 horse.position=last;horse.state.spook=2.
 world.player.position=last+Vector2(0,300);world._update_chunks()
 assert_false(horse.is_queued_for_deletion())
 world.player.position=Vector2(20000,20000);world._update_chunks()
 assert_true(horse.is_queued_for_deletion());assert_false(world._herd_horses.has(key))
 assert_eq(SaveData.world_roaming139.horses[id].pos,last)
 await get_tree().process_frame
 # Reload from the actual disk file, destroy scene, and revisit source first.
 world.free();SaveData.world_roaming139={};SaveData.load_progress()
 assert_eq(SaveData.world_roaming139.horses[id].pos,last)
 SaveData.world_position=Vector2(origin)*1024.+Vector2(400,400)
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 assert_false(world._herd_horses.has(key),"Must not respawn at the seeded source")
 world.player.position=last;world._update_chunks()
 while not world._build_queue.is_empty():world._drain_chunk_builds();await get_tree().process_frame
 assert_true(world._herd_horses.has(key))
 if not world._herd_horses.has(key):return
 var restored=world._herd_horses[key];restored.set_physics_process(false)
 assert_eq(restored.position,last);assert_eq(restored.herd.member_id,id);assert_eq(restored.get_meta("c"),origin)
 assert_eq(restored.home,last,"No pull back to original spawn after reloading")
 world._deliver_horse(origin,restored);await get_tree().process_frame
 assert_false(SaveData.world_roaming139.horses.has(id))
 world._update_chunks();assert_false(world._herd_horses.has(key),"Captured survivor never respawns from override")
func test_failed_parking_save_keeps_live_horse_for_retry():
 var horse=world._herd_horses.values()[0];var id:String=horse.herd.member_id
 horse.position+=Vector2(0,4200);world.player.position=Vector2(20000,20000)
 var path:String=SaveData.save_path;SaveData.save_path="user://missing139/save.dat"
 world._update_chunks();assert_push_error_count(1)
 assert_false(horse.is_queued_for_deletion());assert_true(world._herd_horses.values().has(horse))
 SaveData.save_path=path;world._update_chunks();assert_true(horse.is_queued_for_deletion())
 assert_eq(SaveData.world_roaming139.horses[id].pos,horse.position)
