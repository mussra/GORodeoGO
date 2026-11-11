extends GutTest
func test_inherits_velocity_in_any_direction_and_time_scale():
 for time_scale in [1.0,.24]:
  for velocity in [Vector2.ZERO,Vector2(260,0),Vector2(-180,90),Vector2(400,400)]:
   for aim in [Vector2.RIGHT,Vector2.LEFT,Vector2.DOWN]:
    var origin=Vector2(100,200);var travel=.8
    var target=LassoController.inherited_landing(origin,aim,220,velocity,travel)
    assert_lt(target.distance_to(origin+aim*220+velocity*travel),.001)
    for fraction in [.1,.5,1.0]:
     var wall_time=travel*fraction/time_scale
     var rider=origin+velocity*wall_time*time_scale
     var tip=origin.lerp(target,fraction)
     assert_lt((tip-rider).distance_to(aim*220*fraction),.001)
func test_pig_goat_free_chase_never_drains_and_recovers_immediately():
 for goat in [false,true]:
  var st=WorldGoats.new_state() if goat else WorldPigs.new_chase_state()
  for i in 200:
   st=WorldGoats.tick(st,100,false,.1) if goat else WorldPigs.chase_tick(st,100,260,false,.1)
   assert_false(st.tired);assert_eq(AnimalFatigue.energy(st),1.0)
  st.run=5.0
  var energy=AnimalFatigue.energy(st)
  st=WorldGoats.tick(st,100,false,.01) if goat else WorldPigs.chase_tick(st,100,260,false,.01)
  assert_gt(AnimalFatigue.energy(st),energy)
  st.run=5.0;energy=AnimalFatigue.energy(st)
  st=WorldGoats.tick(st,241,true,.01) if goat else WorldPigs.chase_tick(st,241,260,true,.01)
  assert_true(st.break_rope);assert_gt(AnimalFatigue.energy(st),energy)
  st.tired=true;st.run=7.0;st.rest=0.0
  st=WorldGoats.tick(st,241,true,.01) if goat else WorldPigs.chase_tick(st,241,260,true,.01)
  assert_true(st.break_rope);assert_gt(AnimalFatigue.energy(st),0.0)
func test_charge_visual_projects_the_same_inherited_landing():
 var host=Node2D.new();add_child_autofree(host)
 var lasso=LassoController.new();host.add_child(lasso)
 lasso.rider_velocity=func():return Vector2(260,40)
 lasso.aim_direction=Vector2.RIGHT;lasso._charge_distance=120
 lasso._charge_visual=Line2D.new();lasso.add_child(lasso._charge_visual)
 lasso._update_charge_visual()
 var expected=LassoController.inherited_landing(Vector2.ZERO,Vector2.RIGHT,120,Vector2(260,40),lasso.lasso_travel_time)
 assert_lt(lasso._charge_visual.points[1].distance_to(expected),.001)
