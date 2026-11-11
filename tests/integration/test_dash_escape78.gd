extends GutTest
func test_real_world_dash_does_not_pin_goat_or_pig_at_origin_boundary():
 SaveData.save_path="user://qa-dash78.dat";SaveData.world_seed=7781;SaveData.world_position=Vector2(-360,400);SaveData.world_edits.clear();SaveData.world_tamed.clear();SaveData.world_pigs.clear();SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_quests={}
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child_autofree(world)
 while world._loading_world:await wait_process_frames(1)
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false);world.player.dodge_available=true
 var goat=world._prototype_goats.get_child(0);goat.position=Vector2(-200,400);goat.home=goat.position-Vector2(549,0)
 world.player.position=goat.position-Vector2(220,0);world.player.set_physics_process(true)
 assert_true(world.player.request_dodge(Vector2.RIGHT));world.player.set_physics_process(false)
 world.player.dodge.step_dash(world.player.max_speed,.1)
 assert_lt(world.player.position.distance_to(goat.position),220.0)
 var start:Vector2=goat.position;world._tick_goats(.1)
 assert_gt(goat.position.distance_to(start),5.0);assert_lte(goat.position.distance_to(goat.home),550.01)
 var pigs=world._lasso_pigs();assert_false(pigs.is_empty())
 if pigs.is_empty():return
 var pig=pigs[0];pig.position=Vector2(-200,600);pig.home=pig.position-Vector2(419,0)
 world.player.dodge.cancel();world.player.dodge.cooldown=0;world.player.position=pig.position-Vector2(220,0);world.player.set_physics_process(true)
 assert_true(world.player.request_dodge(Vector2.RIGHT));world.player.set_physics_process(false);world.player.dodge.step_dash(world.player.max_speed,.1)
 start=pig.position;world._tick_pigs(.1);assert_gt(pig.position.distance_to(start),5.0)
 for cycle in 3:
  pig.state=WorldPigs.new_chase_state();pig.state.tired=true;pig.state.run=WorldPigs.CHASE_TIRE_SECONDS
  for frame in 52:
   world.player.position=pig.position-Vector2(100,0);world._tick_pigs(.1)
  assert_false(pig.state.tired);assert_true(pig.state.flee)
  start=pig.position;world.player.position=start-Vector2(100,0);world._tick_pigs(.1);assert_gt(pig.position.distance_to(start),5.0)
 world.queue_free();await wait_process_frames(3)
