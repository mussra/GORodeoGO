extends CharacterBody2D
## A wild horse in the frontier: real riderless sprites (art/world/wild_base),
## deterministic traits from WorldMap, taming driven by WorldTaming. Herd horses
## graze in place; showcase horses (test zone, Ant 7-nov-2026) set wander=true
## to amble around home so the walk gait is visible.
##
## Roped by the lasso it STAYS IN PLACE while trust fills over a few seconds
## and then it is captured (Ant 21:47: "Me gustaba que el caballo no me seguia
## cuando lo tenia con el lazo y al pasar el tiempo ya era capturado"). Rope
## visuals are the shared HeldVisuals. It never blocks the rider (no collision).

const Art := preload("res://src/Presentation/wild_horse_art.gd")

## Contact radii mirror the corral (bull.hit_radius + bull.PLAYER_TOUCH_RADIUS).
const BODY_RADIUS: float = 28.0
const RIDER_TOUCH_RADIUS: float = 18.0
## A just-released horse can't stun the rider who let it go (corral D038 grace).
const RELEASE_TOUCH_GRACE_SECONDS: float = 1.0

var herd: Dictionary = {}
var state: Dictionary = {}
var home: Vector2 = Vector2.ZERO
var wander: bool = false
var wander_radius: float = 70.0
var wander_speed: float = 55.0
## Roped by the rider's lasso: stays in place while trust fills; when the
## timer runs out it is captured (or bolts if released first).
var roped: bool = false

## The sprite stands with its hooves at the node origin (offset -80), so the
## shared hold visuals must lift their anchor to the body or the rope and the
## ring float below the horse (Ant: "el lazo cuando captura no se ve bien").
## Bulls/pigs draw around their origin and keep the default 0.
const ROPE_ANCHOR_Y: float = -55.0
var rider: Node2D = null
## Seconds left roped; while > 0 the horse cannot flee or wander.
var held: float = 0.0
var touch_grace: float = 0.0
## Afinidad genetica (Ant 8-nov 13:33): rasgos visibles compartidos con el
## caballo equipado (0-3); pack_leader_near = el equipado es Lider de manada
## de su tipo. Los actualiza frontier_world cada tick; solo dibuja aqui.
var affinity_matches: int = 0
var pack_leader_near: bool = false
## Jugador cercano para el indicador de afinidad (lo pone frontier_world).
var player_ref: Node2D = null
var _touching_rider: bool = false
var herd_guide:Node2D
var _art: Node2D
var _bob: float = 0.0
var _graze_timer: float = 0.0
var _wander_target: Vector2 = Vector2.ZERO
var _wander_pause: float = 0.0

func setup(p_herd: Dictionary) -> void:
	herd = p_herd
	state = WorldTaming.new_state()
	home = herd.get("pos", Vector2.ZERO)

func _ready() -> void:
	position = home
	var feet := CollisionShape2D.new()
	var fr := RectangleShape2D.new()
	fr.size = Vector2(24, 12)
	feet.shape = fr
	feet.position = Vector2(0, -2)
	add_child(feet)
	# Ant 21:48: bumping into a horse must never block the rider. Taming,
	# capture and the bolting-contact stun are all distance-based, so the
	# body simply doesn't collide.
	collision_layer = 0
	collision_mask = 0
	_art = Art.new()
	_art.traits = herd.get("traits", {})
	add_child(_art)
	_art.scale=Vector2.ONE*float(herd.get("appearance_scale",1.0))
	if wander:
		_pick_wander_target()

func _physics_process(delta: float) -> void:
	_bob += delta
	touch_grace = maxf(0.0, touch_grace - delta)
	if roped:
		# Roped: stays in place while the hold timer runs (no tow, Ant 21:47).
		held = maxf(0.0, held - delta)
		velocity = Vector2.ZERO
		_flee = Vector2.ZERO
		_art.grazing = false
		_art.speed_scale=1.0
		move_and_slide()
		_art.position.y = sin(_bob * 1.6) * 1.5
		queue_redraw()
		return
	if _flee.length() > 0.0:
		var target: Vector2 = position + _flee * delta
		if is_instance_valid(herd_guide) and herd_guide!=self and not herd_guide.roped:
			var gap:Vector2=target-herd_guide.position
			if gap.length()>WorldHerd.COHESION_RADIUS:
				if position.distance_to(herd_guide.position)>WorldHerd.COHESION_RADIUS:
					target=position.move_toward(herd_guide.position,(WorldHerd.PANIC_SPEED+WorldHerd.FOLLOW_CATCHUP)*delta)
				else:target=herd_guide.position+gap.normalized()*WorldHerd.COHESION_RADIUS
			_flee=(target-position)/maxf(delta,.001)
		if (is_instance_valid(herd_guide) and herd_guide!=self) or home.distance_to(target) < WorldTaming.FLEE_LEASH:
			velocity = _flee
		else:
			velocity = Vector2.ZERO
		_flee = Vector2.ZERO
	elif wander:
		_art.speed_scale=1.0
		velocity = _wander_vel(delta)
	else:
		_art.speed_scale=1.0
		velocity = Vector2.ZERO
		_graze_timer -= delta
		if _graze_timer <= 0.0:
			_graze_timer = randf_range(2.0, 5.0)
			_art.grazing = not _art.grazing
	move_and_slide()
	_art.position.y = sin(_bob * 1.6) * 1.5
	queue_redraw()

