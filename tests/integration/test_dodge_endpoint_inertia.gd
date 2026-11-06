extends GutTest
func after_each()->void:
 for a in ["move_left","move_right","move_up","move_down"]:Input.action_release(a)
func player()->Node:
 var source:Node=load("res://src/Presentation/level_0.tscn").instantiate();var p:Node=source.get_node("Player").duplicate();source.free();add_child_autofree(p);await wait_physics_frames(1);p.set_physics_process(false);p.dodge_available=true;return p
func test_trace_endpoint_brakes_and_turns_with_handling_for_both_whips()->void:
 for reach in [260.0,420.0]:
  for handling in [600.0,1500.0]:
   var p:Node=await player();p.acceleration=handling;p.dodge_path_limit=reach;p.global_position=Vector2.ZERO
   assert_true(p.request_dodge_path(PackedVector2Array([Vector2.ZERO,Vector2(110,0)])))
   for i in range(100):
    p._physics_process(1.0/60)
    if p._dodge_path.is_empty():break
   assert_gt(p.velocity.x,0);assert_eq(p._run_after_dodge,Vector2.ZERO)
   var endpoint:Vector2=p.global_position;p._physics_process(1.0/60);assert_gt(p.velocity.x,0,"gradual brake, not instant stop")
   for i in range(180):p._physics_process(1.0/60)
   assert_almost_eq(p.velocity.length(),0.0,.01);assert_lt(p.global_position.distance_to(endpoint),100.0,"no infinite cruise")
   p._dodge_direction=Vector2.RIGHT;Input.action_press("move_left");p._resume_running_after_dodge();assert_gt(p.velocity.x,0,"new opposite input cannot replace tangent")
   p._physics_process(1.0/60);assert_gt(p.velocity.x,0);assert_almost_eq(p.velocity.x,p.max_speed-handling/60.0,.02)
   Input.action_release("move_left")
func test_endpoint_at_world_boundary_stays_bounded()->void:
 var p:Node=await player();p.global_position=p.world_bounds.end-Vector2(2,2);p._dodge_direction=Vector2.RIGHT;p._resume_running_after_dodge()
 for i in range(120):p._physics_process(1.0/60)
 assert_lte(p.global_position.x,p.world_bounds.end.x);assert_almost_eq(p.velocity.length(),0.0,.01)
func test_lasso_edge_on_ellipse_for_all_directions_and_near_zero()->void:
 for offset in [Vector2(180,0),Vector2(-180,0),Vector2(0,180),Vector2(0,-180),Vector2(1,1),Vector2.ZERO]:
  var edge:Vector2=LassoRope.loop_edge(Vector2.ZERO,offset)
  assert_almost_eq(edge.x*edge.x/484.0+edge.y*edge.y/121.0,1.0,.0001)
  assert_true(is_finite(edge.x) and is_finite(edge.y))
