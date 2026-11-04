class_name HDRiderIdle
extends Polygon2D

## One continuous, hoof-anchored idle. Small breathing and neck/mane movement,
## not a walking cycle and not a whole-body floating/bouncing cutout.
var _base: PackedVector2Array
var _time: float = 0.0
func _ready() -> void:
	texture = preload("res://art/ui/hero/rider_hd.png")
	var vertices := PackedVector2Array()
	var uv := PackedVector2Array()
	var cells: Array[PackedInt32Array] = []
	const N: int = 24
	var size: Vector2 = texture.get_size()
	for y in range(N+1):
		for x in range(N+1):
			var p := Vector2(x,y)/N*size
			vertices.append(p-size*.5)
			uv.append(p)
	for y in range(N):
		for x in range(N):
			var a: int = y*(N+1)+x
			cells.append(PackedInt32Array([a,a+1,a+N+2]))
			cells.append(PackedInt32Array([a,a+N+2,a+N+1]))
	polygon = vertices
	_base = vertices.duplicate()
	polygons = cells
	set_uv(uv)
func _process(delta: float) -> void:
	_time += delta
	var vertices: PackedVector2Array = _base.duplicate()
	for i in range(vertices.size()):
		var p: Vector2 = _base[i]
		var high: float = 1.0-smoothstep(120.0,510.0,p.y)
		var neck: float = smoothstep(30.0,360.0,p.x)*high
		var breath: float = sin(_time*1.6)
		vertices[i] += Vector2(sin(_time*1.1)*3.0*high+sin(_time*.8)*3.0*neck, -breath*2.6*high-sin(_time*.8)*3.0*neck)
	polygon = vertices
