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
 assert_eq(h.traits,{"coat":3,"pattern":1,"mane":5,"finish":"normal","eyes":10})
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
 assert_push_error_count(2)
 SaveData.horse_collection.restore(original);SaveData.save_path=path
func test_foal_cannot_equip_or_breed_until_trial_training()->void:
 var original:Dictionary=SaveData.horse_collection.export_state();var path:String=SaveData.save_path
 SaveData.save_path="user://qa_foal_test.dat";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var h:Dictionary=SaveData.breed_horses("trial_a","trial_b",{})
 assert_eq(h.stage,"foal");assert_false(SaveData.select_horse(h.id));assert_eq(SaveData.horse_collection.selected,"original")
 assert_true(SaveData.breed_horses(h.id,"original",{}).is_empty())
 var d:=HorseCollection.new();assert_true(d.restore(SaveData.horse_collection.export_state()));assert_false(d.is_adult(h.id))
 assert_true(SaveData.mature_horse_trial(h.id));assert_true(SaveData.select_horse(h.id));assert_true(SaveData.horse_collection.is_adult(h.id))
 SaveData.horse_collection.restore(original);SaveData.save_path=path;DirAccess.remove_absolute("user://qa_foal_test.dat")
func test_repeated_random_pairs_after_breeding_have_unique_ids()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents()
 c.breed("trial_a","trial_b",{})
 var ids:Dictionary={}
 for j in range(30):
  var before:int=c.horses.size();var added:=c.add_random_trial_pair();assert_eq(added.size(),2);assert_eq(c.horses.size(),before+2)
  for h in added:
   assert_false(ids.has(h.id));ids[h.id]=true;assert_true(c.valid_traits(h.traits));assert_true(c.is_adult(h.id))
 var d:=HorseCollection.new();assert_true(d.restore(c.export_state()));assert_eq(d.horses.size(),64)
