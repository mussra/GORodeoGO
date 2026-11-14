extends Node2D
## Isolated test race. Never writes collection, economy, progression or rewards.
const EQUALIZED:bool=true
var course:=RaceCourse190.new(RaceCourse190.selected)
var selector:Panel
var fence_bodies:Array[StaticBody2D]=[]
var riders:Array[RaceRider190]=[]
var player:RaceRider190
var aim_joystick:VirtualJoystick
var camera:Camera2D
var running:bool=false
var countdown:float=3.
var elapsed:float=0.
var hud:Control
var info:Label
var guidance:Label
var toasts:ToastStack
var results:Panel
var map_view:Control
var pause_panel:Panel
var pause_button:Button
var result_text:Label
var _announced:bool=false
func _ready()->void:
 process_physics_priority=50
 RanchMusic.play_context("world")
 var names:Array[String]=["Tú","Luna","Sol","Brisa"]
 var colors:Array[Color]=[Color("7de1cc"),Color("ffb473"),Color("a8b7ff"),Color("f4a3d1")]
 for i in 4:
  var rider:=RaceRider190.new();rider.race=self;rider.ai=i>0;rider.racer_index=i;rider.racer_name=names[i];rider.tint=colors[i];rider.lane=-105.+i*70.
  rider.can_jump=HorseJump.capable(SaveData.horse_collection.find(SaveData.horse_collection.selected))
  if not EQUALIZED:rider.base_pace=HorseStats.read(SaveData.horse_collection.find(SaveData.horse_collection.selected)).speed
  rider.position=course.at(-30.)+course.tangent(-30.).orthogonal()*rider.lane;rider.previous_position=rider.position
  add_child(rider);riders.append(rider)
 for distance in course.fences:
  var point:Vector2=course.at(distance);var side:Vector2=course.tangent(distance).orthogonal()
  fence_bodies.append(WorldFence.segment(self,point-side*175.,point+side*40.))
 player=riders[0]
 camera=Camera2D.new();camera.zoom=Vector2(.7,.7);camera.position_smoothing_enabled=true;camera.position_smoothing_speed=6.;player.add_child(camera)
 var touch:CanvasLayer=load("res://src/Presentation/touch_controls.tscn").instantiate();add_child(touch)
 var move:VirtualJoystick=touch.get_node("MoveJoystick");move.anchor_top=.36
 aim_joystick=touch.get_node("AimJoystick");aim_joystick.anchor_top=.36
 player.lasso.set_aim_joystick(aim_joystick);player.dodge.set_move_joystick(move);JoystickAppearance.apply(self)
 var sound:=RanchAudio.new();sound.enabled=GameState.sound_enabled;add_child(sound)
 player.lasso.lasso_thrown.connect(func(_o,_p):sound.play("throw"))
 player.dodge.dodge_started.connect(func():sound.play("dodge"))
 _build_hud()
 _build_selector()
 if RaceCourse190.start_selected:selector.hide();RaceCourse190.start_selected=false
 info.text="CARRERAS CON LAZO · elige un circuito"
 guidance.text="Vallas con paso lateral · el salto depende de tu caballo"
 toasts.push("Vallas: salta si tu caballo sabe; si no, pasa por el hueco lateral.",4.)
func _build_hud()->void:
 var layer:=CanvasLayer.new();layer.layer=20;add_child(layer)
 hud=Control.new();hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);hud.mouse_filter=Control.MOUSE_FILTER_IGNORE;hud.theme=RanchTheme.create();layer.add_child(hud)
 var top:=Panel.new();top.mouse_filter=Control.MOUSE_FILTER_IGNORE;top.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE);top.offset_bottom=70.;hud.add_child(top)
 info=Label.new();info.position=Vector2(18,8);info.add_theme_font_size_override("font_size",21);hud.add_child(info)
 guidance=Label.new();guidance.add_theme_font_size_override("font_size",17);guidance.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;guidance.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE);guidance.offset_top=-44.;guidance.offset_bottom=-8.;ToastStack.backdrop(guidance);hud.add_child(guidance)
 pause_button=_button(hud,"Pausa",Vector2.ZERO,func():_pause())
 pause_button.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT);pause_button.offset_left=-125.;pause_button.offset_top=12.;pause_button.offset_right=-15.;pause_button.offset_bottom=56.
 map_view=Control.new();map_view.mouse_filter=Control.MOUSE_FILTER_IGNORE;hud.add_child(map_view);map_view.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT);map_view.offset_left=-236.;map_view.offset_top=84.;map_view.offset_right=-16.;map_view.offset_bottom=234.;map_view.draw.connect(_draw_mini)
 toasts=ToastStack.new();toasts.top_offset=78;hud.add_child(toasts)
 pause_panel=_panel(Vector2(560,275));pause_panel.process_mode=Node.PROCESS_MODE_ALWAYS;pause_panel.hide()
 _label(pause_panel,"PAUSA · CARRERAS",Vector2(28,20),25)
 _button(pause_panel,"Continuar",Vector2(28,75),func():get_tree().paused=false;pause_panel.hide())
 _button(pause_panel,"Reintentar",Vector2(28,137),_retry)
 _button(pause_panel,"Menú",Vector2(300,137),_menu)
 results=_panel(Vector2(640,390));results.hide()
 result_text=_label(results,"",Vector2(28,20),24)
 _button(results,"Otra carrera",Vector2(28,310),_retry)
 _button(results,"Menú",Vector2(350,310),_menu)
