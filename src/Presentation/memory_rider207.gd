extends "res://src/Presentation/world_player.gd"
## Training mount shares the real joystick, art, fence jump and collision code.
func _ready()->void:
 super._ready();can_jump=true;dodge.available=false
 max_speed=240.;world_bounds=Rect2(42,145,1196,520)
func process_lasso_input(_delta:float)->void:pass
func draw_dodge_recharge204()->void:pass
func _physics_process(delta:float)->void:
 super._physics_process(delta)
 position=position.clamp(world_bounds.position,world_bounds.end)
