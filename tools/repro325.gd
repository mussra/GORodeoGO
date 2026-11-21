extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1600,720);GameState.brand_intro_played=true;SaveData.story_intro319=true;SaveData.save_path='user://repro325.cfg'
 var menu=load('res://src/Presentation/main_menu.tscn').instantiate();add_child(menu);await get_tree().create_timer(.7).timeout
 var demo=BullTutorial323.new();menu.add_child(demo);await get_tree().create_timer(.5).timeout
 var stick=demo.level325.touch_controls.get_node('MoveJoystick');print('REPRO325 mouse=',stick.mouse_filter,' rect=',stick.get_global_rect(),' process=',demo.level325.player.is_physics_processing())
 var before=demo.level325.player.position
 var e=InputEventScreenTouch.new();e.index=0;e.position=Vector2(150,490);e.pressed=true;Input.parse_input_event(e);await get_tree().process_frame
 var d=InputEventScreenDrag.new();d.index=0;d.position=Vector2(220,490);d.relative=Vector2(70,0);Input.parse_input_event(d)
 await get_tree().create_timer(.5).timeout;print('REPRO325 movement=',demo.level325.player.position-before,' strength=',Input.get_action_strength('move_right'))
 get_tree().quit()
