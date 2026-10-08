extends GutTest

func test_bull_count_matches_level_number_for_all_ten() -> void:
	for level_number in range(1, 11):
		var data: LevelData = LevelCatalog.get_level(level_number)
		assert_eq(data.bull_count, level_number, "level %d" % level_number)
		assert_eq(data.level_number, level_number)

func test_level_one_has_no_obstacles() -> void:
	var data: LevelData = LevelCatalog.get_level(1)
	assert_eq(data.obstacle_rects.size(), 0)

func test_later_levels_have_more_or_equal_obstacles_than_level_two() -> void:
	var level_2: LevelData = LevelCatalog.get_level(2)
	var level_10: LevelData = LevelCatalog.get_level(10)
	assert_true(level_10.obstacle_rects.size() >= level_2.obstacle_rects.size())

func test_unknown_level_number_defaults_to_no_obstacles() -> void:
	var data: LevelData = LevelCatalog.get_level(999)
	assert_eq(data.obstacle_rects.size(), 0)

func test_chase_probability_ramps_from_five_to_fifty_percent_across_levels_one_to_ten() -> void:
	for level_number in range(1, 11):
		var data: LevelData = LevelCatalog.get_level(level_number)
		assert_almost_eq(data.chase_probability, level_number * 0.05, 0.001, "level %d" % level_number)

func test_chase_probability_caps_at_fifty_percent_for_pen_puzzle_levels() -> void:
	for level_number in range(11, 21):
		var data: LevelData = LevelCatalog.get_level(level_number)
		assert_almost_eq(data.chase_probability, 0.5, 0.001, "level %d" % level_number)

func test_unknown_level_number_gets_baseline_chase_probability() -> void:
	var data: LevelData = LevelCatalog.get_level(999)
	assert_almost_eq(data.chase_probability, 0.5, 0.001)  # clampf(999*0.05, ...) — same formula, no special-case

func test_time_limit_increases_with_level_number() -> void:
	var previous_time: float = 0.0
	for level_number in range(1, 11):
		var data: LevelData = LevelCatalog.get_level(level_number)
		assert_true(data.time_limit_seconds > previous_time, "level %d should get more time than level %d" % [level_number, level_number - 1])
		previous_time = data.time_limit_seconds

func test_pen_puzzle_levels_time_limit_increases_from_eleven_to_twenty() -> void:
	var previous_time: float = 0.0
	for level_number in range(11, 21):
		var data: LevelData = LevelCatalog.get_level(level_number)
		assert_true(data.time_limit_seconds > previous_time, "level %d should get more time than level %d" % [level_number, level_number - 1])
		previous_time = data.time_limit_seconds

func test_levels_one_to_ten_have_no_pens() -> void:
	for level_number in range(1, 11):
		var data: LevelData = LevelCatalog.get_level(level_number)
		assert_eq(data.pens.size(), 0, "level %d should have no pens" % level_number)

func test_level_eleven_is_a_single_pen_of_three_bulls() -> void:
	var data: LevelData = LevelCatalog.get_level(11)
	assert_eq(data.bull_count, 3)
	assert_eq(data.pens.size(), 1)
	assert_eq(data.pens[0]["bull_indices"], [0, 1, 2])

func test_all_pen_indices_are_within_bull_count_across_every_puzzle_level() -> void:
	for level_number in range(11, 21):
		var data: LevelData = LevelCatalog.get_level(level_number)
		for pen_entry: Dictionary in data.pens:
			for index: int in pen_entry["bull_indices"]:
				assert_true(index >= 0 and index < data.bull_count, "level %d: pen index %d out of range for bull_count %d" % [level_number, index, data.bull_count])

func test_pen_puzzle_levels_bull_counts() -> void:
	# 11-14 unchanged (D023); 15-20 all use the full 10 bulls, split across more/differently
	# linked doors instead of growing the bull count further (D026).
	var expected_bull_counts: Dictionary = {11: 3, 12: 5, 13: 7, 14: 9, 15: 10, 16: 10, 17: 10, 18: 10, 19: 10, 20: 10}
	for level_number: int in expected_bull_counts.keys():
		var data: LevelData = LevelCatalog.get_level(level_number)
		assert_eq(data.bull_count, expected_bull_counts[level_number], "level %d" % level_number)

func test_pen_puzzle_levels_door_counts() -> void:
	# The door (pen) count IS the puzzle-complexity dial from level 15 on (D026): 4, 4, 5, 6, 6, 8.
	var expected_pen_counts: Dictionary = {11: 1, 12: 2, 13: 2, 14: 3, 15: 4, 16: 4, 17: 5, 18: 6, 19: 6, 20: 8}
	for level_number: int in expected_pen_counts.keys():
		var data: LevelData = LevelCatalog.get_level(level_number)
		assert_eq(data.pens.size(), expected_pen_counts[level_number], "level %d" % level_number)

func test_every_puzzle_level_uses_all_its_bulls_across_pens_exactly_once() -> void:
	for level_number in range(11, 21):
		var data: LevelData = LevelCatalog.get_level(level_number)
		var seen_indices: Array = []
		for pen_entry: Dictionary in data.pens:
			for index: int in pen_entry["bull_indices"]:
				assert_false(seen_indices.has(index), "level %d: index %d appears in more than one pen" % [level_number, index])
				seen_indices.append(index)
		seen_indices.sort()
		var expected: Array = range(data.bull_count)
		assert_eq(seen_indices, expected, "level %d" % level_number)

