extends GutTest
var previous:Dictionary
func before_each():
 previous={}
 for key in ['save_path','_load_valid','trial_session_active','world_generator_version','world_seed','world_herd_town217','world_cousins140','world_pig_captures','world_goat_captures','world_tamed','world_pigs','equipment_points','world_quests','world_jobs249','world_edits','country_ledger146','world_missions','repeat_contract165','world_garden212','victories240']:
  var value=SaveData.get(key);previous[key]=value.duplicate(true) if value is Dictionary or value is Array else value
 previous.horse_collection=SaveData.horse_collection
 SaveData.save_path='user://palette331-'+str(Time.get_ticks_usec())+'.cfg';SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_generator_version=3;SaveData.world_seed=7;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_pig_captures=[];SaveData.world_goat_captures=[];SaveData.world_tamed=[];SaveData.world_pigs=[];SaveData.world_quests={};SaveData.world_jobs249={};SaveData.world_edits=[];SaveData.country_ledger146={};SaveData.world_missions={};SaveData.repeat_contract165=ProgressionEconomy165.new_contract();SaveData.world_garden212=Garden212.fresh();SaveData.victories240=ModeVictories240.fresh()
func after_each():
 for key in previous:SaveData.set(key,previous[key])
func generated331()->Dictionary:
 var towns=VillageCousins140.fresh(7,[],FloristJourney138.fresh([]));var policy=HerdTown217.fresh(7,towns,[],{},[])
 var base=WorldMap.generate(7,1,-1).herd;var members=HerdTown217.colored(WorldHerd.members(base,7,1,-1,false),policy,1,-1)
 policy.herds['1,-1']=members.map(func(h):return h.traits.duplicate(true));policy.revised226['1,-1']=true
 return policy
func test_actual_generator_palette_roundtrips_without_recoloring_or_losing_progress():
 var policy=generated331();var pink:int=0
 for traits in policy.herds['1,-1']:
  if traits.spots==20:pink+=1
 assert_gt(pink,0,'Actual generator creates the new pink spot color')
 assert_true(HerdTown217.valid(policy,7),'A generated policy must be reloadable')
 SaveData.world_herd_town217=policy.duplicate(true);SaveData.world_cousins140=policy.towns.duplicate(true);SaveData.equipment_points=123;SaveData.world_pig_captures=['prior-pig'];SaveData.world_goat_captures=['prior-goat'];SaveData.world_tamed=['prior-horse']
 assert_true(SaveData.save_progress());var bytes=FileAccess.get_file_as_bytes(SaveData.save_path)
 SaveData.load_progress();assert_true(SaveData._load_valid,'Reload must not globally block saving')
 assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes,'Loading is read-only')
 assert_eq(SaveData.world_herd_town217,policy);assert_eq(SaveData.equipment_points,123);assert_eq(SaveData.world_pig_captures,['prior-pig']);assert_eq(SaveData.world_goat_captures,['prior-goat']);assert_eq(SaveData.world_tamed,['prior-horse'])
 assert_true(SaveData.record_pig104('new-pig'));assert_eq(SaveData.equipment_points,163)
 SaveData.load_progress();assert_true(SaveData._load_valid);assert_eq(SaveData.world_herd_town217,policy);assert_eq(SaveData.world_pig_captures,['prior-pig','new-pig']);assert_eq(SaveData.equipment_points,163)
func test_invalid_palette_seed_and_structure_remain_rejected():
 var policy=generated331();policy.herds['1,-1'][0].spots=HorseCollection.COATS.size();assert_false(HerdTown217.valid(policy,7))
 policy=generated331();policy.herds['1,-1'][0].coat=-1;assert_false(HerdTown217.valid(policy,7))
 policy=generated331();assert_false(HerdTown217.valid(policy,8))
 policy.herds['1,-1']='invalid';assert_false(HerdTown217.valid(policy,7))
func test_reloaded_generated_policy_allows_actual_world_pig_capture_and_reload():
 SaveData.world_herd_town217=generated331();SaveData.world_cousins140=SaveData.world_herd_town217.towns.duplicate(true);SaveData.world_position=WorldNominal98.home();assert_true(SaveData.save_progress())
 SaveData.load_progress();assert_true(SaveData._load_valid)
 var policy=SaveData.world_herd_town217.duplicate(true)
 var world=load('res://src/Presentation/frontier_world.gd').new();add_child(world)
 while world._loading_world:await wait_process_frames(1)
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var pig=world._lasso_pigs()[0];world.player.position=pig.position-Vector2(150,0);world._on_lasso_prey_captured(pig);pig.state.run=AnimalFatigue.RUN_SECONDS-.001
 world._tick_pigs(.01);assert_true(pig.is_queued_for_deletion());assert_eq(SaveData.world_pig_captures.size(),1)
 var captured=SaveData.world_pig_captures.duplicate();world.free();SaveData.load_progress();assert_true(SaveData._load_valid);assert_eq(SaveData.world_pig_captures,captured)
 for key in policy.herds:assert_eq(SaveData.world_herd_town217.herds[key],policy.herds[key],'Existing herd appearances are unchanged')
