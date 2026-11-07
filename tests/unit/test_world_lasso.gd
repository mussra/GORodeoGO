extends GutTest
## Lasso hold on wild horses (Ant, 7-nov-2026 16:20): WorldTaming.hold_tick.

func test_hold_fills_progress_fast():
	var st: Dictionary = WorldTaming.new_state()
	for i in range(40):
		st = WorldTaming.hold_tick(st, 0.0, 0.1)
	assert_true(WorldTaming.tamed(st), "4s hold on a calm horse tames it")

func test_hold_skittish_fills_slower():
	var calm: Dictionary = WorldTaming.new_state()
	var skit: Dictionary = WorldTaming.new_state()
	for i in range(10):
		calm = WorldTaming.hold_tick(calm, 0.0, 0.1)
		skit = WorldTaming.hold_tick(skit, 1.0, 0.1)
	assert_gt(float(calm.progress), float(skit.progress), "temperament resists the rope")

func test_hold_never_exceeds_full():
	var st: Dictionary = {"progress": 0.99, "spook": 0.0}
	st = WorldTaming.hold_tick(st, 0.0, 1.0)
	assert_eq(float(st.progress), 1.0)
