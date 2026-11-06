extends GutTest
var old:Dictionary
var panel:Control
func before_each()->void:
 old=SaveData.horse_collection.export_state();SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents();panel=load("res://src/Presentation/genealogy_panel.gd").new();add_child_autofree(panel)
func after_each()->void:SaveData.horse_collection.restore(old)
func test_search_filter_hide_and_zoom_preserve_records()->void:
 var before:=SaveData.horse_collection.export_state();panel.query="Azul";panel.only_matches=true;panel.draw_graph();assert_eq(panel.counter.text,"1 / 3 match" if TranslationServer.get_locale().begins_with("en") else "1 / 3 coinciden")
 panel.set_zoom(99);assert_eq(panel.zoom,1.8);panel.set_zoom(-2);assert_eq(panel.zoom,.35);panel.query="not-found";panel.draw_graph();assert_eq(SaveData.horse_collection.export_state(),before)
func test_select_shows_actual_parents_only()->void:
 var child:=SaveData.horse_collection.breed("trial_a","trial_b",{});panel.select(child.id);assert_true(panel.info.text.contains("Azul de prueba"));assert_true(panel.info.text.contains("Arcoíris de prueba"));assert_false(panel.info.text.contains("Sierra"))
