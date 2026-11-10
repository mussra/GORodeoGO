extends GutTest
func test_generated_pigs_register_flee_lasso_capture_reward_and_save()->void:
 SaveData.save_path="user://qa-streamed-pigs70.dat";SaveData.world_seed=7781;SaveData.world_position=Vector2(-360,400);SaveData.world_edits.clear();SaveData.world_tamed.clear();SaveData.world_pigs.clear();SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child_autofree(world)
 while world._loading_world:await wait_process_frames(1)
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var actual:Array=[]
 var expected_pens:int=0
 for chunk in world._chunks.values():
  if chunk.has_node("pigs"):expected_pens+=1
 for entity_list in world._chunk_entities.values():
  for entity in entity_list:
   if is_instance_valid(entity) and entity.get_script()==world.PigScript:actual.append(entity)
 assert_gt(actual.size(),0,"La semilla carga cerdos generados")
 assert_eq(world._lasso_pigs().size(),actual.size(),"Todos los generados están registrados, no solo un pen ficticio")
 if world._lasso_pigs().is_empty():return
 var pig=world._lasso_pigs()[0];var start:Vector2=pig.position
 world.player.position=pig.position-Vector2(160,0);world._tick_pigs(.1)
 assert_gt(pig.position.distance_to(start),10.0,"El cerdo generado huye")
 pig.state.run=WorldPigs.CHASE_TIRE_SECONDS-.01;world._tick_pigs(.1)
 assert_true(pig.state.tired)
 world.player.set_physics_process(true)
 world.player.position=pig.position-Vector2(160,0)
 world.player.lasso._release_throw(Vector2(160.0/220.0,0));await wait_seconds(.45)
 world.player.set_physics_process(false)
 assert_eq(world._lasso_horse,pig);assert_true(pig.roped);assert_eq(world._lasso_state,"hold")
 var points:int=SaveData.equipment_points
 world._tick_pigs(1.3);world._tick_pigs(1.3);await wait_process_frames(2)
 assert_false(is_instance_valid(pig));assert_eq(SaveData.equipment_points,points+WorldPigs.CHASE_REWARD_POINTS)
 # Finish each generated pen with real lasso capture, not direct state edits to save.
 for other in world._lasso_pigs():
  world.player.position=other.position-Vector2(160,0);other.state.tired=true
  world.player.lasso.resolve_capture(other.global_position);world._tick_pigs(1.3);await wait_process_frames(2)
 world._tick_pigs(.01)
 assert_eq(SaveData.world_pigs.size(),expected_pens,"Solo las piaras reales terminadas cuentan; no zonas vacías")
 world.queue_free();await wait_process_frames(3)
