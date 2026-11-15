extends Node2D
var player:Node2D
var aim_joystick:VirtualJoystick
func _ready():
 player=load("res://src/Presentation/world_player.gd").new();add_child(player)
 var controls=load("res://src/Presentation/touch_controls.tscn").instantiate();add_child(controls)
 aim_joystick=controls.get_node("AimJoystick");player.dodge.set_move_joystick(controls.get_node("MoveJoystick"));player.lasso.set_aim_joystick(aim_joystick);JoystickAppearance.apply(self)
