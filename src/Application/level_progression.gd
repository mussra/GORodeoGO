class_name LevelProgression
extends RefCounted

## Application layer: which levels the player may start, and validation of persisted
## progress (AI_DEVELOPMENT_RULES.md: persisted data must be validated). Pure, no nodes.

## A level is unlocked once the previous one is completed (level 1 always). [param unlock_all]
## is the developer escape hatch (debug builds only, decided by the caller — D031).
static func is_unlocked(level_number: int, highest_completed: int, unlock_all: bool = false) -> bool:
	if level_number < 1 or level_number > LevelCatalog.MAX_LEVEL:
		return false
	return unlock_all or level_number <= highest_completed + 1

## Anything that is not an int in [0, MAX_LEVEL] (corrupt or hand-edited save) becomes 0 / is clamped.
static func sanitize_highest_completed(value: Variant) -> int:
	if typeof(value) != TYPE_INT:
		return 0
	return clampi(value, 0, LevelCatalog.MAX_LEVEL)
