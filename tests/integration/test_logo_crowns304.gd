extends GutTest
func test_logo_is_supplied_texture_and_never_overlaps_controls_or_subtitle():
 GameState.brand_intro_played=true
 var menu=load('res://src/Presentation/main_menu.tscn').instantiate();add_child(menu)
 menu.set_anchors_preset(Control.PRESET_TOP_LEFT)
 for extent in [Vector2i(960,540),Vector2i(1280,720),Vector2i(1600,720)]:
  menu.size=extent;menu._layout();await wait_process_frames(2)
  var logo=menu._hero.get_node('Logo')
  assert_true(logo is TextureRect);assert_eq(logo.texture.resource_path,'res://art/ui/logo304/logo.png')
  assert_eq(logo.stretch_mode,TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
  assert_false(logo.get_global_rect().intersects(menu._play.get_global_rect()))
  assert_lte(logo.get_global_rect().end.y,menu._hero.get_node('Description').global_position.y)
 menu._show_games213()
 assert_eq(menu._games213.canvas.get_node('Navigate_crowns240/GameIcon223').texture.resource_path,'res://art/ui/crowns241/round/cup.png')
 assert_eq(MenuNavigation.ICONS302.crowns240,'res://art/ui/crowns241/round/cup.png')
 menu.free()
func test_only_closed_resources_exist_and_no_style_selector():
 var screen:=ModeCrowns240.new();add_child(screen)
 for mode in ModeVictories240.MODES:
  for obtained in [true,false]:
   var art=screen._texture241(mode,obtained)
   assert_string_contains(art.resource_path,'/round/')
   assert_false(FileAccess.file_exists('res://art/ui/crowns241/'+mode+('' if obtained else '_pending')+'.png'))
 assert_false(screen.has_method('_toggle_style241'))
 assert_false(FileAccess.file_exists('res://docs/crowns241/source.png'))
 screen.free()
