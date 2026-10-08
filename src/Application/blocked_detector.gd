class_name BlockedDetector
extends RefCounted

## Application layer: detects "tried to move but could not" over time (D036). Fed every
## physics frame with the distance a body INTENDED to cover and the distance it ACTUALLY
## covered. Pure, no nodes.

var _blocked_seconds_threshold: float
var _progress_ratio: float
var _blocked_for: float = 0.0

## [param progress_ratio]: actual/intended below this counts as "not making progress".
func _init(blocked_seconds_threshold: float, progress_ratio: float) -> void:
	_blocked_seconds_threshold = blocked_seconds_threshold
	_progress_ratio = progress_ratio

func reset() -> void:
	_blocked_for = 0.0

## Returns true once, when the continuous blocked time reaches the threshold (then restarts).
func update(delta: float, intended_distance: float, actual_distance: float) -> bool:
	if intended_distance <= 0.0 or actual_distance >= intended_distance * _progress_ratio:
		_blocked_for = 0.0
		return false
	_blocked_for += delta
	if _blocked_for >= _blocked_seconds_threshold:
		_blocked_for = 0.0
		return true
	return false
