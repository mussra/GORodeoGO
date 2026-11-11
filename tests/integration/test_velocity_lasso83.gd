extends GutTest
func after_each():Engine.time_scale=1.0
func test_world_and_level_lasso_inherit_velocity_normal_and_bullet_time():
 SaveData.horse_collection.seed_trial()
 for world_mode in [true,false]:
  var actor:Node
  if world_mode:actor=load("res://src/Presentation/world_player.gd").new()
  else:
   var level=load("res://src/Presentation/level_0.tscn").instantiate();actor=level.get_node("Player").duplicate();level.free()
  add_child(actor);actor.set_physics_process(false);actor.set_process(false)
  for slow in [1.0,.24]:
   Engine.time_scale=slow
   actor.global_position=Vector2(100,100);actor.velocity=Vector2(500,80)
   var lasso=actor.lasso
   lasso.throw_guard=func():return true
   lasso.lasso_travel_time=.2
   var target=Vector2(100,100)+Vector2(120,0)+actor.velocity*.2
   var pig=load("res://src/Presentation/wild_pig.gd").new();pig.setup({"pos":target});add_child(pig);pig.global_position=target;pig.set_process(false)
   lasso.prey_provider=func():return [pig]
   var hits=[];var receiver=func(prey):hits.append(prey)
   lasso.prey_captured.connect(receiver)
   lasso.aim_direction=Vector2.RIGHT;lasso._charge_distance=120;lasso._release_throw()
   var rope=lasso._flight_line
   assert_lt(rope.landing.distance_to(target),.001)
   await wait_seconds(.05)
   assert_true(lasso.is_in_flight())
   var p=rope.progress;actor.global_position=Vector2(100,100)+actor.velocity*.2*p
   var tip=rope.start.lerp(rope.landing,p)
   assert_gt(tip.x,actor.position.x,"forward lasso stays ahead even at500px/s")
   await wait_seconds(.25)
   assert_false(lasso.is_in_flight());assert_eq(hits.size(),1)
   lasso.prey_captured.disconnect(receiver);pig.free()
  actor.free()
