extends GutTest
func test_goat_keeps_fleeing_at_home_boundary_after_fast_approach():
 var goat=load("res://src/Presentation/wild_goat.gd").new();goat.setup({"pos":Vector2.ZERO});add_child_autofree(goat)
 goat.position=Vector2(549,0);var before:Vector2=goat.position
 goat.move_from_or_towards(Vector2(480,0),.1,false)
 assert_gt(goat.position.distance_to(before),5.0,"Una cabra en el borde debe girar, no congelarse")
 assert_lte(goat.position.length(),550.01)
 assert_gt(goat.position.distance_to(Vector2(480,0)),before.distance_to(Vector2(480,0)))
func test_pig_keeps_fleeing_at_home_boundary():
 var pig=load("res://src/Presentation/wild_pig.gd").new();pig.setup({"pos":Vector2.ZERO});add_child_autofree(pig)
 pig.position=Vector2(419,0);var before:Vector2=pig.position
 pig.flee_from(Vector2(350,0),.1,WorldPigs.CHASE_FLEE_SPEED)
 assert_gt(pig.position.distance_to(before),5.0,"Un cerdo en el borde debe girar, no congelarse")
 assert_lte(pig.position.length(),WorldPigs.FLEE_LEASH+.01)
func test_tired_unroped_pig_recovers_and_restarts_repeatedly():
 var st=WorldPigs.new_chase_state()
 for cycle in 3:
  st.run=WorldPigs.CHASE_TIRE_SECONDS-.01
  st=WorldPigs.chase_tick(st,80,700,false,.1)
  assert_true(st.tired);assert_false(st.flee)
  for frame in 51:st=WorldPigs.chase_tick(st,80,0,false,.1)
  assert_false(st.tired);assert_true(st.flee,"Recupera aunque el jinete siga cerca y quieto")
func test_roped_tired_pig_still_requires_chase_and_capture():
 var st=WorldPigs.new_chase_state();st.tired=true
 st=WorldPigs.begin_rope(st)
 assert_true(st.tired);assert_eq(st.progress,0.0);assert_eq(st.rope_run,0.0)
 for frame in 65:st=WorldPigs.chase_tick(st,100,260,true,.1)
 assert_true(st.tired);assert_true(WorldPigs.captured(st))
func test_shared_motion_preserves_open_movement_and_bounds_for_many_steps():
 var pos=Vector2(549,0);var home=Vector2.ZERO
 for i in 240:
  var threat=pos-Vector2(80,0);var before=pos
  pos=WorldEscapeMotion.bounded_step(pos,home,threat,Vector2(20,0),550)
  assert_gt(pos.distance_to(before),4.0);assert_lte(pos.length(),550.01)
 assert_eq(WorldEscapeMotion.bounded_step(Vector2.ZERO,home,Vector2.LEFT,Vector2(10,2),550),Vector2(10,2))
func test_rope_charge_is_not_replaced_by_flee_steering():
 var goat=load("res://src/Presentation/wild_goat.gd").new();goat.setup({"pos":Vector2.ZERO});add_child_autofree(goat)
 goat.position=Vector2(549,0);goat.move_from_or_towards(Vector2(700,0),.1,true)
 assert_gt(goat.position.x,550.0,"La cabra enlazada todavía carga hacia el jinete")
func test_wild_horse_does_not_freeze_at_home_leash():
 var horse=load("res://src/Presentation/wild_horse.gd").new();horse.setup({"pos":Vector2.ZERO,"traits":{"coat":6,"pattern":0,"mane":0}});add_child_autofree(horse)
 horse.set_physics_process(false);horse.position=Vector2(609,0);horse.flee_from(Vector2(530,0),.1)
 var start:Vector2=horse.position;horse._physics_process(.1)
 assert_gt(horse.position.distance_to(start),.5);assert_gt(horse.velocity.length(),50.0);assert_lte(horse.position.length(),WorldTaming.FLEE_LEASH+.01)
func test_pig_and_goat_share_visible_energy_exhaustion_capture_and_recovery():
 for goat in [false,true]:
  var st=WorldGoats.new_state() if goat else WorldPigs.new_chase_state();var previous=1.0
  for frame in 69:
   st=WorldGoats.tick(st,100,false,.1) if goat else WorldPigs.chase_tick(st,100,260,false,.1)
   assert_false(st.tired);var energy=AnimalFatigue.energy(st);assert_lt(energy,previous);previous=energy
  st=WorldGoats.tick(st,100,false,.1) if goat else WorldPigs.chase_tick(st,100,260,false,.1)
  assert_true(st.tired);assert_eq(AnimalFatigue.energy(st),0.0)
  var held=st.duplicate(true)
  held=WorldGoats.tick(held,100,true,.9) if goat else WorldPigs.chase_tick(held,100,260,true,.9)
  assert_lt(held.progress,1.0)
  held=WorldGoats.tick(held,100,true,.1) if goat else WorldPigs.chase_tick(held,100,260,true,.1)
  assert_eq(held.progress,1.0)
  for frame in 50:st=WorldGoats.tick(st,100,false,.1) if goat else WorldPigs.chase_tick(st,100,260,false,.1)
  assert_false(st.tired);assert_gt(AnimalFatigue.energy(st),.5);assert_true(st.flee)
