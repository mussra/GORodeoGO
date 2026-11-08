extends GutTest
## Sementales desconfiados (Ant 8-nov 15:02): alto nivel = rapidos y
## temperamentales; solo los captura un caballo familiar (2+ rasgos) o un
## Lider de manada. Pistas progresivas con tope de 3.

func _herd(speed: float, temperament: float) -> Dictionary:
	return {"stats": {"speed": speed, "handling": 1000.0, "power": 0.7, "dodge": 0.9}, "temperament": temperament}

func test_is_stallion_needs_speed_and_temperament():
	assert_true(WorldTaming.is_stallion(_herd(280.0, 0.8)))
	assert_false(WorldTaming.is_stallion(_herd(274.9, 0.9)), "speed below threshold")
	assert_false(WorldTaming.is_stallion(_herd(285.0, 0.69)), "temperament below threshold")
	assert_false(WorldTaming.is_stallion({"stats": {}, "temperament": 0.0}), "missing stats")

func test_is_stallion_boundaries():
	assert_true(WorldTaming.is_stallion(_herd(WorldTaming.STALLION_MIN_SPEED, WorldTaming.STALLION_MIN_TEMPERAMENT)))

func test_stallion_admits_leader_always():
	assert_true(WorldTaming.stallion_admits(0, true))

func test_stallion_admits_needs_two_matches_without_leader():
	assert_false(WorldTaming.stallion_admits(0, false))
	assert_false(WorldTaming.stallion_admits(1, false))
	assert_true(WorldTaming.stallion_admits(2, false))
	assert_true(WorldTaming.stallion_admits(3, false))

func test_hint_keys_progress_and_clamp():
	assert_eq(WorldTaming.stallion_hint_key(0), "WORLD_STALLION_HINT_1")
	assert_eq(WorldTaming.stallion_hint_key(1), "WORLD_STALLION_HINT_2")
	assert_eq(WorldTaming.stallion_hint_key(2), "WORLD_STALLION_HINT_3")
	assert_eq(WorldTaming.stallion_hint_key(7), "WORLD_STALLION_HINT_3", "never past the third hint")

func test_stallion_break_is_much_shorter_than_hold():
	assert_true(WorldTaming.STALLION_BREAK_SECONDS < WorldTaming.HOLD_SECONDS * 0.5)

func test_stallion_flee_range_covers_lasso_throw():
	assert_true(WorldTaming.STALLION_FLEE_RANGE > 220.0, "flees before max lasso throw distance")
