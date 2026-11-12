extends GutTest
func test_random_wait_range_gesture_cycle_and_immediate_motion_reset():
 var rest=HorseRest107.new()
 var waits:Dictionary={}
 for i in 100:
  rest.reset();assert_between(rest.wait,5.,10.);waits[rest.wait]=true
  assert_eq(rest.step(rest.wait-.01,false),0);assert_eq(rest.step(.6,false),1)
  assert_eq(rest.step(0.,true),0);assert_eq(rest.elapsed,0.)
 assert_gt(waits.size(),1)
func test_mounted_idle_uses_drink_rest_and_moving_frames_are_unmodified():
 var frames=SpriteFrames.new();var traits={"coat":10,"pattern":0,"mane":1}
 PixelLabTrial.apply(frames,"rider","walk_side",traits)
 assert_eq(frames.get_frame_count("walk_side"),9);assert_eq(frames.get_frame_texture("walk_side",0),PixelLabTrial.pose_texture("rider","side",0,traits))
 assert_eq(frames.get_frame_texture("idle",0),HorseRest107.texture(0,traits));assert_eq(frames.get_frame_texture("rest_gesture107",0),HorseRest107.texture(1,traits))
 var host=Node2D.new();add_child_autofree(host);var placeholder=Polygon2D.new();host.add_child(placeholder)
 var swap=SpriteSwap.from_frames(host,placeholder,frames);var before:Vector2=swap._sprite.offset
 RiderGaitVisual.apply(swap,Vector2.ZERO,270,0,.1);assert_eq(swap._sprite.animation,"idle");assert_eq(swap._sprite.offset.x,before.x-8.)
 RiderGaitVisual.apply(swap,Vector2.RIGHT*180.,270,1,.1);assert_eq(swap._sprite.animation,"walk_side");assert_eq(swap._sprite.offset,before)

func test_sixty_seconds_cycles_have_new_waits_and_motion_always_interrupts():
 var rest=HorseRest107.new();var previous:float=0.;var resets:int=0;var gestures:int=0
 for tick in 600:
  var pose:int=rest.step(.1,false)
  if pose==1:gestures+=1
  if rest.elapsed<previous:resets+=1;assert_between(rest.wait,5.,10.)
  previous=rest.elapsed
 assert_between(resets,4,8);assert_gt(gestures,0)
 assert_eq(rest.step(.1,true),0);assert_eq(rest.elapsed,0.)
