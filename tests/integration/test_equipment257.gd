extends "res://tests/integration/test_equipment_juanito243.gd"
func test_lasso_is_buy_once_and_effect_requires_ownership_and_equipped():
 var l:=LassoController.new();add_child(l);l.small_animal_context257=true
 assert_eq(l.effective_distance257(),220.)
 SaveData.equipment_points=240;assert_true(SaveData.buy_equipment("lasso_small257"));assert_eq(SaveData.equipment_points,40)
 assert_eq(l.effective_distance257(),220.);assert_true(SaveData.equip_item("lasso_small257"));assert_eq(l.effective_distance257(),330.)
 var pig=load("res://src/Presentation/wild_pig.gd").new();add_child(pig);pig.set_process(false)
 assert_true(pig.try_capture(pig.global_position+Vector2(75,0)));assert_false(pig.try_capture(pig.global_position+Vector2(81,0)))
 var goat=load("res://src/Presentation/wild_goat.gd").new();add_child(goat);goat.set_process(false)
 assert_true(goat.try_capture(goat.global_position+Vector2(75,0)))
 l.small_animal_context257=false;assert_eq(l.effective_distance257(),220.)
 SaveData.equipment_equipped.erase("lasso");assert_false(pig.try_capture(pig.global_position+Vector2(75,0)))
 pig.free();goat.free();l.free()
func test_scroll_is_shared_and_wide_in_every_panel():
 var panel:=EquipmentPanel.new();add_child(panel);await wait_process_frames(5)
 var scroll:ScrollContainer=panel.find_child("EquipmentList257",true,false)
 assert_not_null(scroll);assert_gte(scroll.get_v_scroll_bar().size.x,24.)
 assert_true(panel.get_children().any(func(c):return c is EquipmentScroll257))
 scroll.scroll_vertical=100000;await wait_process_frames(3)
 assert_gt(scroll.scroll_vertical,1000);assert_almost_eq(float(scroll.scroll_vertical),scroll.get_v_scroll_bar().max_value-scroll.get_v_scroll_bar().page,1.)
 panel.free()
func test_equipment_and_challenge_rewards_survive_reload_and_world_change():
 SaveData.equipment_points=240;assert_true(SaveData.buy_equipment("lasso_small257"));assert_true(SaveData.equip_item("lasso_small257"))
 SaveData.horse_collection.seed_trial();var h:Dictionary=SaveData.horse_collection.find("original")
 h.completed_levels=[1,2,3];h.mode_wins251={"duel":2};h.race_courses251=[0];h.master251=true
 var id:String=str(h.id);SaveData.world_position=Vector2(10000,5000);assert_true(SaveData.save_progress())
 SaveData.equipment_owned.clear();SaveData.equipment_equipped.clear();SaveData.horse_collection=HorseCollection.new();SaveData.equipment_points=0
 SaveData.load_progress();assert_true(SaveData.equipment_owned.has("lasso_small257"));assert_eq(SaveData.equipment_equipped.get("lasso",""),"lasso_small257");assert_eq(SaveData.equipment_points,40)
 var restored:Dictionary=SaveData.horse_collection.find(id);assert_eq(restored.completed_levels,[1,2,3]);assert_eq(restored.mode_wins251,{"duel":2});assert_eq(restored.race_courses251,[0]);assert_true(restored.master251)
 SaveData.world_position=Vector2(1500,730);assert_true(SaveData.save_progress());SaveData.load_progress();assert_eq(SaveData.equipment_equipped.get("lasso",""),"lasso_small257");assert_true(SaveData.horse_collection.find(id).master251)
