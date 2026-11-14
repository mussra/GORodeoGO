extends Node2D
const POINTS=[Vector2(350,300),Vector2(870,300),Vector2(350,510),Vector2(870,510)]
const COLORS=[Color("ff8074"),Color("81c9ff"),Color("ffdf78"),Color("a8e792")]
var model:=JumpMemory207.new()
var player:CharacterBody2D
var aim_joystick:VirtualJoystick
var hud:Control
var status:Label
var hint:Label
var action:Button
var replay:Button
var pause_panel:Panel
var controls:CanvasLayer
var sound:RanchAudio
var light:int=-1
var show_clock:float=0.
var show_index:int=0
var jump_from:Vector2
var jump_valid:bool=false
var paused207:bool=false
var map_view:Control
func _ready():
 RanchMusic.play_context("gameplay")
 for point in POINTS:WorldFence.segment(self,point-Vector2(75,0),point+Vector2(75,0),true,true)
 player=load("res://src/Presentation/memory_rider207.gd").new();player.position=Vector2(150,405);add_child(player)
 player.jump_started.connect(func():jump_from=player.position;jump_valid=true)
 player.jump_finished.connect(_landed)
 controls=load("res://src/Presentation/touch_controls.tscn").instantiate();add_child(controls)
 controls.get_node("AimJoystick").hide();aim_joystick=controls.get_node("AimJoystick")
 controls.get_node("MoveJoystick").anchor_top=.24;JoystickAppearance.apply(self)
 sound=RanchAudio.new();sound.enabled=GameState.sound_enabled;add_child(sound)
 var layer:=CanvasLayer.new();layer.layer=20;add_child(layer)
 hud=Control.new();hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);hud.mouse_filter=Control.MOUSE_FILTER_IGNORE;hud.theme=RanchTheme.create();layer.add_child(hud)
 status=Label.new();status.position=Vector2(18,12);status.size=Vector2(1070,82);ModeText203.apply(status,28);hud.add_child(status)
 hint=Label.new();hint.position=Vector2(18,100);hint.size=Vector2(980,58);hint.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;ModeText203.apply(hint,24);hud.add_child(hint)
 action=_button("Comenzar",Vector2(495,626),_action)
 replay=_button("Ver secuencia",Vector2(770,626),_repeat)
 _button("Menú",Vector2(1050,626),_menu).size.x=210
 _button("Pausa",Vector2(1120,16),_pause).size.x=140
 map_view=load("res://src/Presentation/memory_map207.gd").new();map_view.session=self;map_view.position=Vector2(1040,102);map_view.size=Vector2(220,112);hud.add_child(map_view)
 pause_panel=Panel.new();pause_panel.position=Vector2(430,255);pause_panel.size=Vector2(420,180);pause_panel.process_mode=Node.PROCESS_MODE_ALWAYS;hud.add_child(pause_panel)
 var title:=Label.new();title.text="SALTO DE MEMORIA · PAUSA";title.position=Vector2(20,20);title.add_theme_font_size_override("font_size",24);pause_panel.add_child(title)
 var resume:=Button.new();resume.text="Continuar";resume.position=Vector2(70,90);resume.size=Vector2(280,58);pause_panel.add_child(resume);resume.pressed.connect(_resume);pause_panel.hide()
 _refresh()
func _button(text:String,at:Vector2,call:Callable)->Button:
 var button:=Button.new();button.text=text;button.position=at;button.size=Vector2(260,58);hud.add_child(button);button.pressed.connect(call);return button
func _action():
 if model.state=="ready":model.next_round()
 elif model.state=="passed":model.next_round()
 elif model.state=="won":model=JumpMemory207.new();model.next_round()
 else:model.repeat()
 _start_show()
func _repeat():
 if model.sequence.is_empty():return
 model.repeat();_start_show()
func _start_show():
 jump_valid=false;player.cancel_input();player.position=Vector2(150,405);show_index=0;show_clock=-.5;light=-1;_refresh()
func _physics_process(delta:float):
 if model.state=="show":
  show_clock+=delta
  if show_clock>=0.:
   show_index=int(show_clock/1.15)
   if show_index>=model.sequence.size():light=-1;model.begin_input();_refresh()
   else:
    var next:int=model.sequence[show_index] if fmod(show_clock,1.15)<.8 else -1
    if next!=light and next>=0:sound.play("door")
    light=next
 player.set_physics_process(model.state=="ride")
 if model.state!="ride":player.velocity=Vector2.ZERO
 map_view.queue_redraw();queue_redraw()
func _landed():
 if not jump_valid or model.state!="ride":return
 if jump_from.distance_to(player.position)<HorseJump.DISTANCE*.85:jump_valid=false;return
 jump_valid=false
 for i in POINTS.size():
  var point:Vector2=POINTS[i]
  if Geometry2D.segment_intersects_segment(jump_from,player.position,point-Vector2(75,0),point+Vector2(75,0))!=null:
   var state:String=model.land(i);sound.play("lose" if state=="failed" else "win" if state in ["passed","won"] else "capture")
   if state!="ride":player.set_physics_process(false);player.velocity=Vector2.ZERO
   _refresh();return
func _refresh():
 var phase:String={"ready":"Mira, recuerda y salta","show":"OBSERVA · memoriza el orden","ride":"TU TURNO · salto %d de %d"%[model.cursor+1,model.sequence.size()],"failed":"Orden incorrecto · vuelve a intentarlo","passed":"¡Secuencia completada!","won":"¡Seis obstáculos recordados!"}.get(model.state,"")
 status.text="SALTO DE MEMORIA · ronda %d/%d\n%s"%[maxi(1,model.sequence.size()),JumpMemory207.GOAL,phase]
 hint.text="Joystick izquierdo para cabalgar. Acércate de frente a la valla: el caballo salta solo."
 if model.state=="show":hint.text="Mira qué número se ilumina. Después repite los saltos sin pistas."
 if model.state=="ready":hint.text="Cuatro vallas con color y número. Primero mira; después salta en el mismo orden."
 action.visible=model.state in ["ready","failed","passed","won"]
 action.text={"ready":"Comenzar","failed":"Repetir ronda","passed":"Siguiente ronda","won":"Nueva partida"}.get(model.state,"")
 replay.visible=model.state=="ride";controls.visible=model.state=="ride"
 player.set_physics_process(model.state=="ride");queue_redraw()
func _pause():
 jump_valid=false;player.cancel_input();paused207=true;controls.hide();get_tree().paused=true;pause_panel.show()
func _resume():
 get_tree().paused=false;paused207=false;pause_panel.hide();_refresh()
func _menu():get_tree().paused=false;get_tree().change_scene_to_file("res://src/Presentation/main_menu.tscn")
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel"):_pause()
func _draw():
 draw_rect(Rect2(0,0,1280,720),Color("426443"))
 draw_style_box(RanchTheme.box(Color("d4b780"),Color("f3deaa"),30),Rect2(45,178,1185,425))
 for i in POINTS.size():
  var p:Vector2=POINTS[i]
  draw_circle(p,95.,Color(COLORS[i],.48 if light==i else .09))
  draw_arc(p,91.,0,TAU,48,COLORS[i] if light==i else Color(COLORS[i],.4),7. if light==i else 2.,true)
  draw_style_box(RanchTheme.box(COLORS[i] if light==i else Color("102d35"),COLORS[i],8),Rect2(p+Vector2(-23,-72),Vector2(46,42)))
  draw_string(ThemeDB.fallback_font,p+Vector2(-9,-41),str(i+1),HORIZONTAL_ALIGNMENT_LEFT,-1,30,Color("102d35") if light==i else Color("fff8e8"))