## Rope visuals identical to a held corral bull; while trust builds unroped
## (walk-up taming) the same trust bar shows progress.
func _draw() -> void:
	if roped and is_instance_valid(rider):
		HeldVisuals.draw_hold(self, rider.global_position, float(state.get("progress", 0.0)), false, ROPE_ANCHOR_Y)
	else:
		var progress: float = float(state.get("progress", 0.0))
		if progress > 0.01:
			HeldVisuals.draw_progress(self, progress, ROPE_ANCHOR_Y)
	_draw_affinity()

## Indicador de afinidad sobre la cabeza: corazon gris (sin rasgos), dorado
## (1), dorado brillante (2), dorado con estrella (3). Corona si el equipado
## es Lider de manada de este tipo. Solo visible a tiro de domesticacion.
func _draw_affinity() -> void:
	if player_ref == null or not is_instance_valid(player_ref):
		return
	if position.distance_to(player_ref.position) > WorldTaming.CALM_RANGE * 2.2:
		return
	var y: float = -100.0
	var color: Color
	match affinity_matches:
		0: color = Color("9a9a9a")
		1: color = Color("d9a441")
		2: color = Color("ffd23d")
		_: color = Color("ffd23d")
	_draw_heart(Vector2(0, y), 5.0, color)
	if affinity_matches >= 3:
		_draw_star(Vector2(12, y - 2), 4.0, Color("fff3b0"))
	if pack_leader_near:
		_draw_crown(Vector2(0, y - 14), Color("ffd23d"))

func _draw_heart(c: Vector2, s: float, color: Color) -> void:
	draw_circle(c + Vector2(-s * 0.45, -s * 0.25), s * 0.55, color)
	draw_circle(c + Vector2(s * 0.45, -s * 0.25), s * 0.55, color)
	draw_colored_polygon(PackedVector2Array([c + Vector2(-s, 0), c + Vector2(s, 0), c + Vector2(0, s * 1.2)]), color)

func _draw_star(c: Vector2, s: float, color: Color) -> void:
	draw_colored_polygon(PackedVector2Array([c + Vector2(0, -s), c + Vector2(s * 0.3, -s * 0.3), c + Vector2(s, 0), c + Vector2(s * 0.3, s * 0.3), c + Vector2(0, s), c + Vector2(-s * 0.3, s * 0.3), c + Vector2(-s, 0), c + Vector2(-s * 0.3, -s * 0.3)]), color)

func _draw_crown(c: Vector2, color: Color) -> void:
	draw_colored_polygon(PackedVector2Array([c + Vector2(-7, 4), c + Vector2(-7, -3), c + Vector2(-3.5, 0), c + Vector2(0, -5), c + Vector2(3.5, 0), c + Vector2(7, -3), c + Vector2(7, 4)]), color)

## The rider drops the rope (double tap or a stun): the horse bolts, keeping
## the trust it had — same transition as the corral's release_by_player (D027),
## including the grace so it can't instantly stun the rider who released it.
func release() -> void:
	roped = false
	rider = null
	held = 0.0
	touch_grace = RELEASE_TOUCH_GRACE_SECONDS
	_touching_rider = false

func _wander_vel(delta: float) -> Vector2:
	if _wander_pause > 0.0:
		_wander_pause -= delta
		_art.grazing = true
		if _wander_pause <= 0.0:
			_pick_wander_target()
		return Vector2.ZERO
	_art.grazing = false
	var to: Vector2 = _wander_target - position
	if to.length() < 6.0:
		_wander_pause = randf_range(1.6, 3.6)
		return Vector2.ZERO
	var step: Vector2 = to.normalized() * wander_speed
	_art.flip_h = step.x < 0.0
	_art.set_walk_direction(step)
	return step

func _pick_wander_target() -> void:
	var a: float = randf() * TAU
	var r: float = randf_range(wander_radius * 0.35, wander_radius)
	_wander_target = home + Vector2(cos(a), sin(a)) * r

var _flee: Vector2 = Vector2.ZERO

## Lider de manada: en vez de huir, el salvaje se acerca despacio al jinete.
func approach(point: Vector2, delta: float) -> void:
	var to: Vector2 = point - position
	if to.length() < 1.0:
		return
	_flee = to.normalized() * 40.0  # reuses the leash-checked movement slot
	_art.flip_h = to.x < 0.0
	_art.grazing = false
	_art.set_walk_direction(to)

func flee_velocity(step:Vector2,panic:bool=false)->void:
	_flee=step
	_art.speed_scale=1.95 if panic else 1.55
	_art.flip_h=step.x<0.0
	_art.grazing=false
	_art.set_walk_direction(step)

func flee_from(from: Vector2, _delta: float) -> void:
	var away: Vector2 = position - from
	if away.length() < 1.0:
		away = Vector2.RIGHT
	_flee = away.normalized() * 230.0
	_art.flip_h = away.x < 0.0
	_art.grazing = false

func face_towards(point: Vector2) -> void:
	_art.flip_h = point.x < position.x

## Same capture rule as the corral bulls (Ant: mismo codigo): the LassoController
## resolves nearest-first and each prey accepts landings within body + tolerance.
func try_capture(landing_point: Vector2) -> bool:
	if roped:
		return false
	return global_position.distance_to(landing_point) <= LassoController.PREY_HIT_RADIUS + LassoController.PREY_CAPTURE_TOLERANCE
