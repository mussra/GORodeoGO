extends CharacterBody2D
## Ranch rider for the open-world test: movement, gaits and horse art.
## Lasso is the shared LassoController and dodge/regate the shared
## DodgeController + DodgeVisuals (exactly the corral's gesture, bullet-time,
## trail and recharge bar — Ant: mismo codigo); stun uses the same API and
## rules as the corral rider.

signal jump_started
signal jump_finished
var drink:HorseDrink
var can_jump:bool=false
var world_bounds:Rect2=Rect2(-1000000,-1000000,2000000,2000000)
var _jump_time:float=0
var _jump_direction:Vector2=Vector2.RIGHT
var _jump_mask:int=0
var _jump_z:int=0
var _jump_from:Vector2
var _jump_sprite_base:Vector2
var _jump_sprite_scale:Vector2=Vector2.ONE
var _jump_cooldown:float=0
var jump_recovery_multiplier:float=1
signal stunned

const ANIM_NAMES: Array = ["idle", "walk_side", "walk_up", "walk_down", "walk_diag_down", "walk_diag_up", "gallop_side", "jump_side", "jump_up", "jump_down", "jump_diag_down", "jump_diag_up"]

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
	collision_mask|=64
	drink=HorseDrink.new(self)
	collision_mask|=HorseJump.FENCE_LAYER
	lasso = LassoController.new()
	lasso.rider_velocity = func()->Vector2:return velocity
	lasso.throw_guard = func() -> bool: return _jump_time<=0 and _stun_time_remaining <= 0.0 and is_physics_processing()
	# Ant 22:55 ("el lazo no vuela en el modo frontera"): the flight rope and the
	# landing flash use WORLD coordinates, so they must hang from the world (like
	# the corral's level), not from the moving rider.
	lasso.rope_parent = func() -> Node: return get_parent()
	add_child(lasso)
	dodge = DodgeController.new()
	dodge.owner_body = self
	dodge.can_start = func() -> bool: return _jump_time<=0 and _stun_time_remaining <= 0.0 and is_physics_processing()
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
	feet.name="CollisionShape2D"
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
	_sprite_swap = SpriteSwap.new(self, placeholder, HatAppearance.art_root(SaveData.hat_color), PixelLabTrial.unreplaced_rider_animations(ANIM_NAMES))
	if not horse.is_empty() and _sprite_swap.has_sprite():
		HorseAppearance.apply(_sprite_swap._frames, horse.traits,horse)
	if _sprite_swap.has_sprite():HatAppearance.apply_classic(_sprite_swap._frames,SaveData.hat_color)
	if _sprite_swap.has_sprite():PixelLabTrial.apply(_sprite_swap._frames,"rider","walk_side",horse.get("traits",{}),horse)
	if not horse.is_empty():
		max_speed = HorseStats.read(horse).speed
	if _sprite_swap.has_sprite():
		WorldActorScale.rider(_sprite_swap._sprite)
		_sprite_swap._sprite.offset.y-=44.0/_sprite_swap._sprite.scale.y  # visual hooves share physics/y-sort origin
	_sprite_swap.play("idle")

func stun(duration: float = STUN_SECONDS) -> void:
	if drink!=null:drink.stop()
	if _jump_time>0:HorseJumpMotion.finish(self,true)
	if _stun_time_remaining <= 0.0:
		stunned.emit()
	_stun_time_remaining = maxf(_stun_time_remaining, duration * stun_resistance_multiplier)
	modulate = Color(1.0, 0.5, 0.5, 1.0)  # no stun art in the world yet: corral's red-tint fallback
	dodge.cancel()
	lasso.cancel_input()  # cancel held aim, but let an already thrown rope land
	queue_redraw()

func calm() -> float:
	var horse: Dictionary = SaveData.horse_collection.find(SaveData.horse_collection.selected)
	return HorseStats.read(horse).calm if not horse.is_empty() else 1.0

func _input(event: InputEvent) -> void:
	dodge.handle_input(event)

func request_dodge(direction: Vector2) -> bool:
	if drink!=null:drink.stop()
	return dodge.request_dash(direction)

func request_dodge_path(points: PackedVector2Array) -> bool:
	if drink!=null:drink.stop()
	return dodge.request_path(points)

func _physics_process(delta: float) -> void:
	if drink.step(delta,Input.get_vector("move_left","move_right","move_up","move_down")):return
	_jump_cooldown=maxf(0,_jump_cooldown-delta)
	if _jump_time>0:HorseJumpMotion.process(self,delta);return
	if can_jump and velocity.length()>60 and HorseJumpMotion.try_ahead(self):return
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
		DodgeVisuals.draw_recharge(self, Vector2(0, -110), 1.0 - dodge.cooldown / maxf(0.01, dodge.recharge_seconds))
	if dodge.remaining > 0.0:
		DodgeVisuals.draw_dash_dust(self, dodge.direction)
	# Charge-aim circle: shared with the corral rider (Ant 21:47, it was missing here).
	lasso.draw_charge_aim(self)

func _update_animation(delta: float) -> void:
	if _sprite_swap == null:return
	RiderGaitVisual.apply(_sprite_swap,velocity,max_speed,gait,delta)

func request_jump(direction:Vector2)->bool:return HorseJumpMotion.request(self,direction)
func cancel_input()->void:
	if drink!=null:drink.stop()
	if _jump_time>0:HorseJumpMotion.finish(self,true)
	lasso.cancel_all_actions();dodge.cancel();velocity=Vector2.ZERO
