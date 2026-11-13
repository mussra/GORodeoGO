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

const MAX_LEVEL: int = 40  ## single source of truth for the number of playable levels (menu, progression, save validation)
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

	if level_number>=21 and level_number<=40:
		Campaign173.apply(data);return data
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
			# One-way courier lesson: source keeps three companions, destination six.
			data.bull_count = 10
			data.time_limit_seconds = 320.0
			data.obstacle_rects = []
			data.pens = _herd_pens([[0,1,5,8],[2,3,4,6,7,9]])
			data.pens[0]["opens_pen_indices"] = [1]
		16:
			# Fork: courier visits two destinations, both with a remaining threat.
			data.bull_count = 10
			data.time_limit_seconds = 340.0
			data.obstacle_rects = []
			data.pens = _herd_pens([[0,1,5,8],[2,4,9],[3,6,7]])
			data.pens[0]["opens_pen_indices"] = [1,2]
		17:
			# Two substantial groups: either side can send a physical courier.
			data.bull_count = 10
			data.time_limit_seconds = 360.0
			data.obstacle_rects = []
			data.pens = _herd_pens([[0,1,4,5,8],[2,3,6,7,9]])
			data.pens[0]["opens_pen_indices"] = [1]
			data.pens[1]["opens_pen_indices"] = [0]
		18:
			# Linked pair plus an independent group: choose simultaneous or staged risk.
			data.bull_count = 10
			data.time_limit_seconds = 390.0
			data.obstacle_rects = []
			data.pens = _herd_pens([[0,1,5,8],[2,4,9],[3,6,7]])
			data.pens[0]["opens_pen_indices"] = [1]
		19:
			# First full-herd master. Placement differs from20; no smaller pockets.
			data.bull_count = 10
			data.time_limit_seconds = 410.0
			data.obstacle_rects = []
			data.pens = _herd_pens([[0,1,5,8],[2,4,9],[3,6,7]])
			data.pens[0]["is_master"] = true
			# Mirrored approaches relative to20, while leaving central route clear.
			for entry:Dictionary in data.pens:entry["layout_mirror_x"] = true
		20:
			# Sequence puzzle: the tempting small herd sends a persistent opener
			# to the largest herd. Clearing medium/large first neutralises that consequence.
			data.bull_count = 10
			data.time_limit_seconds = 450.0
			data.obstacle_rects = []
			data.pens = _herd_pens([[0,1],[2,3,4],[5,6,7,8,9]])
			data.pens[0]["opens_pen_indices"] = [2]
		_:
			data.time_limit_seconds = 150.0
			data.obstacle_rects = []

	return data

## Explicit memberships; positions are owned by the physical layout builder.
static func _herd_pens(groups:Array)->Array:
	var result:Array=[]
	for group:Array in groups:
		result.append({"bull_indices":group,"door_hold_seconds":DEFAULT_DOOR_HOLD_SECONDS})
	return result
