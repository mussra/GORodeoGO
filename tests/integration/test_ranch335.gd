extends GutTest
var world:Node
var audio:Node
var previous:Dictionary={}
func before_each():
 for key in ['world_places144','world_position','siesta_rest166','save_path','_load_valid','trial_session_active','equipment_points','world_goat_captures','world_goat_captures','world_quests','repeat_contract165','world_herd_town217','country_ledger146','victories240','cosmetic_protected332','world_garden212']:previous[key]=SaveData.get(key).duplicate(true) if SaveData.get(key) is Array or SaveData.get(key) is Dictionary else SaveData.get(key)
 SaveData.save_path='user://capture330-'+str(Time.get_ticks_usec())+'.cfg';SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_generator_version=3;SaveData.world_seed=752026;SaveData.world_position=WorldNominal98.home();SaveData.world_edits=[];SaveData.world_quests={};SaveData.world_jobs249={};SaveData.world_goat_captures=[];SaveData.world_goat_captures=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();GameState.controls_world323=false
 SaveData.cosmetic_protected332=false;SaveData.world_herd_town217={};SaveData.country_ledger146={};SaveData.victories240=ModeVictories240.fresh();SaveData.world_garden212=Garden212.fresh();SaveData.repeat_contract165=ProgressionEconomy165.new_contract()
 world=load('res://src/Presentation/frontier_world.gd').new();add_child(world)
 while world._loading_world:await wait_process_frames(1)
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 audio=load('res://tests/integration/capture_audio330.gd').new();world.add_child(audio);world._audio=audio
func after_each():
 world.free();Engine.time_scale=1.
 for key in previous:SaveData.set(key,previous[key])
func test_complete_ranch_roundtrip_ignores_half_distance_and_rest():
 var travel=world._travel144;var original=Vector2(50000,470);world.player.position=original;SaveData.siesta_rest166=300.;travel.visit_clock=0.;travel.record_visits()
 var horses=SaveData.horse_collection.export_state();var quests=SaveData.world_quests.duplicate(true)
 assert_true(await travel.start('ranch'));assert_lt(world.player.position.distance_to(WorldNominal98.home()),150.);assert_eq(SaveData.world_places144.return335,original);assert_eq(SaveData.siesta_rest166,300.)
 var verifier=SaveData.get_script().new();verifier.save_path=SaveData.save_path;verifier.load_progress();assert_eq(verifier.world_places144.return335,original);verifier.free()
 assert_true(await travel.start('return335'));assert_lt(world.player.position.distance_to(original),150.);assert_false(SaveData.world_places144.has('return335'));assert_eq(SaveData.horse_collection.export_state(),horses);assert_eq(SaveData.world_quests,quests);assert_false(get_tree().paused)
func test_ranch_still_blocks_active_capture_without_releasing_it():
 world._lasso_state='hold';var pos=world.player.position;assert_false(await world._travel144.start('ranch'));assert_eq(world.player.position,pos);assert_eq(world._lasso_state,'hold')
func test_failed_arrival_keeps_origin_and_return_marker_unchanged():
 var travel=world._travel144;world.player.position=Vector2(30000,470);travel.visit_clock=0.;travel.record_visits();var original=world.player.position;var places=SaveData.world_places144.duplicate(true)
 var timer=get_tree().create_timer(.25,true);timer.timeout.connect(func():SaveData._load_valid=false)
 assert_false(await travel.start('ranch'));assert_eq(world.player.position,original);assert_eq(SaveData.world_places144,places);assert_false(get_tree().paused);SaveData._load_valid=true
