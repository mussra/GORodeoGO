extends Node2D
## Draws the seeded dirt caminos crossing one chunk (Ant: caminos, 7-nov-2026).
## Road tiles via the shared RoadTiles component (art sheet 23:06) stamped
## along the seeded wander. Purely decorative - the rider can leave the path.

## In-game stamp length along the path; dirt band lands at ~48px wide.
const LENGTH := 62.0
const SAMPLE := 24.0

var c: Vector2i = Vector2i.ZERO

func _ready() -> void:
	z_index = -8
	queue_redraw()

func _draw() -> void:
	var seed: int = SaveData.world_seed
	var origin: Vector2 = Vector2(c) * WorldMap.CHUNK_SIZE
	_stamp_axis(origin, true, seed)
	_stamp_axis(origin, false, seed)
	# Local access lanes are drawn once per owning chunk, never random branches.
	if c==Vector2i.ZERO:
		for lane in WorldPaths.access_lanes(seed):RoadTiles.stamp_polyline(self,lane,40.0,28.0)

func _stamp_axis(origin: Vector2, main: bool, seed: int) -> void:
	var n: int = int(WorldMap.CHUNK_SIZE / SAMPLE) + 5
	var pts := PackedVector2Array()
	for i in n:
		var t: float = (i - 2) * SAMPLE
		var center: Vector2
		if main:
			center = Vector2(origin.x + t, WorldMap.trail_y_at(seed, origin.x + t))
		else:
			center = Vector2(WorldMap.branch_x_at(seed, origin.y + t), origin.y + t)
		if center.y < origin.y - 80.0 or center.y > origin.y + WorldMap.CHUNK_SIZE + 80.0:
			continue
		if center.x < origin.x - 80.0 or center.x > origin.x + WorldMap.CHUNK_SIZE + 80.0:
			continue
		pts.append(center)
	RoadTiles.stamp_polyline(self, pts, LENGTH, LENGTH * 0.8)
