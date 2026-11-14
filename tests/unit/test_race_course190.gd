extends GutTest
var course:RaceCourse190
func before_each():course=RaceCourse190.new()
func test_closed_track_and_distance_projection()->void:
 assert_eq(course.points[0],course.points[-1])
 assert_gt(course.length,11000.)
 assert_lt(course.length,13000.)
 for i in 32:
  var s:float=course.length*(i+.3)/32.
  assert_almost_eq(course.project(course.at(s)).s,s,.1)
func test_corridor_limits_both_sides_and_keeps_valid_positions()->void:
 for i in 32:
  var s:float=course.length*i/32.;var p:Vector2=course.at(s);var side:Vector2=course.tangent(s).orthogonal()
  for direction in [-1.,1.]:
   var inside:Vector2=p+side*direction*80.
   assert_lt(course.constrain(inside).distance_to(inside),.1)
   var clipped:Vector2=course.constrain(p+side*direction*600.)
   assert_lte(course.project(clipped).distance,RaceCourse190.WIDTH*.5-17.)
func test_gates_require_forward_crossing_within_corridor()->void:
 for gate in range(1,17):
  var s:float=course.length*gate/16.;var p:Vector2=course.at(s);var forward:Vector2=course.tangent(s);var side:Vector2=forward.orthogonal()
  assert_true(course.crossed_gate(p-forward*10.,p+forward*10.,gate))
  assert_false(course.crossed_gate(p+forward*10.,p-forward*10.,gate))
  assert_false(course.crossed_gate(p-forward*10.+side*300.,p+forward*10.+side*300.,gate))
  assert_false(course.crossed_gate(p-forward*400.,p+forward*10.,gate))
func test_shortcut_or_wrong_gate_cannot_improve_progress()->void:
 var at_finish:Vector2=course.at(course.length-20.)
 assert_lte(course.score(at_finish,1),course.length/16.)
 assert_eq(course.score(Vector2.ZERO,17),course.length)
 assert_false(course.crossed_gate(course.at(10),course.at(course.length*.5),1))
func test_three_courses_are_distinct_closed_and_nonjumpers_have_a_route()->void:
 var previous:PackedVector2Array=PackedVector2Array()
 for index in 3:
  var c:=RaceCourse190.new(index)
  assert_eq(c.points[0],c.points[-1])
  if not previous.is_empty():assert_ne(c.points,previous)
  previous=c.points
  for fence in c.fences:
   assert_eq(c.ai_lane(fence-100.,-80.,false),132.)
   assert_eq(c.ai_lane(fence-100.,-80.,true),-80.)
   var opening:Vector2=c.at(fence)+c.tangent(fence).orthogonal()*132.
   assert_lt(c.constrain(opening).distance_to(opening),1.)
