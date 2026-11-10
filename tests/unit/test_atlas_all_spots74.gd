extends GutTest
func test_giraffe_all_spot_colors_are_navigable_with_exact_count():
 var entries=HorseAtlas.filtered_entries({"pattern":10},[])
 assert_eq(entries.size(),20*6*21)
 var colors:Dictionary={};var signatures:Dictionary={}
 for entry in entries:
  assert_eq(entry.horse.traits.pattern,10)
  colors[HorseCollection.spots_index(entry.horse.traits)]=true
  signatures[HorseAtlas.signature(entry.horse.traits)]=true
 assert_eq(colors.size(),21);assert_eq(signatures.size(),entries.size())
 assert_eq(ceili(entries.size()/6.0),420)
func test_explicit_color_original_and_clear_all_share_same_list():
 var base={"coat":18,"pattern":10,"mane":4}
 assert_eq(HorseAtlas.variants(base,{},[]).size(),21)
 assert_eq(HorseAtlas.variants(base,{"spots":18},[]).size(),1)
 var red=HorseAtlas.filtered_entries({"pattern":10,"spots":5},[])
 assert_eq(red.size(),120)
 for entry in red:assert_eq(entry.horse.traits.spots,5)
 assert_eq(HorseAtlas.filtered_entries({"pattern":10,"spots":-1},[]).size(),120)
 assert_eq(HorseAtlas.filtered_entries({"pattern":10,"coat":18,"mane":4},[]).size(),21)
func test_other_patterns_smooth_and_exact_owned_slice():
 assert_eq(HorseAtlas.filtered_entries({"pattern":0},[]).size(),120)
 for pattern in [1,2,5,9,11]:assert_eq(HorseAtlas.filtered_entries({"pattern":pattern,"coat":3,"mane":0},[]).size(),21)
 var t={"coat":3,"pattern":10,"mane":0,"spots":3,"eyes":4,"legs":1}
 var horses=[{"id":"mine","traits":t}]
 var result=HorseAtlas.filtered_entries({"pattern":10,"coat":3,"mane":0,"eyes":4,"legs":1},horses)
 assert_eq(result.size(),21);assert_true(result[0].owned);assert_eq(result[0].horse.id,"mine")
func test_panel_filtered_source_and_ficha_count_are_actual_variants():
 var previous=SaveData.horse_collection
 SaveData.horse_collection=HorseCollection.new()
 var panel=HorsePanel.new();panel.page="atlas";panel.atlas_filters={"pattern":10}
 var entries=panel.atlas_entries();assert_eq(entries.size(),2520)
 panel.page="atlas_variants";panel.atlas_family={"coat":3,"pattern":10,"mane":0}
 assert_eq(panel.atlas_entries().size(),21)
 panel.free();SaveData.horse_collection=previous
func test_stable_color_order_does_not_jump_on_refresh():
 var a=HorseAtlas.filtered_entries({"pattern":10,"coat":3,"mane":0},[])
 var b=HorseAtlas.filtered_entries({"pattern":10,"coat":3,"mane":0},[])
 for i in 21:
  assert_eq(HorseCollection.spots_index(a[i].horse.traits),i-1)
  assert_eq(a[i].horse.traits,b[i].horse.traits)
func test_breed_preview_is_between_parents_for_several_traits():
 var old_collection=SaveData.horse_collection
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var panel=HorsePanel.new();panel.page="breed";panel.parent_a="trial_a";panel.parent_b="trial_b";add_child_autofree(panel)
 for coat in [3,10,18]:
  SaveData.horse_collection.find("trial_a").traits.coat=coat
  panel.choices["mane"]=coat%2;panel.refresh()
  await wait_process_frames(3)
  var portraits:Array=[]
  for node in panel.content.get_children():
   if node is TextureRect:portraits.append(node)
  assert_eq(portraits.size(),3)
  assert_almost_eq(portraits[2].position.x+portraits[2].size.x/2,640.0,.01)
  assert_almost_eq((portraits[0].position.x+portraits[0].size.x/2+portraits[1].position.x+portraits[1].size.x/2)/2,640.0,.01)
 SaveData.horse_collection=old_collection
func test_real_ficha_pager_steps_same_color_list_and_stops_at_end():
 var old_collection=SaveData.horse_collection;SaveData.horse_collection=HorseCollection.new()
 var entries=HorseAtlas.filtered_entries({"pattern":10},[])
 var panel=HorsePanel.new();panel.page="detail";panel.detail_origin="atlas";panel.detail_entries=entries;panel.focus_id="";panel.focus_preview=entries[0].horse;add_child_autofree(panel)
 await wait_process_frames(3)
 var pager=panel.content.get_node("ItemPager")
 assert_eq(pager.counter.text,"1 / 2520");assert_true(pager.previous.disabled)
 pager.next.pressed.emit();await wait_process_frames(3)
 assert_eq(panel.focus_preview.traits.spots,0);assert_eq(panel.content.get_node("ItemPager").counter.text,"2 / 2520")
 panel.focus_preview=entries[-1].horse;panel.refresh();await wait_process_frames(3)
 pager=panel.content.get_node("ItemPager");assert_eq(pager.counter.text,"2520 / 2520");assert_true(pager.next.disabled)
 SaveData.horse_collection=old_collection
func test_zebra_inherits_independent_pattern_mane_legs_and_hidden_spots_unchanged():
 var c=HorseCollection.new();c.seed_trial();c.add_trial_parents()
 c.find("trial_a").traits={"coat":6,"pattern":0,"mane":0,"eyes":10,"legs":9,"spots":4,"finish":"normal"}
 c.find("trial_b").traits={"coat":19,"pattern":9,"mane":4,"eyes":20,"finish":"normal"}
 var choice={"pattern":1,"eyes":1}
 var preview=c.preview("trial_a","trial_b",choice);var child=c.breed("trial_a","trial_b",choice)
 assert_eq(preview.pattern,9);assert_eq(preview.mane,0);assert_eq(preview.legs,9);assert_eq(preview.spots,4);assert_eq(preview.eyes,20);assert_eq(child.traits,preview)
