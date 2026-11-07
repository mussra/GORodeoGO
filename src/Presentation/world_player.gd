extends CharacterBody2D
## Ranch rider for the open-world test: movement and horse art only.
## Lasso, dodge and jump stay in the corral levels.

const ART_ROOT: String = "res://art/player/"
const ANIM_NAMES: Array = ["idle", "walk_side", "walk_up", "walk_down", "walk_diag_down", "walk_diag_up"]

var max_speed: float = 260.0
var acceleration: float = 900.0
var friction: float = 700.0
var _sprite_swap: SpriteSwap

func _ready() -> void:
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

func _physics_process(delta: float) -> void:
	var wish := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if wish.length() > 0.1:
		velocity = velocity.move_toward(wish.normalized() * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()
	_update_animation()

func _update_animation() -> void:
	if _sprite_swap == null or not _sprite_swap.has_sprite():
		return
	if velocity.length() < 12.0:
		_sprite_swap.stop_on_idle()
		return
	var facing: Array = SpriteSwap.direction_suffix(velocity)
	_sprite_swap.play("walk_" + facing[0])
	_sprite_swap.set_flip_h(facing[1])
	_sprite_swap.set_motion_speed(velocity.length(), max_speed)
