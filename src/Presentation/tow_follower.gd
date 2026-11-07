class_name TowFollower
extends RefCounted

## Leash-follow movement shared by every roped animal: corral bulls and
## frontier captures (horses, pigs) trail the player's travelled path along
## the exact same code — one tow behavior, no copies (Ant's unification rule).
##
## The follower walks the player's breadcrumb path instead of copying velocity
## at an arbitrary offset, so it rounds corners the way the player did and
## never cuts through obstacles the player went around.

const CATCHUP_MARGIN: float = 80.0  # extra speed over the player's own while closing the leash gap

var path: Array[Vector2] = []
var last_sample: Vector2 = Vector2.ZERO
var blocked_seconds: float = 0.0

func reset() -> void:
	path.clear()
	blocked_seconds = 0.0

## Advances the owner along the player's breadcrumb path, keeping a spatial
## leash of leash_distance. Returns the velocity used this step.
## CharacterBody2D owners collide with the world (move_and_collide); plain
## Node2D owners move directly. A colliding owner accumulates blocked_seconds
## so its scene can recover the route (see bull._recover_tow_route).
func step(owner: Node2D, player_position: Vector2, player_speed: float, leash_distance: float, tow_speed: float, delta: float) -> Vector2:
	if path.is_empty():
		path.append(player_position)
		last_sample = player_position
	elif player_position.distance_to(last_sample) > .5:
		path.append(player_position)
		last_sample = player_position
	var remaining: float = owner.global_position.distance_to(path[0])
	for i in range(1, path.size()):
		remaining += path[i - 1].distance_to(path[i])
	var excess: float = maxf(0.0, remaining - leash_distance)
	var speed: float = player_speed + minf(CATCHUP_MARGIN, excess * 4)
	if player_speed < 1.0:
		speed = minf(tow_speed, excess * 8)
	var budget: float = minf(excess, speed * delta)
	var before: Vector2 = owner.global_position
	while budget > .01 and not path.is_empty():
		var offset: Vector2 = path[0] - owner.global_position
		if offset.length() < .1:
			if path.size() == 1:
				break
			path.pop_front()
			continue
		var step_vec: Vector2 = offset.limit_length(budget)
		var collided: bool = false
		if owner is CharacterBody2D:
			collided = (owner as CharacterBody2D).move_and_collide(step_vec) != null
		else:
			owner.global_position += step_vec
		budget -= step_vec.length()
		if collided:
			blocked_seconds += delta
			break
		blocked_seconds = 0.0
		if offset.length() <= step_vec.length() + .1 and path.size() > 1:
			path.pop_front()
	return (owner.global_position - before) / delta