func _label(host:Control,text:String,at:Vector2,font:int)->Label:
 var label:=Label.new();label.text=text;label.position=at;label.add_theme_font_size_override("font_size",font);label.mouse_filter=Control.MOUSE_FILTER_IGNORE;host.add_child(label);return label
func _button(host:Control,text:String,at:Vector2,action:Callable)->Button:
 var b:=Button.new();b.text=text;b.position=at;b.size=Vector2(230,52);b.pressed.connect(action);host.add_child(b);return b
func _panel(extent:Vector2)->Panel:
 var p:=Panel.new();p.set_anchors_and_offsets_preset(Control.PRESET_CENTER);p.position=-extent*.5;p.size=extent;hud.add_child(p);return p
func _physics_process(delta:float)->void:
 if is_instance_valid(selector) and selector.visible:return
 if countdown>0.:
  countdown=maxf(0.,countdown-delta)
  if countdown<=0.:running=true;toasts.push("¡Ya! Sigue las puertas en orden · una vuelta",3.)
 if running:elapsed+=delta
 for rider in riders:
  rider.position=course.constrain(rider.position)
  if running and rider.finish_time<0. and course.crossed_gate(rider.previous_position,rider.position,rider.next_gate):
   rider.next_gate+=1
   if rider.next_gate>RaceCourse190.GATES:
    rider.finish_time=elapsed;rider.velocity=Vector2.ZERO;rider.cancel_input()
  rider.previous_position=rider.position
 if player.finish_time>=0. and not _announced:_finish()
 var order:Array=riders.duplicate();order.sort_custom(_ahead)
 var rank:int=order.find(player)+1
 info.text="CARRERAS · LAZO     %d/4     1 vuelta · %02d:%02d\nPuerta %d/%d · caballos igualados · sin daño"%[rank,int(elapsed)/60,int(elapsed)%60,mini(player.next_gate,16),16]
 if results.visible:guidance.text="Carrera terminada · otra carrera o menú"
 elif countdown>0.:guidance.text="PREPARADOS · %d"%ceili(countdown)
 elif player.slow_left>0.:guidance.text="ENLAZADO · sigues moviéndote · %.1fs"%player.slow_left
 elif player.attack_cooldown>0.:guidance.text="Lazo %.1fs · doble toque al mover: regate · sigue la puerta brillante"%player.attack_cooldown
 else:guidance.text="Mueve izquierda · apunta/suelta derecha: lazo · doble toque al mover: regate"
 map_view.queue_redraw();queue_redraw()
func _ahead(a:RaceRider190,b:RaceRider190)->bool:
 if a.finish_time>=0. and b.finish_time>=0.:return a.finish_time<b.finish_time
 if a.finish_time>=0.:return true
 if b.finish_time>=0.:return false
 return course.score(a.position,a.next_gate)>course.score(b.position,b.next_gate)
func targets_for(attacker:RaceRider190)->Array:
 var list:Array=[];var at:float=course.project(attacker.position).s
 for candidate in riders:
  if candidate==attacker or candidate.finish_time>=0.:continue
  var delta:float=fposmod(course.project(candidate.position).s-at,course.length)
  if delta>4. and delta<220. and attacker.position.distance_to(candidate.position)<=220.:list.append(candidate)
 list.sort_custom(func(a,b):return attacker.position.distance_to(a.position)<attacker.position.distance_to(b.position))
 return list
func notice_hit(target:RaceRider190)->void:
 if target==player:toasts.push("Te han enlazado: freno breve, sin daño. Luego tienes protección.",2.)
func _finish()->void:
 _announced=true;running=false;toasts.clear()
 for rider in riders:rider.cancel_input()
 var order:Array=riders.duplicate();order.sort_custom(_ahead)
 var lines:String="META · %d/4 · %.2fs\n\n"%[order.find(player)+1,player.finish_time]
 for i in order.size():
  lines+="%d. %s · %s\n"%[i+1,order[i].racer_name,("%.2fs"%order[i].finish_time) if order[i].finish_time>=0. else "en pista"]
 result_text.text=lines
 result_text.add_theme_font_size_override("font_size",21)
 _label(results,"Prototipo · sin premios ni cambios en tus caballos.",Vector2(28,268),17)
 results.show()
