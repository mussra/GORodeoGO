extends Node
func _ready():run.call_deferred()
func shot325(label:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/familiarization325-'+label+'.png')
func touch325(at:Vector2,down:bool,index_:int):
 var e=InputEventScreenTouch.new();e.index=index_;e.position=at;e.pressed=down;Input.parse_input_event(e)
func run():
 get_tree().root.size=Vector2i(1600,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true;SaveData.story_intro319=true;SaveData.save_path='user://qa325-visual-only.cfg'
 var menu=load('res://src/Presentation/main_menu.tscn').instantiate();add_child(menu);await get_tree().create_timer(.8).timeout
 var demo=PracticeCatalog323.show323(menu,'bull');await get_tree().create_timer(.7).timeout
 await shot325('start')
 touch325(Vector2(180,540),true,0);await get_tree().process_frame
 var drag=InputEventScreenDrag.new();drag.index=0;drag.position=Vector2(230,540);Input.parse_input_event(drag)
 await get_tree().create_timer(.4).timeout
 touch325(Vector2(1150,530),true,1);await get_tree().process_frame
 drag=InputEventScreenDrag.new();drag.index=1;drag.position=Vector2(1220,530);Input.parse_input_event(drag)
 await get_tree().create_timer(.2).timeout;await shot325('two-fingers')
 touch325(Vector2(230,540),false,0);touch325(Vector2(1220,530),false,1)
 await get_tree().create_timer(.5).timeout
 demo.level325._on_bull_returned(demo.level325._active_bulls[0]);await get_tree().create_timer(.6).timeout;await shot325('complete')
 demo._finish323();await get_tree().create_timer(.2).timeout;get_tree().quit()
