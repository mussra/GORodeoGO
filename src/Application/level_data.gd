class_name LevelData
extends Resource

## Per-level data (GAMEPLAY_SPEC.md #Level contract). Replaces the old single flat
## LevelConfig — now indexed by level via LevelCatalog instead of one Inspector-set
## resource shared by every level.

@export var level_number: int = 1
@export var bull_count: int = 1
@export var time_limit_seconds: float = 150.0
@export var win_requires_all_bulls: bool = true
@export var obstacle_rects: Array = []  # Array of Rect2, world-space obstacle bounds (position = top-left corner)

## Chance (0.0-1.0), re-rolled every 5s per non-chaser wild bull, that it also chases the
## player instead of fleeing (see bull.gd _update_random_chase). The single guaranteed
## chaser (Level0._update_chaser) is separate and unaffected by this value.
@export var chase_probability: float = 0.1

## Pen-puzzle mode (GAMEPLAY_SPEC.md, levels 11+). Empty for every non-puzzle level —
## when empty, Level0 activates every bull immediately exactly as before.
## Array of Dictionary, one per pen, each shaped as:
##   {
##     "bull_indices": Array[int]  -- indices into Level0's all_bulls (0-based)
##     "door_position": Vector2    -- world position of the pen's door
##     "door_hold_seconds": float  -- seconds the player must stand still to open it
##     "is_master": bool           -- optional (default false): opening this door also opens EVERY other door
##     "opens_pen_indices": Array[int] -- optional (default []): opening this door also opens these pens
##                                        (indices into this same pens array, never its own)
##   }
## A door with neither is_master nor opens_pen_indices is a "normal" door: it only opens its
## own pen. What each door releases is resolved by PenLinkResolver (links do not cascade).
## A plain Dictionary (not a new Resource subclass) to match obstacle_rects' style —
## this is one-off per-level data, not a reusable typed contract.
@export var pens: Array = []
