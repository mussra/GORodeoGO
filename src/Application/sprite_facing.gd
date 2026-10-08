class_name SpriteFacing
extends RefCounted

## Application layer: picks a STABLE facing for an animated sprite from a noisy movement
## direction. Near fences/corners the steering direction flips every frame (avoidance fights
## the flee vector), which made the sprite flicker between direction animations. Two guards:
##  - hysteresis: leave the current 45-degree sector only once the direction is clearly
##    outside it (past the sector edge + HYSTERESIS_DEGREES), not the instant it crosses it;
##  - minimum hold: after a change, keep the new sector at least MIN_HOLD_SECONDS.
## Pure, no nodes. The caller feeds a unit-ish direction and a delta; the returned vector is
## the exact centre of the chosen sector, so SpriteSwap.direction_suffix() can never land on
## a sector boundary with it.

const SECTOR_COUNT: int = 8
const HYSTERESIS_DEGREES: float = 12.0
const MIN_HOLD_SECONDS: float = 0.2

var _sector: int = 0
var _has_sector: bool = false
var _hold_left: float = 0.0

## Forget the current facing so the next update snaps straight to the new direction
## (use when the movement mode restarts, e.g. a bull becomes wild again).
func reset() -> void:
	_has_sector = false
	_hold_left = 0.0

func current_sector() -> int:
	return _sector

## Centre direction of the current sector (east = Vector2.RIGHT, y grows downwards).
func facing_direction() -> Vector2:
	return Vector2.from_angle(_sector * _sector_width())

## Feed this frame's movement direction. A (near) zero direction keeps the current facing.
## Returns the stable facing direction.
func update(direction: Vector2, delta: float) -> Vector2:
	_hold_left = maxf(0.0, _hold_left - delta)
	if direction.length_squared() < 0.0001:
		return facing_direction()

	var width: float = _sector_width()
	var angle: float = direction.angle()
	if not _has_sector:
		_sector = _sector_for(angle, width)
		_has_sector = true
		return facing_direction()

	if _hold_left <= 0.0:
		var away: float = absf(angle_difference(_sector * width, angle))
		if away > width * 0.5 + deg_to_rad(HYSTERESIS_DEGREES):
			_sector = _sector_for(angle, width)
			_hold_left = MIN_HOLD_SECONDS
	return facing_direction()

func _sector_width() -> float:
	return TAU / SECTOR_COUNT

func _sector_for(angle: float, width: float) -> int:
	return int(roundf(wrapf(angle, 0.0, TAU) / width)) % SECTOR_COUNT
