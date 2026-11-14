extends GutTest
var old_intro:bool
func before_each():
 old_intro=GameState.brand_intro_played;GameState.brand_intro_played=true
func after_each():GameState.brand_intro_played=old_intro
func menu()->Control:
 var m=load("res://src/Presentation/main_menu.tscn").instantiate();add_child_autofree(m);return m
func test_mounted_skills_are_vertical_and_inside_shared_animated_hero()->void:
 var m=menu();await wait_frames(2)
 assert_eq(m._jump_badge.get_parent(),m._skill_column189)
 assert_eq(m._dodge_badge.get_parent(),m._skill_column189)
 assert_eq(m._skill_column189.get_parent(),m._hero)
 assert_eq(m._jump_badge.position.x,m._dodge_badge.position.x)
 assert_gt(m._dodge_badge.position.y,m._jump_badge.position.y+56)
 assert_gt(m._skill_column189.position.x,m._hero.get_node("Rider").position.x)
 assert_lte(m._skill_column189.position.x+64,1280.0)
 await wait_seconds(.7)
 assert_almost_eq(m._hero.modulate.a,1.,.01)
func test_entry_buttons_use_ant_art()->void:
 var m=menu();await wait_frames(2)
 assert_eq(m._world_button.get_meta("entry_art189"),"frontier")
 assert_eq(m._missions.get_meta("entry_art189"),"levels")
 assert_eq(m._world_button.icon,MenuEntryArt189.texture("frontier"))
 assert_eq(m._missions.icon,MenuEntryArt189.texture("levels"))
 assert_gte(m._world_button.size.y,64.)
 assert_gte(m._missions.size.y,60.)
 assert_true(Rect2(m._missions.position,m._missions.size).end.y<m._caption.position.y)
func test_badges_still_open_their_own_explanations()->void:
 var m=menu();await wait_frames(2)
 for badge in [m._jump_badge,m._dodge_badge]:
  badge.pressed.emit();await wait_frames(1)
  var dialog=badge.get_child(badge.get_child_count()-1)
  assert_true(dialog is AcceptDialog)
  assert_true(dialog.visible)
  dialog.hide();dialog.queue_free();await wait_frames(2)
func test_levels_navigation_and_responsive_layout_still_work()->void:
 var m=menu();await wait_frames(2)
 for extent in [Vector2(960,540),Vector2(1280,720),Vector2(1600,720)]:
  m.size=extent;m._layout()
  assert_lte(m._skill_column189.get_global_rect().end.x,extent.x)
  assert_lte(m._skill_column189.get_global_rect().end.y,extent.y)
 m._missions.pressed.emit();await wait_frames(1)
 assert_true(m._drawer.visible)
 assert_eq(m.level_grid.get_child_count(),LevelCatalog.MAX_LEVEL)
 m._hide_levels();assert_false(m._drawer.visible)

func test_atlas_uses_horse_art_not_world_map()->void:
 assert_not_null(MenuEntryArt189.texture("atlas"))
 assert_ne(MenuEntryArt189.texture("atlas"),AntIcons187.texture(7))
 for key in ["atlas","frontier","levels"]:
  var image:=MenuEntryArt189.texture(key).get_image()
  assert_gt(image.get_width(),450)
  assert_eq(image.get_format(),Image.FORMAT_RGBA8)
  assert_eq(image.get_pixel(0,0).a,0.)
