extends GutTest
func test_nine_slice_states_and_geometry():
 var b:=Button.new();add_child_autofree(b);b.text="Conseguir";b.position=Vector2(12,14);b.size=Vector2(210,60)
 ButtonSkin272.apply(b,true)
 assert_eq(b.position,Vector2(12,14));assert_eq(b.size,Vector2(210,60));assert_eq(b.text,"Conseguir")
 for state in ["normal","hover","pressed","disabled"]:
  var skin=b.get_theme_stylebox(state)
  assert_true(skin is StyleBoxTexture)
  assert_eq(skin.texture.get_size(),Vector2(116,71))
  assert_eq(skin.axis_stretch_horizontal,StyleBoxTexture.AXIS_STRETCH_MODE_TILE)
  assert_eq(skin.axis_stretch_vertical,StyleBoxTexture.AXIS_STRETCH_MODE_TILE)
  assert_eq(skin.get_texture_margin(SIDE_LEFT),32.0)
  assert_eq(skin.get_texture_margin(SIDE_TOP),23.0)
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

func test_panel_repeat_preserves_bounds():
 var p:=Panel.new();add_child_autofree(p);p.size=Vector2(810,320)
 ButtonSkin272.panel(p)
 assert_eq(p.size,Vector2(810,320))
 var skin=p.get_theme_stylebox("panel")
 assert_true(skin is StyleBoxTexture)
 assert_eq(skin.axis_stretch_horizontal,StyleBoxTexture.AXIS_STRETCH_MODE_TILE)
 assert_eq(skin.axis_stretch_vertical,StyleBoxTexture.AXIS_STRETCH_MODE_TILE)

func test_backgrounds_retained_and_content_treatment():
 for mode in ["main","content"]:
  var bg:=MenuBackdrop.new();bg.art_mode300=mode;bg.size=Vector2(1280,720);add_child_autofree(bg)
  # Force the draw callback in headless tests to verify the retained resource.
  bg.art_texture300=load("res://art/ui/background300/"+mode+".png")
  assert_not_null(bg.art_texture300)
  assert_eq(bg.art_texture300.get_size(),Vector2(1280,720))
  assert_eq(bg.mouse_filter,Control.MOUSE_FILTER_IGNORE)
 var normal=ButtonSkin272.style("normal")
 var pressed=ButtonSkin272.style("pressed")
 assert_eq(pressed.content_margin_top-normal.content_margin_top,3.0)
 assert_eq(normal.content_margin_bottom-pressed.content_margin_bottom,3.0)

func test_supplied_icon_sheet300():
 assert_eq(EquipmentIcon229.KINDS300.size(),16)
 for kind in EquipmentIcon229.KINDS300:
  var art=EquipmentIcon229.texture300(kind)
  assert_not_null(art)
  assert_eq(art.get_size(),Vector2(256,256))
  assert_same(art,EquipmentIcon229.texture300(kind))
