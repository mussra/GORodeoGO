extends Node2D
## A wild pig in the frontier, using Ant's supplied pink/brown running sprites.
## Idle/tired are still frames until separate animations are supplied.
##
## Chase mode: flee, keep the rider moving while roped, tire, then capture.
## The optional old walk-up mode still holds the pig in place. Rope visuals
## are shared HeldVisuals; no collision blocks the rider.

## Contact radii mirror the corral (bull.hit_radius + bull.PLAYER_TOUCH_RADIUS).
const BODY_RADIUS: float = 28.0
const RIDER_TOUCH_RADIUS: float = 18.0
## A just-released pig can't stun the rider who let it go (corral D038 grace).
const RELEASE_TOUCH_GRACE_SECONDS: float = 1.0

var pen: Dictionary = {}
var state: Dictionary = {}
## Roped by the rider's lasso: stays in place while trust fills; when the
## timer runs out it counts as captured (or bolts if released first).
var roped: bool = false
var rider: Node2D = null
## Seconds left roped; while > 0 the pig cannot flee.
var held: float = 0.0
var touch_grace: float = 0.0
var _touching_rider: bool = false
var home: Vector2 = Vector2.ZERO
var flip_h: bool = false
var _art:WildPigArt

func setup(p_pen: Dictionary) -> void:
	pen = p_pen
	state = WorldPigs.new_chase_state() if WorldPigs.CHASE_MODE else WorldPigs.new_state()
	home = pen.get("pos", Vector2.ZERO)

func _ready() -> void:
	position = home
	_art=WildPigArt.new()
	_art.variant="brown" if (int(absf(home.x)*31+absf(home.y)*17)%2)==1 else "pink"
	add_child(_art)

func _process(delta: float) -> void:
	if is_instance_valid(_art):_art.update_state(bool(state.get("flee",false)),bool(state.get("tired",false)),flip_h)
	touch_grace = maxf(0.0, touch_grace - delta)
	if roped:
		# Roped: stays in place while the hold timer runs (no tow, Ant 21:47).
		held = maxf(0.0, held - delta)
	queue_redraw()

## The rider drops the rope (double tap or a stun): the pig bolts, keeping the
## trust it had — same transition as the corral's release_by_player (D027).
func release() -> void:
	roped = false
	rider = null
	held = 0.0
	touch_grace = RELEASE_TOUCH_GRACE_SECONDS
	_touching_rider = false

func flee_from(from: Vector2, delta: float, speed: float = 170.0) -> void:
	var away: Vector2 = position - from
	if away.length() < 1.0:
		away = Vector2.RIGHT
	var target: Vector2 = position + away.normalized() * speed * delta
	if home.distance_to(target) < WorldPigs.FLEE_LEASH:
		position = target
	flip_h = away.x < 0.0

func face_towards(point: Vector2) -> void:
	flip_h = point.x < position.x

func _draw() -> void:
	# Rope visuals identical to a held corral bull; while trust builds unroped
	# (walk-up capture) the same trust bar shows progress.
	if roped and is_instance_valid(rider):
		HeldVisuals.draw_hold(self, rider.global_position, float(state.get("progress", 0.0)), false)
	else:
		var progress: float = float(state.get("progress", 0.0))
		if progress > 0.01:
			HeldVisuals.draw_progress(self, progress)

## Same capture rule as the corral bulls (Ant: mismo codigo): the LassoController
## resolves nearest-first and each prey accepts landings within body + tolerance.
func try_capture(landing_point: Vector2) -> bool:
	if roped:
		return false
	return global_position.distance_to(landing_point) <= LassoController.PREY_HIT_RADIUS + LassoController.PREY_CAPTURE_TOLERANCE
