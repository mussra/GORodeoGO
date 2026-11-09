extends GutTest
func test_report_uses_actual_saved_values_and_shows_zero_on_no_progress()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();HorseTraining.configure(c,"trial_a","original","jump");c.selected="original"
 var session:Dictionary=HorseTraining.session(c);var before:Dictionary=TrainingReport.snapshot(c,session)
 assert_eq(TrainingReport.gain(before,before,"learning"),0.0)
 HorseTraining.complete(c,session);var after:Dictionary=TrainingReport.snapshot(c,session)
 assert_eq(TrainingReport.gain(before,after,"learning"),34.0);assert_eq(after.learning,34.0);assert_eq(after.affinity,10.0)
 assert_eq(TrainingReport.gain(before,after,"mastery"),0.0)
 assert_true(TrainingReport.snapshot(c,{}).is_empty())
