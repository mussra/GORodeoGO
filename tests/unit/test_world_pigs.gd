extends GutTest
## Wild pig capture (Ant: cerdos capturables, 7-nov-2026): slow and close fills,
## rushing scatters and drains, capture at full progress.

func test_slow_and_close_captures():
 var st:=WorldPigs.new_state()
 for i in 200:
  st=WorldPigs.tick(st,60.0,20.0,0.05)
 assert_true(WorldPigs.captured(st))

func test_fast_nearby_scatters_and_drains():
 var st:Dictionary={"progress":0.6,"flee":false}
 st=WorldPigs.tick(st,80.0,300.0,0.1)
 assert_true(st.flee)
 assert_lt(float(st.progress),0.6)

func test_far_or_idle_does_nothing():
 var st:=WorldPigs.new_state()
 st=WorldPigs.tick(st,900.0,0.0,1.0)
 assert_eq(float(st.progress),0.0)
 st=WorldPigs.tick(st,60.0,90.0,0.1)  # between STILL and SAFE: no fill, no flee
 assert_eq(float(st.progress),0.0)
 assert_false(st.flee)

func test_progress_never_negative():
 var st:Dictionary={"progress":0.05,"flee":false}
 st=WorldPigs.tick(st,50.0,400.0,1.0)
 assert_eq(float(st.progress),0.0)

## Chase mode (Ant 8-nov-2026): pigs flee, the rider chases and ropes them,
## standing still snaps the rope, the pig tires after a long run and only
## then the capture fills.

func test_chase_pig_flees_when_rider_close():
 var st:=WorldPigs.new_chase_state()
 st=WorldPigs.chase_tick(st,200.0,260.0,false,0.1)
 assert_true(st.flee)
 st=WorldPigs.chase_tick(st,600.0,260.0,false,0.1)
 assert_false(st.flee)

func test_chase_running_tires_the_pig():
 var st:=WorldPigs.new_chase_state()
 for i in int(WorldPigs.CHASE_TIRE_SECONDS/0.1)+2:
  st=WorldPigs.chase_tick(st,100.0,260.0,false,0.1)
 assert_true(st.tired)
 assert_false(st.flee)

func test_chase_roped_runs_even_far_and_tires_faster():
 var st:=WorldPigs.new_chase_state()
 st=WorldPigs.chase_tick(st,600.0,260.0,true,0.1)
 assert_true(st.flee)  # roped drags no matter the distance
 var t:float=0.0
 while not bool(st.tired) and t<WorldPigs.CHASE_TIRE_SECONDS:
  st=WorldPigs.chase_tick(st,600.0,260.0,true,0.1);t+=0.1
 assert_lt(t,WorldPigs.CHASE_TIRE_SECONDS)  # roped tires before the plain budget

func test_chase_standing_still_breaks_the_rope():
 var st:=WorldPigs.new_chase_state()
 var broke:float=-1.0;var t:float=0.0
 while t<2.0:
  st=WorldPigs.chase_tick(st,100.0,0.0,true,0.1)
  if st.break_rope:broke=t;break
  t+=0.1
 assert_true(broke>=0.0 and broke<=WorldPigs.CHASE_ROPE_BREAK_STILL_SECONDS+0.2)
 var after:=WorldPigs.after_rope_break(st)
 assert_gt(float(after.run),0.0)  # keeps its fatigue
 assert_false(bool(after.tired))
 assert_true(after.flee)

func test_chase_moving_keeps_the_rope():
 var st:=WorldPigs.new_chase_state()
 for i in 30:
  st=WorldPigs.chase_tick(st,100.0,200.0,true,0.1)
  assert_false(st.break_rope)

func test_chase_tired_and_roped_captures_fast():
 var st:Dictionary=WorldPigs.new_chase_state();st.tired=true
 var t:float=0.0
 while not WorldPigs.captured(st) and t<3.0:
  st=WorldPigs.chase_tick(st,50.0,150.0,true,0.1);t+=0.1
 assert_true(WorldPigs.captured(st))
 assert_lt(t,2.0)

func test_chase_tired_unroped_recovers():
 var st:Dictionary=WorldPigs.new_chase_state();st.tired=true
 for i in int(WorldPigs.CHASE_RECOVER_SECONDS/0.1)+2:
  st=WorldPigs.chase_tick(st,600.0,0.0,false,0.1)
 assert_false(st.tired)
 assert_gt(float(st.run),0.0)  # partially rested, not fresh
