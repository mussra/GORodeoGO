extends GutTest
func test_drift_bounds_and_slowing():
 var previous=LoadingParade.drift_x(0)
 assert_eq(previous,300.0)
 var last_step=1000.0
 for second in range(1,61):
  var x=LoadingParade.drift_x(second)
  assert_gt(x,previous)
  assert_lt(x,921.0)
  assert_lt(x-previous,last_step)
  last_step=x-previous;previous=x
 assert_lt(LoadingParade.drift_x(6),640.0)
 assert_gt(LoadingParade.drift_x(7),640.0)
 assert_lte(LoadingParade.drift_x(100000),920.0)
 assert_lt(LoadingParade.drift_x(18)+LoadingParade.RUN_SPEED*LoadingParade.FADE,1000.0)
func test_cosmetics_use_only_side_and_no_saved_state():
 var source=FileAccess.get_file_as_string("res://src/Presentation/loading_parade.gd")
 assert_false(source.contains("SaveData"))
 assert_false(source.contains("WorldMap"))
 assert_false(source.contains('"down"'))
 assert_true(source.contains("RandomNumberGenerator.new()"))
 assert_eq(LoadingParade.FADE,.5)
func test_rider_visible_when_prepared_and_finish_keeps_inside():
 var parade=LoadingParade.new()
 parade.rider=AnimatedSprite2D.new();parade.rider.visible=false;parade.add_child(parade.rider)
 parade.prepared=true;parade._process(.1)
 assert_true(parade.rider.visible)
 parade.age=18;parade.finish();parade._process(.5)
 assert_lt(parade.rider.position.x,1000.0)
 parade.free()
