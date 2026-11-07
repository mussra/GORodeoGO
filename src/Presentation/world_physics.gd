class_name WorldPhysics
extends RefCounted
## Static collision boxes for world obstacles, at their base/feet band only
## (Ant 7-nov: collision at feet, no clipping, no getting stuck).

static func add_box(parent: Node2D, rect: Rect2) -> StaticBody2D:
	var body := StaticBody2D.new()
	body.position = rect.get_center()
	var shape := CollisionShape2D.new()
	var r := RectangleShape2D.new()
	r.size = rect.size
	shape.shape = r
	body.add_child(shape)
	parent.add_child(body)
	return body
