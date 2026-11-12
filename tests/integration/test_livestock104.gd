extends GutTest
func test_actual_capture_tick_counts_individual_persists_and_prevents_respawn():
 SaveData.save_path="user://capture104-isolated.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits.clear();SaveData.world_discovered.clear();SaveData.world_pigs.clear();SaveData.world_pig_captures.clear();SaveData.world_goat_captures.clear();SaveData.world_pigs_sold=0;SaveData.world_quests.clear();SaveData.horse_collection.seed_trial();SaveData.equipment_points=0
 var c:Vector2i=Vector2i.ZERO
 for x in range(1,10):
  if WorldMap.generate(752026,x,0).has("pigs"):c=Vector2i(x,0);break
 assert_ne(c,Vector2i.ZERO)
 SaveData.world_position=WorldMap.generate(752026,c.x,c.y).pigs.pos
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var key:String=WorldMap.chunk_key(c.x,c.y);var container=world._chunks[key].get_node("pigs");var pig=container.get_child(0);var id:String=WorldMap.pig_id(c.x,c.y)+":"+str(pig.name)
 var before:int=container.get_child_count()
 NpcQuests.accept(SaveData.world_quests,"farmer_pigs")
 world.player.position=pig.position
 pig.roped=true;pig.state.progress=1.;pig.state.tired=true;pig.state.rest=0.;pig.state["rope_run"]=4.
 world._tick_pigs(.01);await get_tree().process_frame
 assert_true(SaveData.world_pig_captures.has(id));assert_eq(SaveData.pig_inventory104(),1);assert_eq(SaveData.equipment_points,40);assert_eq(container.get_child_count(),before-1)
 # Re-entering the world rebuilds its procedural chunk but skips this exact ID.
 world.free()
 SaveData.world_position=WorldMap.generate(752026,c.x,c.y).pigs.pos
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 container=world._chunks[key].get_node("pigs");assert_eq(container.get_child_count(),before-1)
 for remaining in container.get_children():assert_ne(WorldMap.pig_id(c.x,c.y)+":"+str(remaining.name),id)
 world.free()
 SaveData.world_pig_captures.clear();SaveData.world_goat_captures.clear();SaveData.world_pigs_sold=0
