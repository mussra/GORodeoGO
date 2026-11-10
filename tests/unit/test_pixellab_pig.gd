extends GutTest
func test_reversible_three_real_views()->void:
 PixelLabTrial.initialized=true;PixelLabTrial.pig_enabled=true
 var f=SpriteFrames.new();f.add_animation("run_up");f.add_frame("run_up",load("res://art/world/pigs/pink/up/frame_00.png"))
 PixelLabTrial.apply_pig(f)
 assert_eq(f.get_frame_count("run"),9);assert_eq(f.get_animation_speed("run"),9.0);assert_eq(f.get_frame_count("run_up"),9);assert_eq(f.get_frame_count("run_down"),9);assert_false(f.has_animation("run_diag_down"))
 PixelLabTrial.pig_enabled=false
 var off=SpriteFrames.new();off.add_animation("run");off.add_frame("run",load("res://art/world/pigs/pink/frame_00.png"));PixelLabTrial.apply_pig(off);assert_eq(off.get_frame_count("run"),1)
 PixelLabTrial.pig_enabled=true
