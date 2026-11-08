extends GutTest
## Filtros del atlas (Ant 8-nov 19:13): registro como datos + AND de propiedades.
func _entries() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for n in range(20 * HorseCollection.PATTERNS.size() * HorseCollection.MANES.size()):
		var t: Dictionary = {"coat": int(n / (HorseCollection.PATTERNS.size() * 6)), "pattern": int(n / 6) % HorseCollection.PATTERNS.size(), "mane": n % 6}
		out.append({"horse": {"traits": t, "name": HorseCollection.COATS[t.coat], "stage": "adult"}, "owned": n % 3 == 0})
	return out

func test_registry_is_data_driven() -> void:
	var ids: Array = HorseFilters.properties().map(func(p): return p.id)
	assert_eq(ids, ["coat", "pattern", "mane", "rarity", "owned"])
	for p in HorseFilters.properties():
		assert_gt(p.values.size(), 0, p.id + " ofrece valores")

func test_no_filters_returns_everything() -> void:
	var e: Array[Dictionary] = _entries()
	assert_eq(HorseFilters.apply(e, {}).size(), e.size())

func test_filter_by_coat_and_pattern() -> void:
	var e: Array[Dictionary] = _entries()
	var rojos: Array[Dictionary] = HorseFilters.apply(e, {"coat": 5})
	assert_eq(rojos.size(), 10 * 6, "todos los rojos (20x10x6 -> 60)")
	for entry in rojos:
		assert_eq(entry.horse.traits.coat, 5)
	var rayados: Array[Dictionary] = HorseFilters.apply(e, {"pattern": 9})
	assert_eq(rayados.size(), 20 * 6, "todos los de cebra (rayados)")
	for entry in rayados:
		assert_eq(entry.horse.traits.pattern, 9)

func test_filters_combine_with_and() -> void:
	var e: Array[Dictionary] = _entries()
	var both: Array[Dictionary] = HorseFilters.apply(e, {"coat": 5, "pattern": 9})
	assert_eq(both.size(), 6, "rojos Y rayados: solo las 6 crines")
	for entry in both:
		assert_eq(entry.horse.traits.coat, 5)
		assert_eq(entry.horse.traits.pattern, 9)

func test_filter_by_rarity_and_owned() -> void:
	var e: Array[Dictionary] = _entries()
	for tier_i in range(5):
		var got: Array[Dictionary] = HorseFilters.apply(e, {"rarity": tier_i})
		for entry in got:
			assert_eq(HorseMarket.tier(entry.horse), tier_i)
	var owned: Array[Dictionary] = HorseFilters.apply(e, {"owned": true})
	for entry in owned:
		assert_true(entry.owned)
	assert_eq(owned.size() + HorseFilters.apply(e, {"owned": false}).size(), e.size())

func test_unknown_filter_is_ignored() -> void:
	var e: Array[Dictionary] = _entries()
	assert_eq(HorseFilters.apply(e, {"species": 1}).size(), e.size())
