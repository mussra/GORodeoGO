extends GutTest
var world:Node
var audio:Node
var previous:Dictionary={}
func before_each():
 for key in ['save_path','_load_valid','trial_session_active','equipment_points','world_goat_captures','world_goat_captures','world_quests','repeat_contract165','world_herd_town217','country_ledger146','victories240','cosmetic_protected332','world_garden212']:previous[key]=SaveData.get(key).duplicate(true) if SaveData.get(key) is Array or SaveData.get(key) is Dictionary else SaveData.get(key)
 SaveData.save_path='user://capture330-'+str(Time.get_ticks_usec())+'.cfg';SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_generator_version=3;SaveData.world_seed=752026;SaveData.world_position=WorldNominal98.home();SaveData.world_edits=[];SaveData.world_quests={};SaveData.world_jobs249={};SaveData.world_goat_captures=[];SaveData.world_goat_captures=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();GameState.controls_world323=false
 SaveData.cosmetic_protected332=false;SaveData.world_herd_town217={};SaveData.country_ledger146={};SaveData.victories240=ModeVictories240.fresh();SaveData.world_garden212=Garden212.fresh();SaveData.repeat_contract165=ProgressionEconomy165.new_contract()
 world=load('res://src/Presentation/frontier_world.gd').new();add_child(world)
 while world._loading_world:await wait_process_frames(1)
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 audio=load('res://tests/integration/capture_audio330.gd').new();world.add_child(audio);world._audio=audio
func after_each():
 world.free();Engine.time_scale=1.
 for key in previous:SaveData.set(key,previous[key])
func goat332():
 var goat=load('res://src/Presentation/wild_goat.gd').new();goat.setup({'pos':Vector2(400,600)});goat.set_meta('capture_id112','audit-goat332');world._prototype_goats.add_child(goat);world.player.position=goat.position-Vector2(150,0);world._on_lasso_prey_captured(goat);goat.set_process(false);goat.state.run=AnimalFatigue.RUN_SECONDS-.001;return goat
func test_invalid_save_does_not_ring_every_frame_or_leave_a_stuck_capture():
 var pig=goat332();SaveData._load_valid=false
 var points:int=SaveData.equipment_points;var calls:int=SaveData.save_metrics242.calls
 for i in 60:world._tick_goats(.01)
 print('REPRO330 cues=',audio.cues330.size(),' save_attempts=',SaveData.save_metrics242.calls-calls,' roped=',pig.roped,' lasso=',world._lasso_state)
 assert_eq(audio.cues330.count('win'),0,'No success bell before a persisted capture')
 assert_eq(SaveData.save_metrics242.calls-calls,1,'No frame-by-frame retries')
 assert_false(pig.roped,'Failure releases the animal instead of trapping it')
 assert_eq(world._lasso_state,'');assert_eq(SaveData.world_goat_captures.size(),0);assert_eq(SaveData.equipment_points,points)
func test_healthy_full_chase_captures_once_and_persists():
 var pig=goat332();pig.state.run=0.
 for i in 500:
  if pig.is_queued_for_deletion():break
  world.player.position=pig.position-Vector2(150,0);world._tick_goats(.01)
 assert_true(pig.is_queued_for_deletion());assert_eq(SaveData.world_goat_captures.size(),1);assert_eq(audio.cues330.count('win'),1)
 world._tick_goats(.01);assert_eq(audio.cues330.count('win'),1)
 var cfg=ConfigFile.new();assert_eq(cfg.load(SaveData.save_path),OK);assert_eq(cfg.get_value('world','goat_captures',[]).size(),1)
func test_capture_can_be_retried_after_save_access_returns_without_losing_progress():
 var pig=goat332();SaveData._load_valid=false
 world._tick_goats(.01);assert_false(pig.roped);assert_false(pig.is_queued_for_deletion());assert_true(pig.state.tired)
 SaveData._load_valid=true;world._on_lasso_prey_captured(pig);world._tick_goats(.01)
 assert_true(pig.is_queued_for_deletion());assert_eq(SaveData.world_goat_captures.size(),1);assert_eq(audio.cues330.count('win'),1)
func test_already_recorded_live_pig_is_reconciled_without_duplicate_reward_or_bell():
 var pig=goat332();var id='audit-goat332'
 SaveData.world_goat_captures.append(id);var points:int=SaveData.equipment_points
 world._tick_goats(.01)
 assert_true(pig.is_queued_for_deletion());assert_eq(SaveData.world_goat_captures.size(),1);assert_eq(SaveData.equipment_points,points);assert_eq(audio.cues330.count('win'),0);assert_eq(world._lasso_state,'')

func test_explicit_goat_capture_failure_releases_without_reward_or_sound():
 var goat=goat332();SaveData._load_valid=false;var points=SaveData.equipment_points
 assert_false(world.capture_goat265(goat));assert_false(goat.roped);assert_false(goat.is_queued_for_deletion());assert_eq(world._lasso_state,'');assert_eq(SaveData.equipment_points,points);assert_eq(audio.cues330.size(),0)
func test_flower_failure_is_latched_until_player_leaves_and_returns():
 var id=WorldFlowers105.IDS[0];NpcQuests.accept(SaveData.world_quests,id)
 var door=ModularWorldLayout93.world(WorldNominal98.doors().florist) if WorldNominal98.enabled() else WorldFloristShop.DOOR
 var pos=WorldFlowers105.positions(SaveData.world_seed,SaveData.world_generator_version,door,id)[0]
 world.player.position=pos;SaveData._load_valid=false;var calls=SaveData.save_metrics242.calls
 for i in 60:world._tick_flowers105()
 assert_eq(SaveData.save_metrics242.calls-calls,1);assert_eq(NpcQuests.state(SaveData.world_quests,id).count,0)
 SaveData._load_valid=true;world.player.position=pos+Vector2(100,0);world._tick_flowers105();world.player.position=pos;world._tick_flowers105();assert_eq(NpcQuests.state(SaveData.world_quests,id).count,1)
func test_town_job_failure_does_not_retry_each_frame():
 SaveData.world_generator_version=6
 var id='home|loco';SaveData.world_jobs249[id]={'status':'active','count':0,'events':[]}
 var points=TownJobs249.objective_points();var target={}
 for point in points:
  if point.id==id:target=point;break
 assert_false(target.is_empty())
 if target.is_empty():return
 world.player.position=target.pos;SaveData._load_valid=false;var calls=SaveData.save_metrics242.calls
 for i in 60:world._tick_jobs249()
 assert_eq(SaveData.save_metrics242.calls-calls,1);assert_eq(SaveData.world_jobs249[id].count,0)
 SaveData._load_valid=true;SaveData.world_herd_town217={};world.player.position=target.pos+Vector2(200,0);world._tick_jobs249();world.player.position=target.pos;world._tick_jobs249();assert_eq(SaveData.world_jobs249[id].count,1)
