extends GutTest
## Afinidad genetica + Lider de manada (Ant 8-nov-2026 13:33).

const T: Dictionary = {"coat": 10, "pattern": 2, "mane": 1, "eyes": 0, "finish": "normal"}

func test_affinity_counts_visible_traits_not_eyes():
	var wild := {"coat": 10, "pattern": 2, "mane": 4, "eyes": 7, "finish": "normal"}
	assert_eq(WorldTaming.affinity_matches(T, wild), 2)
	assert_eq(WorldTaming.affinity_matches(T, T), 3)
	assert_eq(WorldTaming.affinity_matches(T, {"coat": 0, "pattern": 0, "mane": 0}), 0)

func test_affinity_bonus_caps_at_three_traits():
	assert_eq(WorldTaming.affinity_bonus(0), 1.0)
	assert_eq(WorldTaming.affinity_bonus(1), 1.25)
	assert_eq(WorldTaming.affinity_bonus(3), 1.75)

func test_affinity_speeds_trust_fill():
	var slow := WorldTaming.new_state()
	var fast := WorldTaming.new_state()
	for i in range(120):
		slow = WorldTaming.tick(slow, 100.0, 0.0, 1.0, 0.5, 1.0 / 60.0, 1.0)
		fast = WorldTaming.tick(fast, 100.0, 0.0, 1.0, 0.5, 1.0 / 60.0, 1.75)
	assert_gt(fast.progress, slow.progress)

func test_affinity_speeds_lasso_hold_fill():
	var slow := WorldTaming.new_state()
	var fast := WorldTaming.new_state()
	for i in range(120):
		slow = WorldTaming.hold_tick(slow, 0.5, 1.0 / 60.0, 1.0)
		fast = WorldTaming.hold_tick(fast, 0.5, 1.0 / 60.0, 1.75)
	assert_gt(fast.progress, slow.progress)

func test_spook_shorter_with_two_matching_traits():
	assert_eq(WorldTaming.spook_seconds(0), WorldTaming.SPOOK_SECONDS)
	assert_eq(WorldTaming.spook_seconds(1), WorldTaming.SPOOK_SECONDS)
	assert_eq(WorldTaming.spook_seconds(2), WorldTaming.AFFINITY_SPOOK_SECONDS)
	assert_eq(WorldTaming.spook_seconds(3), WorldTaming.AFFINITY_SPOOK_SECONDS)

func _lineage_collection() -> HorseCollection:
	var c := HorseCollection.new()
	var stats := {"speed": 265.0, "handling": 950.0, "power": 0.65, "dodge": 0.9}
	var mk := func(id: String, parents: Array, traits: Dictionary, stage: String = "adult") -> Dictionary:
		return {"id": id, "name": id, "parents": parents, "stage": stage, "traits": traits, "stats": stats}
	var v: Dictionary = c.export_state()
	v.horses.append(mk.call("original", [], T))
	v.horses.append(mk.call("r2", [], T))
	v.horses.append(mk.call("a", ["original", "r2"], T))
	v.horses.append(mk.call("b", ["a", "r2"], T))
	v.horses.append(mk.call("lider", ["b", "a"], T))
	var off: Dictionary = T.duplicate()
	off["pattern"] = 4
	v.horses.append(mk.call("diferente", ["b", "a"], off))
	v.horses.append(mk.call("potro", ["b", "a"], T, "foal"))
	c.restore(v)
	return c

func test_pack_leader_requires_generation_three_and_fixed_traits():
	var c := _lineage_collection()
	assert_true(PackLeader.is_leader(c.find("lider"), c))
	assert_false(PackLeader.is_leader(c.find("b"), c), "solo generacion 2")
	assert_false(PackLeader.is_leader(c.find("original"), c), "sin padres")
	assert_false(PackLeader.is_leader(c.find("diferente"), c), "rasgos no fijados")
	assert_false(PackLeader.is_leader(c.find("potro"), c), "potro no")
	assert_false(PackLeader.is_leader({}, c))
