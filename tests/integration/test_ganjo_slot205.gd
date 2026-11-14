extends GutTest
func test_missing_art_stays_hidden_and_cannot_change_gameplay():
 var slot:=GanjoMusician205.new();add_child_autofree(slot)
 assert_false(slot.art_ready);assert_false(slot.visible)
 assert_eq(slot.get_child_count(),1)
 assert_true(slot.get_child(0) is AnimatedSprite2D)
 assert_eq(slot.find_children("*","CollisionObject2D").size(),0)
func test_supplied_play_frames_enable_preview_only():
 var slot:=GanjoMusician205.new();add_child_autofree(slot)
 var frames:=SpriteFrames.new();frames.add_animation("play")
 var image:=Image.create(16,32,false,Image.FORMAT_RGBA8);image.fill(Color.WHITE)
 frames.add_frame("play",ImageTexture.create_from_image(image))
 slot.configure_frames205(frames)
 assert_true(slot.art_ready);assert_true(slot.visible)
 assert_true(slot.get_node("Artist").is_playing())
 slot.configure_frames205(null);assert_false(slot.visible)
func test_track_anchor_is_outside_racing_surface():
 for variant in 4:
  var course:=RaceCourse190.new(variant)
  var at:=GanjoMusician205.beside_race205(course)
  assert_gt(course.project(at).distance,RaceCourse190.WIDTH*.5)
