extends GutTest
func test_half_follows_route_length_not_straight_line_and_final_trunk_is_manual():
 var roads=[PackedVector2Array([Vector2.ZERO,Vector2(1000,0),Vector2(1000,1000)])]
 var plan:=SiestaRoute163.plan(Vector2.ZERO,Vector2(1000,1000),roads,func(_p):return true)
 assert_false(plan.is_empty());assert_almost_eq(plan.length,2000.,.1);assert_lt(plan.pos.distance_to(Vector2(1000,0)),1.);assert_almost_eq(plan.advance,plan.length*.5,.1)
 var second:=SiestaRoute163.plan(plan.pos,Vector2(1000,1000),roads,func(_p):return true);assert_lt(second.pos.distance_to(Vector2(1000,500)),1.);assert_false(SiestaRoute163.plan(second.pos,Vector2(1000,1000),roads,func(_p):return true).is_empty())
 assert_true(SiestaRoute163.plan(Vector2(1000,900),Vector2(1000,1000),roads,func(_p):return true).is_empty())
func test_unknown_or_blocked_sections_cannot_be_crossed_even_when_endpoints_are_clear():
 var roads=[PackedVector2Array([Vector2.ZERO,Vector2(2000,0)])]
 assert_true(SiestaRoute163.plan(Vector2.ZERO,Vector2(2000,0),roads,func(p):return p.x<800 or p.x>1200).is_empty())
func test_country_half_avoids_river_and_sea_and_needs_connected_exploration():
 var data:=CountryRoute146.plan(123);var cells:Dictionary={};CountryExploration148.reveal(cells,data.entry);CountryExploration148.reveal(cells,data.sites.source)
 var stopped:=SiestaRoute163.country(data.entry,data.sites.source,data,cells);assert_false(stopped.is_empty());assert_true(stopped.stopped172)
 for path in [data.approach,data.upstream]:
  for i in range(1,path.size()):
   for j in ceili(path[i-1].distance_to(path[i])/100.)+1:CountryExploration148.reveal(cells,path[i-1].move_toward(path[i],j*100.))
 var plan:=SiestaRoute163.country(data.entry,data.sites.source,data,cells);assert_false(plan.is_empty());assert_false(CountryRoute146.blocked(data,plan.pos));assert_gt(plan.pos.distance_to(data.sites.source),120.)
 for point in plan.path:assert_true(plan.allowed.call(point));assert_false(CountryRoute146.blocked(data,point))
