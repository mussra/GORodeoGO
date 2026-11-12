extends GutTest
var p:HorsePanel
var child:Dictionary
var old:Dictionary
func before_each():
 old=SaveData.horse_collection.export_state();SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents();SaveData.horse_collection.find("trial_a").traits.finish="galaxy";SaveData.horse_collection.find("trial_b").traits.finish="galaxy";child=SaveData.horse_collection.breed("trial_a","trial_b",{})
 SaveData.debug_mode=false;SaveData.trial_session_active=false;p=HorsePanel.new();add_child(p);await settle()
func after_each():
 await settle();p.free();await settle();SaveData.horse_collection.restore(old)
func settle():await get_tree().process_frame;await get_tree().process_frame
func texts(node:Node)->String:
 var out:String=""
 for n in node.get_children():
  if n is Label:out+=n.text+"\n"
  out+=texts(n)
 return out
func test_detail_explains_pure_not_unicorn_and_normal_edit_lock_is_kept():
 p.focus_id=child.id;p.show_page("detail");await settle()
 var badge:Label=p.content.find_child("GalaxyPureBadge143",true,false);assert_not_null(badge);assert_true(badge.text.contains("GALAXY PURO"));assert_true(badge.text.contains("no es un unicornio"))
 assert_false(texts(p.content).contains("Crecer (prueba)"));assert_eq(child.stage,"foal")
func test_grouped_collection_counts_pure_records_without_relabelling_legacy():
 var legacy:Dictionary=child.duplicate(true);legacy.id="old_child143";legacy.erase("galaxy_birth143");SaveData.horse_collection.horses.append(legacy)
 p.show_page("collection");await settle();assert_true(texts(p.content).contains("GALAXY PURO ×1"));assert_false(GalaxyPure143.is_pure(legacy))
func test_pasture_and_family_show_explicit_pure_badge():
 p.open_section("pasture141");await settle();assert_true(texts(p.content).contains(GalaxyPure143.BADGE))
 var ranch:RanchPasturePanel141
 for n in p.content.get_children():
  if n is RanchPasturePanel141:ranch=n
 ranch.family_id=child.id;ranch.refresh();assert_true(texts(ranch.content).contains("Cría · "+GalaxyPure143.BADGE));assert_eq(ranch.animated.size(),2)
