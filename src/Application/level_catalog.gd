class_name LevelCatalog
extends RefCounted

## All level definitions in one place (ARCHITECTURE.md: level data separate from
## gameplay logic). Levels 1-10: bull_count == level_number, no pens. Levels 11-20:
## pen-puzzle mode (GAMEPLAY_SPEC.md) — bull_count and pens set explicitly per level.
##
## Time limits are hand-tuned per level, not a blind formula — early levels stay tight,
## later levels get meaningfully more room since 10 simultaneous bulls (even with dual
## capture unlocked at Level 5) genuinely takes longer to clear. UNVERIFIED — nobody has
## timed an actual playthrough yet, these are estimates; report back if a level still
## feels too tight or too generous and it's a one-line number fix here.
##
## Obstacle/door geometry is now checked by tests/unit/test_level_geometry.gd (inside the arena,
## clear of spawns, pen and each other) — v0.17.0 moved obstacles of levels 7-10 and 15 that sat
## on top of the player spawn, the pen or a bull spawn. Still UNVERIFIED by eye: obstacle placement was chosen to clear the known fixed bull spawn points
## and the player/pen start positions with margin, by calculation, not by looking at the
## running scene. If a bull ever spawns stuck inside a wall, that's why — report it and
## it's a one-line position fix here, not a deeper bug.

const MAX_LEVEL: int = 20  ## single source of truth for the number of playable levels (menu, progression, save validation)
const DEFAULT_DOOR_HOLD_SECONDS: float = 1.2  ## seconds standing still to open any pen door (Nivel 11+); override per-pen below if ever needed

