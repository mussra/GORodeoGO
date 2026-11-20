extends Control
func shot323(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/'+name_+'.png')
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true;SaveData.save_path='user://qa323-bull-only.cfg'
 var practice:=BullTutorial323.new();practice.onboarding323=true;add_child(practice)
 await get_tree().create_timer(2.).timeout;await shot323('tutorial323-bull-approach')
 touch323(Vector2(150,490),true,0);await get_tree().process_frame
 var move:=InputEventScreenDrag.new();move.index=0;move.position=Vector2(220,490);move.relative=Vector2(70,0);Input.parse_input_event(move)
 await get_tree().create_timer(1.35).timeout;touch323(move.position,false,0)
 await get_tree().create_timer(.3).timeout
 var distance_:float=practice.player.position.distance_to(practice.bull.position)
 touch323(Vector2(890,490),true,1);await get_tree().process_frame
 var drag:=InputEventScreenDrag.new();drag.index=1;drag.position=Vector2(890+distance_/220.*70.,490);drag.relative=Vector2(distance_/220.*70.,0);Input.parse_input_event(drag)
 await get_tree().create_timer(1.5).timeout;await shot323('tutorial323-bull-aim')
 touch323(drag.position,false,1)
 await get_tree().create_timer(.6).timeout
 await get_tree().create_timer(.8).timeout;await shot323('tutorial323-bull-tow')
 Input.action_press('move_right');await get_tree().create_timer(2.).timeout;Input.action_release('move_right')
 await get_tree().create_timer(1.).timeout;await shot323('tutorial323-bull-target')
 touch323(Vector2(900,490),true,1);await get_tree().process_frame;touch323(Vector2(900,490),false,1)
 await get_tree().create_timer(.12).timeout
 touch323(Vector2(900,490),true,1);await get_tree().process_frame;touch323(Vector2(900,490),false,1)
 await get_tree().create_timer(1.).timeout;await shot323('tutorial323-bull-done')
 print('BULL_QA_STEP=',practice.step323,' POSITION=',practice.bull.position)
 practice._finish323();await get_tree().process_frame
 var menu=load('res://src/Presentation/main_menu.tscn').instantiate();SaveData.story_intro319=true;GameState.rodeo_guide323=false;add_child(menu)
 await get_tree().create_timer(1.).timeout;await shot323('tutorial323-menu');menu._show_practice323()
 await get_tree().create_timer(.5).timeout;await shot323('tutorial323-catalog');get_tree().quit()

func touch323(pos:Vector2,down:bool,index_:int):
 var event:=InputEventScreenTouch.new();event.index=index_;event.position=pos;event.pressed=down;Input.parse_input_event(event)
