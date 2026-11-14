extends Node2D
## Isolated best-of-three. No save, economy, rewards or horse mutation.
var course:=RaceCourse190.new()
var riders:Array[DuelRider193]=[]
var player:DuelRider193
var running:bool=false
var countdown:float=3.
var elapsed:float=0.
var scores:Array[int]=[0,0]
var round_number:int=1
var pending:Array[int]=[]
var capture_frame:int=-1
var finished:bool=false
var info:Label
var guidance:Label
var result:Panel
var result_text:Label
var next_button:Button
var pause_panel:Panel
var hud:Control
var aim_joystick:VirtualJoystick
var controls:CanvasLayer
func _ready()->void:
 process_physics_priority=50
 RanchMusic.play_context("world")
 for index in 2:
  var rider:=DuelRider193.new();rider.race=self;rider.ai=index==1;rider.racer_index=index;rider.racer_name="Tú" if index==0 else "Luna";rider.tint=Color("7de1cc") if index==0 else Color("ffb473")
  add_child(rider);riders.append(rider)
 player=riders[0]
 var camera:=Camera2D.new();camera.position=Vector2(0,-20);camera.zoom=Vector2.ONE*.88;add_child(camera)
 var sound:=RanchAudio.new();sound.enabled=GameState.sound_enabled;add_child(sound)
 player.lasso.lasso_released.connect(func():sound.play("throw"))
 player.dodge.dodge_started.connect(func():sound.play("dodge"))
 var layer:=CanvasLayer.new();layer.layer=20;add_child(layer)
 hud=Control.new();hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);hud.mouse_filter=Control.MOUSE_FILTER_IGNORE;hud.theme=RanchTheme.create();layer.add_child(hud)
 info=_label(hud,"",Vector2(18,12),24);info.size=Vector2(1070,72);ToastStack.backdrop(info)
 guidance=_label(hud,"",Vector2.ZERO,20);guidance.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE);guidance.offset_top=-52.;guidance.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;ToastStack.backdrop(guidance)
 var pause:=_button(hud,"Pausa",Vector2.ZERO,_pause);pause.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT);pause.offset_left=-130.;pause.offset_top=12.;pause.offset_right=-16.;pause.offset_bottom=58.
 result=_panel(Vector2(650,330));result_text=_label(result,"",Vector2(26,24),25);result_text.size=Vector2(600,180);TextFit181.fixed(result_text,Vector2(600,180),25,20,5)
 next_button=_button(result,"Siguiente manga",Vector2(26,248),_next_round);next_button.size.x=280.
 _button(result,"Menú",Vector2(345,248),_menu);result.hide()
 pause_panel=_panel(Vector2(650,260));pause_panel.process_mode=Node.PROCESS_MODE_ALWAYS
 _label(pause_panel,"DUELO EN PAUSA",Vector2(26,24),26)
 _button(pause_panel,"Continuar",Vector2(26,110),_resume);_button(pause_panel,"Menú",Vector2(345,110),_menu);pause_panel.hide()
 _reset_round();queue_redraw()
func _label(parent:Control,text:String,at:Vector2,font:int)->Label:
 var label:=Label.new();label.text=text;label.position=at;label.add_theme_font_size_override("font_size",font);label.mouse_filter=Control.MOUSE_FILTER_IGNORE;parent.add_child(label);return label
func _button(parent:Control,text:String,at:Vector2,action:Callable)->Button:
 var button:=Button.new();button.text=text;button.position=at;button.size=Vector2(270,56);button.pressed.connect(action);parent.add_child(button);return button
func _panel(extent:Vector2)->Panel:
 var panel:=Panel.new();panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER);panel.position=-extent*.5;panel.size=extent;hud.add_child(panel);return panel
func _reset_round()->void:
 running=false;countdown=3.;elapsed=0.;pending.clear();capture_frame=-1;result.hide()
 for i in 2:
  var rider:DuelRider193=riders[i];rider.cancel_input();rider.position=Vector2((-360. if i==0 else 360.)*(-1. if round_number%2==0 else 1.),0);rider.attack_cooldown=0.;rider.attack_think=.7;rider.dodge.cooldown=0.;rider.finish_time=-1.
 _reset_controls()
 _refresh()
func _next_round()->void:
 if finished:get_tree().reload_current_scene();return
 if pending.size()!=2:round_number+=1
 _reset_round()
