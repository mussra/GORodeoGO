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
func test_selection_toggles_preserves_filters_zoom_and_scroll()->void:
 var child:=SaveData.horse_collection.breed("trial_a","trial_b",{});panel.query="Azul";panel.filters={"coat":3};panel.zoom=1.4;panel.draw_graph();await wait_frames(2);panel.view.scroll_horizontal=100
 panel.select(child.id);await wait_frames(2);assert_eq(panel.selected,child.id);assert_true(panel.relation_nodes.has("trial_a"));assert_true(panel.relation_nodes.has("trial_b"));assert_false(panel.relation_nodes.has("original"));assert_eq(panel.zoom,1.4);assert_eq(panel.query,"Azul");assert_eq(panel.filters,{"coat":3});assert_eq(panel.view.scroll_horizontal,100)
 var layer:Node=panel.world.get_child(0)
 for node in layer.get_children():
  if node is Button:
   var id:String=node.get_meta("horse_id");assert_almost_eq(node.modulate.a,1.0 if panel.relation_nodes.has(id) else .24,.001)
 panel.select(child.id);await wait_frames(2);assert_eq(panel.selected,"");assert_true(panel.relation_nodes.is_empty());assert_eq(panel.zoom,1.4);assert_eq(panel.query,"Azul");assert_eq(panel.view.scroll_horizontal,100)
func test_hidden_filter_never_invents_edges_or_unhides_relatives()->void:
 var child:=SaveData.horse_collection.breed("trial_a","trial_b",{});panel.query="trial_a";panel.only_matches=true;panel.select(child.id)
 var count:int=0
 for node in panel.world.get_child(0).get_children():
  if node is Button:count+=1;assert_eq(node.get_meta("horse_id"),"trial_a")
  if node is Line2D:fail_test("hidden ancestors must not gain invented shortcuts")
 assert_eq(count,1);panel.select("trial_a");assert_eq(panel.selected,"trial_a");panel.select("trial_a");assert_eq(panel.selected,"")
