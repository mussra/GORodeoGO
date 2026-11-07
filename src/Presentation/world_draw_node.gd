extends Node2D
## Single-draw-callback node: each visual world item is its own node so the
## world y-sort orders it by its base/feet y (Ant 7-nov: depth perfection).

var draw_fn: Callable
var draw_origin: Vector2 = Vector2.ZERO

func _draw() -> void:
	draw_set_transform(draw_origin)
	draw_fn.call(self)
