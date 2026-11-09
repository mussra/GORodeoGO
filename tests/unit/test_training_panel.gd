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
