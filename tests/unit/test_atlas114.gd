extends GutTest
func test_order_preserves_all_entries_and_owned_variants():
 var old=SaveData.horse_collection;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var duplicate:Dictionary=SaveData.horse_collection.horses[1].duplicate(true);duplicate.id="same-family-other-eyes";duplicate.traits.eyes=19;SaveData.horse_collection.horses.append(duplicate)
 var panel=HorsePanel.new();panel.page="atlas";panel.atlas_owned_first=false;var natural:Array=panel.atlas_entries();panel.atlas_owned_first=true;var sorted_:Array=panel.atlas_entries()
 assert_eq(natural.size(),sorted_.size());var all_ids:Dictionary={}
 for entry in natural:all_ids[str(entry.horse.get("id",HorseAtlas.signature(entry.horse.traits)))]=true
 for entry in sorted_:assert_true(all_ids.has(str(entry.horse.get("id",HorseAtlas.signature(entry.horse.traits)))))
 for i in SaveData.horse_collection.horses.size():assert_true(sorted_[i].owned)
 panel.free();SaveData.horse_collection=old
func test_legendary_mystery_in_filter_no_unicorn_labels():
 var panel=HorsePanel.new();panel.page="atlas";panel.atlas_filters={"rarity":4}
 var found:Array=panel.atlas_entries();var hidden:int=0
 for entry in found:
  if entry.get("mystery115",false):hidden+=1;assert_eq(entry.horse.name,"Legendario sin descubrir");assert_false(entry.owned)
 assert_eq(hidden,5);panel.free()
func test_order_button_survives_click_resets_page_without_filters():
 var panel=HorsePanel.new();add_child_autofree(panel);panel.page="atlas";panel.atlas_page=14;panel._refresh()
 var before:int=panel.atlas_entries().size();var button=panel.content.find_child("AtlasOrder114",true,false);assert_not_null(button)
 button.pressed.emit();await get_tree().process_frame;await get_tree().process_frame
 assert_not_null(panel.content.find_child("AtlasOrder114",true,false));assert_eq(panel.atlas_page,0);assert_eq(panel.atlas_entries().size(),before);assert_true(panel.atlas_filters.is_empty())
 panel.page="atlas_variants";panel.atlas_family={"coat":3,"pattern":1,"mane":1};panel._refresh();assert_not_null(panel.content.find_child("AtlasOrder114",true,false))
func test_owned_legendary_keeps_identity_even_with_matching_regular_traits():
 var old=SaveData.horse_collection;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var h:Dictionary=SaveData.horse_collection.horses[0].duplicate(true);h.id="owned-unicorn";h.name="Mi leyenda";h.species="unicorn";h.unicorn_variant="blue";SaveData.horse_collection.horses.append(h)
 var panel=HorsePanel.new();panel.page="atlas";panel.atlas_filters={"rarity":4}
 var entries:Array=HorseFilters.apply(panel.atlas_entries(),panel.atlas_filters);var owned=entries.filter(func(e):return e.owned and e.horse.id==h.id)
 assert_eq(owned.size(),1);assert_eq(owned[0].horse.name,"Mi leyenda");assert_false(owned[0].get("mystery115",false))
 assert_eq(entries.filter(func(e):return e.get("mystery115",false)).size(),4)
 panel.atlas_filters["owned"]=true;assert_eq(HorseFilters.apply(panel.atlas_entries(),panel.atlas_filters).size(),1)
 panel.page="atlas_variants";panel.atlas_filters={};panel.atlas_family=h.traits;var variants:Array=panel.atlas_entries();assert_true(variants.any(func(e):return e.owned and e.horse.id==h.id));assert_true(variants.any(func(e):return e.owned and e.horse.id=="original"))
 panel.free();SaveData.horse_collection=old
func test_six_cards_visible_in_two_rows_without_scroll():
 var panel=HorsePanel.new();add_child_autofree(panel);panel.page="atlas";panel._refresh()
 var grid=panel.content.find_child("AtlasVisibleGrid117",true,false);assert_not_null(grid);assert_eq(grid.size,Vector2(1240,365));var count:int=0
 for child in grid.get_children():
  if str(child.name).begins_with("AtlasCard117_"):
   count+=1;assert_true(Rect2(Vector2.ZERO,grid.size).encloses(Rect2(child.position,child.size)))
  assert_false(child is ScrollContainer)
 assert_eq(count,6)
