extends Node2D
## Wild pink pig. Brown appearance cancelled until further notice (10-Nov).
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
## Shared lasso target; chase-mode pigs keep running while roped.
var roped: bool = false
var rider: Node2D = null
## Safety timeout for a rope session.
var held: float = 0.0
var touch_grace: float = 0.0
var _touching_rider: bool = false
var road_provider94:Callable
var _escape_left95:float=0.
func _settle_offroad95(delta:float)->void:
	_escape_left95=maxf(0.,_escape_left95-delta)
	if _escape_left95<=0. and not roped and road_provider94.is_valid() and road_provider94.call(global_position,WorldWildRoads94.FOOTPRINT):
		var safe:Vector2=WorldWildRoads94.clear_spawn(global_position,road_provider94)
		if safe.is_finite():global_position=WorldWildRoads94.terrain_step(self,global_position,global_position.move_toward(safe,100.*delta))

var home: Vector2 = Vector2.ZERO
var flip_h: bool = false
var movement:Vector2=Vector2.RIGHT
var _art:WildPigArt

func setup(p_pen: Dictionary) -> void:
	pen = p_pen
	state = WorldPigs.new_chase_state() if WorldPigs.CHASE_MODE else WorldPigs.new_state()
	home = pen.get("pos", Vector2.ZERO)

func _ready() -> void:
	position = home
	road_provider94=WorldWildRoads94.provider(self)
	WorldWildRoads94.bind_spawn(self,road_provider94)
	_art=WildPigArt.new()
	_art.variant="pink"  # Brown pigs cancelled until further notice.
	add_child(_art)

func _process(delta: float) -> void:
	_settle_offroad95(delta)
	if is_instance_valid(_art):_art.update_state(bool(state.get("flee",false)),bool(state.get("tired",false)),flip_h,movement)
	touch_grace = maxf(0.0, touch_grace - delta)
	if roped:
		# Safety timer. Chase motion is handled by the shared world tick.
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
	# Gentle changes of heading while roped make the rider track the pig.
	if roped:
		var chase_time:float=float(state.get("rope_run",0.0))
		away=away.rotated(sin(chase_time*2.6+home.x*.01)*.7)
	var target: Vector2 = position + away.normalized() * speed * delta
	if not roped:target=WorldEscapeMotion.bounded_step(position,home,from,target-position,WorldPigs.FLEE_LEASH)
	if WorldFence.crosses(self,target):target=position
	_escape_left95=.2 # Genuine flee motion may cross the road.
	target=get_parent().to_local(WorldWildRoads94.terrain_step(self,global_position,get_parent().to_global(target))) if road_provider94.is_valid() else target
	movement=(target-position).normalized()
	position = target
	flip_h = movement.x < 0.0

func face_towards(point: Vector2) -> void:
	flip_h = point.x < position.x

func _draw() -> void:
	AnimalFatigueBar.draw(self,state)
	# Rope visuals identical to a held corral bull; while trust builds unroped
	# (walk-up capture) the same trust bar shows progress.
	if roped and is_instance_valid(rider):
		HeldVisuals.draw_hold(self, rider, float(state.get("progress", 0.0)), false)
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
