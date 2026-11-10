extends GutTest
func test_nominal_three_real_views_ignore_old_config()->void:
 var f=SpriteFrames.new();PixelLabTrial.apply_pig(f)
 assert_eq(f.get_frame_count("run"),9);assert_eq(f.get_animation_speed("run"),9.0);assert_eq(f.get_frame_count("run_up"),9);assert_eq(f.get_frame_count("run_down"),9);assert_false(f.has_animation("run_diag_down"))
