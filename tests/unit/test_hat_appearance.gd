extends GutTest
class FailingSave:
 extends "res://src/Application/save_data.gd"
 func save_progress()->bool:return false
const PATH="user://qa_hat_colors.dat"
func after_each()->void:
 DirAccess.remove_absolute(PATH)
 DirAccess.remove_absolute(PATH+".tmp")
func test_color_validation_and_original_fallback()->void:
 assert_eq(HatAppearance.sanitize("blue"),"blue")
 assert_eq(HatAppearance.sanitize("sand"),"sand")
 assert_eq(HatAppearance.sanitize("unknown"),"original")
 assert_eq(HatAppearance.sanitize(2),"original")
 assert_eq(HatAppearance.art_root("original"),"res://art/player/")
func test_selection_roundtrip_preserves_points_equipment_progress()->void:
 var sut=load("res://src/Application/save_data.gd").new();sut.save_path=PATH
 sut.equipment_points=675;sut.highest_level_completed=10;sut.points_legacy_credit_applied=true;sut.dual_lasso_intro_shown=true
 sut.equipment_owned.assign(["whip_basic","whip_long"]);sut.equipment_equipped={"whip":"whip_long"}
 for color in ["blue","sand","original"]:
  assert_true(sut.select_hat(color));sut.load_progress();assert_eq(sut.hat_color,color)
  assert_eq(sut.equipment_points,675);assert_eq(sut.highest_level_completed,10);assert_true(sut.points_legacy_credit_applied);assert_true(sut.dual_lasso_intro_shown)
  assert_eq(sut.equipped_whip_reach(),420.0)
 assert_false(sut.select_hat("invalid"));assert_eq(sut.hat_color,"original")
 sut.free()
func test_legacy_save_keeps_original_and_invalid_fields_are_safe()->void:
 var c:=ConfigFile.new();c.set_value("progress","highest_level_completed",5);c.save(PATH)
 var sut=load("res://src/Application/save_data.gd").new();sut.save_path=PATH;sut.hat_color="sand";sut.load_progress()
 assert_eq(sut.hat_color,"original");assert_eq(sut.highest_level_completed,5)
 c.set_value("appearance","hat_color","invalid");c.save(PATH);sut.load_progress();assert_eq(sut.hat_color,"original")
 sut.free()
func test_failed_save_rolls_back_selected_hat()->void:
 var sut=FailingSave.new();sut.hat_color="blue"
 assert_false(sut.select_hat("sand"));assert_eq(sut.hat_color,"blue");sut.free()
func test_all_existing_frames_have_both_variants()->void:
 for anim in ["idle","stunned","jump_side","jump_down","jump_up","jump_diag_down","jump_diag_up"]:
  for file in DirAccess.get_files_at("res://art/player/"+anim):
   if not file.ends_with(".png"):continue
   for color in ["blue","sand"]:assert_true(ResourceLoader.exists(HatAppearance.art_root(color)+anim+"/"+file))
