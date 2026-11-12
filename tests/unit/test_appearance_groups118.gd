extends GutTest
func horse(id_:String)->Dictionary:
 return {"id":id_,"name":"Caballo "+id_,"traits":{"coat":16,"pattern":6,"mane":1},"stage":"adult","parents":[],"stats":{"speed":265.0}}
func test_equal_appearance_groups_without_losing_individual_records():
 var a=horse("a");var b=horse("b");b.stats.speed=290.;b.can_jump=true;b.parents=["parent"]
 var before:String=JSON.stringify([a,b]);var groups=HorseAppearanceGroups118.groups([a,b]);assert_eq(groups.size(),1);assert_eq(groups[0].horses.size(),2);assert_eq(groups[0].horses[1].id,"b");assert_eq(JSON.stringify([a,b]),before)
func test_visible_traits_stage_emblem_and_finish_split_groups():
 var a=horse("a")
 for pair in [["coat",3],["pattern",11],["mane",5],["eyes",20],["legs",3],["spots",5],["finish","galaxy"],["emblem",HorseEmblem.DEFAULT]]:
  var b=a.duplicate(true);b.traits[pair[0]]=pair[1];assert_ne(HorseAppearanceGroups118.key(a),HorseAppearanceGroups118.key(b))
 var foal=a.duplicate(true);foal.stage="foal";assert_ne(HorseAppearanceGroups118.key(a),HorseAppearanceGroups118.key(foal))
func test_expand_retains_specific_ids_actions_and_equipped_state():
 var old=SaveData.horse_collection;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.horses.assign([horse("a"),horse("b"),horse("c")]);SaveData.horse_collection.selected="b"
 var panel=HorsePanel.new();add_child_autofree(panel);panel.page="collection";panel._refresh()
 var toggle=panel.content.find_child("ToggleAppearance118",true,false);assert_not_null(toggle);assert_true(toggle.text.contains("×3"));toggle.pressed.emit()
 for id_ in ["a","b","c"]:
  var equip=panel.content.find_child("Equip118_"+id_,true,false);assert_not_null(equip);assert_eq(equip.disabled,id_=="b");assert_not_null(panel.content.find_child("Ficha118_"+id_,true,false))
 panel.content.find_child("Ficha118_c",true,false).pressed.emit();assert_eq(panel.focus_id,"c");assert_eq(panel.detail_entries.size(),3)
 assert_eq(SaveData.horse_collection.horses.size(),3);assert_eq(SaveData.horse_collection.selected,"b")
 SaveData.horse_collection=old
func test_genealogy_back_restores_real_collection_and_expanded_group():
 var old=SaveData.horse_collection;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.horses.assign([horse("a"),horse("b"),horse("c")]);SaveData.horse_collection.selected="a"
 var panel=HorsePanel.new();add_child_autofree(panel);panel.page="collection";panel._refresh()
 panel.content.find_child("ToggleAppearance118",true,false).pressed.emit();var expanded=panel.expanded_appearance_groups118.duplicate()
 panel.content.find_child("Ficha118_b",true,false).pressed.emit();await get_tree().process_frame;await get_tree().process_frame
 assert_eq(panel.page,"detail");assert_eq(panel.detail_origin,"collection")
 panel.show_page("family");await get_tree().process_frame;await get_tree().process_frame;await get_tree().process_frame
 assert_eq(panel.page,"collection");var graph=panel.get_node("HorseGenealogyOverlay118");assert_not_null(graph)
 graph.queue_free();await get_tree().process_frame;await get_tree().process_frame
 assert_not_null(panel.content.find_child("AppearanceGroups118",true,false));assert_true(panel.content.find_child("AppearanceMembers118",true,false).visible);assert_eq(panel.expanded_appearance_groups118,expanded);assert_not_null(panel.content.find_child("Ficha118_b",true,false))
 SaveData.horse_collection=old
