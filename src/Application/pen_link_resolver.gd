class_name PenLinkResolver
extends RefCounted

## Application layer: decides which pens a door releases when it opens (GAMEPLAY_SPEC.md
## pen-puzzle mode, door links). Pure data-in/data-out — no nodes — so the rules are unit
## testable without a scene tree. Works on LevelData.pens entries, where each pen may carry:
##   "is_master": bool                 -- opening this door also opens EVERY other door
##   "opens_pen_indices": Array[int]   -- opening this door also opens these specific pens
## A pen with neither is a "normal" door: it only releases itself.
##
## Links are NOT cascading: a door opened *by a link* releases only its own pen; its own
## is_master / opens_pen_indices are not followed. Only a door the player opens triggers
## its links. Keeps outcomes predictable and rules out chain reactions.
##
## Invalid data (index out of range, a pen pointing at itself) is ignored rather than
## crashing; tests over LevelCatalog guarantee shipped levels never contain any.

## Pen indices this pen's door opens IN ADDITION to its own (never includes source_index).
## Sorted ascending, no duplicates.
static func get_linked_pen_indices(pens: Array, source_index: int) -> Array:
	if source_index < 0 or source_index >= pens.size():
		return []

	var source: Dictionary = pens[source_index]
	var linked: Dictionary = {}  # used as a Set — value unused

	if source.get("is_master", false):
		for i in range(pens.size()):
			linked[i] = true

	for target_index: int in source.get("opens_pen_indices", []):
		if target_index >= 0 and target_index < pens.size():
			linked[target_index] = true

	linked.erase(source_index)

	var result: Array = linked.keys()
	result.sort()
	return result

## Every pen released when the player opens source door opened_index: itself plus its
## linked pens. Sorted ascending, no duplicates. Empty if opened_index is out of range.
static func get_released_pen_indices(pens: Array, opened_index: int) -> Array:
	if opened_index < 0 or opened_index >= pens.size():
		return []

	var released: Array = [opened_index]
	released.append_array(get_linked_pen_indices(pens, opened_index))
	released.sort()
	return released
