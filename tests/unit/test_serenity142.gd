extends GutTest
func test_bull_base_slow_fast_rates_do_not_mutate_tuning():
 var tuning:=BullTuning.new()
 for pair in [[.5,94.],[1.,88.],[2.,76.]]:
  var bull:=BullController.new(BullState.State.CAPTURED,tuning);bull.update_hold(1.,10.,0.,pair[0]);assert_almost_eq(bull.current_nerves(),pair[1],.0001);assert_eq(bull.current_state(),BullState.State.CALMING)
 assert_eq(tuning.calm_rate_per_second,12.)
func test_bounded_invalid_multiplier_uses_existing_stat_limits():
 for pair in [[-30.,.5],[300.,2.],[NAN,1.],[INF,1.],[-INF,1.],["bad",1.],[true,1.]]:assert_eq(HorseStats.calm_factor(pair[0]),pair[1])
 var c:=HorseCollection.new();c.seed_trial();assert_eq(HorseStats.mounted_calm(c),1.)
 c.find("original")["stats"]={"calm":300.};assert_eq(HorseStats.mounted_calm(c),2.)
func test_disturbances_escape_and_tranquilizer_do_not_gain_immunity():
 var bull:=BullController.new(BullState.State.CAPTURED);bull.update_hold(1.,10.,0.,2.);assert_eq(bull.current_nerves(),76.)
 bull.update_hold(.5,10.,1.,2.);assert_eq(bull.current_nerves(),86.);assert_true(bull.force_escape());assert_eq(bull.current_state(),BullState.State.ESCAPED)
 var tuning:=BullTuning.new();tuning.max_rope_distance=20.
 bull=BullController.new(BullState.State.CAPTURED,tuning);bull.update_hold(5.,50.,0.,2.);assert_eq(bull.current_state(),BullState.State.ESCAPED);assert_eq(bull.current_nerves(),100.)
 bull=BullController.new(BullState.State.CAPTURED);assert_true(bull.use_tranquilizer());assert_eq(bull.current_nerves(),0.)
func test_control_times_scale_but_do_not_become_instant():
 for pair in [[.5,16.7],[1.,8.4],[2.,4.2]]:
  var bull:=BullController.new(BullState.State.CAPTURED);var elapsed:float=0.
  while bull.current_state()!=BullState.State.CONTROLLED and elapsed<30.:bull.update_hold(.1,10.,0.,pair[0]);elapsed+=.1
  assert_almost_eq(elapsed,pair[1],.05)
func test_rope_trust_uses_same_factor_and_keeps_affinity_and_temperament():
 for multiplier in [.5,1.,2.]:
  var st:=WorldTaming.new_state();var out:=WorldTaming.hold_tick(st,.5,.1,1.5,multiplier)
  assert_almost_eq(float(out.progress),.65*.75*.1*1.5*multiplier,.00001);assert_eq(float(st.progress),0.)
func test_unroped_never_gains_trust_even_with_serenity():
 var st:=WorldTaming.new_state()
 for i in 30:st=WorldTaming.tick(st,20.,0.,2.,0.,1.,1.75)
 assert_eq(st.progress,0.);assert_false(WorldTaming.tamed(st))
