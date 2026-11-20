class_name BullTutorial323
extends Node2D
signal finished
var player:CharacterBody2D
var bull:CharacterBody2D
var step323:int=0
var onboarding323:bool=false
var goal323:=Vector2(1020,370)
var text323:Label
var marker323:Label
var controls323:CanvasLayer
var camera323:Camera2D
var ui323:CanvasLayer
var hint323:Label
var layout323:Control
var previous_camera323:Camera2D
const LINES:Array[String]=[
 "1 · Acércate al toro con el dedo izquierdo. Este toro espera quieto y no te hará daño.",
 "2 · Apunta con el dedo derecho. Arrastra hasta que el círculo del lazo cubra al toro y suelta para lanzarlo.",
 "3 · ¡Lo tienes! Muévete con el dedo izquierdo hasta la zona dorada. El toro te seguirá sujeto por el lazo.",
 "4 · Dentro de la zona, toca DOS VECES seguidas el mando derecho sin arrastrar para soltar al toro.",
 "¡Muy bien, Pablo! Ya sabes moverte, apuntar, capturar, guiar y soltar. Ahora puedes explorar Frontera."
]
func _ready()->void:
 name="BullTutorial323";z_index=190;process_mode=Node.PROCESS_MODE_ALWAYS
 var scene=load("res://src/Presentation/level_0.tscn").instantiate()
 player=scene.get_node("Player");scene.remove_child(player)
 bull=scene.get_node("Bull");scene.remove_child(bull);scene.free()
 player.position=Vector2(230,370);player.world_bounds=Rect2(70,200,1140,340);add_child(player)
 bull.position=Vector2(730,370);bull.world_bounds=player.world_bounds;bull.collision_mask=0;bull.collision_layer=0;add_child(bull)
 bull.set_player(player);bull.begin_active();bull.set_physics_process(false);bull.collision_layer=0;bull.collision_mask=0
 controls323=load("res://src/Presentation/touch_controls.tscn").instantiate();controls323.layer=205;add_child(controls323)
 player.set_move_joystick(controls323.get_node("MoveJoystick"));player.set_aim_joystick(controls323.get_node("AimJoystick"))
 player.lasso.prey_provider=func()->Array:return [bull] if step323==1 else []
 player.lasso.can_capture=func()->bool:return step323==1
 player.prey_captured.connect(_captured323);player.release_requested.connect(_release323)
 previous_camera323=get_viewport().get_camera_2d()
 camera323=Camera2D.new();camera323.position=Vector2(640,360);add_child(camera323)
 get_viewport().size_changed.connect(_fit323)
 ui323=CanvasLayer.new();ui323.layer=210;add_child(ui323)
 layout323=Control.new();layout323.set_meta("ui_modal",true);layout323.mouse_filter=Control.MOUSE_FILTER_IGNORE;layout323.size=Vector2(1280,720);ui323.add_child(layout323)
 text323=Label.new();text323.position=Vector2(50,45);text323.size=Vector2(1180,120);text323.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;text323.add_theme_font_size_override("font_size",28);text323.mouse_filter=Control.MOUSE_FILTER_IGNORE;layout323.add_child(text323)
 hint323=Label.new();hint323.text="PRÁCTICA SEGURA · sin tiempo, premios ni cambios en tu partida";hint323.position=Vector2(50,12);hint323.add_theme_font_size_override("font_size",18);layout323.add_child(hint323)
 marker323=Label.new();marker323.position=Vector2(885,255);marker323.text="LLEVA EL TORO AQUÍ";marker323.add_theme_font_size_override("font_size",22);add_child(marker323)
 var skip:=Button.new();skip.text="Salir de la práctica";skip.position=Vector2(970,640);skip.size=Vector2(270,56);QuestButtonStyle.apply(skip);layout323.add_child(skip);skip.pressed.connect(_finish323)
 _fit323();_step323(0)
func _fit323()->void:
 var extent:=get_viewport_rect().size;camera323.zoom=Vector2.ONE*minf(extent.x/1280.,extent.y/720.)
 if is_instance_valid(layout323):layout323.scale=camera323.zoom;layout323.position=(extent-Vector2(1280,720)*camera323.zoom)*.5
func _step323(value:int)->void:
 step323=value;text323.text=LINES[value];queue_redraw()
 if value==4 and not onboarding323:text323.text="¡Muy bien, Pablo! Ya sabes moverte, apuntar, capturar, guiar y soltar. Puedes repetir esta práctica cuando quieras."
 if value==4:
  player.cancel_input();player.set_physics_process(false);controls323.hide()
  var next:=Button.new();next.text="Continuar a Frontera" if onboarding323 else "Volver al menú";next.position=Vector2(440,550);next.size=Vector2(400,70);QuestButtonStyle.apply(next);layout323.add_child(next);next.pressed.connect(_finish323)
func _physics_process(_delta:float)->void:
 if not is_instance_valid(player):return
 if step323==0 and player.position.distance_to(bull.position)<195.:_step323(1)
 if step323==2 and bull.position.distance_to(goal323)<85.:_step323(3)
 if step323 in [0,1]:bull.velocity=Vector2.ZERO
 queue_redraw()
func _captured323(_prey:Node2D)->void:
 if step323!=1:return
 bull.controller.use_tranquilizer();bull.set_physics_process(true);player.set_active_capture_count(1);_step323(2)
func _release323()->void:
 if step323 not in [2,3]:return
 if bull.position.distance_to(goal323)>100.:
  text323.text="Primero guía al toro hasta la zona dorada. Después lo soltaremos con dos toques.";return
 bull.release_by_player();bull.set_physics_process(false);bull.velocity=Vector2.ZERO;player.set_active_capture_count(0);_step323(4)
func _draw()->void:
 draw_rect(Rect2(-2000,-2000,5000,5000),Color("122d2e"))
 draw_style_box(RanchTheme.box(Color("617942"),Color("c5ad72"),28),Rect2(55,180,1170,390))
 for x in range(90,1220,55):draw_line(Vector2(x,180),Vector2(x,190),Color("e2ca8f"),3.)
 draw_circle(goal323,85.,Color(.95,.72,.25,.22));draw_arc(goal323,85.,0,TAU,64,Color("f7cf7c"),4.,true)
 if is_instance_valid(bull) and step323 in [0,1]:
  draw_arc(bull.position,65.,0,TAU,48,Color("f7cf7c"),3.,true)
  var target:Vector2=bull.position if step323==0 else goal323
  if is_instance_valid(player):draw_dashed_line(player.position+Vector2(0,42),target+Vector2(0,42),Color("f7cf7c"),3.,12.)
 if step323 in [2,3] and is_instance_valid(bull):draw_dashed_line(bull.position+Vector2(0,42),goal323,Color("f7cf7c"),3.,12.)
func _finish323()->void:
 if is_queued_for_deletion():return
 player.cancel_all_actions()
 if is_instance_valid(previous_camera323):previous_camera323.make_current()
 finished.emit();queue_free()
func _exit_tree()->void:
 for action in ["move_left","move_right","move_up","move_down","aim_left","aim_right","aim_up","aim_down"]:Input.action_release(action)

func _unhandled_input(event:InputEvent)->void:
 if event.is_action_pressed("ui_cancel"):
  _finish323();get_viewport().set_input_as_handled()
