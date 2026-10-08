class_name LassoAim
extends RefCounted

## Application layer: how the aim stick vector becomes a throw (D037). Pure, no nodes.

## Release with a stick vector shorter than this = cancel the throw (no lasso spent).
## Matches the InputMap deadzone of the aim_* actions (0.2): below it the charge line is
## already zero-length, so "nothing is extending" and "release cancels" always agree.
const CANCEL_THRESHOLD: float = 0.2

## A tap = press and release in (almost) the same spot, quickly. Two quick taps on the aim stick
## drop the most recently captured bull (D038).
const TAP_MAX_SECONDS: float = 0.3
const DOUBLE_TAP_WINDOW_SECONDS: float = 0.4

static func is_tap(stick_vector: Vector2, press_duration_seconds: float) -> bool:
	return is_cancel(stick_vector) and press_duration_seconds <= TAP_MAX_SECONDS

static func is_cancel(stick_vector: Vector2) -> bool:
	return stick_vector.length() < CANCEL_THRESHOLD

## Linear stick-to-range mapping; the stick vector is already in [0, 1] but is clamped anyway.
static func throw_distance(stick_vector: Vector2, max_distance: float) -> float:
	return minf(stick_vector.length(), 1.0) * max_distance
