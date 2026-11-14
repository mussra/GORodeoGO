extends GutTest
const CUP="user://cup195-test-only.cfg"
const SAVE="user://cup195-save-only.cfg"
var old_collection:HorseCollection
var old_save:String
var old_mode:bool
var old_trial:bool
func before_each():
 old_collection=SaveData.horse_collection;old_save=SaveData.save_path;old_mode=SaveData.debug_mode;old_trial=SaveData.trial_session_active
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.save_path=SAVE;SaveData.trial_session_active=false
 RaceCupSession194.path_override=CUP
 for path in [CUP,SAVE,CUP+".tmp",SAVE+".tmp"]:
  if FileAccess.file_exists(path):DirAccess.remove_absolute(path)
func after_each():
 SaveData.horse_collection=old_collection;SaveData.save_path=old_save;SaveData.debug_mode=old_mode;SaveData.trial_session_active=old_trial;RaceCupSession194.path_override=""
 for path in [CUP,SAVE,CUP+".tmp",SAVE+".tmp"]:
  if FileAccess.file_exists(path):DirAccess.remove_absolute(path)
func complete():
 var state:=RaceCup194.fresh();state.last_sequence=RaceCup194.CHALLENGES.size()
 for goal in RaceCup194.CHALLENGES:state.completed.append(goal.id)
 assert_true(RaceCupStore194.write_state(CUP,state).ok)
func test_no_reward_before_completion_or_in_trial():
 assert_false(SaveData.claim_cup195().ok);assert_eq(SaveData.horse_collection.horses.size(),1)
 complete();SaveData.trial_session_active=true
 assert_false(SaveData.claim_cup195().ok);assert_false(FileAccess.file_exists(SAVE))
func test_both_rewards_once_and_reload_idempotent():
 complete();assert_true(SaveData.claim_cup195().ok)
 assert_eq(SaveData.horse_collection.horses.size(),2)
 assert_true(CupRewards195.has_temper(SaveData.horse_collection.find(CupRewards195.HORSE)))
 var saved:=ConfigFile.new();assert_eq(saved.load(SAVE),OK)
 var restored:=HorseCollection.new();assert_true(restored.restore(saved.get_value("horses_trial","state")))
 assert_eq(restored.cup_rewards195[CupRewards195.RECEIPT].object,"wind_compass")
 SaveData.horse_collection=restored;assert_true(SaveData.claim_cup195().already);assert_eq(restored.horses.size(),2)
func test_failed_save_rolls_back_horse_and_object_and_allows_retry():
 complete();var before:=SaveData.horse_collection.export_state();SaveData.save_path="user://nonexistent195/no-parent/save.cfg"
 assert_false(SaveData.claim_cup195().ok);assert_push_error_count(1);assert_eq(SaveData.horse_collection.export_state(),before)
 SaveData.save_path=SAVE;assert_true(SaveData.claim_cup195().ok)
func test_inheritance_and_old_state_compatibility():
 var collection:=SaveData.horse_collection
 collection.add_trial_parents();assert_true(CupRewards195.claim(collection).ok)
 var child:=collection.breed(CupRewards195.HORSE,"trial_a",{})
 assert_true(CupRewards195.has_temper(child));assert_almost_eq(CupRewards195.crossing_duration(child),.52,.001)
 assert_almost_eq(CupRewards195.crossing_duration(collection.find("trial_a")),.65,.001)
 var copy:=HorseCollection.new();assert_true(copy.restore(collection.export_state()))
 assert_true(CupRewards195.has_temper(copy.find(child.id)))
 var legacy:=HorseCollection.new();legacy.seed_trial();var state:=legacy.export_state();state.erase("cup_rewards195")
 assert_true(copy.restore(state));assert_true(copy.cup_rewards195.is_empty())
func test_corrupt_receipt_or_temper_rejected_without_mutating_collection():
 var before:=SaveData.horse_collection.export_state();var bad:=before.duplicate(true)
 bad.cup_rewards195={"rancho_cup195":{"rule":9}}
 assert_false(SaveData.horse_collection.restore(bad));assert_eq(SaveData.horse_collection.export_state(),before)
 bad=before.duplicate(true);bad.horses[0].cup_temper195="fastest"
 assert_false(SaveData.horse_collection.restore(bad));assert_eq(SaveData.horse_collection.export_state(),before)
func test_existing_horse_id_never_overwritten_or_duplicated():
 complete();SaveData.horse_collection.horses.append(CupRewards195.horse())
 assert_false(SaveData.claim_cup195().ok);assert_eq(SaveData.horse_collection.horses.size(),2)
 assert_true(SaveData.horse_collection.cup_rewards195.is_empty())

func test_earned_horse_detail_displays_heritable_temper():
 complete();assert_true(SaveData.claim_cup195().ok)
 var panel:=HorsePanel.new();panel.page="detail";panel.focus_id=CupRewards195.HORSE;add_child(panel);await wait_physics_frames(2)
 var label=panel.find_child("CupTemper195",true,false);assert_not_null(label)
 if label:assert_true(label.text.contains("heredable"))
 panel.free()
