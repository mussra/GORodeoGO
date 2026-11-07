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
