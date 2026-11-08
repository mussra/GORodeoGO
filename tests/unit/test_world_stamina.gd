extends GutTest
## Horse stamina (Ant 11:39): gallop drains, trot sips, walk/idle recover,
## empty forces a gentle breather, no punishment, one knob file.

func test_gallop_drains_trot_sips():
 var st:=WorldStamina.new_state()
 var after_gal:=WorldStamina.tick(st,WorldGait.GALOPE,true,1.0)
 assert_true(float(after_gal.value)<float(st.value)-3.0 and float(after_gal.value)>float(st.value)-5.0)
 var after_tro:=WorldStamina.tick(st,WorldGait.TROTE,true,1.0)
 assert_true(float(after_tro.value)<float(st.value) and float(after_tro.value)>float(st.value)-3.5)

## Ant (8-nov-2026): long trips - the worst horse lasts DOUBLE what it did.
func test_worst_horse_lasts_double():
 var worst:float=WorldStamina.max_for(0.0)
 var seconds_now:float=worst/(WorldStamina.DRAIN_GALOPE/WorldStamina.ENDURANCE_MULT)
 var seconds_before:float=worst/WorldStamina.DRAIN_GALOPE
 assert_almost_eq(seconds_now,seconds_before*WorldStamina.ENDURANCE_MULT,0.01)
 assert_eq(WorldStamina.ENDURANCE_MULT,2.0)
 var st:Dictionary={"value":worst,"max":worst,"forced_left":0.0}
 var t:float=0.0
 while float(st.value)>0.0 and t<seconds_now+5.0:
  st=WorldStamina.tick(st,WorldGait.GALOPE,true,0.5);t+=0.5
 assert_true(t>=seconds_now)  # really endures the full doubled time

func test_walk_and_idle_recover():
 var st:Dictionary={"value":20.0,"max":100.0,"forced_left":0.0}
 assert_gt(float(WorldStamina.tick(st,WorldGait.PASO,true,1.0).value),20.0)
 assert_gt(float(WorldStamina.tick(st,WorldGait.PASO,false,1.0).value),float(WorldStamina.tick(st,WorldGait.PASO,true,1.0).value))

func test_empty_forces_a_breather_then_recovers():
 var st:Dictionary={"value":1.0,"max":100.0,"forced_left":0.0}
 var before:=WorldStamina.tick(st,WorldGait.GALOPE,true,1.0)
 assert_eq(WorldStamina.cap_gait(before,WorldGait.GALOPE),WorldGait.PASO)
 assert_true(WorldStamina.just_tired(st,before))
 var t:float=0.0
 while float(before.forced_left)>0.0 and t<WorldStamina.FORCE_PASO_SECONDS+1.0:
  before=WorldStamina.tick(before,WorldGait.PASO,true,0.5)
  t+=0.5
 assert_gt(float(before.value),0.0)  # it rested, nothing broke

func test_galope_blocked_below_min_but_trot_allowed():
 var st:Dictionary={"value":WorldStamina.GALOPE_MIN-1.0,"max":100.0,"forced_left":0.0}
 assert_eq(WorldStamina.cap_gait(st,WorldGait.GALOPE),WorldGait.TROTE)
 assert_eq(WorldStamina.cap_gait(st,WorldGait.TROTE),WorldGait.TROTE)

func test_better_horse_lasts_longer_and_never_below_base():
 assert_gt(WorldStamina.max_for(1.0),WorldStamina.MAX)
 assert_lt(WorldStamina.max_for(0.0),WorldStamina.MAX)
 assert_gt(WorldStamina.max_for(0.0),WorldStamina.MAX*0.8)
