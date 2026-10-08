class_name RandomChaseRoller
extends RefCounted

## Application layer: the secondary, probabilistic chase (D024/D030) for a wild bull that is
## NOT the designated chaser. Every REROLL_SECONDS it re-decides whether to also chase, with
## LevelData.chase_probability. Gated on capture_held: with nothing captured every bull flees
## and the roll cycle restarts fresh. The random source is injectable for deterministic tests.

const REROLL_SECONDS: float = 5.0

var _roll_source: Callable
var _timer: float = 0.0
var _rolled_once: bool = false
var _active: bool = false

## [param roll_source]: Callable returning a float in [0, 1). Defaults to randf().
func _init(roll_source: Callable = Callable()) -> void:
	_roll_source = roll_source if roll_source.is_valid() else _default_roll

func is_active() -> bool:
	return _active

func reset() -> void:
	_timer = 0.0
	_rolled_once = false
	_active = false

## Returns whether this bull is currently also chasing the player.
func update(delta: float, is_designated_chaser: bool, capture_held: bool, probability: float) -> bool:
	if is_designated_chaser or not capture_held:
		reset()
		return false

	_timer += delta
	if not _rolled_once or _timer >= REROLL_SECONDS:
		_timer = 0.0
		_rolled_once = true
		_active = float(_roll_source.call()) < probability
	return _active

func _default_roll() -> float:
	return randf()
