extends GutTest
func test_road_consumes_less_at_trot_and_gallop_but_same_regen():
 var st:Dictionary={"value":50.,"max":100.,"forced_left":0.}
 for gait in [WorldGait.TROTE,WorldGait.GALOPE]:
  var grass:Dictionary=WorldStamina.tick(st,gait,true,2.)
  var road:Dictionary=WorldStamina.tick(st,gait,true,2.,true)
  assert_lt(float(road.value),50.)
  assert_gt(float(road.value),float(grass.value))
  assert_almost_eq(50.-float(road.value),(50.-float(grass.value))*WorldStamina.ROAD_DRAIN_MULT,.0001)
 for moving in [true,false]:assert_eq(WorldStamina.tick(st,WorldGait.PASO,moving,1.,true),WorldStamina.tick(st,WorldGait.PASO,moving,1.))
 assert_false(WorldStamina.LEVELS_ENABLED)
func test_modular_actual_soil_all_pieces_both_art_sets():
 for dark in [false,true]:
  var surface=WorldRoadSurface94.new(0,true,dark)
  var graph:Dictionary=ModularWorldLayout93.graph()
  for cell in graph:
   var piece:Dictionary=ModularWorldLayout93.piece(graph,cell)
   var center:Vector2=ModularWorldLayout93.world(cell)
   for next in graph[cell]:
    var port:Vector2=center+Vector2(next-cell)*38.
    assert_true(surface.contains(port),str(dark)+" port "+str(cell)+" "+piece.kind)
   if piece.kind=="corner":
    var curve:Vector2=(Vector2(40./sqrt(2.),40.-40./sqrt(2.))-Vector2(40,0)).rotated(piece.rotation*PI/2)
    # Base corner bends from LEFT to DOWN around its lower-left corner.
    assert_true(surface.contains(center+curve),"curve interior "+str(dark)+str(cell))
    assert_false(surface.contains(center+Vector2(30,-30).rotated(piece.rotation*PI/2)),"outside curve remains grass")
  assert_false(surface.contains(Vector2(-100,-100)))
func test_old_world_trunks_access_and_no_fake_wide_shoulder():
 var surface=WorldRoadSurface94.new(752026)
 assert_true(surface.contains(Vector2.ZERO))
 assert_true(surface.contains(WorldPaths.FLORIST_DOOR))
 assert_false(surface.contains(Vector2(710,500))) # away from narrow vertical access
 for lane in WorldPaths.access_lanes(752026):assert_true(surface.contains(lane[-1]))
func test_no_spawn_or_tunneling_on_road_and_no_provider_keeps_levels_same():
 var road:Callable=func(p:Vector2,margin:float)->bool:return absf(p.x)<20.+margin
 var spawn:Vector2=WorldWildRoads94.clear_spawn(Vector2.ZERO,road)
 assert_false(road.call(spawn,WorldWildRoads94.FOOTPRINT))
 assert_eq(spawn,WorldWildRoads94.clear_spawn(Vector2.ZERO,road))
 var a:Vector2=Vector2(-80,0);var b:Vector2=Vector2(80,0)
 var step:Vector2=WorldWildRoads94.safe_step(a,b,road)
 assert_true(WorldWildRoads94.segment_clear(a,step,road))
 assert_lt(step.x,-38.)
 assert_eq(WorldWildRoads94.safe_step(a,b,Callable()),b)
 assert_eq(WorldWildRoads94.clear_spawn(Vector2.ZERO,Callable()),Vector2.ZERO)
