extends CharacterBody2D
## Ranch rider for the open-world test: movement, gaits and horse art.
## Lasso is the shared LassoController (same as the corral); stun uses the
## same API and rules as the corral rider.

signal stunned

const ART_ROOT: String = "res://art/player/"
const ANIM_NAMES: Array = ["idle", "walk_side", "walk_up", "walk_down", "walk_diag_down", "walk_diag_up"]

var max_speed: float = 260.0
var acceleration: float = 900.0
var friction: float = 700.0
var gait: int = WorldGait.PASO
var gait_cap: int = WorldGait.GALOPE  # stamina caps this; the world sets it

## Regate in the open world (Ant, 7-nov-2026 16:21): quick dash in the current
## direction with the dodge trail (estela), same feel as the corral dodge.
const DODGE_SECONDS: float = 0.18
const DODGE_SPEED_FACTOR: float = 2.2
var dodge_recharge_seconds: float = 2.5
var dodge_cooldown: float = 0.0
var _dodge_remaining: float = 0.0
var _dodge_direction: Vector2 = Vector2.ZERO
var _skid_trail: Array[Vector2] = []
var _trail_fade: float = 0.0
## Stun: same API, duration and red-tint fallback as the corral rider.
const STUN_SECONDS: float = 2.0
var stun_resistance_multiplier: float = 1.0
var _stun_time_remaining: float = 0.0
var _sprite_swap: SpriteSwap
var lasso: LassoController = null

func _ready() -> void:
	lasso = LassoController.new()
	lasso.throw_guard = func() -> bool: return _stun_time_remaining <= 0.0 and is_physics_processing()
	add_child(lasso)
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
	_sprite_swap = SpriteSwap.new(self, placeholder, HatAppearance.art_root(SaveData.hat_color), ANIM_NAMES)
	var horse: Dictionary = SaveData.horse_collection.find(SaveData.horse_collection.selected)
	if not horse.is_empty():
		max_speed = HorseStats.read(horse).speed
		if _sprite_swap.has_sprite():
			HorseAppearance.apply(_sprite_swap._frames, horse.traits)
	_sprite_swap.play("idle")

func stun(duration: float = STUN_SECONDS) -> void:
	if _stun_time_remaining <= 0.0:
		stunned.emit()
	_stun_time_remaining = maxf(_stun_time_remaining, duration * stun_resistance_multiplier)
	modulate = Color(1.0, 0.5, 0.5, 1.0)  # no stun art in the world yet: corral's red-tint fallback

func calm() -> float:
	var horse: Dictionary = SaveData.horse_collection.find(SaveData.horse_collection.selected)
	return HorseStats.read(horse).calm if not horse.is_empty() else 1.0

func request_dodge(direction: Vector2) -> bool:
	if _dodge_remaining > 0.0 or dodge_cooldown > 0.0 or direction.length() < 0.2:
		return false
	_dodge_direction = direction.normalized()
	_dodge_remaining = DODGE_SECONDS
	dodge_cooldown = dodge_recharge_seconds
	_skid_trail.clear()
	_skid_trail.append(global_position)
	_trail_fade = 0.7
	return true

func _physics_process(delta: float) -> void:
	lasso.process_throw_input(delta)
	dodge_cooldown = maxf(0.0, dodge_cooldown - delta)
	if _dodge_remaining > 0.0:
		_dodge_remaining -= delta
		velocity = _dodge_direction * max_speed * DODGE_SPEED_FACTOR
		move_and_slide()
		_skid_trail.append(global_position)
		_update_animation(delta)
		return
	if _trail_fade > 0.0:
		_trail_fade = maxf(0.0, _trail_fade - delta)
		if _trail_fade <= 0.0:
			_skid_trail.clear()
	if _stun_time_remaining > 0.0:
		_stun_time_remaining -= delta
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		move_and_slide()
		if _stun_time_remaining <= 0.0:
			modulate = Color.WHITE
		_update_animation(delta)
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

func _update_animation(delta: float) -> void:
	if _sprite_swap == null or not _sprite_swap.has_sprite():
		return
	if velocity.length() < 12.0:
		_sprite_swap.stop_on_idle()
		_sprite_swap.set_gait_pose(Vector2.ZERO, delta, false)
		return
	var facing: Array = SpriteSwap.direction_suffix(velocity)
	_sprite_swap.play("walk_" + facing[0])
	_sprite_swap.set_flip_h(facing[1])
	_sprite_swap.set_motion_speed(velocity.length(), max_speed / WorldGait.pace_for(gait))
	_sprite_swap.set_gait_pose(WorldGait.pose_for(gait), delta, true)
