extends GutTest
func test_native_confirmation_auto_skin_preserves_words_and_actions():
 var d:=ConfirmationDialog.new();d.dialog_text='Confirmación de prueba';d.ok_button_text='Seguir';d.cancel_button_text='Volver';add_child_autofree(d)
 await wait_process_frames(3)
 assert_true(d.get_meta('dialog_skin305',false));assert_eq(d.dialog_text,'Confirmación de prueba')
 assert_eq(d.get_ok_button().text,'Seguir');assert_eq(d.get_cancel_button().text,'Volver')
 assert_true(d.borderless);assert_true(d.transparent_bg)
 var panel=d.theme.get_stylebox('panel','AcceptDialog');assert_true(panel is StyleBoxTexture)
 assert_eq(panel.axis_stretch_horizontal,StyleBoxTexture.AXIS_STRETCH_MODE_TILE)
 for b in [d.get_ok_button(),d.get_cancel_button()]:
  assert_true(b.get_meta('skin272',false));assert_gte(b.custom_minimum_size.y,52.)
  assert_same(b.get_theme_stylebox('normal'),ButtonSkin272.style('normal'))
func test_accept_and_equipment_confirmation_share_frame_and_buttons():
 var d:=AcceptDialog.new();add_child_autofree(d)
 var p:=EquipmentPanel.new();add_child_autofree(p);await wait_process_frames(4)
 for dialog in [d,p._confirm]:
  assert_true(dialog.get_meta('dialog_skin305',false));assert_true(dialog.theme.get_stylebox('panel','AcceptDialog') is StyleBoxTexture)
  assert_true(dialog.get_ok_button().get_meta('skin272',false))
func test_conversation_panel_and_dynamically_added_buttons():
 var p:=NpcDialog.new();p.setup_story('Granjero','El rancho','Un mensaje de prueba.');add_child_autofree(p)
 await wait_process_frames(4)
 assert_true(p.get_meta('dialog_skin305',false));assert_true(p.get_theme_stylebox('panel') is StyleBoxTexture)
 var button:=Button.new();button.text='Seguir';p.add_child(button);await wait_process_frames(4)
 assert_true(button.get_meta('skin272',false));assert_eq(button.text,'Seguir')
func test_hat_has_room_below_top_buttons_at_all_aspects():
 GameState.brand_intro_played=true
 var menu=load('res://src/Presentation/main_menu.tscn').instantiate();add_child_autofree(menu);menu.set_anchors_preset(Control.PRESET_TOP_LEFT)
 for extent in [Vector2i(960,540),Vector2i(1280,720),Vector2i(1600,720),Vector2i(1280,800)]:
  menu.size=extent;menu._layout();await wait_process_frames(2)
  var sprite:Sprite2D=menu._hd_rider
  var upper_left:Vector2=sprite.global_transform*(sprite.get_rect().position)
  var lower_right:Vector2=sprite.global_transform*(sprite.get_rect().end)
  var k:float=menu._hero.scale.y
  assert_gte(upper_left.y-menu._book256.get_global_rect().end.y,32.*k)
  assert_gte(upper_left.y-menu._settings_button.get_global_rect().end.y,32.*k)
  assert_lte(lower_right.y,(menu._hero.get_global_transform()*Vector2(912,600)).y)
