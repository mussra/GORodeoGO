extends GutTest
var old:Dictionary
func before_each()->void:
 old={"save_path":SaveData.save_path,"debug_mode":SaveData.debug_mode,"normal_mode_path":SaveData.normal_mode_path,"debug_mode_path":SaveData.debug_mode_path,"horses":SaveData.horse_collection.export_state(),"highest":SaveData.highest_level_completed,"points":SaveData.equipment_points,"credit":SaveData.points_legacy_credit_applied,"owned":SaveData.equipment_owned.duplicate(),"equipped":SaveData.equipment_equipped.duplicate(),"hat":SaveData.hat_color}
 SaveData.end_trial_session();SaveData.normal_mode_path="user://qa-mode-normal.dat";SaveData.debug_mode_path="user://qa-mode-debug.dat";SaveData.save_path=SaveData.normal_mode_path;SaveData.debug_mode=false
 for p in [SaveData.normal_mode_path,SaveData.debug_mode_path]:DirAccess.remove_absolute(p)
 SaveData.load_progress();SaveData.points_legacy_credit_applied=true
func after_each()->void:
 for p in [SaveData.normal_mode_path,SaveData.debug_mode_path]:DirAccess.remove_absolute(p)
 SaveData.save_path=old.save_path;SaveData.debug_mode=old.debug_mode;SaveData.normal_mode_path=old.normal_mode_path;SaveData.debug_mode_path=old.debug_mode_path;SaveData.horse_collection.restore(old.horses);SaveData.highest_level_completed=old.highest;SaveData.equipment_points=old.points;SaveData.points_legacy_credit_applied=old.credit;SaveData.equipment_owned.assign(old.owned);SaveData.equipment_equipped=old.equipped;SaveData.hat_color=old.hat
func test_switch_roundtrip_keeps_both_progress_and_horses()->void:
 SaveData.highest_level_completed=2;SaveData.equipment_points=17;assert_true(SaveData.save_progress());var bytes:PackedByteArray=FileAccess.get_file_as_bytes(SaveData.normal_mode_path)
 assert_true(SaveData.switch_mode(true));assert_eq(SaveData.effective_progress(),LevelCatalog.MAX_LEVEL);assert_true(GameState.debug_cheats_active());SaveData.horse_collection.add_random_trial_pair();SaveData.highest_level_completed=9;SaveData.equipment_points=999;var debug_count:int=SaveData.horse_collection.horses.size()
 assert_true(SaveData.switch_mode(false));assert_eq(SaveData.highest_level_completed,2);assert_eq(SaveData.equipment_points,17);assert_eq(SaveData.horse_collection.horses.size(),1);assert_false(GameState.debug_cheats_active());assert_eq(FileAccess.get_file_as_bytes(SaveData.normal_mode_path),bytes)
 assert_true(SaveData.switch_mode(true));assert_eq(SaveData.highest_level_completed,9);assert_eq(SaveData.equipment_points,999);assert_eq(SaveData.horse_collection.horses.size(),debug_count)
 SaveData.load_progress();assert_eq(SaveData.horse_collection.horses.size(),debug_count)
func test_departure_save_failure_does_not_switch()->void:
 SaveData.save_path="user://missing-mode-dir/fail.dat";assert_false(SaveData.switch_mode(true));assert_false(SaveData.debug_mode);assert_eq(SaveData.save_path,"user://missing-mode-dir/fail.dat");assert_push_error_count(1)
func test_normal_progression_not_unlocked_by_debug()->void:
 assert_true(SaveData.switch_mode(true));assert_true(LevelProgression.is_unlocked(20,SaveData.effective_progress()));assert_true(SaveData.switch_mode(false));assert_false(LevelProgression.is_unlocked(2,SaveData.effective_progress()));assert_true(LevelProgression.is_unlocked(1,SaveData.effective_progress()))
func test_corrupt_target_is_not_overwritten()->void:
 var file:=FileAccess.open(SaveData.debug_mode_path,FileAccess.WRITE);file.store_string("broken [ data");file.close();var bytes:=FileAccess.get_file_as_bytes(SaveData.debug_mode_path)
 assert_false(SaveData.switch_mode(true));assert_false(SaveData.debug_mode);assert_eq(FileAccess.get_file_as_bytes(SaveData.debug_mode_path),bytes)
func test_debug_view_survives_menu_return_without_reverting_horses()->void:
 assert_true(SaveData.switch_mode(true));SaveData.horse_collection.add_random_trial_pair();assert_true(SaveData.save_progress());var count:int=SaveData.horse_collection.horses.size();SaveData.end_trial_session();assert_eq(SaveData.horse_collection.horses.size(),count)
func test_failed_target_creation_restores_departing_mode()->void:
 SaveData.highest_level_completed=4;SaveData.debug_mode_path="user://missing-mode-dir/target.dat";assert_false(SaveData.switch_mode(true));assert_false(SaveData.debug_mode);assert_eq(SaveData.highest_level_completed,4);assert_eq(SaveData.save_path,SaveData.normal_mode_path);assert_push_error_count(1)
