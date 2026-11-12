extends GutTest
func test_exact_sectors_and_epsilon_jitter_retain_previous_pose():
 for previous in ["side","diag_up","diag_down","up","down"]:
  for boundary in [atan2(1.,1.6),atan2(1.,.45)]:
   for sign_ in [-1.,1.]:
    var current:String=previous
    var changes:int=0
    for i in 120:
     var motion=Vector2.from_angle(sign_*(boundary+(.000001 if i%2==0 else -.000001)))*260.
     var next=WildHeading129.view(motion,current)
     if next!=current:changes+=1
     current=next
    assert_lte(changes,1,"no boundary oscillation "+previous)
func test_horizontal_sign_jitter_and_exact_flip_deadzone():
 for original in [false,true]:
  for x in [-.000001,0.,.000001,-.18,.18]:
   var motion=Vector2(x,sqrt(1.-x*x))*260.
   assert_eq(WildHeading129.flip(motion,original),original)
 assert_true(WildHeading129.flip(Vector2(-100,200),false))
 assert_false(WildHeading129.flip(Vector2(100,200),true))
func test_zero_motion_and_minimum_boundary():
 assert_eq(WildHeading129.view(Vector2.ZERO,"up"),"up")
 assert_eq(WildHeading129.view(Vector2(11.999,0),"up"),"up")
 assert_eq(WildHeading129.view(Vector2(12,0),"up"),"side")
 assert_eq(WildHeading129.steer(Vector2.ZERO,Vector2.LEFT*230,.016),Vector2.LEFT*230)
func test_bounded_turn_speed_even_on_reversal_and_frame_rate():
 for hz in [30,60,120]:
  var current=Vector2.RIGHT*260.
  for i in hz:
   var next=WildHeading129.steer(current,Vector2.LEFT*260.,1./hz)
   assert_lte(absf(angle_difference(current.angle(),next.angle())),WildHeading129.TURN_RATE/hz+.00001)
   assert_almost_eq(next.length(),260.,.001)
   current=next
  assert_lt(current.distance_to(Vector2.LEFT*260.),.01,"turn completes instead of locking")
