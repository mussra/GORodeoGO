extends GutTest
var scene:Node
func after_each():
 if is_instance_valid(scene):scene.free()
 Engine.time_scale=1.;get_tree().paused=false
func make_mode(mode:String):
 RaceCourse190.start_selected=true
 scene=load("res://src/Presentation/"+mode+".tscn").instantiate();add_child(scene)
 await wait_physics_frames(2)
 scene.countdown=0.;scene.running=true;scene.set_physics_process(false)
 for r in scene.riders:r.set_physics_process(false)
func test_launched_rope_does_not_trigger_or_advance_sprint_in_race_or_duel():
 for mode in ["race190","duel193"]:
  await make_mode(mode)
  var a=scene.player;var bot=scene.riders[1]
  a.position=Vector2.ZERO;bot.position=Vector2(150,0);bot.sprint_plan204=4.
  a.lasso.aim_direction=Vector2.RIGHT;a.lasso._start_charging();a.lasso._charge_distance=150.;a.lasso._release_throw()
  assert_true(a.lasso.is_in_flight())
  bot._evade();bot._plan_sprint204(.1)
  assert_eq(bot.dodge.remaining,0.);assert_true(bot.dodge.path.is_empty())
  assert_almost_eq(bot.sprint_plan204,3.9,.0001)
  scene.free();scene=null
func test_independent_duel_plan_sprints_when_due_even_without_rope():
 await make_mode("duel193")
 var bot=scene.riders[1];bot.set_physics_process(true);bot.sprint_plan204=.02
 assert_false(scene.player.lasso.is_in_flight())
 bot._plan_sprint204(.03)
 assert_gt(bot.dodge.remaining,0.)
 assert_gte(bot.sprint_plan204,6.5)
func test_well_placed_actual_rope_captures_without_reflex_sprint():
 await make_mode("duel193")
 var a=scene.player;var bot=scene.riders[1]
 a.position=Vector2.ZERO;bot.position=Vector2(150,0);bot.sprint_plan204=4.
 a.lasso.aim_direction=Vector2.RIGHT;a.lasso._start_charging();a.lasso._charge_distance=150.;a.lasso._release_throw()
 for i in 45:
  bot._plan_sprint204(1./60.)
  await wait_physics_frames(1)
 assert_true(scene.pending.has(0),"well aimed real flight captures before independent plan")
 assert_eq(bot.dodge.remaining,0.)
