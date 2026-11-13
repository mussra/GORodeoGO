extends GutTest
var prior:Dictionary
var path:String
var progress:int
var points:int
var debug_:bool
var trial:bool
func before_each():
 prior=SaveData.horse_collection.export_state();path=SaveData.save_path;progress=SaveData.highest_level_completed;points=SaveData.equipment_points;debug_=SaveData.debug_mode;trial=SaveData.trial_session_active
 SaveData.save_path="user://campaign173.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.debug_mode=false;SaveData.highest_level_completed=19;SaveData.equipment_points=100000;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.points_legacy_credit_applied=true
func after_each():
 get_tree().paused=false;SaveData.horse_collection.restore(prior);SaveData.save_path=path;SaveData.highest_level_completed=progress;SaveData.equipment_points=points;SaveData.debug_mode=debug_;SaveData.trial_session_active=trial;DirAccess.remove_absolute("user://campaign173.dat")
func test_level20_key_buy_reload_no_repeat_key40_second_and_save_failure_rollback():
 assert_gt(SaveData.record_victory(20,{},"original"),0);assert_eq(GalaxyKeys173.available(SaveData.horse_collection,20),[20]);assert_eq(SaveData.horse_collection.horses.size(),1)
 var offer:Dictionary=HorseMarket.offers(20)[5];assert_true(SaveData.buy_market_horse(offer));var bought:=SaveData.horse_collection.horses[-1].duplicate(true);SaveData.load_progress();assert_eq(SaveData.horse_collection.find(bought.id),bought)
 var points_before:int=SaveData.equipment_points;assert_false(SaveData.buy_market_horse(offer));assert_eq(SaveData.equipment_points,points_before)
 assert_gt(SaveData.record_victory(20,{},"original"),0);assert_eq(GalaxyKeys173.available(SaveData.horse_collection,20),[])
 SaveData.highest_level_completed=39;assert_gt(SaveData.record_victory(40,{},"original"),0);assert_eq(GalaxyKeys173.available(SaveData.horse_collection,40),[40])
 var second:Dictionary=HorseMarket.offers(40)[4];var before:=SaveData.horse_collection.export_state();points_before=SaveData.equipment_points;SaveData.save_path="user://missing173/save.dat"
 assert_false(SaveData.buy_market_horse(second));assert_push_error_count(1);assert_eq(SaveData.horse_collection.export_state(),before);assert_eq(SaveData.equipment_points,points_before)
 SaveData.save_path="user://campaign173.dat";assert_true(SaveData.buy_market_horse(second));assert_eq(GalaxyKeys173.available(SaveData.horse_collection,40),[]);assert_eq(SaveData.horse_collection.horses.size(),3)
func test_all_twenty_levels_instantiate_actual_ten_bulls_gates_and_geometry():
 var previous:int=GameState.selected_level
 for n in range(21,41):
  GameState.selected_level=n;var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level);await get_tree().physics_frame
  assert_eq(level.all_bulls.size(),10);assert_eq(level._puzzle_corrals.size(),LevelCatalog.get_level(n).pens.size());assert_eq(level._level_number,n)
  for corral in level._puzzle_corrals:assert_true(ArenaLayout.bounds_for_level(n).encloses(corral.layout.rect))
  level.free();await get_tree().process_frame
 GameState.selected_level=previous
func test_real_40_win_preserves_campaign1_master_and_records_campaign2():
 var previous:int=GameState.selected_level;var horse:=SaveData.horse_collection.find("original");horse.completed_levels=range(1,21);GameState.selected_level=40
 var scene=load("res://src/Presentation/level_0.tscn").instantiate();add_child(scene);await get_tree().physics_frame
 scene._trigger_win();assert_eq(HorseMastery.percent(horse),100.);assert_eq(HorseMastery.campaign_percent173(horse,2),5.);assert_eq(SaveData.highest_level_completed,40);scene.free();GameState.selected_level=previous
func test_new_campaign_couriers_reach_linked_latches_with_obstacles_and_live_herd():
 var prior_scale:float=Engine.time_scale;Engine.time_scale=1.;SaveData.dual_lasso_intro_shown=true;seed(20261105)
 var previous:int=GameState.selected_level
 for number in range(21,41):
  GameState.selected_level=number;var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level);await wait_physics_frames(3)
  level.player.position=Vector2(0,150);level.player.set_physics_process(false)
  var source:int=0
  for i in level._pens_data.size():
   if not level._pens_data[i].get("opens_pen_indices",[]).is_empty():source=i;break
  var targets:Array=level._pens_data[source].get("opens_pen_indices",[]).duplicate();level._on_pen_door_opened(source)
  for step in 4800:
   await wait_physics_frames(1)
   if level._courier_jobs.is_empty():break
  print("NEW_ROUTE ",number," remaining=",level._courier_jobs.size());assert_true(level._courier_jobs.is_empty(),"courier completes actual route in level %d"%number)
  for target in targets:assert_true(level._pen_released[target],"target opens in level %d"%number)
  level.free();await get_tree().process_frame
 Engine.time_scale=prior_scale;GameState.selected_level=previous
