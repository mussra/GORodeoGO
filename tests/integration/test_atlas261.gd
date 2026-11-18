extends GutTest
func test_light_legs_hides_spot_gene_and_preserves_twenty_two_combinations():
 var base={"coat":0,"pattern":4,"mane":4};var raw:=HorseAtlas.variants(base,{},[]);assert_eq(raw.size(),22)
 var grouped:=HorseAtlas.visible_groups261(raw);assert_eq(grouped.size(),1);assert_eq(grouped[0].combinations261,22);assert_eq(grouped[0].members261.size(),22)
 assert_eq(raw[0].horse.traits.spots,-1);assert_eq(raw[21].horse.traits.spots,20)
func test_filtered_results_group_after_filter_without_merging_owned_ids():
 var raw:=HorseAtlas.filtered_entries({"coat":0,"pattern":4,"mane":4},[],false)
 assert_eq(raw.size(),22);assert_eq(HorseAtlas.visible_groups261(raw).size(),1)
 var a={"id":"a","name":"A","traits":{"coat":0,"pattern":4,"mane":4,"spots":2}}
 var b={"id":"b","name":"B","traits":{"coat":0,"pattern":4,"mane":4,"spots":3}}
 var grouped:=HorseAtlas.visible_groups261([{"horse":a,"owned":true},{"horse":b,"owned":true}]);assert_eq(grouped.size(),1);assert_eq(grouped[0].members261.size(),2);assert_eq(a.id,"a");assert_eq(b.id,"b")
func test_distinct_visible_ink_mane_eyes_legs_and_mastery_remain_separate():
 var h={"traits":{"coat":0,"pattern":6,"mane":4,"spots":2}}
 var key:=HorseAtlas.visible_key261(h)
 for pair in [["spots",3],["mane",2],["eyes",2],["legs",3]]:
  var changed:Dictionary=h.duplicate(true);changed.traits[pair[0]]=pair[1];assert_ne(HorseAtlas.visible_key261(changed),key)
 var master:Dictionary=h.duplicate(true);master.master251=true;assert_ne(HorseAtlas.visible_key261(master),key)
func test_atlas_cache_has_one_entry_across_page_turns():
 var panel:=HorsePanel.new();panel.page="atlas_variants";panel.atlas_family={"coat":0,"pattern":4,"mane":4};add_child(panel);await wait_process_frames(3)
 var a:=panel.atlas_entries();panel.atlas_page=1;var b:=panel.atlas_entries();assert_eq(a,b);assert_eq(panel.atlas_cache261.size(),1);assert_eq(a.size(),1);panel.free()

func test_filtered_family_groups_have_distinct_variant_counts_and_open_preserves_filter():
 var raw:=HorseAtlas.filtered_entries({"coat":0,"pattern":4,"mane":4},[],false)
 var families:=HorseAtlas.family_groups261(raw);assert_eq(families.size(),1);assert_eq(families[0].variants261,1)
 raw=HorseAtlas.filtered_entries({"rarity":3},[],false);families=HorseAtlas.family_groups261(raw);assert_eq(families.size(),117)
 for family in families:
  var variants:=HorseAtlas.visible_groups261(HorseAtlas.variants(family.horse.traits,{"rarity":3},[]))
  assert_eq(family.variants261,variants.size())
