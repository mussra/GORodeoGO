extends GutTest
class TestHost extends Node:
 var aim_joystick:Control
func after_each():JoystickAppearance.cache.clear()
func test_native_joystick_does_not_generate_unused_textures():
 SaveData.horse_collection.seed_trial()
 var level=TestHost.new();add_child_autofree(level)
 var touch=Node.new();touch.name="TouchControls";level.add_child(touch)
 var move=VirtualJoystick.new();move.name="MoveJoystick";touch.add_child(move)
 var aim=VirtualJoystick.new();touch.add_child(aim);level.aim_joystick=aim
 JoystickAppearance.cache.clear()
 assert_false("joystick_texture" in move)
 JoystickAppearance.apply(level)
 assert_true(JoystickAppearance.cache.is_empty(),"Native UI must not generate discarded art")
 assert_eq(move.get_theme_color("ring_normal_color"),Color.WHITE)
