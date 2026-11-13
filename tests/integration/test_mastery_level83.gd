extends GutTest
func test_real_level_snapshot_survives_selection_change_and_card_shows_mastery():
 var trial=SaveData.trial_session_active;var intro=SaveData.dual_lasso_intro_shown;SaveData.trial_session_active=false;SaveData.dual_lasso_intro_shown=true
 var previous=SaveData.horse_collection.export_state();var save=SaveData.save_path;var highest=SaveData.highest_level_completed;var points=SaveData.equipment_points;var credits=SaveData.points_legacy_credit_applied;var level=GameState.selected_level
 SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents();SaveData.horse_collection.selected="trial_a";SaveData.horse_collection.find("trial_a").traits.finish="galaxy"
 SaveData.save_path="user://mastery-level83-test.dat";SaveData.points_legacy_credit_applied=true;GameState.selected_level=1
 var scene=load("res://src/Presentation/level_0.tscn").instantiate();add_child_autofree(scene);await wait_process_frames(2)
 assert_eq(scene._mounted_horse_id,"trial_a")
 SaveData.horse_collection.selected="trial_b"
 assert_gt(SaveData.record_victory(scene._level_number,scene._training_session,scene._mounted_horse_id),0)
 assert_eq(HorseMastery.levels(SaveData.horse_collection.find("trial_a")),[1]);assert_eq(HorseMastery.levels(SaveData.horse_collection.find("trial_b")),[])
 var panel=HorsePanel.new();panel.page="detail";panel.focus_id="trial_a";add_child_autofree(panel);await wait_process_frames(3)
 var all=[];_texts(panel,all);assert_true(all.any(func(s):return s.contains("Niveles superados: 1")));assert_true(all.any(func(s):return s=="Maestría de campaña · 5%"))
 get_tree().paused=false;SaveData.trial_session_active=trial;SaveData.dual_lasso_intro_shown=intro;SaveData.horse_collection.restore(previous);SaveData.save_path=save;SaveData.highest_level_completed=highest;SaveData.equipment_points=points;SaveData.points_legacy_credit_applied=credits;GameState.selected_level=level;DirAccess.remove_absolute("user://mastery-level83-test.dat")
func _texts(node:Node,out:Array):
 if node is Label:out.append(node.text)
 for child in node.get_children():_texts(child,out)
