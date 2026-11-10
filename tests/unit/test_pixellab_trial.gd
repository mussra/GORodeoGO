extends GutTest
func test_trial_replaces_five_views_and_idle_without_touching_genes()->void:

 var frames:=SpriteFrames.new();frames.add_animation("walk_up")
 var original:Texture2D=load("res://art/experimental/pixellab/horse/up/frame_00.png")
 frames.add_frame("walk_up",original)
 PixelLabTrial.apply(frames,"horse","walk")
 assert_eq(frames.get_frame_count("walk"),9)
 assert_eq(frames.get_animation_speed("walk"),9.0)
 assert_eq(frames.get_frame_count("idle"),1)
 for view in ["walk","walk_down","walk_up","walk_diag_down","walk_diag_up"]:
  assert_eq(frames.get_frame_count(view),9)
  assert_eq(frames.get_animation_speed(view),9.0)
 for i in 9:assert_eq(frames.get_frame_texture("walk",i).get_size(),Vector2(96,96))
func test_rider_always_uses_nine_frames()->void:
 var frames:=SpriteFrames.new();frames.add_animation("walk_side")
 frames.add_frame("walk_side",load("res://art/experimental/pixellab/rider/side/frame_00.png"))
 PixelLabTrial.apply(frames,"rider","walk_side")
 assert_eq(frames.get_frame_count("walk_side"),9)
 PixelLabTrial.apply(frames,"rider","walk_side")
 assert_eq(frames.get_frame_count("walk_side"),9)
func after_all()->void:
 pass

func test_world_and_level_rider_both_use_shared_trial()->void:

 SaveData.horse_collection.seed_trial()
 var world_rider:Node2D=load("res://src/Presentation/world_player.gd").new();add_child_autofree(world_rider)
 assert_eq(world_rider._sprite_swap._frames.get_frame_count("walk_side"),9)
 var rider:Node2D=load("res://src/Presentation/level_0.tscn").instantiate()
 add_child_autofree(rider)
 assert_eq(rider.player._sprite_swap._frames.get_frame_count("walk_side"),9)