func _physics_process(delta:float)->void:
 if capture_frame>=0 and Engine.get_physics_frames()>capture_frame:_resolve_round()
 if result.visible:return
 if countdown>0.:
  countdown=maxf(0.,countdown-delta)
  if countdown<=0.:running=true
 if running:elapsed+=delta
 _refresh()
func _refresh()->void:
 info.text="DUELO DE LAZOS · %d - %d · mejor de tres\nManga %d · primer lazo válido gana · sin daño"%[scores[0],scores[1],round_number]
 guidance.text="PREPARADOS · %d"%ceili(countdown) if countdown>0. else "Mueve izquierda · apunta y suelta derecha · doble toque al mover: regate"
func targets_for(attacker:Node2D)->Array:
 var opponent:Node2D=riders[1] if attacker==riders[0] else riders[0]
 return [opponent] if running and attacker.position.distance_to(opponent.position)<=220. else []
func capture_landed(target:Node2D)->void:
 if not running:return
 var winner:int=1 if target==riders[0] else 0
 if not pending.has(winner):pending.append(winner)
 if capture_frame<0:capture_frame=Engine.get_physics_frames()
func _resolve_round()->void:
 running=false;capture_frame=-1
 for rider in riders:rider.cancel_input()
 _clear_actions()
 if is_instance_valid(controls):controls.hide()
 if pending.size()==1:scores[pending[0]]+=1
 finished=scores[0]>=2 or scores[1]>=2
 var title:String="Impactos simultáneos · repetimos sin punto" if pending.size()==2 else ("¡Manga para ti!" if pending[0]==0 else "Luna gana la manga")
 if finished:title="¡Has ganado el duelo!" if scores[0]>=2 else "Luna gana el duelo"
 result_text.text=title+"\n\nTú %d - %d Luna\nSin premios ni cambios en tus caballos."%[scores[0],scores[1]]
 next_button.text="Repetir duelo" if finished else "Repetir manga" if pending.size()==2 else "Siguiente manga"
 result.show();_refresh()
func _clear_actions()->void:
 for action in ["move_left","move_right","move_up","move_down","aim_left","aim_right","aim_up","aim_down","throw_lasso"]:Input.action_release(action)
func _reset_controls()->void:
 if is_instance_valid(controls):controls.free()
 _clear_actions()
 controls=load("res://src/Presentation/touch_controls.tscn").instantiate();add_child(controls)
 var move:VirtualJoystick=controls.get_node("MoveJoystick");move.anchor_top=.4
 aim_joystick=controls.get_node("AimJoystick");aim_joystick.anchor_top=.4
 player.lasso.set_aim_joystick(aim_joystick);player.dodge.set_move_joystick(move);JoystickAppearance.apply(self)
func _pause()->void:
 if result.visible:return
 player.cancel_input();_clear_actions();controls.hide();get_tree().paused=true;pause_panel.show()
func _resume()->void:
 get_tree().paused=false;pause_panel.hide();_reset_controls()
func navigate_back()->void:
 if pause_panel.visible:_resume()
 elif result.visible:_menu()
 else:_pause()
func _unhandled_input(event:InputEvent)->void:
 if event.is_action_pressed("ui_cancel"):navigate_back();get_viewport().set_input_as_handled()
func _menu()->void:
 get_tree().paused=false;get_tree().change_scene_to_file("res://src/Presentation/main_menu.tscn")
func _exit_tree()->void:
 get_tree().paused=false;Engine.time_scale=1.
 for rider in riders:
  if is_instance_valid(rider):rider.cancel_input()
 for action in ["move_left","move_right","move_up","move_down","aim_left","aim_right","aim_up","aim_down","throw_lasso"]:Input.action_release(action)
func _draw()->void:
 draw_rect(Rect2(-2000,-2000,4000,4000),Color("426443"))
 draw_style_box(RanchTheme.box(Color("d4b780"),Color("80633c"),50),Rect2(-580,-300,1160,600))
 draw_rect(Rect2(-540,-260,1080,520),Color("e0c696"),false,5.)
 for i in 36:
  var p:=Vector2(sin(i*27.4)*500.,sin(i*8.1)*225.)
  draw_line(p,p+Vector2(12,2),Color("c8ac77"),2.,true)
 var barrel:Texture2D=RaceScenery191.BARREL
 for x in [-600.,600.]:
  for y in [-280.,280.]:AntIcons188.draw_texture_fit(self,barrel,Rect2(Vector2(x-20,y-45),Vector2(40,55)))
 draw_arc(Vector2.ZERO,125.,0,TAU,64,Color("f5dfaf"),3.,true)
