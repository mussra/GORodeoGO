extends GutTest
var panel:HorsePanel
func before_each()->void:
 SaveData.horse_collection.seed_trial();panel=HorsePanel.new();get_tree().root.add_child(panel);await wait_process_frames(5)
func after_each()->void:
 if is_instance_valid(panel):panel.queue_free()
func test_hub_has_six_large_entries_and_no_permanent_tabs()->void:
 assert_eq(panel.page,"hub")
 for id in ["collection","breed","atlas","market","training","genealogy"]:
  var card:=panel.content.get_node("Navigate_"+id) as Button
  assert_not_null(card);assert_gte(card.size.y,150.0)
 panel.show_page("breed");await wait_process_frames(5)
 assert_null(panel.content.get_node_or_null("Navigate_collection"))
 assert_not_null(panel.content.get_node_or_null("NavigationBack"))
 var large:int=0
 for child in panel.content.get_children():
  if child is TextureRect and child.size.x>=280:large+=1
 assert_eq(large,2,"both adult parents readable above the two trait rows")
 panel.go_back();await wait_process_frames(4);assert_eq(panel.page,"hub")
 panel.go_back();await wait_process_frames(3);assert_false(panel.visible)
 panel.open_menu();await wait_process_frames(4);assert_eq(panel.page,"hub");assert_true(panel.visible)
func test_detail_back_returns_to_origin_and_preserves_filters_page()->void:
 panel.show_page("atlas");panel.atlas_filters={"coat":8};panel.atlas_page=3
 panel.focus_id="original";panel.show_page("detail");await wait_process_frames(4)
 panel.go_back();await wait_process_frames(4);assert_eq(panel.page,"atlas");assert_eq(panel.atlas_filters,{"coat":8});assert_gte(panel.atlas_page,0)
func test_filters_are_hidden_and_modal_repeatedly_restore_back()->void:
 panel.show_page("atlas");await wait_process_frames(5)
 var back:Button=panel.content.get_node("NavigationBack")
 assert_eq(panel.content.get_children().filter(func(c):return c is OptionButton).size(),0)
 for cycle in range(3):
  panel.open_atlas_filters();await wait_process_frames(5)
  var drawer:FilterDrawer=panel.get_children().filter(func(c):return c is FilterDrawer)[0]
  assert_true(back.disabled,"background blocked by filters")
  assert_eq(drawer.count,8)
  assert_false(drawer.canvas.get_node("NavigationBack").disabled)
  drawer.queue_free();await wait_process_frames(5)
  assert_false(back.disabled,"back restored after closing filters")
func test_atlas_and_market_use_same_filter_drawer()->void:
 for page in ["atlas","market"]:
  panel.show_page(page);await wait_process_frames(5);panel.open_atlas_filters();await wait_process_frames(4)
  var drawer:FilterDrawer=panel.get_children().filter(func(c):return c is FilterDrawer)[0]
  drawer.changed.emit("coat",8);await wait_process_frames(5);assert_eq(panel.atlas_filters.coat,8)
  drawer.cleared.emit();await wait_process_frames(5);assert_true(panel.atlas_filters.is_empty())
  drawer.queue_free();await wait_process_frames(3)
func test_genealogy_hides_all_filter_choices_in_same_drawer()->void:
 var graph:=GenealogyPanel.new();panel.add_child(graph);await wait_process_frames(5)
 assert_eq(graph.canvas.get_children().filter(func(c):return c is OptionButton).size(),0)
 graph.open_filters();await wait_process_frames(4)
 var drawer:FilterDrawer=graph.get_children().filter(func(c):return c is FilterDrawer)[0]
 assert_eq(drawer.count,8)
 drawer.changed.emit("pattern",10);assert_eq(graph.filters.pattern,10)
 drawer.changed.emit("origin",2);assert_eq(graph.origin_filter,2)
 drawer.changed.emit("mode",true);assert_true(graph.only_matches)
 drawer.cleared.emit();assert_true(graph.filters.is_empty());assert_eq(graph.origin_filter,0);assert_false(graph.only_matches)
 graph.queue_free()
func test_shared_map_opacity_keeps_frame_clear_and_floor_translucent()->void:
 assert_almost_eq(MapAppearance.floor_color("34575c").a,.75,.001)
 assert_eq(MapAppearance.frame().bg_color.a,0.0)
 assert_eq(MapAppearance.frame().border_color.a,1.0)
func test_common_menu_finish_respects_mute_and_wires_new_controls()->void:
 await wait_process_frames(5)
 assert_not_null(panel.get_node_or_null("SharedMenuAmbience"))
 var prior:bool=GameState.sound_enabled;GameState.sound_enabled=false
 var last:int=MenuSounds.last_msec;MenuSounds.play("tap");assert_eq(MenuSounds.last_msec,last)
 GameState.sound_enabled=prior
 assert_eq(MenuSounds.voices.size(),3,"small fixed reusable voice pool")
 assert_true(panel.theme is Theme)
func test_atlas_variant_page_preserves_return_and_cannot_buy_preview()->void:
 panel.atlas_family={"coat":10,"pattern":1,"mane":2};panel.atlas_family_page=4;panel.show_page("atlas_variants");await wait_process_frames(4)
 panel.focus_id="";panel.focus_preview={"traits":{"coat":10,"pattern":1,"mane":2,"spots":3},"stage":"adult"};panel.show_page("detail");await wait_process_frames(4)
 assert_eq(panel.content.get_children().filter(func(c):return c is Button and c.text.begins_with("Comprar")).size(),0)
 panel.go_back();await wait_process_frames(4);assert_eq(panel.page,"atlas_variants")
 panel.go_back();await wait_process_frames(4);assert_eq(panel.page,"atlas");assert_eq(panel.atlas_page,4)
