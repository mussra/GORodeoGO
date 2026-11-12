extends GutTest
func test_slow_approach_alerts_but_can_aim_and_close_or_fast_flees():
 var slow=WorldTaming.new_state();var fast=slow.duplicate();var close=slow.duplicate()
 for i in 60:
  slow=WorldAwareness110.tick(slow,150.,70.,false,.016)
  fast=WorldAwareness110.tick(fast,250.,260.,false,.016)
  close=WorldAwareness110.tick(close,60.,70.,false,.016)
 assert_true(slow.alert110);assert_eq(slow.spook,0.);assert_gt(fast.spook,0.);assert_gt(close.spook,0.)
func test_cover_substantially_reduces_notice_but_contact_still_alerts():
 var covered=WorldAwareness110.tick(WorldTaming.new_state(),150.,70.,true,1.)
 var open_=WorldAwareness110.tick(WorldTaming.new_state(),150.,70.,false,1.)
 assert_false(covered.alert110);assert_true(open_.alert110)
 assert_gt(WorldAwareness110.tick(WorldTaming.new_state(),35.,70.,true,1.).spook,0.)
 var index=WorldAwareness110.build_index({"tree":[Rect2(40,-20,30,40)],"far":[Rect2(400,400,50,60)]})
 assert_true(WorldAwareness110.covered(index,Vector2.ZERO,Vector2(100,0)))
 assert_false(WorldAwareness110.covered(index,Vector2.ZERO,Vector2(0,100)))
func test_detection_is_deterministic_not_random_capture_failure():
 for speed in [0.,70.,260.]:
  for distance in [40.,100.,150.,250.,400.]:
   var a=WorldAwareness110.tick(WorldTaming.new_state(),distance,speed,false,1.)
   assert_eq(a,WorldAwareness110.tick(WorldTaming.new_state(),distance,speed,false,1.))
