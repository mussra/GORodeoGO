extends GutTest
var before:Dictionary
var path:String
var progress:int
var points:int
var trial:bool
var oldlevel:int
func before_each()->void:
 before=SaveData.horse_collection.export_state();path=SaveData.save_path;progress=SaveData.highest_level_completed;points=SaveData.equipment_points;trial=SaveData.trial_session_active;oldlevel=GameState.selected_level
 SaveData.save_path="user://qa-training-levels.dat";SaveData.trial_session_active=false
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 HorseTraining.configure(SaveData.horse_collection,"trial_a","original","jump");SaveData.horse_collection.selected="original"
func after_each()->void:
 SaveData.horse_collection.restore(before);SaveData.save_path=path;SaveData.highest_level_completed=progress;SaveData.equipment_points=points;SaveData.trial_session_active=trial;GameState.selected_level=oldlevel;get_tree().paused=false
 DirAccess.remove_absolute("user://qa-training-levels.dat")
func test_real_level_123_win_handler_advances_mounted_learner_and_persists()->void:
 var expected:Array[float]=[34.0,68.68,100.0]
 for number in range(1,4):
  GameState.selected_level=number
  var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level);await wait_physics_frames(2)
  assert_eq(str(level._training_session.get("mounted_learner","")),"original")
  level._trigger_win()
  assert_almost_eq(HorseTraining.progress(SaveData.horse_collection.find("original"),"jump"),expected[number-1],.01)
  assert_eq(SaveData.horse_collection.affinities[HorseTraining.pair_key("trial_a","original")],float(number*10))
  level.queue_free();await wait_physics_frames(2)
  SaveData.load_progress()
 assert_true(HorseJump.capable(SaveData.horse_collection.find("original")))
func test_real_level_win_with_mentor_does_not_advance_training()->void:
 SaveData.horse_collection.selected="trial_a";GameState.selected_level=1
 var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level);await wait_physics_frames(2)
 assert_true(level._training_session.is_empty());level._trigger_win()
 assert_eq(HorseTraining.progress(SaveData.horse_collection.find("original"),"jump"),0.0);assert_true(SaveData.horse_collection.affinities.is_empty())
 level.queue_free();await wait_physics_frames(2)
func test_training_hud_and_result_show_current_and_actual_gain()->void:
 GameState.selected_level=1
 var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level);await wait_physics_frames(2)
 assert_not_null(level._training_status);assert_false(level._training_status.text.contains("%"));assert_eq(level._training_status.get_parent().get_node("TrainingBars").get_child(0).get_child(1).value,0.0)
 level._trigger_win();var result:Label=level.hud.end_panel.get_node("TrainingResult")
 assert_false(result.text.contains("%"));assert_almost_eq(level.hud.end_panel.get_node("TrainingResultBars").get_child(0).get_child(1).value,.34,.001);assert_almost_eq(level.hud.end_panel.get_node("TrainingResultBars").get_child(2).get_child(1).value,.1,.001)
 level.queue_free();await wait_physics_frames(2)
func test_loss_training_result_shows_zero_gain()->void:
 GameState.selected_level=1
 var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level);await wait_physics_frames(2)
 level._trigger_lose("QA");var result:Label=level.hud.end_panel.get_node("TrainingResult")
 assert_false(result.text.contains("%"));assert_eq(level.hud.end_panel.get_node("TrainingResultBars").get_child(0).get_child(1).value,0.0);assert_eq(HorseTraining.progress(SaveData.horse_collection.find("original"),"jump"),0.0)
 level.queue_free();await wait_physics_frames(2)
