extends GutTest
func test_nine_slice_states_and_geometry():
 var b:=Button.new();add_child_autofree(b);b.text="Conseguir";b.position=Vector2(12,14);b.size=Vector2(210,60)
 ButtonSkin272.apply(b,true)
 assert_eq(b.position,Vector2(12,14));assert_eq(b.size,Vector2(210,60));assert_eq(b.text,"Conseguir")
 for state in ["normal","hover","pressed","disabled"]:
  var skin=b.get_theme_stylebox(state)
  assert_true(skin is StyleBoxTexture)
  assert_eq(skin.texture.get_size(),Vector2(120,54))
  assert_eq(skin.get_texture_margin(SIDE_LEFT),20.0)
  assert_eq(skin.get_texture_margin(SIDE_TOP),17.0)
 assert_ne(b.get_theme_stylebox("normal").texture,b.get_theme_stylebox("disabled").texture)
func test_equipment_primary_secondary_and_real_data():
 var p:=EquipmentPanel.new();add_child_autofree(p);await get_tree().process_frame
 assert_gt(p._buy.size(),0)
 for key in p._buy:
  assert_true(p._buy[key].get_meta("skin272",false));assert_true(p._equip[key].get_meta("skin272",false))
  assert_same(p._buy[key].get_theme_stylebox("normal"),ButtonSkin272.style("normal",true))
  assert_same(p._equip[key].get_theme_stylebox("normal"),ButtonSkin272.style("normal",false))
func test_settings_and_main():
 GameState.brand_intro_played=true
 var m=load("res://src/Presentation/main_menu.tscn").instantiate();add_child_autofree(m);await get_tree().process_frame
 assert_true(m._play.get_meta("skin272",false));assert_true(m._world_button.get_meta("skin272",false))
 m._show_settings();assert_not_null(m.get_node_or_null("Settings213"))
 var choice=m.find_child("MovementMode258",true,false);assert_not_null(choice);assert_eq(choice.item_count,2);assert_true(choice.get_meta("skin272",false))
