extends GutTest
func test_bounds_fixed_hitboxes_and_no_motion_for_unavailable_neighbor()->void:
 var host=Control.new();add_child_autofree(host)
 var indices:Array=[];var pager=ItemPager.create(host,Vector2.ZERO,340,0,3,func(i:int):indices.append(i))
 assert_true(pager.previous.disabled);assert_false(pager.next.disabled)
 var left_box:Rect2=pager.previous.get_rect();var right_box:Rect2=pager.next.get_rect()
 pager._process(.25);assert_eq(pager._left.position.x,0.0);assert_ne(pager._right.position.x,0.0)
 assert_eq(pager.previous.get_rect(),left_box);assert_eq(pager.next.get_rect(),right_box)
 pager.next.pressed.emit();assert_eq(pager.index,1);assert_eq(indices,[1])
 pager.next.pressed.emit();assert_true(pager.next.disabled);pager._process(.25);assert_eq(pager._right.position.x,0.0)
 pager.set_state(0,1);assert_false(pager.is_processing());assert_true(pager.previous.disabled);assert_true(pager.next.disabled)
func test_ficha_navigation_and_atlas_pages_use_same_component()->void:
 SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var panel=HorsePanel.new();add_child_autofree(panel);await wait_process_frames(3)
 panel.page="detail";panel.focus_id=SaveData.horse_collection.horses[0].id;panel.refresh();await wait_process_frames(3)
 var pager:ItemPager=panel.content.get_node("ItemPager");assert_eq(pager.total,SaveData.horse_collection.horses.size())
 var expected:String=SaveData.horse_collection.horses[1].id;pager.next.pressed.emit();await wait_process_frames(3);assert_eq(panel.focus_id,expected)
 panel.show_page("atlas");await wait_process_frames(3)
 pager=panel.content.get_node("ItemPager");assert_gt(pager.total,1);pager.next.pressed.emit();await wait_process_frames(3);assert_eq(panel.atlas_page,1)
func test_horse_picker_keeps_arrows_clear_of_dropdown_and_neighbor_controls()->void:
 SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var host=Control.new();add_child_autofree(host);var items:Array=SaveData.horse_collection.horses
 var pick=HorsePicker.create(host,items,items[0].id,Vector2(35,195),395,func(_id:String):pass)
 var pager:ItemPager=host.get_node("ItemPager")
 assert_false(pick.get_rect().intersects(pager.get_rect()))
 assert_eq(pager.previous.size,Vector2(56,56));assert_eq(pager.next.size,Vector2(56,56))

func test_genealogy_selection_restores_enabled_arrows_after_initially_hidden()->void:
 SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var panel=GenealogyPanel.new();add_child_autofree(panel);await wait_process_frames(3)
 panel.select(SaveData.horse_collection.horses[1].id);await wait_process_frames(5)
 assert_false(panel.item_pager.previous.disabled);assert_false(panel.item_pager.next.disabled)
 assert_gt(panel.item_pager._left.modulate.a,.9)
 panel.item_pager.next.pressed.emit();await wait_process_frames(5)
 assert_eq(panel.selected,SaveData.horse_collection.horses[2].id)
