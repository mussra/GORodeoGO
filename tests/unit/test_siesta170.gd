extends GutTest
func test_grass_detour_without_a_road_uses_only_explored_walkable_ground():
 var cells:Dictionary={}
 for x in 5:
  for y in 3:cells[Vector2i(x,y)]=true
 var allowed:Callable=func(p:Vector2):return cells.has(Vector2i((p/512.).floor())) and not Rect2(1000,0,120,850).has_point(p)
 var plan:=SiestaRoute163.terrain170(Vector2(160,160),Vector2(2200,160),cells,512.,allowed)
 assert_false(plan.is_empty());assert_gt(plan.length,2040.);assert_almost_eq(plan.advance,plan.length*.5,.1)
 for i in range(1,plan.path.size()):assert_true(SiestaRoute163.clear(plan.path[i-1],plan.path[i],allowed))
func test_unknown_gap_and_actual_obstacle_still_block_and_near_is_not_a_route_failure():
 var cells:Dictionary={Vector2i.ZERO:true,Vector2i(2,0):true};var allowed:Callable=func(p:Vector2):return cells.has(Vector2i((p/512.).floor()))
 assert_true(SiestaRoute163.terrain170(Vector2(160,160),Vector2(1300,160),cells,512.,allowed).is_empty())
 assert_true(SiestaRoute163.terrain170(Vector2(160,160),Vector2(240,160),cells,512.,allowed).is_empty())
func test_notes_and_photo_locations_are_destinations_but_unknown_notes_are_not():
 var notes:Dictionary={"0,0":[{"id":"memo","pos":Vector2(200,200),"text":"Mi sitio","photo":""},{"id":"photo","pos":Vector2(400,200),"text":"","photo":"user://map-photos/photo.png"},{"id":"unknown","pos":Vector2(5000,200),"text":"Lejos"}]}
 var sites:=SiestaDestinations170.notes(notes,func(p):return p.x<1000)
 assert_eq(sites.size(),2);assert_eq(sites[0].id,"note170:memo");assert_eq(sites[1].name,"Captura guardada")
func test_pig_lasso_panic_runs_even_outside_proximity_but_does_not_reset_exhaustion():
 var state:=WorldPigs.new_chase_state();state.lasso_panic170=6.
 var out:=WorldPigs.chase_tick(state,500.,0.,false,.1);assert_true(out.flee);assert_almost_eq(out.lasso_panic170,5.9,.001)
 state.tired=true;state.rest=0.;var tired:=WorldPigs.chase_tick(state,500.,0.,false,.1);assert_true(tired.tired);assert_false(tired.flee)
