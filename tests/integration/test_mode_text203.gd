extends GutTest
var scene:Node
func after_each():
 if is_instance_valid(scene):scene.free()
 get_tree().paused=false;Engine.time_scale=1.
func test_race_text_is_larger_opaque_and_does_not_overlap_header():
 RaceCourse190.start_selected=true
 scene=load("res://src/Presentation/race190.tscn").instantiate();add_child(scene)
 await wait_frames(4)
 for label in [scene.info,scene.telemetry,scene.standings,scene.guidance]:
  assert_gte(label.get_theme_font_size("font_size"),24)
  assert_gte(label.get_theme_stylebox("normal").bg_color.a,.95)
  assert_eq(label.mouse_filter,Control.MOUSE_FILTER_IGNORE)
 assert_lte(scene.info.get_global_rect().end.y,scene.progress_bar.get_global_rect().position.y)
 assert_lte(scene.progress_bar.get_global_rect().end.y,scene.telemetry.get_global_rect().position.y)
 assert_lte(scene.telemetry.get_global_rect().end.y,scene.standings.get_global_rect().position.y)
 assert_gte(scene.guidance.get_global_rect().position.y,620.)
 assert_eq(scene.toasts.font_size203,24)
func test_joust_larger_labels_keep_arena_center_free():
 scene=load("res://src/Presentation/joust196.tscn").instantiate();add_child(scene)
 await wait_frames(4)
 assert_eq(scene.info.get_theme_font_size("font_size"),28)
 assert_eq(scene.guidance.get_theme_font_size("font_size"),26)
 assert_lt(scene.info.get_global_rect().end.y,120.)
 assert_gt(scene.guidance.get_global_rect().position.y,620.)
