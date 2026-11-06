extends GutTest
class FailingSave:
 extends "res://src/Application/save_data.gd"
 func save_progress()->bool:return false

const PATH="user://qa_points_migration.dat"
func after_each()->void:
 DirAccess.remove_absolute(PATH)
 DirAccess.remove_absolute(PATH+".tmp")
func legacy_save(highest:int)->void:
 var c:=ConfigFile.new()
 c.set_value("meta","version",1)
 c.set_value("progress","highest_level_completed",highest)
 c.set_value("progress","dual_lasso_intro_shown",true)
 assert_eq(c.save(PATH),OK)
func test_credit_is_once_for_completed_levels_and_survives_reload()->void:
 legacy_save(3)
 var sut=load("res://src/Application/save_data.gd").new();sut.save_path=PATH
 sut.load_progress()
 assert_eq(sut.highest_level_completed,3)
 assert_true(sut.dual_lasso_intro_shown)
 assert_eq(sut.equipment_points,0,"load does not invent a curve")
 assert_true(sut.apply_legacy_points_credit({1:10,2:25,3:60}))
 assert_eq(sut.equipment_points,95)
 assert_true(sut.apply_legacy_points_credit({1:999,2:999,3:999}))
 assert_eq(sut.equipment_points,95,"repeated call cannot credit twice")
 sut.load_progress()
 assert_true(sut.points_legacy_credit_applied)
 assert_eq(sut.equipment_points,95)
 assert_eq(sut.highest_level_completed,3)
 assert_true(sut.dual_lasso_intro_shown)
 assert_true(sut.apply_legacy_points_credit({1:10,2:25,3:60}))
 assert_eq(sut.equipment_points,95)
 sut.free()
func test_incomplete_or_invalid_reward_table_postpones_without_changes()->void:
 legacy_save(3)
 var sut=load("res://src/Application/save_data.gd").new();sut.save_path=PATH;sut.load_progress()
 assert_false(sut.apply_legacy_points_credit({1:10,3:60}))
 assert_false(sut.apply_legacy_points_credit({1:10,2:-25,3:60}))
 assert_eq(sut.equipment_points,0)
 assert_false(sut.points_legacy_credit_applied)
 sut.free()
func test_failed_persistence_rolls_back_credit_and_marker()->void:
 var sut=FailingSave.new()
 sut.highest_level_completed=1;sut.equipment_points=40
 # save_progress reports an expected error; suppress that report in this fault test.
 var result:bool=sut.apply_legacy_points_credit({1:10})
 assert_false(result)
 assert_eq(sut.equipment_points,40)
 assert_false(sut.points_legacy_credit_applied)
 sut.free()
func test_points_inventory_roundtrip_does_not_change_progress()->void:
 var sut=load("res://src/Application/save_data.gd").new();sut.save_path=PATH
 sut.highest_level_completed=10;sut.dual_lasso_intro_shown=true
 sut.equipment_points=200;sut.equipment_owned.append("whip")
 sut.equipment_equipped={"whip":"whip"};sut.points_legacy_credit_applied=true
 assert_true(sut.save_progress());sut.load_progress()
 assert_eq(sut.equipment_points,200)
 assert_eq(sut.equipment_owned,["whip"])
 assert_eq(sut.equipment_equipped,{"whip":"whip"})
 assert_eq(sut.highest_level_completed,10)
 assert_true(sut.dual_lasso_intro_shown)
 sut.free()

func test_existing_new_points_and_inventory_survive_legacy_credit()->void:
 var sut=load("res://src/Application/save_data.gd").new();sut.save_path=PATH
 sut.highest_level_completed=2;sut.equipment_points=40
 sut.equipment_owned.append("base_hat");sut.equipment_equipped={"hat":"base_hat"}
 assert_true(sut.save_progress())
 sut.load_progress()
 assert_true(sut.apply_legacy_points_credit({1:10,2:25}))
 assert_eq(sut.equipment_points,75)
 assert_eq(sut.equipment_owned,["base_hat"])
 assert_eq(sut.equipment_equipped,{"hat":"base_hat"})
 sut.load_progress();assert_true(sut.apply_legacy_points_credit({1:10,2:25}))
 assert_eq(sut.equipment_points,75)
 sut.free()

func test_invalid_point_fields_do_not_replace_valid_level_progress()->void:
 var c:=ConfigFile.new()
 c.set_value("progress","highest_level_completed",8)
 c.set_value("progress","dual_lasso_intro_shown",true)
 c.set_value("equipment","points",-30)
 c.set_value("equipment","owned",["base_hat",11,"base_hat"])
 c.set_value("equipment","equipped",{"hat":"base_hat","whip":99})
 assert_eq(c.save(PATH),OK)
 var sut=load("res://src/Application/save_data.gd").new();sut.save_path=PATH;sut.load_progress()
 assert_eq(sut.highest_level_completed,8)
 assert_true(sut.dual_lasso_intro_shown)
 assert_eq(sut.equipment_points,0)
 assert_eq(sut.equipment_owned,["base_hat"])
 assert_eq(sut.equipment_equipped,{"hat":"base_hat"})
 sut.free()
