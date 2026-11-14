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
var map_view:RaceMap191
var race_order:Array=[]
var telemetry:Label
var standings:Label
var progress_bar:ProgressBar
var _track_visual:RaceScenery191
var hit_count:int=0
var throws_count:int=0
var story_dialog:NpcDialog
var pause_panel:Panel
var pause_button:Button
var result_text:Label
var _announced:bool=false
func _ready()->void:
 process_physics_priority=50
 RanchMusic.play_context("world")
 _track_visual=RaceScenery191.new();_track_visual.name="RaceScenery191";_track_visual.course=course;add_child(_track_visual)
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
  fence_bodies.append(WorldFence.segment(self,point-side*175.,point+side*40.,true,true))
 player=riders[0]
 camera=Camera2D.new();camera.zoom=Vector2(.7,.7);camera.position_smoothing_enabled=true;camera.position_smoothing_speed=6.;player.add_child(camera)
 var touch:CanvasLayer=load("res://src/Presentation/touch_controls.tscn").instantiate();add_child(touch)
 var move:VirtualJoystick=touch.get_node("MoveJoystick");move.anchor_top=.36
 aim_joystick=touch.get_node("AimJoystick");aim_joystick.anchor_top=.36
 player.lasso.set_aim_joystick(aim_joystick);player.dodge.set_move_joystick(move);JoystickAppearance.apply(self)
 var sound:=RanchAudio.new();sound.enabled=GameState.sound_enabled;add_child(sound)
 player.lasso.lasso_thrown.connect(func(_o,_p):sound.play("throw");throws_count+=1)
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
 map_view=RaceMap191.new();map_view.race=self;map_view.z_index=20;map_view.process_mode=Node.PROCESS_MODE_ALWAYS;hud.add_child(map_view);map_view.layout()
 telemetry=_label(hud,"",Vector2(18,78),18)
 standings=_label(hud,"",Vector2(18,170),16)
 ToastStack.backdrop(telemetry);ToastStack.backdrop(standings)
 standings.add_theme_color_override("font_color",Color("d9ead9"))
 progress_bar=ProgressBar.new();progress_bar.show_percentage=false;progress_bar.mouse_filter=Control.MOUSE_FILTER_IGNORE;hud.add_child(progress_bar)
 progress_bar.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE);progress_bar.offset_left=18.;progress_bar.offset_top=68.;progress_bar.offset_right=-18.;progress_bar.offset_bottom=74.
 progress_bar.add_theme_stylebox_override("fill",RanchTheme.box(Color("8be3ba"),Color("8be3ba"),3))
 progress_bar.add_theme_stylebox_override("background",RanchTheme.box(Color("2d4947"),Color("2d4947"),3))
 toasts=ToastStack.new();toasts.top_offset=380;hud.add_child(toasts)
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
 var order:Array=riders.duplicate();order.sort_custom(_ahead);race_order=order
 var rank:int=order.find(player)+1
 progress_bar.value=course.score(player.position,player.next_gate)/course.length*100.
 telemetry.text="%d m/s · %d%% del circuito\nLazo %s · Regate %s"%[roundi(player.velocity.length()/10.),roundi(progress_bar.value),"LISTO" if player.attack_cooldown<=0. else "%.1fs"%player.attack_cooldown,"LISTO" if player.dodge.cooldown<=0. else "%.1fs"%player.dodge.cooldown]
 standings.text=""
 for i in order.size():standings.text+="%d  %s%s\n"%[i+1,order[i].racer_name," ◀" if order[i]==player else ""]
 # Gradual zoom, never rotate the world or change control directions.
 var target_zoom:float=.64 if player.velocity.length()>230. else .7
 camera.zoom=camera.zoom.lerp(Vector2.ONE*target_zoom,minf(1.,delta*2.))
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
 hit_count+=1
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
 if order[0]==player:_winner_story()
func _pause()->void:
 if results.visible or selector.visible:return
 player.cancel_input();get_tree().paused=true;pause_panel.show()
func navigate_back()->void:
 if is_instance_valid(story_dialog):story_dialog.queue_free()
 elif map_view.expanded:map_view.toggle()
 elif selector.visible:_menu()
 elif pause_panel.visible:get_tree().paused=false;pause_panel.hide()
 else:_pause()
func _retry()->void:
 RaceCourse190.start_selected=true
 get_tree().paused=false;Engine.time_scale=1.;get_tree().reload_current_scene()
func _menu()->void:
 get_tree().paused=false;Engine.time_scale=1.;get_tree().change_scene_to_file("res://src/Presentation/main_menu.tscn")
func _exit_tree()->void:
 Engine.time_scale=1.;get_tree().paused=false
 for action in ["move_left","move_right","move_up","move_down","throw_lasso"]:Input.action_release(action)
func _draw()->void:
 for i in 16:
  var s:float=course.length*i/16.;var center:Vector2=course.at(s);var side:Vector2=course.tangent(s).orthogonal();var color:=Color("8d6745")
  if is_instance_valid(player) and i==player.next_gate%16:color=Color("aaffd5")
  draw_line(center-side*180.,center+side*180.,Color(color,.3),8.,true)
  for sign in [-1.,1.]:
   var post:Vector2=center+side*184.*sign;draw_circle(post,12.,color);draw_string(ThemeDB.fallback_font,post+Vector2(-9,-18),"META" if i==0 else str(i),HORIZONTAL_ALIGNMENT_LEFT,-1,22,Color("fff2cc"))
 for attacker in riders:
  if attacker!=player and attacker.lasso.is_in_flight() and is_instance_valid(attacker.lasso._flight_line):
   var landing:Vector2=attacker.lasso._flight_line.landing
   if player.position.distance_to(landing)<220.:
    draw_arc(landing,62.,0,TAU,48,Color("ffb765"),4.,true)
    draw_string(ThemeDB.fallback_font,landing+Vector2(-45,-75),"¡LAZO!",HORIZONTAL_ALIGNMENT_LEFT,-1,24,Color("ffe5a8"))
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

func _winner_story()->void:
 if is_instance_valid(story_dialog):return
 story_dialog=NpcDialog.new()
 var clues:Array[String]=[
  "¡Buena carrera! Los mejores jinetes no solo corren: miran la pista y eligen cuándo lanzar el lazo y cuándo esquivarlo.",
  "Una valla no obliga a todos a hacer lo mismo. Algunos caballos la saltan; otros pueden ganar tomando bien el paso lateral.",
  "Se habla de un caballo especial reservado a las grandes carreras. Tal vez esas pistas nos acerquen algún día a los unicornios."
 ]
 story_dialog.setup_story("Granjero","Después de la carrera",clues[course.variant]+"\n\nEsta es una carrera de prueba: aún no entrega premios ni desbloquea caballos.")
 hud.add_child(story_dialog);story_dialog.closed.connect(func():story_dialog.queue_free())
