class_name BullController
extends RefCounted

## Coordinates BullStateMachine + NervesValue for a single bull instance.
## No Node/scene dependency — Presentation drives this with plain values (ARCHITECTURE.md dependency rule).

signal state_changed(new_state: BullState.State)
signal nerves_changed(current: float)

var _state_machine: BullStateMachine
var _nerves: NervesValue
var _tuning: BullTuning

func _init(initial_state: BullState.State = BullState.State.SAFE, tuning: BullTuning = null) -> void:
	_state_machine = BullStateMachine.new(initial_state)
	_nerves = NervesValue.new()
	_tuning = tuning if tuning != null else BullTuning.new()

func current_state() -> BullState.State:
	return _state_machine.current

func current_nerves() -> float:
	return _nerves.current

## Single source of truth for "is this bull currently under the player's control in some
## form" — was duplicated as a hand-rolled tri-state comparison in 3 different places.
func is_held() -> bool:
	var state: BullState.State = current_state()
	return state == BullState.State.CAPTURED or state == BullState.State.CALMING or state == BullState.State.CONTROLLED

## Single source of truth for "actively troublesome to a player calming a different bull
## nearby" — was duplicated similarly.
func is_wild() -> bool:
	var state: BullState.State = current_state()
	return state == BullState.State.ESCAPED or state == BullState.State.PURSUED or state == BullState.State.ALERT

func tuning() -> BullTuning:
	return _tuning

func _emit_transition(target: BullState.State) -> bool:
	var ok: bool = _state_machine.try_transition(target)
	if ok:
		state_changed.emit(current_state())
	return ok

func go_calm() -> bool:
	return _emit_transition(BullState.State.CALM)

func go_alert() -> bool:
	return _emit_transition(BullState.State.ALERT)

func go_escaped() -> bool:
	return _emit_transition(BullState.State.ESCAPED)

## Attempts to resolve a lasso throw against this bull. Transitions to CAPTURED on hit.
func attempt_capture(attempt: CaptureAttempt) -> bool:
	if not CaptureResolver.resolve_hit(attempt):
		return false
	return _emit_transition(BullState.State.CAPTURED)

func start_calming() -> bool:
	return _emit_transition(BullState.State.CALMING)

## Called every physics frame while CAPTURED/CALMING.
## [param rope_distance]: current distance between player and bull.
## [param disturbance]: external nerve-raising pressure this frame (0 if none).
func update_hold(delta: float, rope_distance: float, disturbance: float = 0.0) -> void:
	if current_state() != BullState.State.CAPTURED and current_state() != BullState.State.CALMING:
		return

	if rope_distance > _tuning.max_rope_distance:
		_emit_transition(BullState.State.ESCAPED)
		return

	if current_state() == BullState.State.CAPTURED:
		start_calming()

	if disturbance > 0.0:
		_nerves.increase_by(_tuning.disturbance_rate_per_second * delta * disturbance)
	else:
		_nerves.reduce_by(_tuning.calm_rate_per_second * delta)

	nerves_changed.emit(current_nerves())

	if _nerves.is_controlled():
		_emit_transition(BullState.State.CONTROLLED)

func return_to_pen() -> bool:
	return _emit_transition(BullState.State.SAFE)

## Forces a captured/calming/controlled bull to bolt (e.g. player was hit by another wild
## bull and drops what they were holding). No-op if not currently held.
func force_escape() -> bool:
	return _emit_transition(BullState.State.ESCAPED)

## The tranquilizer item: instantly finishes calming a currently-held bull. No-op (false)
## if not currently CAPTURED/CALMING.
func use_tranquilizer() -> bool:
	if current_state() != BullState.State.CAPTURED and current_state() != BullState.State.CALMING:
		return false
	if current_state() == BullState.State.CAPTURED:
		start_calming()
	_nerves.force_calm()
	nerves_changed.emit(current_nerves())
	return _emit_transition(BullState.State.CONTROLLED)
