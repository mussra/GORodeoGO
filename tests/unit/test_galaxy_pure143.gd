extends GutTest
func collection()->HorseCollection:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();c.find("trial_a").traits.finish="galaxy";c.find("trial_b").traits.finish="galaxy";return c
func test_two_galaxy_parents_record_birth_but_do_not_transform_or_change_stats():
 var c:=collection();var a:Dictionary=c.find("trial_a").duplicate(true);var b:Dictionary=c.find("trial_b").duplicate(true)
 var child:=c.breed(a.id,b.id,{})
 assert_true(GalaxyPure143.is_pure(child));assert_eq(child.stage,"foal");assert_eq(child.traits.finish,"galaxy");assert_false(child.has("species"));assert_false(c.is_adult(child.id));assert_false(HorseMastery.galaxy_master(child));assert_eq(child.stats,HorseStats.inherit(a,b));assert_eq(c.find(a.id),a);assert_eq(c.find(b.id),b)
func test_single_galaxy_does_not_pass_finish_or_purity():
 var c:=collection();c.find("trial_b").traits.finish="normal"
 var child:=c.breed("trial_a","trial_b",{})
 assert_eq(child.traits.finish,"normal");assert_false(child.has("galaxy_birth143"));assert_false(GalaxyPure143.is_pure(child));assert_eq(GalaxyPure143.birth(c.find("trial_a"),c.find("trial_a")),{})
func test_birth_snapshot_is_independent_of_parent_edits_and_sale():
 var c:=collection();var child:=c.breed("trial_a","trial_b",{});var proof:Dictionary=child.galaxy_birth143.duplicate(true)
 c.find("trial_a").traits.finish="normal";assert_true(HorseMarket.sell(c,"trial_b"))
 assert_eq(child.galaxy_birth143,proof);assert_true(GalaxyPure143.is_pure(child));var reloaded:=HorseCollection.new();assert_true(reloaded.restore(c.export_state()));assert_true(GalaxyPure143.is_pure(reloaded.find(child.id)))
func test_legacy_records_are_not_retroactively_labelled():
 var c:=collection();var child:=c.breed("trial_a","trial_b",{});child.erase("galaxy_birth143")
 var reloaded:=HorseCollection.new();assert_true(reloaded.restore(c.export_state()));assert_false(GalaxyPure143.is_pure(reloaded.find(child.id)))
func test_malformed_proof_rejected_without_changing_collection():
 var c:=collection();var child:=c.breed("trial_a","trial_b",{});var state:=c.export_state()
 for field in ["rule","criterion","parents"]:
  var bad:=state.duplicate(true);bad.horses[-1].galaxy_birth143.erase(field);var target:=collection();var before:=target.export_state();assert_false(target.restore(bad));assert_eq(target.export_state(),before)
 var bad:=state.duplicate(true);bad.horses[-1].galaxy_birth143.parents[0].id="invented";assert_false(c.restore(bad));assert_eq(c.export_state(),state)
func test_atomic_birth_and_maturity_persist_the_proof():
 var old_path:String=SaveData.save_path;var old_collection:Dictionary=SaveData.horse_collection.export_state();var old_trial:bool=SaveData.trial_session_active;var old_debug:bool=SaveData.debug_mode
 SaveData.save_path="user://galaxy-pure143.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.debug_mode=true;SaveData.horse_collection=collection()
 var child:=SaveData.breed_horses("trial_a","trial_b",{});assert_true(GalaxyPure143.is_pure(child));SaveData.load_progress();assert_true(GalaxyPure143.is_pure(SaveData.horse_collection.find(child.id)))
 assert_true(SaveData.mature_horse_trial(child.id));SaveData.load_progress();assert_true(GalaxyPure143.is_pure(SaveData.horse_collection.find(child.id)));assert_true(SaveData.horse_collection.is_adult(child.id))
 var before:=SaveData.horse_collection.export_state();SaveData.save_path="user://missing143/save.dat";assert_eq(SaveData.breed_horses("trial_a","trial_b",{}),{});assert_push_error_count(1);assert_eq(SaveData.horse_collection.export_state(),before)
 SaveData.save_path=old_path;SaveData.horse_collection.restore(old_collection);SaveData.trial_session_active=old_trial;SaveData.debug_mode=old_debug;DirAccess.remove_absolute("user://galaxy-pure143.dat")
