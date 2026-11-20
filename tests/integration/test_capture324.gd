extends GutTest
func test_world_records_pig_and_goat_on_their_exhaustion_tick_once():
 SaveData.save_path='user://qa324-capture-only.cfg';SaveData.world_generator_version=3;SaveData.world_seed=752026;SaveData.world_position=WorldNominal98.home();SaveData.world_quests={};SaveData.world_jobs249={};SaveData.world_edits=[];SaveData.world_goat_captures=[];SaveData.world_pig_captures=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.trial_session_active=false;GameState.brand_intro_played=true;SaveData.story_intro319=true
 var world=load('res://src/Presentation/frontier_world.gd').new();add_child(world)
 while world._loading_world:await wait_process_frames(1)
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var pigs=world._lasso_pigs();assert_gt(pigs.size(),0)
 if not pigs.is_empty():
  var pig=pigs[0];world.player.position=pig.position-Vector2(150,0);pig.roped=true;pig.state.run=AnimalFatigue.RUN_SECONDS-.001
  var before:int=SaveData.world_pig_captures.size();world._tick_pigs(.01)
  assert_true(pig.is_queued_for_deletion());assert_eq(SaveData.world_pig_captures.size(),before+1)
  world._tick_pigs(.01);assert_eq(SaveData.world_pig_captures.size(),before+1)
 await wait_process_frames(2)
 assert_gt(world._prototype_goats.get_child_count(),0)
 if world._prototype_goats.get_child_count()>0:
  var goat=world._prototype_goats.get_child(0);world.player.position=goat.position-Vector2(150,0);goat.roped=true;goat.state.run=AnimalFatigue.RUN_SECONDS-.001
  var before:int=SaveData.world_goat_captures.size();world._tick_goats(.01)
  assert_true(goat.is_queued_for_deletion());assert_eq(SaveData.world_goat_captures.size(),before+1)
  await wait_process_frames(2);world._tick_goats(.01);assert_eq(SaveData.world_goat_captures.size(),before+1)
 world.free();DirAccess.remove_absolute(SaveData.save_path)
