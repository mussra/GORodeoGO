extends GutTest
func test_starter_and_explicit_test_parents()->void:
 var c:=HorseCollection.new();c.seed_trial();assert_eq(c.horses.size(),1);assert_eq(c.selected,"original")
 c.add_trial_parents();c.add_trial_parents();assert_eq(c.horses.size(),3)
func test_two_distinct_owned_parents_no_consumption()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents()
 assert_true(c.breed("original","original",{}).is_empty())
 assert_true(c.breed("original","unknown",{}).is_empty())
 var a:Dictionary=c.find("trial_a").duplicate(true);var b:Dictionary=c.find("trial_b").duplicate(true)
 var h:Dictionary=c.breed("trial_a","trial_b",{"coat":0,"pattern":0,"mane":1})
 assert_eq(h.traits,{"coat":3,"pattern":1,"mane":5,"finish":"normal"})
 assert_eq(h.parents,["trial_a","trial_b"]);assert_eq(c.find("trial_a"),a);assert_eq(c.find("trial_b"),b)
func test_round_trip_and_bad_state()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();var h:Dictionary=c.breed("trial_a","trial_b",{})
 var d:=HorseCollection.new();assert_true(d.restore(c.export_state()));assert_eq(d.find(h.id),h)
 var invalid:Dictionary=c.export_state();invalid.horses[0].parents=[h.id,h.id]
 assert_false(d.restore(invalid));assert_eq(d.find(h.id),h)
func test_save_failure_rollback()->void:
 var original:Dictionary=SaveData.horse_collection.export_state();var path:String=SaveData.save_path
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents();SaveData.save_path="user://missing-dir/blocked.dat"
 var before:Dictionary=SaveData.horse_collection.export_state()
 assert_true(SaveData.breed_horses("trial_a","trial_b",{}).is_empty());assert_eq(SaveData.horse_collection.export_state(),before)
 assert_false(SaveData.select_horse("trial_a"));assert_eq(SaveData.horse_collection.selected,"original")
 SaveData.horse_collection.restore(original);SaveData.save_path=path
