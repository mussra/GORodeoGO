extends GutTest
var saved:Dictionary={}
func before_each():
 saved={"owned":SaveData.equipment_owned.duplicate(),"equipped":SaveData.equipment_equipped.duplicate(true),"points":SaveData.equipment_points}
 SaveData.equipment_owned.append("scare_whip265");SaveData.equipment_equipped.scare_whip="scare_whip265"
func after_each():
 SaveData.equipment_owned=saved.owned;SaveData.equipment_equipped=saved.equipped;SaveData.equipment_points=saved.points
 await wait_process_frames(3)
func test_button_larger_clock_no_overlap_and_cooldown():
 var player=load("res://src/Presentation/world_player.gd").new();add_child(player)
 var button:=ScareButton265.new();button.player=player;add_child(button);await wait_process_frames(2)
 assert_eq(button.position,Vector2(1150,510));assert_lte(button.position.x+button.size.x,1280.);assert_false(button.get_rect().intersects(Rect2(1214,636,76,76)));assert_gt(button.size.x,76.);assert_false(button.get_rect().intersects(Rect2(956,636,76,76)));assert_false(button.get_rect().intersects(Rect2(1046,636,76,76)))
 assert_true(button.can_activate265());button.activate265();assert_eq(button.cooldown265,5.);assert_false(button.can_activate265());button.activate265();assert_eq(button.cooldown265,5.)
 player.set_physics_process(false);button.cooldown265=0;assert_false(button.can_activate265());button.free();player.free()
func test_wild_animals_flee_held_animals_unchanged_and_range():
 var pig=load("res://src/Presentation/wild_pig.gd").new();pig.setup({"pos":Vector2(100,0)});add_child(pig)
 var goat=load("res://src/Presentation/wild_goat.gd").new();goat.setup({"pos":Vector2(150,0)});add_child(goat);await wait_process_frames(2)
 assert_true(AnimalScare265.apply_to(pig,Vector2.ZERO,AnimalScare265.BASIC));assert_gt(pig.scare_left265,0.)
 goat.roped=true;assert_false(AnimalScare265.apply_to(goat,Vector2.ZERO,AnimalScare265.BASIC));assert_eq(goat.scare_left265,0.)
 pig.position=Vector2(500,0);assert_false(AnimalScare265.apply_to(pig,Vector2.ZERO,AnimalScare265.BASIC))
 pig.free();goat.free()
func test_upgrade_separate_slot_no_old_whip_loss():
 assert_eq(EquipmentCatalog.ITEMS.scare_whip_plus265.requires,"scare_whip265");assert_ne(EquipmentCatalog.ITEMS.scare_whip265.slot,EquipmentCatalog.ITEMS.whip_basic.slot)
 var button:=ScareButton265.new();assert_eq(button.settings265().cooldown,5.);SaveData.equipment_owned.append("scare_whip_plus265");SaveData.equipment_equipped.scare_whip="scare_whip_plus265";assert_eq(button.settings265().cooldown,4.);button.free()

func test_bull_scare_turns_without_capture_or_damage():
 var bull=load("res://src/Presentation/bull.gd").new();var art:=Polygon2D.new();art.name="Polygon2D";bull.add_child(art);bull.tuning=BullTuning.new();add_child(bull);await wait_process_frames(2)
 bull.controller.go_escaped();var state_before:int=bull.controller.current_state();var accepted:bool=bull.scare265(Vector2(-100,0),1.)
 if bull.controller.is_wild():assert_true(accepted);assert_gt(bull.scare_left265,0.)
 else:assert_false(accepted)
 assert_eq(bull.controller.current_state(),state_before);bull.free()