static func get_level(level_number: int) -> LevelData:
	var data := LevelData.new()
	data.level_number = level_number
	data.bull_count = level_number
	# 5%/level up to 50% at level 10; puzzle levels 11-15 stay at the ceiling. Ceiling is 50%,
	# not 100% — with the always-chasing designated chaser (D021) plus ~50% of the rest
	# rolling in, roughly half of all wild bulls end up chasing at the hardest levels, not
	# all of them (explicit requirement, reduced from the original 100% ceiling). A single
	# formula rather than 15 repeated lines — override data.chase_probability inside a
	# specific case below if a level ever needs to diverge from the ramp.
	data.chase_probability = clampf(level_number * 0.05, 0.05, 0.5)

	match level_number:
		1:
			data.time_limit_seconds = 80.0
			data.obstacle_rects = []
		2:
			data.time_limit_seconds = 100.0
			data.obstacle_rects = [Rect2(-160, -30, 120, 60)]
		3:
			data.time_limit_seconds = 120.0
			data.obstacle_rects = [Rect2(-40, -140, 80, 50), Rect2(-40, 90, 80, 50)]
		4:
			data.time_limit_seconds = 140.0
			data.obstacle_rects = [Rect2(-160, -30, 120, 60), Rect2(60, -30, 120, 60)]
		5:
			data.time_limit_seconds = 165.0
			data.obstacle_rects = [Rect2(-40, -140, 80, 50), Rect2(-40, 90, 80, 50), Rect2(100, -30, 90, 60)]
		6:
			data.time_limit_seconds = 190.0
			data.obstacle_rects = [Rect2(-160, -30, 120, 60), Rect2(60, -30, 120, 60), Rect2(-40, -180, 80, 50)]
		7:
			data.time_limit_seconds = 215.0
			data.obstacle_rects = [Rect2(-320, 60, 90, 130), Rect2(230, 60, 90, 130)]
		8:
			data.time_limit_seconds = 240.0
			data.obstacle_rects = [Rect2(-160, -180, 120, 50), Rect2(-160, 70, 120, 50), Rect2(40, -20, 80, 40)]
		9:
			data.time_limit_seconds = 270.0
			data.obstacle_rects = [Rect2(-320, 60, 90, 130), Rect2(230, 60, 90, 130), Rect2(-40, -140, 80, 50), Rect2(-40, 90, 80, 50)]
		10:
			data.time_limit_seconds = 300.0
			data.obstacle_rects = [Rect2(-160, -180, 120, 50), Rect2(-160, 70, 120, 50), Rect2(40, -180, 80, 50), Rect2(40, 130, 80, 50), Rect2(-40, -90, 80, 60)]
		11:
			# First pen-puzzle level (GAMEPLAY_SPEC.md, levels 11+). Intentionally introductory:
			# a single pen, so there is no order to plan yet — it only teaches the hold-to-open
			# door mechanic before level 12+ introduces multiple pens and real risk management.
			# bull_count overridden below: this level uses 3 bulls, not 11.
			data.bull_count = 3
			data.time_limit_seconds = 90.0
			data.obstacle_rects = []
			data.pens = [
				{
					"bull_indices": [0, 1, 2],
					"door_position": Vector2(100, 0),  # UNVERIFIED: central to Bull/Bull2/Bull3's fixed tscn positions, not play-tested
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				}
			]
		12:
			# Second pen-puzzle level: first real order decision — 2 pens, so opening one
			# leaves the other still locked (a genuine choice of which risk to take first).
			data.bull_count = 5
			data.time_limit_seconds = 150.0
			data.obstacle_rects = []
			data.pens = [
				{
					"bull_indices": [0, 1],
					"door_position": Vector2(225, -75),  # UNVERIFIED: centroid of Bull/Bull2
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [2, 3, 4],
					"door_position": Vector2(-150, 57),  # UNVERIFIED: centroid of Bull3/Bull4/Bull5
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				}
			]
		13:
			# Still 2 pens, more bulls per pen (raises the cost of opening the wrong one first)
			# plus a couple of obstacles back in play (GAMEPLAY_SPEC.md: obstacles + pens
			# compounding, same escalation shape as levels 1-10's own obstacle ramp).
			data.bull_count = 7
			data.time_limit_seconds = 200.0
			data.obstacle_rects = [Rect2(-40, -140, 80, 50), Rect2(-40, 90, 80, 50)]
			data.pens = [
				{
					"bull_indices": [0, 1, 5],
					"door_position": Vector2(267, -100),  # UNVERIFIED: centroid of Bull/Bull2/Bull6
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [2, 3, 4, 6],
					"door_position": Vector2(-200, 80),  # UNVERIFIED: centroid of Bull3/Bull4/Bull5/Bull7
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				}
			]
		14:
			# First 3-pen level: real prioritisation between three simultaneous risk fronts,
			# not just two.
			data.bull_count = 9
			data.time_limit_seconds = 260.0
			data.obstacle_rects = [Rect2(-160, -30, 120, 60), Rect2(60, -30, 120, 60)]
			data.pens = [
				{
					"bull_indices": [0, 5, 7],
					"door_position": Vector2(283, 10),  # UNVERIFIED: centroid of Bull/Bull6/Bull8
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [1, 4, 8],
					"door_position": Vector2(-115, -175),  # UNVERIFIED: centroid of Bull2/Bull5/Bull9
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [2, 3, 6],
					"door_position": Vector2(-165, 165),  # UNVERIFIED: centroid of Bull3/Bull4/Bull7
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				}
			]
		15:
			# Redefined (was 3 pens/10 bulls): 4 doors, one near each corner of the play area —
			# same 10 fixed bull spawn points, regrouped by nearest corner. Two doors are linked
			# unidirectionally: opening NE also opens NW, but not the other way round. SW and SE
			# are unlinked. PenLinkOverlay draws this as a pink arrow pointing NE -> NW.
			data.bull_count = 10
			data.time_limit_seconds = 320.0
			data.obstacle_rects = [Rect2(-160, -180, 120, 50), Rect2(-160, 70, 120, 50), Rect2(40, -180, 80, 50), Rect2(40, 130, 80, 50)]
			data.pens = [
				{
					"bull_indices": [0, 1, 5],  # NE corner
					"door_position": Vector2(380, -190),
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
					"opens_pen_indices": [1],  # unidirectional: NE also opens NW
				},
				{
					"bull_indices": [4, 8],  # NW corner
					"door_position": Vector2(-380, -190),
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [2, 6],  # SW corner
					"door_position": Vector2(-380, 190),
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [3, 7, 9],  # SE corner
					"door_position": Vector2(380, 190),
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				}
			]
		16:
			# Same 4 corner pens/positions as level 15 (only the link config changes): one door
			# (NE) is now related to TWO others unidirectionally — opening it also opens NW and
			# SW, but SE stays untouched.
			data.bull_count = 10
			data.time_limit_seconds = 340.0
			data.obstacle_rects = []
			data.pens = [
				{
					"bull_indices": [0, 1, 5],  # NE corner
					"door_position": Vector2(380, -190),
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
					"opens_pen_indices": [1, 2],  # unidirectional: NE also opens NW and SW
				},
				{
					"bull_indices": [4, 8],  # NW corner
					"door_position": Vector2(-380, -190),
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [2, 6],  # SW corner
					"door_position": Vector2(-380, 190),
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [3, 7, 9],  # SE corner
					"door_position": Vector2(380, 190),
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				}
			]
		17:
			# 5 doors: the same 4 corners (2 bulls each now, not 2-3) plus a new one in the
			# centre of the map. The centre door is related to 3 of the 4 corners (all but SE),
			# unidirectionally — SE stays fully independent.
			data.bull_count = 10
			data.time_limit_seconds = 360.0
			data.obstacle_rects = []
			data.pens = [
				{
					"bull_indices": [0, 5],  # NE corner
					"door_position": Vector2(380, -190),
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [4, 8],  # NW corner
					"door_position": Vector2(-380, -190),
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [2, 6],  # SW corner
					"door_position": Vector2(-380, 190),
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [7, 9],  # SE corner
					"door_position": Vector2(380, 190),
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [1, 3],  # centre
					"door_position": Vector2(0, -60),  # UNVERIFIED: clear of player spawn (0,0) and the pen (-300,0)
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
					"opens_pen_indices": [0, 1, 2],  # centre unidirectionally opens NE, NW, SW — not SE
				}
			]
		18:
			# 6 doors, positioned scattered around the level rather than any corner/centre
			# pattern. Related two-by-two: 3 independent pairs, each pair opens the other door
			# in the pair (so unlike every level above, these pairs are NOT one-directional —
			# opening either door of a pair opens its partner too; PenLinkOverlay draws that as
			# two opposing arrowheads on the same line).
			data.bull_count = 10
			data.time_limit_seconds = 390.0
			data.obstacle_rects = []
			data.pens = _scattered_pairs_pens()
		19:
			# Same 6 doors/positions/pairs as level 18, plus: pen 0's door is ALSO a master —
			# opening it releases every pen at once (its pair link is dropped: the master
			# already covers it).
			data.bull_count = 10
			data.time_limit_seconds = 410.0
			data.obstacle_rects = []
			data.pens = _scattered_pairs_pens()
			data.pens[0].erase("opens_pen_indices")  # master supersedes the pair link
			data.pens[0]["is_master"] = true
		20:
			# 8 doors, fully scattered, "aleatorio" as requested — a deliberately messy mix of
			# all three door types: pen 0 is a MASTER (opens all 7 others); pen 3 is a CHAIN to
			# pen 6; pen 5 is a CHAIN to both pen 1 and pen 2; pens 1, 2, 4, 6, 7 are NORMAL
			# (targets only, no outgoing link of their own).
			data.bull_count = 10
			data.time_limit_seconds = 450.0
			data.obstacle_rects = []
			data.pens = [
				{
					"bull_indices": [0, 5],
					"door_position": Vector2(300, -230),  # UNVERIFIED: scattered placement, not play-tested
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
					"is_master": true,
				},
				{
					"bull_indices": [1],
					"door_position": Vector2(-420, -220),  # UNVERIFIED: scattered placement, not play-tested
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [9],
					"door_position": Vector2(0, 230),  # UNVERIFIED: scattered placement, not play-tested
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [4, 8],
					"door_position": Vector2(-200, -60),  # UNVERIFIED: scattered placement, not play-tested
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
					"opens_pen_indices": [6],
				},
				{
					"bull_indices": [2],
					"door_position": Vector2(420, 60),  # UNVERIFIED: scattered placement, not play-tested
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [6],
					"door_position": Vector2(-420, 220),  # UNVERIFIED: scattered placement, not play-tested
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
					"opens_pen_indices": [1, 2],
				},
				{
					"bull_indices": [3],
					"door_position": Vector2(150, -60),  # UNVERIFIED: scattered placement, not play-tested
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				},
				{
					"bull_indices": [7],
					"door_position": Vector2(-60, -220),  # UNVERIFIED: scattered placement, not play-tested
					"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
				}
			]
		_:
			data.time_limit_seconds = 150.0
			data.obstacle_rects = []

	return data

