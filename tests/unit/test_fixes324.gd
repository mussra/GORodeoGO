extends GutTest
func test_pig_and_goat_capture_on_the_exact_exhaustion_tick():
 for goat in [false,true]:
  for delta in [.001,1./60.,.1,1.]:
   var state=WorldGoats.new_state() if goat else WorldPigs.new_chase_state()
   state.run=AnimalFatigue.RUN_SECONDS-delta*AnimalFatigue.ROPED_MULTIPLIER*.5
   state=WorldGoats.tick(state,100.,true,delta) if goat else WorldPigs.chase_tick(state,100.,260.,true,delta)
   assert_true(state.tired);assert_false(state.flee);assert_eq(state.progress,1.0)
func test_already_tired_animal_needs_no_extra_hold_timer():
 for goat in [false,true]:
  var state=WorldGoats.new_state() if goat else WorldPigs.new_chase_state()
  state.tired=true
  state=WorldGoats.tick(state,100.,true,.0001) if goat else WorldPigs.chase_tick(state,100.,260.,true,.0001)
  assert_eq(state.progress,1.0)
func test_rope_break_and_goat_contact_still_win():
 for goat in [false,true]:
  var state=WorldGoats.new_state() if goat else WorldPigs.new_chase_state()
  state.run=AnimalFatigue.RUN_SECONDS-.0001
  state=WorldGoats.tick(state,241.,true,.1) if goat else WorldPigs.chase_tick(state,241.,260.,true,.1)
  assert_true(state.break_rope);assert_eq(state.progress,0.0)
 var state=WorldGoats.new_state();state.run=AnimalFatigue.RUN_SECONDS-.0001
 state=WorldGoats.tick(state,40.,true,.1)
 assert_true(state.contact);assert_true(state.break_rope);assert_eq(state.progress,0.0)
func test_unroped_animals_do_not_capture_themselves():
 for goat in [false,true]:
  var state=WorldGoats.new_state() if goat else WorldPigs.new_chase_state()
  state.tired=true
  state=WorldGoats.tick(state,100.,false,.01) if goat else WorldPigs.chase_tick(state,100.,260.,false,.01)
  assert_eq(state.progress,0.0)
func test_both_riders_no_longer_draw_the_overhead_bar():
 for path in ['res://src/Presentation/player.gd','res://src/Presentation/world_player.gd']:
  var code=FileAccess.get_file_as_string(path)
  assert_false(code.contains('DodgeVisuals.draw_recharge('))
func test_portrait_has_full_hooves_and_aligned_masks():
 var art=HorsePortrait.ART
 assert_eq(art.get_size(),Vector2(936,1036))
 for texture in [HorsePortrait.MASK,HorsePortrait.EYES,HorsePortrait.LOWER_LEGS,HorsePortrait.LIGHT_LEGS]:
  assert_eq(texture.get_size(),art.get_size())
