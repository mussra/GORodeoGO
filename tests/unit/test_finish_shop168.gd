extends GutTest
var sut:Node
func before_each():
 sut=load("res://src/Application/save_data.gd").new();sut.save_path="user://finish168.dat";sut.horse_collection.seed_trial();sut.equipment_points=1000000;sut.points_legacy_credit_applied=true
func after_each():
 sut.free();DirAccess.remove_absolute("user://finish168.dat")
func unlock_activity():
 for i in 280:sut.world_pig_captures.append("pig%d"%i)
 for i in 220:sut.world_goat_captures.append("goat%d"%i)
 sut.repeat_contract165=ProgressionEconomy165.new_contract(56)
func test_money_alone_cannot_buy_then_purchase_once_equips_and_preserves_genes_stats():
 assert_false(sut.buy_finish168("ice"));assert_false(sut.equip_finish168("original","ice"));unlock_activity()
 var before:Dictionary=sut.horse_collection.export_state();var points:int=sut.equipment_points
 assert_true(sut.buy_finish168("ice"));assert_eq(sut.equipment_points,points-66000);assert_false(sut.buy_finish168("ice"))
 assert_true(sut.equip_finish168("original","ice"));assert_eq(sut.horse_collection.find("original").special_finish168,"ice");assert_eq(sut.horse_collection.find("original").traits,before.horses[0].traits)
 sut.load_progress();assert_eq(sut.horse_collection.find("original").special_finish168,"ice");assert_true(sut.equipment_owned.has("finish_ice"));assert_eq(sut.world_pig_captures.size(),280);assert_eq(sut.repeat_contract165.completed,56)
 assert_true(sut.equip_finish168("original",""));assert_eq(sut.horse_collection.export_state(),before)
func test_save_failure_rolls_back_purchase_and_per_horse_equipment():
 unlock_activity();sut._load_valid=false;var points:int=sut.equipment_points
 assert_false(sut.buy_finish168("gold"));assert_eq(sut.equipment_points,points);assert_false(sut.equipment_owned.has("finish_gold"))
 sut._load_valid=true;assert_true(sut.buy_finish168("gold"));sut._load_valid=false
 assert_false(sut.equip_finish168("original","gold"));assert_false(sut.horse_collection.find("original").has("special_finish168"))
func test_modes_foals_invalid_style_and_unowned_horse_cannot_equip():
 unlock_activity();sut.trial_session_active=true;assert_false(sut.buy_finish168("gold"));sut.trial_session_active=false;assert_true(sut.buy_finish168("gold"))
 assert_false(sut.buy_finish168("galaxy"));assert_false(sut.equip_finish168("unknown","gold"));assert_false(sut.equip_finish168("original","legendary"))
 sut.horse_collection.find("original").stage="foal";assert_false(sut.equip_finish168("original","gold"))
func test_render_mapping_covers_runtime_animation_names():
 for animation in ["idle","rest_gesture107","walk_side","walk_down","walk_up","walk_diag_down","walk_diag_up","jump_side","jump_down","jump_up","jump_diag_down","jump_diag_up","stunned"]:
  assert_false(HorseFinish168.selected_spec(animation,"rider").is_empty(),animation)
 assert_eq(HorseFinish168.selected_spec("rest_gesture107","rider").kind,"drink")
 assert_eq(HorseFinish168.style({"special_finish168":"ice"}),"ice");assert_eq(HorseFinish168.style({"special_finish168":"unknown"}),"")
