extends GutTest
var saved230:Dictionary={}
var collection230:Dictionary={}
var old_path:String
var old_progress:int
var old_points:int
var old_owned:Array[String]
var old_equipped:Dictionary
var old_marker:bool
var old_intro:bool
func before_each()->void:
 # The flow owns its complete profile. Prior world tests may intentionally
 # leave an invalid-load guard or a different seed, neither is this fixture.
 for property in SaveData.get_script().get_script_property_list():
  var value:Variant=SaveData.get(property.name)
  saved230[property.name]=value.duplicate(true) if value is Dictionary or value is Array else value
 collection230=SaveData.horse_collection.export_state().duplicate(true)
 SaveData._load_valid=true;SaveData.trial_session_active=false
 SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_places144={};SaveData.country_ledger146={};SaveData.world_roaming139={};SaveData.world_quests={};SaveData.world_garden212=Garden212.fresh();SaveData.world_seed=0;SaveData.world_generator_version=1
 old_path=SaveData.save_path;old_progress=SaveData.highest_level_completed;old_points=SaveData.equipment_points
 old_owned=SaveData.equipment_owned.duplicate();old_equipped=SaveData.equipment_equipped.duplicate();old_marker=SaveData.points_legacy_credit_applied;old_intro=SaveData.dual_lasso_intro_shown
 SaveData.save_path="user://qa_equipment_flow.dat";SaveData.highest_level_completed=0;SaveData.equipment_points=0;SaveData.equipment_owned.clear();SaveData.equipment_equipped.clear();SaveData.points_legacy_credit_applied=true;SaveData.dual_lasso_intro_shown=true
func after_each()->void:
 SaveData.save_path=old_path;SaveData.highest_level_completed=old_progress;SaveData.equipment_points=old_points
 SaveData.equipment_owned=old_owned;SaveData.equipment_equipped=old_equipped;SaveData.points_legacy_credit_applied=old_marker;SaveData.dual_lasso_intro_shown=old_intro
 DirAccess.remove_absolute("user://qa_equipment_flow.dat")
 for key in saved230:SaveData.set(key,saved230[key])
 SaveData.horse_collection.restore(collection230)
func test_victory_repeats_purchase_equip_reload_and_player_effect()->void:
 # Isolated old profile already finished ten, eligible for the approved first-win credit.
 SaveData.highest_level_completed=10;SaveData.points_legacy_credit_applied=false
 assert_true(SaveData.apply_legacy_points_credit(EquipmentCatalog.REWARDS))
 assert_eq(SaveData.equipment_points,3665)
 GameState.selected_level=1
 var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level)
 await wait_physics_frames(1)
 assert_false(level.player.dodge_available,"points do not auto-equip a fusta")
 level._trigger_win()
 assert_eq(SaveData.equipment_points,3675)
 level._trigger_win()
 assert_eq(SaveData.equipment_points,3675,"duplicate win trigger cannot double credit")
 assert_true(level.hud.end_label.text.contains("+10 puntos"))
 level.free()
 assert_eq(SaveData.record_victory(1),10,"a later separate win still earns")
 assert_eq(SaveData.equipment_points,3685)
 assert_true(SaveData.buy_equipment("whip_basic"))
 assert_eq(SaveData.equipment_points,2685)
 assert_eq(SaveData.equipped_whip_reach(),0.0,"buy separate from equip")
 assert_true(SaveData.equip_item("whip_basic"))
 assert_eq(SaveData.equipped_whip_reach(),260.0)
 assert_true(SaveData.buy_equipment("whip_long"))
 assert_true(SaveData.equip_item("whip_long"))
 SaveData.load_progress()
 assert_eq(SaveData.equipment_points,685)
 assert_eq(SaveData.equipped_whip_reach(),420.0)
 assert_eq(SaveData.highest_level_completed,10)
 assert_true(SaveData.points_legacy_credit_applied)
 assert_true(SaveData.dual_lasso_intro_shown)
 level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level)
 await wait_physics_frames(1)
 assert_true(level.player.dodge_available)
 assert_eq(level.player.dodge_path_limit,420.0)
 var panel:=EquipmentPanel.new();add_child(panel)
 assert_eq(panel._equip["whip_long"].get_node("Caption229").text,tr("UI_061"))
 assert_true(panel._equip["whip_long"].disabled)
 panel.free();level.free()
func test_new_profile_gets_ten_points_first_win_and_only_next_level()->void:
 assert_eq(SaveData.record_victory(1),10)
 assert_eq(SaveData.highest_level_completed,1)
 assert_eq(SaveData.equipment_points,10)
 assert_false(SaveData.buy_equipment("whip_basic"))
 assert_true(LevelProgression.is_unlocked(2,SaveData.highest_level_completed))
 assert_false(LevelProgression.is_unlocked(3,SaveData.highest_level_completed))
