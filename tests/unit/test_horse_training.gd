extends GutTest
func test_learning_learner_mastery_affinity_and_no_auto_inheritance()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();var child:=c.breed("trial_a","trial_b",{});c.mature_trial(child.id)
 assert_false(HorseTraining.knows(child,"jump"));assert_false(HorseTraining.knows(child,"dodge"));assert_true(HorseTraining.knows(c.find("original"),"dodge"));assert_true(HorseTraining.configure(c,"trial_a",child.id,"jump"));c.selected=child.id
 var session:=HorseTraining.session(c);assert_false(session.is_empty())
 for i in range(3):assert_true(HorseTraining.complete(c,session));assert_eq(HorseTraining.mastery(c.find("trial_a"),"jump"),0.0)
 assert_true(HorseTraining.knows(child,"jump"));assert_eq(c.affinities[HorseTraining.pair_key("trial_a",child.id)],30.0);assert_eq(HorseTraining.pair_key("a","b"),HorseTraining.pair_key("b","a"))
 var progress:Dictionary=child.duplicate(true);c.training_pair={};assert_eq(child,progress);assert_true(HorseTraining.configure(c,"trial_b",child.id,"dodge"));c.selected="original";assert_true(HorseTraining.session(c).is_empty())
func test_diminishing_mastery_cap_and_cannot_train_missing_or_self()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();assert_false(HorseTraining.configure(c,"original","original","dodge"));assert_false(HorseTraining.configure(c,"original","trial_a","jump"));assert_true(HorseTraining.configure(c,"trial_a","original","jump"));c.selected="original"
 c.find("original")["can_jump"]=true
 var session:=HorseTraining.session(c);HorseTraining.complete(c,session);var first:float=HorseTraining.mastery(c.find("original"),"jump");HorseTraining.complete(c,session);assert_lt(HorseTraining.mastery(c.find("original"),"jump")-first,first)
 for i in range(1000):HorseTraining.complete(c,session)
 assert_lte(HorseTraining.mastery(c.find("original"),"jump"),100.0);assert_gte(HorseTraining.recovery(c.find("original"),"jump"),.8);assert_eq(c.affinities.values()[0],100.0)
 var restored:=HorseCollection.new();assert_true(restored.restore(c.export_state()));assert_eq(restored.export_state(),c.export_state())
func test_mission_save_failure_rolls_back_training_and_loss_gives_nothing()->void:
 var sut=load("res://src/Application/save_data.gd").new();sut.save_path="user://missing-training-dir/fail.dat";sut.points_legacy_credit_applied=true;sut.horse_collection.seed_trial();sut.horse_collection.add_trial_parents();HorseTraining.configure(sut.horse_collection,"trial_a","original","jump");sut.horse_collection.selected="original"
 var before:Dictionary=sut.horse_collection.export_state();assert_eq(sut.record_victory(1,HorseTraining.session(sut.horse_collection)),0);assert_eq(sut.horse_collection.export_state(),before);assert_push_error_count(1);sut.free()
func test_successful_mission_training_saves_and_switching_pair_keeps_learning()->void:
 var sut=load("res://src/Application/save_data.gd").new();sut.save_path="user://training-persist-qa.dat";sut.points_legacy_credit_applied=true;sut.horse_collection.seed_trial();sut.horse_collection.add_trial_parents();assert_true(sut.set_training_pair("trial_a","original","jump"));sut.horse_collection.selected="original"
 var snap:Dictionary=HorseTraining.session(sut.horse_collection);assert_gt(sut.record_victory(1,snap),0);var learning:float=HorseTraining.progress(sut.horse_collection.find("original"),"jump");assert_gt(learning,0);sut.load_progress();assert_eq(HorseTraining.progress(sut.horse_collection.find("original"),"jump"),learning);assert_eq(sut.horse_collection.affinities.values()[0],10.0)
 assert_true(sut.set_training_pair("trial_b","original","dodge"));assert_eq(HorseTraining.progress(sut.horse_collection.find("original"),"jump"),learning);assert_true(sut.clear_training_pair());sut.load_progress();assert_eq(HorseTraining.progress(sut.horse_collection.find("original"),"jump"),learning);assert_eq(sut.horse_collection.affinities.values()[0],10.0);sut.free();DirAccess.remove_absolute("user://training-persist-qa.dat")
func test_mentor_missions_give_no_learning_mastery_or_affinity()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();assert_true(HorseTraining.configure(c,"trial_a","original","jump"));c.selected="trial_a"
 var before:Dictionary=c.export_state()
 assert_true(HorseTraining.session(c).is_empty())
 assert_false(HorseTraining.complete(c,c.training_pair))
 var bad:Dictionary=c.training_pair.duplicate();bad.mounted_learner="trial_a"
 assert_false(HorseTraining.complete(c,bad));assert_eq(c.export_state(),before)
func test_saved_progress_kept_and_mission_snapshot_uses_actual_learner()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();c.find("trial_a").mastery={"jump":37.0};c.find("original").learning={"jump":21.0}
 assert_true(HorseTraining.configure(c,"trial_a","original","jump"));c.selected="original"
 var snap:Dictionary=HorseTraining.session(c);var state:Dictionary=c.export_state();var restored:=HorseCollection.new();assert_true(restored.restore(state));assert_eq(restored.export_state(),state)
 c.selected="trial_a" # Menu selection after mission start cannot reattribute its result.
 assert_true(HorseTraining.complete(c,snap));assert_gt(HorseTraining.progress(c.find("original"),"jump"),21.0);assert_eq(HorseTraining.mastery(c.find("trial_a"),"jump"),37.0)
 assert_eq(c.affinities[HorseTraining.pair_key("trial_a","original")],10.0)
