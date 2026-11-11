extends GutTest
func test_same_color_pattern_is_hidden_not_invented():
 var t={"coat":6,"pattern":10,"mane":0,"spots":6,"finish":"normal"};var before=t.duplicate(true)
 assert_eq(HorseValues.hidden_genes(t),["Lleva gen: Jirafa (oculto)"]);assert_eq(t,before)
 t.pattern=9;assert_eq(HorseValues.hidden_genes(t),["Lleva gen: Cebra (oculto)"])
 t.spots=1;assert_true(HorseValues.hidden_genes(t).is_empty())
func test_smooth_only_carries_saved_color_never_invented_pattern():
 var t={"coat":6,"pattern":0,"mane":0,"spots":4}
 assert_eq(HorseValues.hidden_genes(t),["Lleva gen: color de manchas Verde (oculto)"])
 t.erase("spots");assert_true(HorseValues.hidden_genes(t).is_empty())
func test_original_giraffe_brown_and_leg_pattern():
 assert_eq(HorseValues.hidden_genes({"coat":10,"pattern":10,"mane":0}),["Lleva gen: Jirafa (oculto)"])
 assert_eq(HorseValues.hidden_genes({"coat":6,"pattern":4,"mane":0,"spots":6}),["Lleva gen: color de manchas Violeta (oculto)"])
func test_genetics_inheritance_unchanged_after_reading():
 var c=HorseCollection.new();c.seed_trial();c.add_trial_parents()
 c.find("trial_a").traits={"coat":6,"pattern":10,"mane":0,"spots":6}
 var before=c.export_state();HorseValues.hidden_genes(c.find("trial_a").traits);assert_eq(c.export_state(),before)
 var child=c.breed("trial_a","trial_b",{});assert_eq(child.traits.pattern,10);assert_eq(child.traits.spots,6)

func test_ficha_shows_existing_hidden_gene_only_for_owned_horse():
 var previous=SaveData.horse_collection;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var h=SaveData.horse_collection.find("original");h.traits={"coat":6,"pattern":10,"mane":0,"spots":6}
 var before=SaveData.horse_collection.export_state()
 var panel=HorsePanel.new();panel.page="detail";panel.focus_id="original";add_child_autofree(panel)
 await wait_process_frames(3)
 assert_true(_has_text(panel,"Lleva gen: Jirafa (oculto)"));assert_eq(SaveData.horse_collection.export_state(),before)
 panel.focus_id="";panel.focus_preview=h.duplicate(true);panel.refresh();await wait_process_frames(3)
 assert_false(_has_text(panel,"Lleva gen: Jirafa (oculto)"));SaveData.horse_collection=previous
func _has_text(node:Node,text:String)->bool:
 if node is Label and node.text==text:return true
 for child in node.get_children():
  if _has_text(child,text):return true
 return false
