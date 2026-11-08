extends CharacterBody2D
## Ranch rider for the open-world test: movement, gaits and horse art.
## Lasso is the shared LassoController and dodge/regate the shared
## DodgeController + DodgeVisuals (exactly the corral's gesture, bullet-time,
## trail and recharge bar — Ant: mismo codigo); stun uses the same API and
## rules as the corral rider.

signal stunned

const ANIM_NAMES: Array = ["idle", "walk_side", "walk_up", "walk_down", "walk_diag_down", "walk_diag_up", "gallop_side"]

var max_speed: float = 260.0
var acceleration: float = 900.0
var friction: float = 700.0
var gait: int = WorldGait.PASO
var gait_cap: int = WorldGait.GALOPE  # stamina caps this; the world sets it

## Stun: same API, duration and red-tint fallback as the corral rider.
const STUN_SECONDS: float = 2.0
var stun_resistance_multiplier: float = 1.0
var _stun_time_remaining: float = 0.0

## The dodge lives in the shared DodgeController; these forwards keep the
## world's HUD, trail drawing and the edge cue working with the corral names.
const DRAW_EDGE_DWELL: float = DodgeController.DRAW_EDGE_DWELL
var dodge: DodgeController = null
var dodge_available: bool:
	get: return false if dodge == null else dodge.available
	set(v): if dodge != null: dodge.available = v
var dodge_recharge_seconds: float:
	get: return 2.5 if dodge == null else dodge.recharge_seconds
	set(v): if dodge != null: dodge.recharge_seconds = v
var dodge_cooldown: float:
	get: return 0.0 if dodge == null else dodge.cooldown
	set(v): if dodge != null: dodge.cooldown = v
var _skid_trail: Array[Vector2]:
	get: return [] if dodge == null else dodge.skid_trail
var _trail_fade: float:
	get: return 0.0 if dodge == null else dodge.trail_fade
var _drawing_dodge: bool:
	get: return false if dodge == null else dodge.drawing
var _draw_edge_elapsed: float:
	get: return 0.0 if dodge == null else dodge.draw_edge_elapsed
var _draw_edge_active: bool:
	get: return false if dodge == null else dodge.draw_edge_active
var _last_pointer: Vector2:
	get: return Vector2.ZERO if dodge == null else dodge.last_pointer
var _draw_heading: Vector2:
	get: return Vector2.ZERO if dodge == null else dodge.draw_heading

var _sprite_swap: SpriteSwap
var lasso: LassoController = null

func _ready() -> void:
	lasso = LassoController.new()
	lasso.throw_guard = func() -> bool: return _stun_time_remaining <= 0.0 and is_physics_processing()
	# Ant 22:55 ("el lazo no vuela en el modo frontera"): the flight rope and the
	# landing flash use WORLD coordinates, so they must hang from the world (like
	# the corral's level), not from the moving rider.
	lasso.rope_parent = func() -> Node: return get_parent()
	add_child(lasso)
	dodge = DodgeController.new()
	dodge.owner_body = self
	dodge.can_start = func() -> bool: return _stun_time_remaining <= 0.0 and is_physics_processing()
	dodge.resumed = func(dir: Vector2) -> void: velocity = dir * max_speed
	dodge.on_moved = func() -> void:
		_update_animation(get_physics_process_delta_time())
		queue_redraw()
	add_child(dodge)
	var cue_layer := CanvasLayer.new()
	cue_layer.layer = 16
	add_child(cue_layer)
	var cue := DodgeEdgeCue.new()
	cue.player = self
	cue_layer.add_child(cue)
	var feet := CollisionShape2D.new()
	var fr := RectangleShape2D.new()
	fr.size = Vector2(18, 10)
	feet.shape = fr
	feet.position = Vector2(0, -2)
	add_child(feet)
	var placeholder := Polygon2D.new()
	placeholder.polygon = PackedVector2Array([Vector2(-20, -14), Vector2(20, -14), Vector2(20, 14), Vector2(-20, 14)])
	placeholder.color = Color("c8b994")
	add_child(placeholder)
	var horse: Dictionary = SaveData.horse_collection.find(SaveData.horse_collection.selected)
	# Jinete = el de niveles (Ant 8-nov 18:06): mismo SpriteSwap, mismo arte
	# art/player + sombreros (HatAppearance) y mismo recolor por genotipo
	# (HorseAppearance) que el modo niveles. Una sola base para ambos modos.
	_sprite_swap = SpriteSwap.new(self, placeholder, HatAppearance.art_root(SaveData.hat_color), ANIM_NAMES)
	if not horse.is_empty() and _sprite_swap.has_sprite():
		HorseAppearance.apply(_sprite_swap._frames, horse.traits)
	if not horse.is_empty():
		max_speed = HorseStats.read(horse).speed
	_sprite_swap.play("idle")

