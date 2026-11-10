extends GutTest
func test_calm_close_without_rope_never_fills_trust():
 var st:=WorldTaming.new_state()
 for i in range(600):
  st=WorldTaming.tick(st,100.0,0.0,1.0,0.5,1.0/60.0)
 assert_eq(st.progress,0.0)
func test_rushing_spooks_and_blocks_progress():
 var st:=WorldTaming.new_state()
 st=WorldTaming.tick(st,100.0,200.0,1.0,0.5,1.0/60.0)
 assert_true(st.spook>0.0)
 var before:float=st.progress
 st=WorldTaming.tick(st,100.0,0.0,1.0,0.5,1.0/60.0)
 assert_true(st.progress<=before+0.001 or st.spook>0.0)
func test_far_or_fast_without_spook_gains_nothing():
 var st:=WorldTaming.new_state()
 st=WorldTaming.tick(st,400.0,0.0,1.0,0.5,1.0)
 assert_eq(st.progress,0.0)
 st=WorldTaming.tick(st,100.0,120.0,1.0,0.5,1.0)
 assert_eq(st.progress,0.0)
func test_serenidad_cannot_bypass_rope():
 var slow:=WorldTaming.new_state();var fast:=WorldTaming.new_state()
 for i in range(120):
  slow=WorldTaming.tick(slow,100.0,0.0,0.5,0.5,1.0/60.0)
  fast=WorldTaming.tick(fast,100.0,0.0,2.0,0.5,1.0/60.0)
 assert_eq(fast.progress,0.0);assert_eq(slow.progress,0.0)
func test_tamed_at_full_progress():
 assert_true(WorldTaming.tamed({"progress":1.0,"spook":0.0}))
 assert_false(WorldTaming.tamed(WorldTaming.new_state()))
