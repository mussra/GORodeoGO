extends GutTest
func test_trial_replaces_only_lateral_and_idle_without_touching_genes()->void:
 PixelLabTrial.initialized=true;PixelLabTrial.enabled=true
 var frames:=SpriteFrames.new();frames.add_animation("walk_up")
 var original:Texture2D=load("res://art/world/wild_base/walk_up/frame_00.png")
 frames.add_frame("walk_up",original)
 PixelLabTrial.apply(frames,"horse","walk")
 assert_eq(frames.get_frame_count("walk"),9)
 assert_eq(frames.get_animation_speed("walk"),9.0)
 assert_eq(frames.get_frame_count("idle"),1)
 assert_eq(frames.get_frame_texture("walk_up",0),original)
 for i in 9:assert_eq(frames.get_frame_texture("walk",i).get_size(),Vector2(96,96))
func test_disabled_preserves_original_and_rider_uses_nine_frames()->void:
 var frames:=SpriteFrames.new();frames.add_animation("walk_side")
 frames.add_frame("walk_side",load("res://art/player/walk_side/frame_00.png"))
 PixelLabTrial.enabled=false;PixelLabTrial.apply(frames,"rider","walk_side")
 assert_eq(frames.get_frame_count("walk_side"),1)
 PixelLabTrial.enabled=true;PixelLabTrial.apply(frames,"rider","walk_side")
 assert_eq(frames.get_frame_count("walk_side"),9)
func after_all()->void:
 PixelLabTrial.initialized=false
func test_world_and_level_rider_both_use_shared_trial()->void:
 PixelLabTrial.initialized=true;PixelLabTrial.enabled=true
 SaveData.horse_collection.seed_trial()
 var world_rider:Node2D=load("res://src/Presentation/world_player.gd").new();add_child_autofree(world_rider)
 assert_eq(world_rider._sprite_swap._frames.get_frame_count("walk_side"),9)
 var rider:Node2D=load("res://src/Presentation/level_0.tscn").instantiate()
 add_child_autofree(rider)
 assert_eq(rider.player._sprite_swap._frames.get_frame_count("walk_side"),9)
