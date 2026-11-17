extends GutTest
var host:Node2D
var pig:Node2D
func before_each():
 host=load("res://tests/integration/pigwall_host224.gd").new();add_child(host)
 var ridge:Dictionary=WorldTerrain103.ridge(host.SEED,0,0)
 var p:=Vector2(ridge.boxes[0].end.x+19.,200.)
 pig=load("res://src/Presentation/wild_pig.gd").new();pig.setup({"pos":p});host.add_child(pig);await wait_physics_frames(2)
func after_each():
 host.free();await wait_physics_frames(2)
func test_flee_slides_along_town_wall_without_crossing_or_sticking():
 var start:Vector2=pig.position
 for i in 60:
  pig.flee_from(pig.position+Vector2(100,0),1./60.,225.)
  assert_false(WorldTerrain103.blocked(host.SEED,pig.position,18.))
 assert_gt(pig.position.distance_to(start),80.,"A threatened pig follows the wall, not a stationary running animation")
func test_real_lasso_still_ropes_and_tires_pig_beside_wall():
 var lasso:=LassoController.new();host.add_child(lasso);lasso.prey_provider=func()->Array:return [pig]
 assert_eq(lasso.resolve_capture(pig.global_position),pig)
 pig.roped=true;pig.state=WorldPigs.begin_rope(pig.state)
 for i in 100:
  pig.state=WorldPigs.chase_tick(pig.state,130.,200.,true,.1)
  if pig.state.flee:pig.flee_from(pig.position+Vector2(100,0),.1,225.)
 assert_true(pig.state.tired);assert_true(WorldPigs.captured(pig.state))
func test_fence_block_also_has_a_legal_flee_direction():
 # Far from terrain separators; a physical fence alone should not pin it.
 pig.position=Vector2(100,100);pig.home=pig.position;WorldFence.segment(host,Vector2(95,-200),Vector2(95,400));await wait_physics_frames(2)
 var start:Vector2=pig.position
 for i in 40:pig.flee_from(pig.position+Vector2(100,0),1./60.,225.)
 assert_gt(pig.position.distance_to(start),60.);assert_gt(pig.position.x,95.)
func test_sprite_has_deadzone_and_temporal_hysteresis_near_vertical_motion():
 pig.flip_h=false
 for i in 120:pig._heading249(Vector2(-2. if i%2==0 else 2.,225.),1./60.)
 assert_false(pig.flip_h)
 for i in 4:pig._heading249(Vector2(-225.,0),1./60.)
 assert_false(pig.flip_h)
 for i in 4:pig._heading249(Vector2(-225.,0),1./60.)
 assert_true(pig.flip_h)
func test_jittering_threat_along_wall_keeps_tangent_progress_and_lasso_state():
 var start:Vector2=pig.position;var changes:int=0;var last:bool=pig.flip_h
 for i in 180:
  pig.flee_from(pig.position+Vector2(100,1. if i%2==0 else -1.),1./60.,225.)
  if pig.flip_h!=last:changes+=1;last=pig.flip_h
  assert_false(WorldTerrain103.blocked(host.SEED,pig.position,18.))
 assert_gt(pig.position.distance_to(start),120.)
 assert_lt(changes,8)
 assert_false(pig.roped)
