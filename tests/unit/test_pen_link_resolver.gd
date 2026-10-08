extends GutTest

# Helper: build a pens array where each entry is just its link config (bull_indices etc. are
# irrelevant to PenLinkResolver, which only reads is_master / opens_pen_indices).
func _pens(configs: Array) -> Array:
	return configs

func test_normal_door_releases_only_its_own_pen() -> void:
	var pens: Array = _pens([{}, {}, {}])
	assert_eq(PenLinkResolver.get_released_pen_indices(pens, 1), [1])
	assert_eq(PenLinkResolver.get_linked_pen_indices(pens, 1), [])

func test_master_door_releases_every_pen() -> void:
	var pens: Array = _pens([{}, {"is_master": true}, {}])
	assert_eq(PenLinkResolver.get_released_pen_indices(pens, 1), [0, 1, 2])

func test_master_link_targets_exclude_itself() -> void:
	var pens: Array = _pens([{}, {"is_master": true}, {}])
	assert_eq(PenLinkResolver.get_linked_pen_indices(pens, 1), [0, 2])

func test_chain_door_releases_itself_and_its_target_only() -> void:
	var pens: Array = _pens([{"opens_pen_indices": [1]}, {}, {}])
	assert_eq(PenLinkResolver.get_released_pen_indices(pens, 0), [0, 1])

func test_chain_door_can_open_several_specific_pens() -> void:
	var pens: Array = _pens([{"opens_pen_indices": [2, 1]}, {}, {}])
	assert_eq(PenLinkResolver.get_released_pen_indices(pens, 0), [0, 1, 2])

func test_links_are_not_cascading_through_a_chain_target() -> void:
	# Door 0 chains to door 1, and door 1 is a master. Opening door 0 must NOT follow door 1's
	# master link — only a door the player opens triggers its own links.
	var pens: Array = _pens([{"opens_pen_indices": [1]}, {"is_master": true}, {}])
	assert_eq(PenLinkResolver.get_released_pen_indices(pens, 0), [0, 1])

func test_opening_a_target_door_directly_does_not_open_the_source() -> void:
	# Links are one-directional: door 1 (normal) opened by the player never opens door 0.
	var pens: Array = _pens([{"opens_pen_indices": [1]}, {}])
	assert_eq(PenLinkResolver.get_released_pen_indices(pens, 1), [1])

func test_duplicate_targets_are_deduplicated() -> void:
	var pens: Array = _pens([{"opens_pen_indices": [1, 1, 1]}, {}])
	assert_eq(PenLinkResolver.get_released_pen_indices(pens, 0), [0, 1])

func test_master_plus_explicit_targets_do_not_duplicate() -> void:
	var pens: Array = _pens([{"is_master": true, "opens_pen_indices": [1]}, {}, {}])
	assert_eq(PenLinkResolver.get_released_pen_indices(pens, 0), [0, 1, 2])

func test_self_reference_is_ignored() -> void:
	var pens: Array = _pens([{"opens_pen_indices": [0]}, {}])
	assert_eq(PenLinkResolver.get_linked_pen_indices(pens, 0), [])
	assert_eq(PenLinkResolver.get_released_pen_indices(pens, 0), [0])

func test_out_of_range_targets_are_ignored() -> void:
	var pens: Array = _pens([{"opens_pen_indices": [-1, 5, 1]}, {}])
	assert_eq(PenLinkResolver.get_released_pen_indices(pens, 0), [0, 1])

func test_out_of_range_opened_index_releases_nothing() -> void:
	var pens: Array = _pens([{}, {}])
	assert_eq(PenLinkResolver.get_released_pen_indices(pens, -1), [])
	assert_eq(PenLinkResolver.get_released_pen_indices(pens, 2), [])
	assert_eq(PenLinkResolver.get_linked_pen_indices(pens, 2), [])

func test_empty_pens_array_releases_nothing() -> void:
	assert_eq(PenLinkResolver.get_released_pen_indices([], 0), [])

func test_single_pen_master_only_releases_itself() -> void:
	var pens: Array = _pens([{"is_master": true}])
	assert_eq(PenLinkResolver.get_released_pen_indices(pens, 0), [0])

func test_result_is_sorted_ascending() -> void:
	var pens: Array = _pens([{}, {}, {}, {"opens_pen_indices": [2, 0, 1]}])
	assert_eq(PenLinkResolver.get_released_pen_indices(pens, 3), [0, 1, 2, 3])
