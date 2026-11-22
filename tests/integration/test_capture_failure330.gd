extends GutTest
var world:Node
var audio:Node
var previous:Dictionary={}
func before_each():
 for key in ['save_path','_load_valid','trial_session_active','equipment_points','world_pig_captures','world_goat_captures','world_quests','repeat_contract165']:previous[key]=SaveData.get(key).duplicate(true) if SaveData.get(key) is Array or SaveData.get(key) is Dictionary else SaveData.get(key)
 SaveData.save_path='user://capture330-'+str(Time.get_ticks_usec())+'.cfg';SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_generator_version=3;SaveData.world_seed=752026;SaveData.world_position=WorldNominal98.home();SaveData.world_edits=[];SaveData.world_quests={};SaveData.world_jobs249={};SaveData.world_goat_captures=[];SaveData.world_pig_captures=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();GameState.controls_world323=false
 world=load('res://src/Presentation/frontier_world.gd').new();add_child(world)
 while world._loading_world:await wait_process_frames(1)
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 audio=load('res://tests/integration/capture_audio330.gd').new();world.add_child(audio);world._audio=audio
func after_each():
 world.free();Engine.time_scale=1.
 for key in previous:SaveData.set(key,previous[key])
func pig330():
 var pig=world._lasso_pigs()[0];world.player.position=pig.position-Vector2(150,0);world._on_lasso_prey_captured(pig);pig.set_process(false);pig.state.run=AnimalFatigue.RUN_SECONDS-.001;return pig
func test_invalid_save_does_not_ring_every_frame_or_leave_a_stuck_capture():
 var pig=pig330();SaveData._load_valid=false
 var points:int=SaveData.equipment_points;var calls:int=SaveData.save_metrics242.calls
 for i in 60:world._tick_pigs(.01)
 print('REPRO330 cues=',audio.cues330.size(),' save_attempts=',SaveData.save_metrics242.calls-calls,' roped=',pig.roped,' lasso=',world._lasso_state)
 assert_eq(audio.cues330.count('return'),0,'No success bell before a persisted capture')
 assert_eq(SaveData.save_metrics242.calls-calls,1,'No frame-by-frame retries')
 assert_false(pig.roped,'Failure releases the animal instead of trapping it')
 assert_eq(world._lasso_state,'');assert_eq(SaveData.world_pig_captures.size(),0);assert_eq(SaveData.equipment_points,points)
func test_healthy_full_chase_captures_once_and_persists():
 var pig=pig330();pig.state.run=0.
 for i in 500:
  if pig.is_queued_for_deletion():break
  world.player.position=pig.position-Vector2(150,0);world._tick_pigs(.01)
 assert_true(pig.is_queued_for_deletion());assert_eq(SaveData.world_pig_captures.size(),1);assert_eq(audio.cues330.count('return'),1)
 world._tick_pigs(.01);assert_eq(audio.cues330.count('return'),1)
 var cfg=ConfigFile.new();assert_eq(cfg.load(SaveData.save_path),OK);assert_eq(cfg.get_value('world','pig_captures',[]).size(),1)
func test_capture_can_be_retried_after_save_access_returns_without_losing_progress():
 var pig=pig330();SaveData._load_valid=false
 world._tick_pigs(.01);assert_false(pig.roped);assert_false(pig.is_queued_for_deletion());assert_true(pig.state.tired)
 SaveData._load_valid=true;world._on_lasso_prey_captured(pig);world._tick_pigs(.01)
 assert_true(pig.is_queued_for_deletion());assert_eq(SaveData.world_pig_captures.size(),1);assert_eq(audio.cues330.count('return'),1)
func test_already_recorded_live_pig_is_reconciled_without_duplicate_reward_or_bell():
 var pig=pig330();var chunk=pig.get_parent().get_parent();var id=world._pen_id_for(Vector2i(chunk.get_meta('c')))+':'+str(pig.name)
 SaveData.world_pig_captures.append(id);var points:int=SaveData.equipment_points
 world._tick_pigs(.01)
 assert_true(pig.is_queued_for_deletion());assert_eq(SaveData.world_pig_captures.size(),1);assert_eq(SaveData.equipment_points,points);assert_eq(audio.cues330.count('return'),0);assert_eq(world._lasso_state,'')
func test_readonly_diagnostic_identifies_bad_horse_data_and_preserves_source_bytes():
 var cfg=ConfigFile.new();cfg.set_value('progress','highest_level_completed',1);cfg.set_value('horses_trial','state',{'invalid':true});assert_eq(cfg.save(SaveData.save_path),OK)
 var before=FileAccess.get_file_as_bytes(SaveData.save_path);SaveData._load_valid=false
 var diagnostic=SaveData.save_diagnostic330()
 assert_true(diagnostic.contains('G21'));assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),before);assert_false(SaveData._load_valid)
func test_protected_save_remains_unchanged_after_failed_pig_capture():
 var cfg=ConfigFile.new();cfg.set_value('protected','keep','original bytes');assert_eq(cfg.save(SaveData.save_path),OK)
 var original=FileAccess.get_file_as_bytes(SaveData.save_path);var pig=pig330();SaveData._load_valid=false
 for i in 120:world._tick_pigs(.01)
 assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),original);assert_eq(SaveData.world_pig_captures.size(),0);assert_eq(audio.cues330.count('return'),0)