## The 6 scattered doors shared by levels 18 and 19 (3 mutual pairs). Built fresh on every call
## so level 19 can modify its copy without touching level 18's.
static func _scattered_pairs_pens() -> Array:
	return [
		{
			"bull_indices": [0, 5],
			"door_position": Vector2(250, -220),  # UNVERIFIED: scattered placement, not play-tested
			"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
			"opens_pen_indices": [1],
		},
		{
			"bull_indices": [1, 9],
			"door_position": Vector2(-60, 240),  # UNVERIFIED: scattered placement, not play-tested
			"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
			"opens_pen_indices": [0],
		},
		{
			"bull_indices": [4, 8],
			"door_position": Vector2(-420, 60),  # UNVERIFIED: scattered placement, not play-tested
			"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
			"opens_pen_indices": [3],
		},
		{
			"bull_indices": [2, 6],
			"door_position": Vector2(150, 140),  # UNVERIFIED: scattered placement, not play-tested
			"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
			"opens_pen_indices": [2],
		},
		{
			"bull_indices": [3],
			"door_position": Vector2(-250, -230),  # UNVERIFIED: scattered placement, not play-tested
			"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
			"opens_pen_indices": [5],
		},
		{
			"bull_indices": [7],
			"door_position": Vector2(420, -40),  # UNVERIFIED: scattered placement, not play-tested
			"door_hold_seconds": DEFAULT_DOOR_HOLD_SECONDS,
			"opens_pen_indices": [4],
		}
	]

