extends GutTest
func test_florist_dialog_active_glyph_contact_collection_and_reload():
 SaveData.save_path="user://flowers105-isolated.dat";SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits.clear();SaveData.world_discovered.clear();SaveData.world_missions.clear();SaveData.world_quests.clear();SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var florist=world._npcs98()[1];world.player.position=florist.position;world._open_npc(florist)
 assert_not_null(world._npc_dialog);assert_true(NpcQuests.accept(SaveData.world_quests,"florist_blue105"));world._close_npc();world.player.set_physics_process(false)
 world._tick_npcs();assert_eq(world._flower_nodes105.size(),3);assert_eq(world._flower_strip105.get_child_count(),1)
 world._toasts.clear()
 var positions=WorldFlowers105.positions(752026,3,ModularWorldLayout93.world(WorldNominal98.doors().florist),"florist_blue105")
 for i in 3:
  world.player.position=positions[i]+Vector2(45,0);world._tick_npcs();assert_eq(SaveData.world_quests.florist_blue105.count,i)
  world.player.position=positions[i];world._tick_npcs();assert_eq(SaveData.world_quests.florist_blue105.count,i+1)
  assert_eq(world._toasts.active[0].text,"Flores azules · %d/3"%(i+1));assert_eq(world._toasts.pending.size(),0)
 assert_eq(SaveData.world_quests.florist_blue105.status,"done");assert_eq(world._flower_nodes105.size(),0)
 SaveData.load_progress();assert_eq(SaveData.world_quests.florist_blue105.count,3);assert_true(NpcQuests.available(SaveData.world_quests,"florist_gold105"))
 world.free();DirAccess.remove_absolute(SaveData.save_path)

func test_real_targets_are_clear_scattered_wilderness_near_requesting_town():
 SaveData.save_path="user://flowers139-targets.dat";SaveData.trial_session_active=false;SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_flora138={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var door:=FloristJourney138.home_door(752026)
 for id in WorldFlowers105.IDS:
  for p in WorldFlowers105.positions(752026,3,door,id):
   world.player.position=p;world._update_chunks()
   while not world._build_queue.is_empty():world._drain_chunk_builds();await get_tree().process_frame
   await get_tree().physics_frame
   assert_gt(p.distance_to(door),900.);assert_lt(p.distance_to(door),2500.)
   assert_false(WorldTerrain103.blocked(752026,p,28.));assert_false(world._get_surface98().contains(p,65.))
   for d in [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]:
    assert_false(world.player.test_move(world.player.global_transform,d*4.),"Target accessible in real scene at "+str(p))
 world.free();DirAccess.remove_absolute(SaveData.save_path)
