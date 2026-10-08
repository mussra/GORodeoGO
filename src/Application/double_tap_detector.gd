class_name DoubleTapDetector
extends RefCounted

## Application layer: recognises two taps within a time window (D038). Pure — the caller
## supplies timestamps, so it needs no clock and is deterministic under test.

var _window_seconds: float
var _last_tap_time: float = -INF

func _init(window_seconds: float) -> void:
	_window_seconds = window_seconds

## Returns true when this tap completes a double tap (and then forgets both taps, so a third
## quick tap starts a new pair instead of chaining).
func register_tap(time_seconds: float) -> bool:
	if time_seconds - _last_tap_time <= _window_seconds:
		_last_tap_time = -INF
		return true
	_last_tap_time = time_seconds
	return false

## Anything that is not a tap (a real drag/throw) in between breaks the pair.
func reset() -> void:
	_last_tap_time = -INF
