class_name NervesValue
extends RefCounted

## Configurable nerves value for a captured bull (GAMEPLAY_SPEC.md #Control/calming).
## MAX = fully alert/nervous, MIN = calm/controlled threshold.

const MAX_VALUE: float = 100.0
const MIN_VALUE: float = 0.0

var current: float

func _init(initial: float = MAX_VALUE) -> void:
	current = clampf(initial, MIN_VALUE, MAX_VALUE)

func is_controlled() -> bool:
	return current <= MIN_VALUE

## Reduces nerves while the player maintains valid control conditions.
func reduce_by(amount: float) -> void:
	assert(amount >= 0.0, "Reduction amount must not be negative.")
	current = clampf(current - amount, MIN_VALUE, MAX_VALUE)

## Raises nerves due to disturbance events (nearby alert bulls, noise, lost distance, etc).
func increase_by(amount: float) -> void:
	assert(amount >= 0.0, "Increase amount must not be negative.")
	current = clampf(current + amount, MIN_VALUE, MAX_VALUE)

## Instantly forces nerves to zero (the tranquilizer item) — bypasses reduce_by's rate,
## a one-shot consumable effect rather than gradual calming.
func force_calm() -> void:
	current = MIN_VALUE
