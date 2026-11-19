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
		CorralArt310.closed(self,gate_x,0)
	else:
		CorralArt310.opened(self,gate_x,0)
func _segment(a: float,b: float,color: Color) -> void:
	CorralArt310.horizontal(self,a,b,0)
