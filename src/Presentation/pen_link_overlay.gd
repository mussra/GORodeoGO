class_name PenLinkOverlay
extends Node2D

## Ground-worn ranch tracks: no diagram line or abstract arrow.
var _pens: Array = []
var _doors: Array = []
var layouts: Array = []
func setup(pens: Array,doors: Array) -> void:
	z_index = -5
	_pens = pens
	_doors = doors
func _process(_delta: float) -> void: queue_redraw()
func _draw() -> void:
	for source in range(_pens.size()):
		for target: int in PenLinkResolver.get_linked_pen_indices(_pens,source):
			if source>=layouts.size() or target>=layouts.size(): continue
			var path: PackedVector2Array = CorralRoute.build(layouts[source],layouts[target])
			for i in range(1,path.size()):
				var a: Vector2 = path[i-1]
				var b: Vector2 = path[i]
				var count: int = maxi(1,int(a.distance_to(b)/12))
				for step in range(count+1):
					var p: Vector2 = a.lerp(b,float(step)/count)
					draw_circle(p,12,Color(.58,.38,.19,.085))
					var side: Vector2 = (b-a).normalized().orthogonal()*4
					draw_arc(p+side,2.2,0,PI,6,Color(.35,.24,.13,.21),1.3,true)
					draw_arc(p-side,2.2,0,PI,6,Color(.35,.24,.13,.21),1.3,true)
