class_name CollisionLayers
extends RefCounted

## Named collision layer bits — single source of truth for what each raw layer number
## means, referenced from any script that sets or checks collision_layer/collision_mask.
##
## Godot scene files (.tscn) store these as literal integers, not script references — a
## resource file can't point at a GDScript constant. So level_0.tscn's Player/Bull/Fence/
## Pen/PenBarrier nodes still carry raw numbers (1, 2, 4, 8) in their own
## collision_layer/collision_mask fields; this file is where those numbers are named and
## documented, and it's what any runtime code (bull.gd, level_0.gd's dynamic obstacle
## spawning) should reference instead of repeating the literals.

const PLAYER: int = 1
const BULL: int = 2
const FENCE: int = 4
const PEN_BARRIER: int = 8
## Bulls that are held by the player or already delivered to the pen. Deliberately NOT in any
## bull's collision_mask, so they never block (or get blocked by) other bulls (D036). The Pen
## Area2D adds this bit to its own mask at runtime so it still detects deliveries.
const BULL_PASSIVE: int = 16
