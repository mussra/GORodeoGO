extends GutTest
func test_equipment_hidden_then_shown_restores_available_buttons()->void:
 var host:=Control.new();get_tree().root.add_child(host);host.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 MenuInputGuard.install(host)
 var panel:=EquipmentPanel.new();host.add_child(panel)
 panel.hide();await wait_process_frames(4)
 panel.show();panel.refresh();await wait_process_frames(5)
 var buttons:Array=[]
 for child in panel._canvas.get_children():
  if child is Button:buttons.append(child)
 assert_false(buttons[0].disabled,"VOLVER debe funcionar después de mostrar Equipo")
 for b in buttons:
  if b.text==tr("UI_052") or b.text==tr("UI_053"):assert_false(b.disabled,"acceso a subpanel disponible")
 host.queue_free()
func test_equipment_balance_and_ownership_refresh_while_hidden()->void:
 var points:int=SaveData.equipment_points
 var owned:Array=SaveData.equipment_owned.duplicate()
 var equipped:Dictionary=SaveData.equipment_equipped.duplicate()
 SaveData.equipment_points=595;SaveData.equipment_owned.clear();SaveData.equipment_equipped.clear()
 var host:=Control.new();get_tree().root.add_child(host);host.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 MenuInputGuard.install(host)
 var panel:=EquipmentPanel.new();host.add_child(panel)
 for cycle in 3:
  panel.hide();await wait_process_frames(4)
  SaveData.equipment_points=595 if cycle==0 else 3000
  panel.refresh();panel.show();await wait_process_frames(4)
  assert_eq(panel._buy.whip_basic.disabled,cycle==0,"saldo real tras mostrar panel")
  assert_true(panel._equip.whip_basic.disabled,"no puede equipar una fusta no comprada")
  var horses:=HorsePanel.new();panel.add_child(horses);await wait_process_frames(4)
  for child in panel._canvas.get_children():
   if child is Button:assert_true(child.disabled,"Equipo bloqueado con caballeriza encima")
  horses.hide();await wait_process_frames(4)
  var back:Button=panel._canvas.get_children().filter(func(c):return c is Button)[0]
  assert_false(back.disabled,"VOLVER vuelve a funcionar tras cerrar caballeriza")
  horses.queue_free();await wait_process_frames(2)
 host.queue_free()
 SaveData.equipment_points=points;SaveData.equipment_owned.assign(owned);SaveData.equipment_equipped=equipped
func test_real_main_menu_equipment_back_mouse_click()->void:
 var scene:PackedScene=load("res://src/Presentation/main_menu.tscn")
 var menu:Control=scene.instantiate();get_tree().root.add_child(menu)
 await wait_process_frames(6)
 var panel:EquipmentPanel=menu._equipment_panel
 panel.refresh();panel.show();await wait_process_frames(5)
 var back:Button=panel._canvas.get_children().filter(func(c):return c is Button)[0]
 assert_false(back.disabled)
 var point:Vector2=get_tree().root.get_final_transform()*back.get_global_rect().get_center()
 var sender:=GutInputSender.new(Input);sender.set_auto_flush_input(true)
 sender.mouse_motion(point);sender.mouse_left_button_down(point);await wait_process_frames(2)
 sender.mouse_left_button_up(point);await wait_process_frames(3)
 assert_false(panel.visible,"VOLVER cierra Equipo en el menú real")
 sender.release_all();menu.queue_free()
