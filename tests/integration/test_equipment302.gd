extends "res://tests/integration/test_equipment_flow.gd"
func test_purchase_and_upgrade_immediately_show_enabled_equip():
 SaveData.equipment_points=10000
 var p:=EquipmentPanel.new();add_child(p);await wait_process_frames(8)
 for id in ["scare_whip265","scare_whip_plus265"]:
  p._confirm_purchase(id);await wait_process_frames(5)
  p._confirm.get_ok_button().pressed.emit()
  await wait_process_frames(5)
  assert_true(SaveData.equipment_owned.has(id),id+" purchased")
  assert_false(p._equip[id].disabled,id+" equip immediately enabled")
  assert_eq(p._equip[id].modulate,Color.WHITE,id+" not visually disabled")
  assert_ne(SaveData.equipment_equipped.get("scare_whip",""),id,"purchase does not auto-equip")
  assert_eq(p._badges302[id].text,"SIN EQUIPAR")
  p._equip[id].pressed.emit();await wait_process_frames(2)
  assert_eq(SaveData.equipment_equipped.get("scare_whip",""),id)
  assert_eq(p._badges302[id].text,"✓ EQUIPADO")
  assert_eq(p._equip[id].get_node("Caption229").text,"✓ EQUIPADO")
  assert_true(p._equip[id].disabled)
  assert_eq(p._equip[id].modulate,Color.WHITE)
  assert_eq(p._equip[id].get_theme_stylebox("disabled"),ButtonSkin272.style("pressed"))
 p.free()