# --- Pen door links (is_master / opens_pen_indices), see PenLinkResolver ---
# Levels 11-14: D026 reverted D025's links here — kept exactly as D023 defined them, unlinked.
# Levels 15-20: new door-link layouts (D026), see level_catalog.gd comments per level for the
# reasoning behind each specific assignment.

# "master" = is_master; "chain" = opens specific pens but is not master; "normal" = neither.
func _door_type_counts(pens: Array) -> Dictionary:
	var counts: Dictionary = {"master": 0, "chain": 0, "normal": 0}
	for pen_entry: Dictionary in pens:
		if pen_entry.get("is_master", false):
			counts["master"] += 1
		elif not pen_entry.get("opens_pen_indices", []).is_empty():
			counts["chain"] += 1
		else:
			counts["normal"] += 1
	return counts

func test_levels_eleven_to_fourteen_have_no_door_links_at_all() -> void:
	for level_number in range(11, 15):
		var data: LevelData = LevelCatalog.get_level(level_number)
		var counts: Dictionary = _door_type_counts(data.pens)
		assert_eq(counts["master"], 0, "level %d" % level_number)
		assert_eq(counts["chain"], 0, "level %d" % level_number)

func test_door_type_counts_per_level_fifteen_to_twenty() -> void:
	var expected: Dictionary = {
		15: {"master": 0, "chain": 1, "normal": 3},
		16: {"master": 0, "chain": 1, "normal": 3},
		17: {"master": 0, "chain": 1, "normal": 4},
		18: {"master": 0, "chain": 6, "normal": 0},  # 3 mutually-linked pairs: every door has an outgoing link
		19: {"master": 1, "chain": 5, "normal": 0},  # same 3 pairs as 18, plus pen 0 is also a master
		20: {"master": 1, "chain": 2, "normal": 5},
	}
	for level_number: int in expected.keys():
		var data: LevelData = LevelCatalog.get_level(level_number)
		assert_eq(_door_type_counts(data.pens), expected[level_number], "level %d" % level_number)

func test_all_door_link_indices_are_valid_and_never_self() -> void:
	for level_number in range(11, 21):
		var data: LevelData = LevelCatalog.get_level(level_number)
		for pen_index in range(data.pens.size()):
			for target: int in data.pens[pen_index].get("opens_pen_indices", []):
				assert_true(target >= 0 and target < data.pens.size(), "level %d pen %d links out of range" % [level_number, pen_index])
				assert_ne(target, pen_index, "level %d pen %d links to itself" % [level_number, pen_index])

func test_master_doors_in_levels_nineteen_and_twenty_release_every_bull() -> void:
	for level_number in [19, 20]:
		var data: LevelData = LevelCatalog.get_level(level_number)
		var master_index: int = -1
		for pen_index in range(data.pens.size()):
			if data.pens[pen_index].get("is_master", false):
				master_index = pen_index
		assert_ne(master_index, -1, "level %d should have a master door" % level_number)
		var released_bulls: Array = []
		for pen_index: int in PenLinkResolver.get_released_pen_indices(data.pens, master_index):
			released_bulls.append_array(data.pens[pen_index]["bull_indices"])
		assert_eq(released_bulls.size(), data.bull_count, "level %d: master should release all bulls" % level_number)

func test_level_fifteen_chain_door_opens_exactly_one_extra_pen() -> void:
	var data: LevelData = LevelCatalog.get_level(15)
	assert_eq(PenLinkResolver.get_released_pen_indices(data.pens, 0), [0, 1])

func test_level_sixteen_chain_door_opens_exactly_two_extra_pens() -> void:
	var data: LevelData = LevelCatalog.get_level(16)
	assert_eq(PenLinkResolver.get_released_pen_indices(data.pens, 0), [0, 1, 2])

func test_level_seventeen_centre_door_opens_three_corners_but_not_the_fourth() -> void:
	var data: LevelData = LevelCatalog.get_level(17)
	assert_eq(PenLinkResolver.get_released_pen_indices(data.pens, 4), [0, 1, 2, 4])

func test_level_eighteen_pairs_are_symmetric() -> void:
	var data: LevelData = LevelCatalog.get_level(18)
	# Opening either door of a pair releases both — checked for all 3 pairs, both directions.
	assert_eq(PenLinkResolver.get_released_pen_indices(data.pens, 0), [0, 1])
	assert_eq(PenLinkResolver.get_released_pen_indices(data.pens, 1), [0, 1])
	assert_eq(PenLinkResolver.get_released_pen_indices(data.pens, 2), [2, 3])
	assert_eq(PenLinkResolver.get_released_pen_indices(data.pens, 3), [2, 3])
	assert_eq(PenLinkResolver.get_released_pen_indices(data.pens, 4), [4, 5])
	assert_eq(PenLinkResolver.get_released_pen_indices(data.pens, 5), [4, 5])

func test_level_twenty_chain_doors_open_their_specific_targets_only() -> void:
	var data: LevelData = LevelCatalog.get_level(20)
	assert_eq(PenLinkResolver.get_released_pen_indices(data.pens, 3), [3, 6])
	assert_eq(PenLinkResolver.get_released_pen_indices(data.pens, 5), [1, 2, 5])