func stun(duration: float = STUN_SECONDS) -> void:
	if _stun_time_remaining <= 0.0:
		stunned.emit()
	_stun_time_remaining = maxf(_stun_time_remaining, duration * stun_resistance_multiplier)
	modulate = Color(1.0, 0.5, 0.5, 1.0)  # no stun art in the world yet: corral's red-tint fallback
	dodge.cancel()  # same as the corral's cancel_input on stun

func calm() -> float:
	var horse: Dictionary = SaveData.horse_collection.find(SaveData.horse_collection.selected)
	return HorseStats.read(horse).calm if not horse.is_empty() else 1.0

func _input(event: InputEvent) -> void:
	dodge.handle_input(event)

func request_dodge(direction: Vector2) -> bool:
	return dodge.request_dash(direction)

func request_dodge_path(points: PackedVector2Array) -> bool:
	return dodge.request_path(points)

func _physics_process(delta: float) -> void:
	lasso.process_throw_input(delta)
	dodge.cooldown = maxf(0.0, dodge.cooldown - delta)
	if dodge.fade_trail(delta):
		queue_redraw()
	if _stun_time_remaining > 0.0:
		_stun_time_remaining -= delta
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		move_and_slide()
		if _stun_time_remaining <= 0.0:
			modulate = Color.WHITE
		_update_animation(delta)
		return
	# Dodge branches run in the shared DodgeController (same code as the corral).
	if dodge.drawing:
		dodge.process_drawing(delta / maxf(Engine.time_scale, .01))
		return
	if dodge.step_path(max_speed, delta):
		return
	if dodge.step_coast(max_speed, delta):
		return
	if dodge.step_dash(max_speed, delta):
		return
	var wish := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	gait = mini(WorldGait.update(gait, wish.length()), gait_cap)
	var gait_speed: float = WorldGait.speed_for(gait, max_speed)
	if wish.length() > 0.1:
		velocity = velocity.move_toward(wish.normalized() * gait_speed * clampf(wish.length(), 0.0, 1.0), acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()
	_update_animation(delta)
	queue_redraw()

## Same dodge drawing as the corral rider (DodgeVisuals): trail, bullet-time
## preview, recharge bar and dust.
func _draw() -> void:
	DodgeVisuals.draw_trail(self, dodge.skid_trail, dodge.trail_fade)
	if dodge.drawing:
		DodgeVisuals.draw_drawing(self, dodge.preview_points(dodge.draw_points))
	if dodge_available:
		DodgeVisuals.draw_recharge(self, Vector2(0, -59), 1.0 - dodge.cooldown / maxf(0.01, dodge.recharge_seconds))
	if dodge.remaining > 0.0:
		DodgeVisuals.draw_dash_dust(self, dodge.direction)
	# Charge-aim circle: shared with the corral rider (Ant 21:47, it was missing here).
	lasso.draw_charge_aim(self)

func _update_animation(delta: float) -> void:
	if _sprite_swap == null or not _sprite_swap.has_sprite():
		return
	if velocity.length() < 12.0:
		_sprite_swap.stop_on_idle()
		_sprite_swap.set_gait_pose(Vector2.ZERO, delta, false)
		return
	var facing: Array = SpriteSwap.direction_suffix(velocity)
	# 12-frame gallop art (Ant, 8-nov-2026), side view only for now: diagonal
	# and vertical gallops keep the shared walk art until their own art exists.
	# Its bob is baked into the frames, so the code bob is zeroed for it (no double).
	var anim: String = "walk_" + facing[0]
	if gait == WorldGait.GALOPE and facing[0] == "side" and _sprite_swap.has_animation("gallop_side"):
		anim = "gallop_side"
	_sprite_swap.play(anim)
	_sprite_swap.set_flip_h(facing[1])
	_sprite_swap.set_motion_speed(velocity.length(), max_speed / WorldGait.pace_for(gait))
	var pose: Vector2 = WorldGait.pose_for(gait)
	if anim == "gallop_side":
		pose = Vector2(pose.x, 0.0)
	_sprite_swap.set_gait_pose(pose, delta, true)
