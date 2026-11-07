class_name LassoGesture
extends RefCounted

## Application layer: the ONE aim-stick gesture state machine for the lasso,
## shared verbatim by the corral (player.gd) and the open world
## (frontier_world.gd) — Ant 07-nov 18:17: "Asegura que es el mismo código.
## No una copia." Pure logic, no nodes: press timing, tap vs drag, cancel
## threshold and double-tap detection. Each mode decides what the outcomes
## MEAN (rope a bull vs a wild horse, drop the held capture, ...).

enum Action { NONE, CANCEL, THROW }

var _pressed_at_seconds: float = -1.0
var _double_tap: DoubleTapDetector = DoubleTapDetector.new(LassoAim.DOUBLE_TAP_WINDOW_SECONDS)

## Records the stick press; call when the aim stick is pressed.
func press(now_seconds: float) -> void:
	_pressed_at_seconds = now_seconds

## Interprets a stick release. `charging` = a throw was being charged.
## Returns a Dictionary:
## - double_tap (bool): two quick taps → drop the held capture (D038). It can
##   coincide with action == CANCEL: a tap while charging also cancels it.
## - action (Action): THROW when released with the stick beyond the cancel
##   zone, CANCEL when released near the centre (D037), NONE without a charge.
## - distance (float): throw distance for THROW (LassoAim.throw_distance).
func release(input_vector: Vector2, now_seconds: float, charging: bool, max_throw_distance: float) -> Dictionary:
	var double_tap := false
	if LassoAim.is_tap(input_vector, now_seconds - _pressed_at_seconds):
		double_tap = _double_tap.register_tap(now_seconds)
	else:
		_double_tap.reset()
	var action := Action.NONE
	var distance := 0.0
	if charging:
		if LassoAim.is_cancel(input_vector):
			action = Action.CANCEL
		else:
			action = Action.THROW
			distance = LassoAim.throw_distance(input_vector, max_throw_distance)
	return {"double_tap": double_tap, "action": action, "distance": distance}

## Forgets any pending tap (stun / external input cancellation).
func reset() -> void:
	_double_tap.reset()
