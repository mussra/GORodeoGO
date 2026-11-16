extends GutTest
func test_actions_keep_large_touch_targets_with_icon_above_small_caption():
 var panel:=EquipmentPanel.new();add_child(panel);await wait_process_frames(2)
 var buttons:int=0
 for child in panel._canvas.get_children():
  if not child is Button:continue
  buttons+=1;assert_eq(child.text,"");assert_true(child.has_node("Caption229"));assert_gte(child.size.y,80.)
  assert_true(child.get_children().any(func(n):return n is EquipmentIcon229));assert_eq(child.get_node("Caption229").get_theme_font_size("font_size"),18)
 assert_eq(buttons,5);assert_eq(panel._buy.size(),EquipmentCatalog.ORDER.size());assert_eq(panel._equip.size(),EquipmentCatalog.ORDER.size())
 panel.free()
