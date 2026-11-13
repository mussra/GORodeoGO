extends GutTest
var path:String
var prior:Variant
func before_each()->void:
 prior=ProjectSettings.get_setting("rancho/trial_tools",false);ProjectSettings.set_setting("rancho/trial_tools",true)
 path=SaveData.save_path;SaveData.save_path="user://isolated_trial_test.dat";SaveData.save_progress()
func after_each()->void:
 SaveData.end_trial_session();SaveData.save_path=path
 ProjectSettings.set_setting("rancho/trial_tools",prior)
func test_bytes_and_all_state_preserved_across_scratch_routes()->void:
 var bytes:PackedByteArray=FileAccess.get_file_as_bytes(SaveData.save_path)
 var horses:Dictionary=SaveData.horse_collection.export_state();var owned:Array=SaveData.equipment_owned.duplicate();var hat:String=SaveData.hat_color
 var progress:int=SaveData.highest_level_completed;var points:int=SaveData.equipment_points
 var contracts:Dictionary=SaveData.repeat_contract165.duplicate(true);var rest:float=SaveData.siesta_rest166
 assert_true(SaveData.begin_trial_session());assert_false(SaveData.begin_trial_session())
 assert_eq(SaveData.effective_progress(),LevelCatalog.MAX_LEVEL);assert_true(SaveData.equip_item("whip_long"));assert_eq(SaveData.equipped_whip_reach(),420.0)
 assert_true(SaveData.preview_trial_traits(19,4,5));assert_eq(HorseStats.read(SaveData.horse_collection.find("preview_temporary")),HorseStats.BASE)
 assert_true(SaveData.select_hat("blue" if HatAppearance.OPTIONS.has("blue") else "original"))
 var child:Dictionary=SaveData.breed_horses("original","trial_a",{});assert_false(child.is_empty());assert_false(SaveData.select_horse(child.id));assert_true(SaveData.mature_horse_trial(child.id));assert_true(SaveData.select_horse(child.id))
 SaveData.repeat_contract165=ProgressionEconomy165.new_contract(999);SaveData.siesta_rest166=250.
 assert_false(SaveData.accept_repeat_contract165());assert_eq(SaveData.claim_repeat_contract165(),0)
 assert_eq(SaveData.record_victory(20),0);SaveData.mark_dual_lasso_intro_shown();assert_true(SaveData.save_progress())
 assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes)
 SaveData.end_trial_session()
 assert_eq(SaveData.repeat_contract165,contracts);assert_eq(SaveData.siesta_rest166,rest)
 assert_eq(SaveData.horse_collection.export_state(),horses);assert_eq(SaveData.equipment_owned,owned);assert_eq(SaveData.highest_level_completed,progress);assert_eq(SaveData.equipment_points,points);assert_eq(SaveData.hat_color,hat)
 assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes)
 assert_true(SaveData.begin_trial_session());SaveData.preview_trial_traits(0,0,0);SaveData.load_progress()
 assert_false(SaveData.trial_session_active);assert_eq(SaveData.horse_collection.export_state(),horses);assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes)
func test_menu_boundary_restores_real_state()->void:
 var bytes:PackedByteArray=FileAccess.get_file_as_bytes(SaveData.save_path)
 assert_true(SaveData.begin_trial_session());SaveData.preview_trial_traits(19,4,5)
 var menu:Node=load("res://src/Presentation/main_menu.tscn").instantiate();add_child_autofree(menu);await wait_process_frames(2)
 assert_false(SaveData.trial_session_active);assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),bytes)
func test_normal_build_cannot_enter_session()->void:
 ProjectSettings.set_setting("rancho/trial_tools",false);assert_false(SaveData.begin_trial_session());assert_eq(SaveData.effective_progress(),SaveData.highest_level_completed)
