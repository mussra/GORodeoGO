extends GutTest
func test_suggestion_suffix_and_custom_names()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents()
 var a:=c.breed("original","trial_a",{});var b:=c.breed("original","trial_a",{})
 assert_eq(a.name,"Castaño liso");assert_eq(b.name,"Castaño liso 2")
 assert_true(c.rename_horse(a.id,"  Pepe  "));assert_eq(c.find(a.id).name,"Pepe")
 assert_false(c.rename_horse(a.id,"   "));assert_eq(c.find(a.id).name,"Pepe")
 var d:=HorseCollection.new();assert_true(d.restore(c.export_state()));assert_eq(d.find(a.id).name,"Pepe")
func test_rename_saved_and_atomic_failure()->void:
 var snapshot:=SaveData.horse_collection.export_state();var path:String=SaveData.save_path;var was_debug:bool=SaveData.debug_mode;SaveData.debug_mode=true
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.save_path="user://names2_test.dat"
 assert_true(SaveData.rename_horse("original","Azul bonito"));SaveData.load_progress();assert_eq(SaveData.horse_collection.find("original").name,"Azul bonito")
 SaveData.save_path="user://missing-dir/cannot.dat";assert_false(SaveData.rename_horse("original","Pepe"));assert_eq(SaveData.horse_collection.find("original").name,"Azul bonito");assert_push_error_count(1)
 SaveData.horse_collection.restore(snapshot);SaveData.save_path=path;SaveData.debug_mode=was_debug;DirAccess.remove_absolute("user://names2_test.dat")
