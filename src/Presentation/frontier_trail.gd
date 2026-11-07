extends Node2D
## Draws the seeded dirt caminos crossing one chunk (Ant: caminos, 7-nov-2026).
## Purely decorative - the rider can always leave the path.

var c: Vector2i = Vector2i.ZERO
var _ready_drawn: bool = false

func _ready() -> void:
	z_index = -8
	queue_redraw()

func _draw() -> void:
	var seed: int = SaveData.world_seed
	var origin: Vector2 = Vector2(c) * WorldMap.CHUNK_SIZE
	_stamp_axis(origin, true, seed)
	_stamp_axis(origin, false, seed)

func _stamp_axis(origin: Vector2, main: bool, seed: int) -> void:
	var step: float = 26.0
	var n: int = int(WorldMap.CHUNK_SIZE / step) + 1
	for i in n:
		var t: float = i * step
		var center: Vector2
		if main:
			center = Vector2(origin.x + t, WorldMap.trail_y_at(seed, origin.x + t))
		else:
			center = Vector2(WorldMap.branch_x_at(seed, origin.y + t), origin.y + t)
		if center.y < origin.y - 60 or center.y > origin.y + WorldMap.CHUNK_SIZE + 60:
			continue
		if center.x < origin.x - 60 or center.x > origin.x + WorldMap.CHUNK_SIZE + 60:
			continue
		draw_circle(center, WorldMap.TRAIL_WIDTH * 0.55, Color("8a6b45"))
	for i in n:
		var t: float = i * step
		var center: Vector2
		if main:
			center = Vector2(origin.x + t, WorldMap.trail_y_at(seed, origin.x + t))
		else:
			center = Vector2(WorldMap.branch_x_at(seed, origin.y + t), origin.y + t)
		if center.y < origin.y - 60 or center.y > origin.y + WorldMap.CHUNK_SIZE + 60:
			continue
		if center.x < origin.x - 60 or center.x > origin.x + WorldMap.CHUNK_SIZE + 60:
			continue
		draw_circle(center, WorldMap.TRAIL_WIDTH * 0.34, Color("97795052"))
