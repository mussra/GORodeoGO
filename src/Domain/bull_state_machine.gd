class_name BullStateMachine
extends RefCounted

## Single authoritative owner of a bull's state.
## Only explicitly defined transitions are permitted (GAMEPLAY_SPEC.md #Target state model).

var current: BullState.State

static var _valid_transitions: Dictionary = {
	BullState.State.SAFE: [BullState.State.CALM],
	BullState.State.CALM: [BullState.State.ALERT],
	BullState.State.ALERT: [BullState.State.ESCAPED, BullState.State.CALM],
	BullState.State.ESCAPED: [BullState.State.PURSUED, BullState.State.CAPTURED],
	BullState.State.PURSUED: [BullState.State.CAPTURED, BullState.State.ESCAPED],
	BullState.State.CAPTURED: [BullState.State.CALMING, BullState.State.ESCAPED],
	BullState.State.CALMING: [BullState.State.CONTROLLED, BullState.State.ESCAPED],
	BullState.State.CONTROLLED: [BullState.State.SAFE, BullState.State.ESCAPED],
}

func _init(initial: BullState.State = BullState.State.SAFE) -> void:
	current = initial

## Attempts to transition to [param target].
## Returns false and leaves state unchanged if the transition is not defined.
func try_transition(target: BullState.State) -> bool:
	if not can_transition(target):
		return false
	current = target
	return true

func can_transition(target: BullState.State) -> bool:
	var allowed: Array = _valid_transitions.get(current, [])
	return allowed.has(target)
