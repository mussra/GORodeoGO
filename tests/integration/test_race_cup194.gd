extends GutTest
const PATH="user://cup194-integration-only.cfg"
var collection:HorseCollection
var path:String
func before_each():
 collection=SaveData.horse_collection;path=SaveData.save_path;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.save_path="user://cup194-never-main.cfg"
 RaceCupSession194.path_override=PATH;RaceCupSession194.active=false
 if FileAccess.file_exists(PATH):DirAccess.remove_absolute(PATH)
func after_each():
 RaceCupSession194.active=false;RaceCupSession194.path_override="";RaceCupSession194.pending_result.clear();RaceCupSession194.pending_path=""
 SaveData.horse_collection=collection;SaveData.save_path=path
 if FileAccess.file_exists(PATH):DirAccess.remove_absolute(PATH)
func test_free_race_finish_does_not_create_cup_state():
 var race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race);await wait_physics_frames(2)
 race.player.finish_time=50.;race._finish()
 assert_false(FileAccess.file_exists(PATH));race.free()
func test_opt_in_completed_race_credits_current_goal_and_keeps_main_save_untouched():
 assert_true(RaceCupSession194.begin().ok)
 var race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race);await wait_physics_frames(2)
 race.player.next_gate=17;race.player.finish_time=50.
 race._finish()
 assert_false(RaceCupSession194.active)
 assert_eq(RaceCupStore194.read_state(PATH).state.completed,["learn_oval"])
 assert_false(FileAccess.file_exists(SaveData.save_path))
 race.free()
func test_incomplete_or_replayed_cup_event_cannot_duplicate_progress():
 RaceCupSession194.begin()
 assert_false(RaceCupSession194.finish({"mode":"race","finished":true,"course":0,"rank":1,"gates":15,"landed":0,"dodges":0,"hits":0}).ok)
 assert_false(FileAccess.file_exists(PATH))
 RaceCupSession194.begin()
 var result={"mode":"race","finished":true,"course":0,"rank":1,"gates":16,"landed":0,"dodges":0,"hits":0}
 assert_true(RaceCupSession194.finish(result).ok)
 assert_false(RaceCupSession194.finish(result).ok)
 assert_eq(RaceCupStore194.read_state(PATH).state.completed.size(),1)
func test_mode_change_cannot_write_into_other_mode():
 RaceCupSession194.begin();RaceCupSession194.path_override=PATH+"other"
 assert_false(RaceCupSession194.finish({}).ok)
 assert_false(FileAccess.file_exists(PATH+"other"))
func test_cup_view_has_real_current_goal_and_no_reward_side_effect():
 var before:String=var_to_str(SaveData.horse_collection.horses)
 var view=load("res://src/Presentation/race_cup194.tscn").instantiate();add_child(view);await wait_physics_frames(3)
 assert_eq(view.goal.id,"learn_oval");assert_false(view.play.disabled)
 assert_true(view.body.text.contains("Sin esperas"))
 assert_false(FileAccess.file_exists(PATH));assert_eq(var_to_str(SaveData.horse_collection.horses),before)
 view.free()

func test_telemetry_counts_real_dash_and_completed_lasso_not_a_charge():
 var race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race);await wait_physics_frames(2)
 race.selector.hide();race.countdown=0.;race.running=true
 assert_true(race.player.request_dodge(Vector2.RIGHT))
 assert_eq(race.dodges194,1)
 assert_false(race.player.request_dodge(Vector2.RIGHT));assert_eq(race.dodges194,1)
 race.player.lasso._start_charging();assert_eq(race.landed194,0)
 race.player.lasso.cancel_input()
 race.player.lasso.prey_captured.emit(race.riders[1]);assert_eq(race.landed194,1)
 race.free()
func test_cup_duel_credits_only_whole_match_and_returns_to_cup():
 var state:=RaceCup194.fresh();state.last_sequence=10
 for i in 10:state.completed.append(RaceCup194.CHALLENGES[i].id)
 assert_true(RaceCupStore194.write_state(PATH,state).ok)
 assert_true(RaceCupSession194.begin().ok)
 var duel=load("res://src/Presentation/duel193.tscn").instantiate();add_child(duel);await wait_physics_frames(2)
 duel.countdown=0.;duel.running=true
 for rider in duel.riders:rider.set_physics_process(false)
 duel.capture_landed(duel.riders[1]);duel._resolve_round()
 assert_true(RaceCupSession194.active)
 assert_eq(RaceCupStore194.read_state(PATH).state.completed.size(),10)
 duel._next_round();duel.countdown=0.;duel.running=true
 duel.capture_landed(duel.riders[1]);duel._resolve_round()
 assert_false(RaceCupSession194.active)
 assert_eq(RaceCupStore194.read_state(PATH).state.completed.size(),11)
 assert_eq(duel.next_button.text,"Volver a la copa")
 assert_false(FileAccess.file_exists(SaveData.save_path));duel.free()
