class_name CorralFrontRail
extends Node2D
## A y-sorted rail sibling: creatures behind it are occluded, creatures in front
## are not. Geometry and collision remain owned by PuzzleCorral.
var left: float
var right: float
var gate_x: float
var corral: Node2D
func _process(_delta: float) -> void: queue_redraw()
func _draw() -> void:
	if not is_instance_valid(corral): return
	var color := Color("84aeb4")
	_segment(left,gate_x-60,color)
	_segment(gate_x+60,right,color)
	if not corral.opened:
		_segment(gate_x-60,gate_x+60,Color("eac781"))
func _segment(a: float,b: float,color: Color) -> void:
	draw_line(Vector2(a,0),Vector2(b,0),color,6,true)
	var steps: int=maxi(1,int((b-a)/30))
	for i in range(steps+1):
		draw_rect(Rect2(Vector2(lerpf(a,b,float(i)/steps)-4,-7),Vector2(8,14)),Color("395c68"))
