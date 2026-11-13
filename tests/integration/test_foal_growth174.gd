extends GutTest
var horses:Dictionary
var old_path:String
var old_progress:int
var old_points:int
var old_trial:bool
var old_debug:bool
var old_contract:Dictionary
func before_each():
 horses=SaveData.horse_collection.export_state();old_path=SaveData.save_path;old_progress=SaveData.highest_level_completed;old_points=SaveData.equipment_points;old_trial=SaveData.trial_session_active;old_debug=SaveData.debug_mode;old_contract=SaveData.repeat_contract165.duplicate(true)
 SaveData.save_path="user://growth174.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.debug_mode=false;SaveData.highest_level_completed=0;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var other:=HorseMarket.buy(SaveData.horse_collection,HorseMarket.offers(1)[0]);SaveData.horse_collection.breed("original",other.id,{})
func after_each():
 SaveData.horse_collection.restore(horses);SaveData.save_path=old_path;SaveData.highest_level_completed=old_progress;SaveData.equipment_points=old_points;SaveData.trial_session_active=old_trial;SaveData.debug_mode=old_debug;SaveData.repeat_contract165=old_contract;DirAccess.remove_absolute("user://growth174.dat")
func test_future_wins_care_reload_maturation_and_failure_are_atomic():
 var id:String=SaveData.horse_collection.horses[-1].id;var foal:Dictionary=SaveData.horse_collection.find(id);var traits:Dictionary=foal.traits.duplicate(true)
 assert_false(SaveData.mature_horse174(id));assert_gt(SaveData.record_victory(1),0);assert_eq(FoalGrowth174.sessions(SaveData.horse_collection.find(id)),1);SaveData.load_progress();assert_eq(FoalGrowth174.sessions(SaveData.horse_collection.find(id)),1)
 var before:Dictionary=SaveData.horse_collection.export_state();SaveData.save_path="user://missing174/save.dat";assert_eq(SaveData.record_victory(1),0);assert_push_error_count(1);assert_eq(SaveData.horse_collection.export_state(),before);SaveData.save_path="user://growth174.dat"
 for i in 9:assert_gt(SaveData.record_victory(1),0)
 assert_true(FoalGrowth174.ready(SaveData.horse_collection.find(id)));before=SaveData.horse_collection.export_state();SaveData.save_path="user://missing174/save.dat";assert_false(SaveData.mature_horse174(id));assert_push_error_count(2);assert_eq(SaveData.horse_collection.export_state(),before);SaveData.save_path="user://growth174.dat"
 assert_true(SaveData.mature_horse174(id));SaveData.load_progress();assert_true(SaveData.horse_collection.is_adult(id));assert_eq(SaveData.horse_collection.find(id).traits,traits)
func test_contract_claim_advances_once_and_failed_claim_restores_foals():
 var id:String=SaveData.horse_collection.horses[-1].id;SaveData.repeat_contract165=ProgressionEconomy165.new_contract();assert_true(SaveData.accept_repeat_contract165())
 for i in 5:assert_true(ProgressionEconomy165.record(SaveData.repeat_contract165,"pig","new174_%d"%i))
 var before:Dictionary=SaveData.horse_collection.export_state();var contract:Dictionary=SaveData.repeat_contract165.duplicate(true);SaveData.save_path="user://missing174/save.dat"
 assert_eq(SaveData.claim_repeat_contract165(),0);assert_push_error_count(1);assert_eq(SaveData.horse_collection.export_state(),before);assert_eq(SaveData.repeat_contract165,contract)
 SaveData.save_path="user://growth174.dat";assert_eq(SaveData.claim_repeat_contract165(),400);assert_eq(FoalGrowth174.sessions(SaveData.horse_collection.find(id)),1);assert_eq(SaveData.claim_repeat_contract165(),0);assert_eq(FoalGrowth174.sessions(SaveData.horse_collection.find(id)),1)
func test_trial_invalid_win_and_old_credits_never_advance_existing_foal():
 var id:String=SaveData.horse_collection.horses[-1].id;SaveData.horse_collection.birth_credits=500
 assert_eq(FoalGrowth174.sessions(SaveData.horse_collection.find(id)),0);assert_eq(SaveData.record_victory(0),0);assert_eq(FoalGrowth174.sessions(SaveData.horse_collection.find(id)),0)
 SaveData.trial_session_active=true;assert_eq(SaveData.record_victory(1),0);assert_eq(SaveData.claim_repeat_contract165(),0);assert_eq(FoalGrowth174.sessions(SaveData.horse_collection.find(id)),0);SaveData.trial_session_active=false
func test_real_detail_button_is_disabled_until_ten_then_matures_and_persists():
 var id:String=SaveData.horse_collection.horses[-1].id;var panel:=HorsePanel.new();panel.page="detail";panel.focus_id=id;add_child(panel);await get_tree().create_timer(.25).timeout
 var button:Button
 for candidate in panel.find_children("*","Button",true,false):
  if candidate.text=="Hacerse adulto":button=candidate
 assert_not_null(button);assert_true(button.disabled)
 SaveData.horse_collection.find(id).growth174=10;panel.refresh();await get_tree().create_timer(.25).timeout
 for candidate in panel.find_children("*","Button",true,false):
  if candidate.text=="Hacerse adulto":button=candidate
 for scroll in panel.find_children("*","ScrollContainer",true,false):scroll.scroll_vertical=10000
 await get_tree().create_timer(.1).timeout
 assert_false(button.disabled);button.pressed.emit();await get_tree().process_frame;assert_true(SaveData.horse_collection.is_adult(id));SaveData.load_progress();assert_true(SaveData.horse_collection.is_adult(id));panel.free()
