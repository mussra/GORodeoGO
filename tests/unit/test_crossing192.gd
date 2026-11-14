extends GutTest
func test_crossing_has_two_distinct_route_branches_at_same_point():
 var c:=RaceCourse190.new(3)
 var a:float=c.length*.25;var b:float=c.length*.75
 assert_lt(c.at(a).distance_to(c.at(b)),2.)
 assert_lt(c.at(a).length(),2.)
 var p:Vector2=Vector2.ZERO
 assert_almost_eq(c.route_project(p,a-80.).s,a,2.)
 assert_almost_eq(c.route_project(p,b-80.).s,b,2.)
 assert_gt(absf(c.route_project(p,a).s-c.route_project(p,b).s),c.length*.45)
func test_wrong_branch_does_not_advance_to_remote_gate():
 var c:=RaceCourse190.new(3);var a:float=c.length*.25
 var wrong:Vector2=c.at(c.length*.75+180.)
 var q:Dictionary=c.route_project(wrong,a-30.)
 assert_lt(absf(q.s-a),300.)
 assert_lte(c.route_score(wrong,4,q.s),c.length*.25)
 # Geometry alone shares the crossing; the route guard rejects gate 12.
 assert_gt(absf(q.s-c.length*12./16.),100.)
func test_original_courses_keep_existing_projection_and_score():
 for index in 3:
  var c:=RaceCourse190.new(index);var p:Vector2=c.at(1000.)
  assert_eq(c.route_project(p,50.),c.project(p))
  assert_eq(c.route_score(p,2,50.),c.score(p,2))
