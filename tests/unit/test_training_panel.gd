extends GutTest
func test_reopen_loads_pair_and_mount_button_equips_saved_learner()->void:
 var before:Dictionary=SaveData.horse_collection.export_state();var path:String=SaveData.save_path
 SaveData.save_path="user://qa-training-panel.dat";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 HorseTraining.configure(SaveData.horse_collection,"trial_a","original","jump");SaveData.horse_collection.selected="trial_a"
 var panel:=TrainingPanel.new();add_child_autofree(panel);await wait_process_frames(4)
 assert_eq(panel.mentor,"trial_a");assert_eq(panel.learner,"original");assert_eq(panel.skill,"jump")
 var buttons:Array=panel.content.get_children().filter(func(c):return c is Button and c.text==tr("TRAIN_EQUIP_LEARNER"))
 assert_eq(buttons.size(),1);buttons[0].pressed.emit();await wait_process_frames(3)
 assert_eq(SaveData.horse_collection.selected,"original");SaveData.load_progress();assert_eq(SaveData.horse_collection.selected,"original")
 SaveData.horse_collection.restore(before);SaveData.save_path=path;DirAccess.remove_absolute("user://qa-training-panel.dat")
func test_auto_save_changes_keeps_progress_and_invalid_pair_keeps_active()->void:
 var before:Dictionary=SaveData.horse_collection.export_state();var path:String=SaveData.save_path
 SaveData.save_path="user://qa-training-auto.dat";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var c:HorseCollection=SaveData.horse_collection;c.find("original").learning={"jump":42.0};HorseTraining.configure(c,"trial_a","original","jump")
 var panel:=TrainingPanel.new();add_child_autofree(panel);await wait_process_frames(4)
 assert_eq(panel.content.get_children().filter(func(n):return n is TextureRect).size(),2)
 assert_eq(panel.content.get_children().filter(func(n):return n is Button and n.text==tr("TRAIN_START")).size(),0)
 panel.learner="trial_b";panel.save_selection();assert_eq(c.training_pair.learner,"trial_b")
 SaveData.load_progress();assert_eq(SaveData.horse_collection.training_pair.learner,"trial_b");assert_eq(HorseTraining.progress(c.find("original"),"jump"),42.0)
 panel.learner="trial_a";panel.save_selection();assert_eq(c.training_pair.learner,"trial_b")
 panel.learner="original";SaveData.save_path="user://missing-training-auto/fail.dat";panel.save_selection();assert_eq(panel.learner,"trial_b");assert_push_error_count(1)
 SaveData.horse_collection.restore(before);SaveData.save_path=path;DirAccess.remove_absolute("user://qa-training-auto.dat")
