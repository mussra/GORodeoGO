extends GutTest
func test_direct_sleep_stops_before_wall_even_if_known_detour_exists():
 var allowed:Callable=func(p:Vector2):return not Rect2(400,-100,120,200).has_point(p)
 var route:=SiestaRoute163.direct172(Vector2.ZERO,Vector2(2000,0),allowed)
 assert_false(route.is_empty());assert_true(route.stopped172);assert_lt(route.pos.x,400.);assert_eq(route.pos.y,0.);assert_true(SiestaRoute163.clear(Vector2.ZERO,route.pos,allowed));assert_false(route.wake172.is_empty())
func test_real_river_stops_on_origin_bank_and_never_detours():
 var data:=CountryRoute146.plan(752026);var center:Vector2=data.source+Vector2(0,500)
 var origin:Vector2=center+Vector2(-600,0);var goal:Vector2=center+Vector2(1800,0);var cells:Dictionary={}
 for x in range(floori((center.x-1500)/512.),ceili((center.x+2500)/512.)):
  for y in range(floori((center.y-1500)/512.),ceili((center.y+1500)/512.)):cells[Vector2i(x,y)]=true
 var route:=SiestaRoute163.country(origin,goal,data,cells)
 assert_false(route.is_empty());assert_true(route.stopped172);assert_lt(route.pos.x,center.x);assert_almost_eq(route.pos.y,origin.y,.01)
 for i in 100:assert_false(CountryRoute146.blocked(data,origin.lerp(route.pos,float(i)/99.)))
func test_clear_line_goes_halfway_but_unknown_boundary_stops_short():
 var route:=SiestaRoute163.direct172(Vector2.ZERO,Vector2(2000,0),func(_p):return true)
 assert_eq(route.pos,Vector2(1000,0));assert_false(route.stopped172)
 var unknown:=SiestaRoute163.direct172(Vector2.ZERO,Vector2(2000,0),func(p):return p.x<300.)
 assert_lt(unknown.pos.x,300.);assert_true(unknown.stopped172)
