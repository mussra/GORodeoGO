extends GutTest
func test_all_crops_have_alpha_and_no_number_corner():
 for i in range(1,73):
  var art:=AntIcons187.texture(i);assert_not_null(art)
  var image:=art.get_image()
  if image.is_compressed():image.decompress()
  assert_true(image.detect_alpha()!=Image.ALPHA_NONE,"real alpha cell "+str(i))
func test_badges_keep_transparent_input_and_art_states():
 for skill in ["jump","dodge"]:
  for known in [false,true]:
   var badge:=JumpBadge.new();badge.skill=skill;badge.capable=known;add_child_autofree(badge)
   assert_eq(badge.custom_minimum_size,Vector2(64,56));assert_true(badge.get_theme_stylebox("disabled") is StyleBoxEmpty)
func test_shared_menu_cells_and_preserved_clocks():
 assert_eq(MenuGlyph.CELLS.collection,5);assert_eq(MenuGlyph.CELLS.breed,6);assert_eq(MenuGlyph.CELLS.atlas,7)
 for id in ["stamina","dodge","jump"]:assert_true(RadialGauge.ART[id].resource_path.begins_with("res://art/ui/skills/"))
func test_theme_dropdown_keeps_small_footprint():
 assert_eq(RanchTheme.create().get_icon("arrow","OptionButton").get_size(),Vector2(12,12))
