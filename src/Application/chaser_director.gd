class_name ChaserDirector
extends RefCounted

## Application layer: the "tag" rule (D021) — exactly one wild bull is the designated chaser
## while the player holds at least one capture. Extracted from level_0.gd (D016 follow-up)
## so it can be unit tested. Bulls are identified by an int id (their index in Level0).
##
## Behaviour: no capture held -> no chaser. Capture held -> the nearest wild bull becomes the
## chaser after [param engage_delay_seconds] (D024). The same chaser is kept until it stops
## being wild, then the nearest wild bull takes over after the delay again.

const NO_CHASER: int = -1

var _engage_delay_seconds: float
var _chaser_id: int = NO_CHASER
var _pending_id: int = NO_CHASER
var _engage_timer: float = 0.0
var _roll_source: Callable

## [param roll_source]: Callable returning a float in [0, 1) used to pick a random successor
## when the chaser is blocked. Defaults to randf(); injectable for deterministic tests.
func _init(engage_delay_seconds: float, roll_source: Callable = Callable()) -> void:
	_engage_delay_seconds = engage_delay_seconds
	_roll_source = roll_source if roll_source.is_valid() else _default_roll

func chaser_id() -> int:
	return _chaser_id

## [param wild_distances]: Dictionary {bull_id: int -> distance_to_player: float}, containing
## ONLY the bulls that are currently wild. Returns the id of the current chaser or NO_CHASER.
func update(delta: float, holding_capture: bool, wild_distances: Dictionary) -> int:
	if not holding_capture:
		_chaser_id = NO_CHASER
		_pending_id = NO_CHASER
		_engage_timer = 0.0
		return NO_CHASER

	if _chaser_id != NO_CHASER and wild_distances.has(_chaser_id):
		return _chaser_id
	_chaser_id = NO_CHASER

	var nearest_id: int = _nearest(wild_distances)
	if nearest_id != _pending_id:
		_pending_id = nearest_id
		_engage_timer = 0.0
	if _pending_id == NO_CHASER:
		return NO_CHASER

	_engage_timer += delta
	if _engage_timer >= _engage_delay_seconds:
		_chaser_id = _pending_id
		_pending_id = NO_CHASER
	return _chaser_id

## The current chaser is stuck (D036): pass the baton at once to a RANDOM other wild bull.
## If there is no other wild bull the current chaser keeps the role. No-op without a chaser.
## Returns the (possibly new) chaser id.
func hand_over_randomly(wild_distances: Dictionary) -> int:
	if _chaser_id == NO_CHASER:
		return NO_CHASER
	var candidates: Array = []
	for bull_id: int in wild_distances:
		if bull_id != _chaser_id:
			candidates.append(bull_id)
	if candidates.is_empty():
		return _chaser_id
	var index: int = clampi(int(float(_roll_source.call()) * candidates.size()), 0, candidates.size() - 1)
	_chaser_id = candidates[index]
	_pending_id = NO_CHASER
	_engage_timer = 0.0
	return _chaser_id

func _default_roll() -> float:
	return randf()

func _nearest(wild_distances: Dictionary) -> int:
	var nearest_id: int = NO_CHASER
	var nearest_distance: float = INF
	for bull_id: int in wild_distances:
		var distance: float = wild_distances[bull_id]
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_id = bull_id
	return nearest_id
