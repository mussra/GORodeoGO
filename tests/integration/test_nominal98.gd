extends GutTest
func test_v2_uses_shared_buildings_persistent_missions_map_and_legacy_stays_legacy():
 SaveData.save_path="user://nominal98-frontier-only.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection.seed_trial()
 for version in [1,2]:
  SaveData.world_generator_version=version;SaveData.world_position=WorldNominal98.home() if version==2 else Vector2(100,180)
  var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
  while world._loading_world:await get_tree().process_frame
  world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
  assert_eq(world.has_node("NominalBuildings98"),version==2)
  assert_eq(world._road_surface94.nominal,version==2)
  if version==2:
   assert_true(world.road_surface_contains94(ModularWorldLayout93.world(Vector2i(30,4))))
   assert_false(world.road_surface_contains94(Vector2.ZERO))
   assert_lte(world.player.position.distance_to(WorldNominal98.home()),30.)
   assert_lte(world._npcs98()[0].position.distance_to(WorldNominal98.home()),120.)
   var buildings=world.get_node("NominalBuildings98")
   var graph=WorldNominal98.graph_for_chunk(SaveData.world_seed,Vector2i.ZERO)
   for cell in graph:
    for box in buildings.collision_rects:assert_false(box.grow(9).has_point(ModularWorldLayout93.world(cell)))
   for b in world._chunk_entities.values():
    for entity in b:
     if entity.get_script()==load("res://src/Presentation/world_decor.gd"):
      assert_false(world.road_surface_contains94(entity.position,20.))
   assert_true(is_instance_valid(world._map_overlay))
   assert_true(NpcQuests.accept(SaveData.world_quests,"farmer_pigs"))
   assert_eq(NpcQuests.state(SaveData.world_quests,"farmer_pigs").status,"active")
  world.free()
 SaveData.world_generator_version=1
