class_name FleeSteering
extends RefCounted

## Application layer: pure steering for a wild bull (extracted from bull.gd, D016 follow-up).
## Base direction is away from the player (or toward, for a chaser), bent away from nearby
## world bounds, obstacles and the pen. Margin/weight history: D014.

const AVOIDANCE_WEIGHT: float = 0.8

static func compute_direction(
	position: Vector2,
	player_position: Vector2,
	toward_player: bool,
	bounds: Rect2,
	obstacles: Array,
	pen_rect: Rect2,
	avoid_margin: float
) -> Vector2:
	var offset: Vector2 = (player_position - position) if toward_player else (position - player_position)
	var base_dir: Vector2 = offset.normalized() if offset.length() > 0.0 else Vector2.RIGHT

	var avoid: Vector2 = Vector2.ZERO
	if position.x - bounds.position.x < avoid_margin:
		avoid.x += 1.0
	if bounds.end.x - position.x < avoid_margin:
		avoid.x -= 1.0
	if position.y - bounds.position.y < avoid_margin:
		avoid.y += 1.0
	if bounds.end.y - position.y < avoid_margin:
		avoid.y -= 1.0

	for obstacle_rect: Rect2 in obstacles:
		if obstacle_rect.grow(avoid_margin).has_point(position):
			avoid += _away_from(obstacle_rect, position)

	if pen_rect.size != Vector2.ZERO and pen_rect.grow(avoid_margin).has_point(position):
		avoid += _away_from(pen_rect, position)

	if avoid.length() > 0.0:
		base_dir = (base_dir + avoid.normalized() * AVOIDANCE_WEIGHT).normalized()
	return base_dir

static func _away_from(rect: Rect2, position: Vector2) -> Vector2:
	var from_center: Vector2 = position - (rect.position + rect.size / 2.0)
	return from_center.normalized() if from_center.length() > 0.0 else Vector2.ZERO
