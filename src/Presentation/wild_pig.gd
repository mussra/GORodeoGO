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
var _wall249:Dictionary={}
var _flip_pending249:float=0.
var movement:Vector2=Vector2.RIGHT
var _art:WildPigArt

func setup(p_pen: Dictionary) -> void:
	pen = p_pen
	state = WorldPigs.new_chase_state() if WorldPigs.CHASE_MODE else WorldPigs.new_state()
	home = pen.get("pos", Vector2.ZERO)

func _ready() -> void:
	add_to_group("scare_animals265")
	position = home
	road_provider94=WorldWildRoads94.provider(self)
	WorldWildRoads94.bind_spawn(self,road_provider94)
	_art=WildPigArt.new()
	_art.variant="pink"  # Brown pigs cancelled until further notice.
	add_child(_art)

func _process(delta: float) -> void:
	_tick_scare265(delta)
	_settle_offroad95(delta)
	if is_instance_valid(_art):_art.update_state(bool(state.get("flee",false)) and not movement.is_zero_approx(),bool(state.get("tired",false)),flip_h,movement)
	touch_grace = maxf(0.0, touch_grace - delta)
	if roped and not bullet_time_held326():
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
	if scare_left265>0.:from=scare_origin265
	var away: Vector2 = position - from
	if away.length() < 1.0:
		away = Vector2.RIGHT
	# Gentle changes of heading while roped make the rider track the pig.
	if roped:
		var chase_time:float=float(state.get("rope_run",0.0))
		away=away.rotated(sin(chase_time*2.6+home.x*.01)*.7)
	var wanted:Vector2=away.normalized()*speed*delta
	var target:Vector2=_flee_step224(from,wanted,delta)
	_escape_left95=.2 # Genuine flee motion may cross the road.
	movement=(target-position).normalized()
	position = target
	_heading249(movement*speed,delta)

## Keep the same home leash and solid walls. If the direct step is blocked,
## take a legal tangent instead of running forever into the same wall.
func _flee_step224(threat:Vector2,wanted:Vector2,delta:float=1./60.)->Vector2:
	var direct:Vector2=_legal_flee_step224(threat,wanted)
	return WorldEscapeMotion.slide249(position,threat,wanted,direct,func(step:Vector2)->Vector2:return _legal_flee_step224(threat,step),_wall249,delta)
func _legal_flee_step224(threat:Vector2,wanted:Vector2,delta:float=1./60.)->Vector2:
	var target:Vector2=position+wanted
	if not roped:target=WorldEscapeMotion.bounded_step(position,home,threat,wanted,WorldPigs.FLEE_LEASH)
	if WorldFence.crosses(self,target):return position
	if road_provider94.is_valid():target=get_parent().to_local(WorldWildRoads94.terrain_step(self,global_position,get_parent().to_global(target)))
	return target

func face_towards(point: Vector2) -> void:
	if absf(point.x-position.x)>12.:flip_h = point.x < position.x

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
	return global_position.distance_to(landing_point) <= (80.0 if EquipmentEffects.small_lasso257() else LassoController.PREY_HIT_RADIUS + LassoController.PREY_CAPTURE_TOLERANCE)

func _heading249(motion:Vector2,delta:float)->void:
	var desired:bool=WildHeading129.flip(motion,flip_h)
	if desired==flip_h:_flip_pending249=0.;return
	_flip_pending249+=maxf(0.,delta)
	if _flip_pending249>=WildHeading129.VIEW_HOLD:flip_h=desired;_flip_pending249=0.

func small_lasso_target257()->bool:return true

var scare_left265:float=0.
var scare_origin265:Vector2
func scare265(origin:Vector2,seconds:float)->bool:
	if roped:return false
	scare_origin265=origin-global_position+position;scare_left265=seconds
	state.spook=maxf(float(state.get("spook",0.)),seconds);return true
func _tick_scare265(delta:float):
	if scare_left265<=0. or roped:return
	scare_left265=maxf(0.,scare_left265-delta);flee_from(scare_origin265,delta,145. if self.get_script().resource_path.ends_with("wild_goat.gd") else 175.)

func bullet_time_held326()->bool:
	return roped and is_instance_valid(rider) and rider.get('dodge')!=null and rider.dodge.drawing
