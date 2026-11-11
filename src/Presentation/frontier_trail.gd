extends Node2D
## Draws the seeded dirt caminos crossing one chunk (Ant: caminos, 7-nov-2026).
## Continuous one-straight ribbons and explicit derived T/cross junctions.
## Purely decorative - the rider can leave the path.
const SAMPLE := 24.0

var c: Vector2i = Vector2i.ZERO

func _ready() -> void:
	z_index = -8
	texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED
	queue_redraw()

func _draw() -> void:
	var seed: int = SaveData.world_seed
	var origin: Vector2 = Vector2(c) * WorldMap.CHUNK_SIZE
	var junctions=WorldRoadJunctions.layout(seed)
	_stamp_axis(origin, true, seed,junctions)
	_stamp_axis(origin, false, seed,junctions)
	if c==Vector2i.ZERO:
		for lane in WorldPaths.access_lanes(seed):
			ContinuousRoadArt.access(self,lane,32.0,junctions)
	# Each junction has one owner, including junctions at negative coordinates.
	for junction in junctions:
		var owner=Vector2i((junction.center/WorldMap.CHUNK_SIZE).floor())
		if c==owner:ContinuousRoadArt.draw_junction(self,junction)

func _stamp_axis(origin: Vector2, main: bool, seed: int,junctions:Array) -> void:
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
	ContinuousRoadArt.ribbon(self,pts,45.0,junctions)