func _pause()->void:
 if results.visible:return
 player.cancel_input();get_tree().paused=true;pause_panel.show()
func navigate_back()->void:
 if pause_panel.visible:get_tree().paused=false;pause_panel.hide()
 else:_pause()
func _retry()->void:
 get_tree().paused=false;Engine.time_scale=1.;get_tree().reload_current_scene()
func _menu()->void:
 get_tree().paused=false;Engine.time_scale=1.;get_tree().change_scene_to_file("res://src/Presentation/main_menu.tscn")
func _exit_tree()->void:
 Engine.time_scale=1.;get_tree().paused=false
 for action in ["move_left","move_right","move_up","move_down","throw_lasso"]:Input.action_release(action)
func _draw_mini()->void:
 map_view.draw_style_box(RanchTheme.box(Color("102d35"),Color("679995"),10),Rect2(Vector2.ZERO,map_view.size))
 var center:=map_view.size*.5
 var path:=PackedVector2Array()
 for point in course.points:path.append(center+point*.037)
 map_view.draw_polyline(path,Color("c4a677"),13.,true)
 for rider in riders:map_view.draw_circle(center+rider.position*.037,4.5,rider.tint)
 map_view.draw_string(ThemeDB.fallback_font,Vector2(14,19),"CIRCUITO · 1 VUELTA",HORIZONTAL_ALIGNMENT_LEFT,-1,13,Color("fff1cd"))
func _draw()->void:
 draw_rect(Rect2(-6000,-5000,12000,10000),Color("486949"))
 draw_colored_polygon(course.points,Color("375a43"))
 draw_polyline(course.points,Color("744f32"),RaceCourse190.WIDTH+18.,true)
 draw_polyline(course.points,Color("d3b079"),RaceCourse190.WIDTH,true)
 # Dashes and gate posts are geometry, existing art is used for all riders.
 for i in 96:
  var s:float=course.length*i/96.;draw_line(course.at(s),course.at(s+24.),Color("ead6aa"),4.,true)
 for i in 16:
  var s:float=course.length*i/16.;var center:Vector2=course.at(s);var side:Vector2=course.tangent(s).orthogonal();var color:=Color("8d6745")
  if is_instance_valid(player) and i==player.next_gate%16:color=Color("aaffd5")
  draw_line(center-side*180.,center+side*180.,Color(color,.3),8.,true)
  for sign in [-1.,1.]:
   var post:Vector2=center+side*184.*sign;draw_circle(post,12.,color);draw_string(ThemeDB.fallback_font,post+Vector2(-9,-18),"META" if i==0 else str(i),HORIZONTAL_ALIGNMENT_LEFT,-1,22,Color("fff2cc"))
 for rider in riders:
  if rider.slow_left>0. and is_instance_valid(rider.tether_from):
   var start:Vector2=LassoRopeStyle.rider_hand(rider.tether_from);var end:Vector2=rider.position+Vector2(0,-26);var cord:=PackedVector2Array()
   for i in 17:
    var t:float=i/16.;cord.append(start.lerp(end,t)+Vector2(0,18.*sin(t*PI)))
   LassoRopeStyle.draw_cord(self,cord)
 if is_instance_valid(player) and player.next_gate<=16:
  var gate:Vector2=course.at(course.length*player.next_gate/16.)
  var dir:Vector2=(gate-player.position).normalized();var tip:Vector2=player.position+dir*180.+Vector2(0,-45)
  draw_colored_polygon(PackedVector2Array([tip+dir*24.,tip-dir*14.+dir.orthogonal()*15.,tip-dir*14.-dir.orthogonal()*15.]),Color("afffd4"))

func _unhandled_input(event:InputEvent)->void:
 if event.is_action_pressed("ui_cancel"):
  navigate_back();get_viewport().set_input_as_handled()

func _build_selector()->void:
 selector=_panel(Vector2(760,420));selector.name="RaceSelector190"
 _label(selector,"CARRERAS CON LAZO · PRUEBA",Vector2(26,18),25)
 _label(selector,"Velocidad igualada. El salto depende de tu caballo.
Vallas parciales: salta o rodea por el hueco.
Sin daño ni premios todavía.",Vector2(26,65),20)
 for i in 3:
  var b:=_button(selector,RaceCourse190.TITLES[i],Vector2(26,172+i*64),_choose_course.bind(i));b.size=Vector2(700,54)
 _button(selector,"Menú",Vector2(500,360),_menu)
func _choose_course(index:int)->void:
 if index!=course.variant:
  RaceCourse190.selected=index;RaceCourse190.start_selected=true;_retry();return
 selector.hide()
 toasts.clear();toasts.push("Salto: automático al acercarte si tu caballo sabe. Si no, busca el hueco.",4.)
