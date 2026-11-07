extends GutTest
## Seeded caminos (Ant, 7-nov-2026): deterministic per seed, anchored at the
## ranch, continuous, and purely decorative (on_trail is a lookup, never a wall).

func test_trail_is_deterministic():
 for x in [-3000.0,-511.0,0.0,512.0,4096.0]:
  assert_eq(WorldMap.trail_y_at(12345,x),WorldMap.trail_y_at(12345,x))
  assert_eq(WorldMap.branch_x_at(12345,x),WorldMap.branch_x_at(12345,x))

func test_trail_passes_by_the_ranch():
 assert_almost_eq(WorldMap.trail_y_at(12345,0.0),0.0,0.001)
 assert_almost_eq(WorldMap.branch_x_at(12345,0.0),0.0,0.001)
 assert_true(WorldMap.on_trail(12345,Vector2.ZERO))

func test_trail_changes_with_seed():
 var diff:=false
 for i in 20:
  var x:=float(i)*500.0+250.0
  if absf(WorldMap.trail_y_at(1,x)-WorldMap.trail_y_at(2,x))>1.0:diff=true
 assert_true(diff)

func test_trail_wander_stays_bounded_and_continuous():
 var prev:=WorldMap.trail_y_at(99,0.0)
 for i in 400:
  var x:=float(i)*32.0
  var y:=WorldMap.trail_y_at(99,x)
  assert_true(absf(y)<=WorldMap.TRAIL_WANDER+0.01)
  assert_true(absf(y-prev)<55.0)  # no jumps: the path never teleports
  prev=y
