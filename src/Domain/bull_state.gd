class_name BullState
extends RefCounted

## Single source of truth for the set of valid bull states (GAMEPLAY_SPEC.md #Target state model).
enum State {
	SAFE,
	CALM,
	ALERT,
	ESCAPED,
	PURSUED,
	CAPTURED,
	CALMING,
	CONTROLLED,
}
