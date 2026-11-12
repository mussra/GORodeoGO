extends GutTest
func make_save(path:String)->Node:
 var save=load("res://src/Application/save_data.gd").new();add_child_autofree(save);save.save_path=path;save.world_pig_captures.clear();save.world_pigs_sold=0;save.world_goat_captures.clear();save.equipment_points=0;save.world_quests.clear();return save
func test_individual_captures_no_duplicates_optional_sale_and_roundtrip():
 var save=make_save("user://livestock104.dat");save.trial_session_active=false;save.world_seed=42;save.world_generator_version=2
 NpcQuests.accept(save.world_quests,"farmer_pigs")
 for id in ["pig_1,0:pig0","pig_1,0:pig1","pig_2,0:pig0"]:assert_true(save.record_pig104(id))
 assert_eq(save.pig_inventory104(),3);assert_eq(save.world_pig_captures.size(),3);assert_eq(save.equipment_points,120);assert_eq(save.world_quests.farmer_pigs.status,"done")
 assert_false(save.record_pig104("pig_1,0:pig0"));assert_eq(save.equipment_points,120)
 assert_true(save.sell_pigs104(4,40).is_empty());assert_true(save.sell_pigs104(2,39).is_empty());assert_eq(save.pig_inventory104(),3)
 var sale=save.sell_pigs104(2,WorldLivestock104.PIG_SALE_PRICE);assert_eq(sale.total,80);assert_eq(save.equipment_points,200);assert_eq(save.pig_inventory104(),1)
 save.load_progress();assert_eq(save.world_generator_version,2);assert_eq(save.pig_inventory104(),1);assert_eq(save.world_pig_captures.size(),3);assert_eq(save.equipment_points,200)
 assert_true(save.record_goat104("goat:new"));assert_false(save.record_goat104("goat:new"));save.load_progress();assert_eq(save.world_goat_captures.size(),1)
 DirAccess.remove_absolute(save.save_path)
func test_failed_save_rolls_back_capture_quest_money_and_sale():
 var save=make_save("user://missing104-directory/save.dat");save.trial_session_active=false
 NpcQuests.accept(save.world_quests,"farmer_pigs")
 assert_false(save.record_pig104("pig:new"));assert_eq(save.world_pig_captures.size(),0);assert_eq(save.equipment_points,0);assert_eq(save.world_quests.farmer_pigs.count,0)
 save.world_pig_captures.assign(["a","b"])
 assert_true(save.sell_pigs104(2,40).is_empty());assert_eq(save.world_pigs_sold,0);assert_eq(save.equipment_points,0);assert_eq(save.pig_inventory104(),2)
 assert_false(save.record_goat104("goat:new"));assert_eq(save.world_goat_captures.size(),0)
 assert_push_error_count(3)
func test_no_storage_capture_cap_and_clean_untrusted_save_fields():
 var save=make_save("user://livestock104-large.dat");save.trial_session_active=false
 for i in 10000:save.world_pig_captures.append("pig:%d"%i);save.world_goat_captures.append("goat:%d"%i)
 assert_true(save.save_progress());save.load_progress();assert_eq(save.pig_inventory104(),10000);assert_eq(save.world_goat_captures.size(),10000)
 var before:int=save.equipment_points
 assert_eq(save.sell_pigs104(10000,40).total,400000);assert_eq(save.equipment_points,before+400000);assert_eq(save.pig_inventory104(),0)
 assert_eq(WorldLivestock104.valid_ids(["a","a",1,"",null,"b"]),["a","b"])
 DirAccess.remove_absolute(save.save_path)
func test_farmer_quote_is_visible_before_optional_sell():
 var old:Array[String]=SaveData.world_pig_captures.duplicate();var sold:int=SaveData.world_pigs_sold
 SaveData.world_pig_captures.assign(["a","b"]);SaveData.world_pigs_sold=0
 var dialog=NpcDialog.new();add_child_autofree(dialog);dialog.setup(NpcQuests.NPCS[0],{})
 assert_true(dialog.has_node("PigPrice104"));assert_true(dialog.has_node("SellPigs104"));assert_false(dialog.get_node("SellPigs104").disabled)
 assert_string_contains(dialog.get_node("SellPigs104").text,"80");assert_eq(SaveData.pig_inventory104(),2)
 SaveData.world_pig_captures=old;SaveData.world_pigs_sold=sold
