class_name CaptureAttempt
extends RefCounted

var landing_point: Vector2
var target_position: Vector2
var target_hit_radius: float

func _init(
	p_landing_point: Vector2,
	p_target_position: Vector2,
	p_target_hit_radius: float
) -> void:
	landing_point = p_landing_point
	target_position = p_target_position
	target_hit_radius = p_target_hit_radius
