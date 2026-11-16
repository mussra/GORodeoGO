extends "res://src/Presentation/duel193.gd"
## Nonviolent, isolated test mode: automatic opposite passes, shared lazo; planned regate.
var sprint_gauge206:RadialGauge
var pass_number:int=0
var end_wait:float=0.
func _ready()->void:
 RaceCupSession194.active=false
 super._ready()
 var barrier:=StaticBody2D.new();barrier.name="LaneDivider223";barrier.collision_layer=HorseJump.FENCE_LAYER;barrier.collision_mask=0
 var shape:=CollisionShape2D.new();var rectangle:=RectangleShape2D.new();rectangle.size=Vector2(1120,12);shape.shape=rectangle;barrier.add_child(shape);add_child(barrier)
 ModeText203.apply(info,28);ModeText203.apply(guidance,26)
 guidance.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;guidance.offset_top=-84.
 sprint_gauge206=RadialGauge.new();sprint_gauge206.name="SprintGauge206";sprint_gauge206.skill="stamina";hud.add_child(sprint_gauge206)
 sprint_gauge206.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT);sprint_gauge206.offset_left=-178.;sprint_gauge206.offset_right=-94.;sprint_gauge206.offset_top=-182.;sprint_gauge206.offset_bottom=-98.
 var counter:=StartCountdown198.new();counter.name="StartCountdown198";counter.session=self;hud.add_child(counter)
 var pause_title:Label=pause_panel.get_child(0);pause_title.text="JUSTA DE LAZOS EN PAUSA"
func _make_rider()->DuelRider193:return JoustRider196.new()
func _reset_round()->void:
 super._reset_round();pass_number+=1;end_wait=0.
 for i in 2:
  var side:float=(-1. if i==0 else 1.)*(-1. if pass_number%2==0 else 1.)
  var rider:JoustRider196=riders[i];rider.position=Vector2(side*440.,-45. if i==0 else 45.);rider.forward=-side;rider.attack_think=.15;rider._sprite_swap.set_flip_h(rider.forward<0.)
 _refresh()
func _physics_process(delta:float)->void:
 super._physics_process(delta)
 if is_instance_valid(sprint_gauge206):sprint_gauge206.set_state(true,1.-player.dodge.cooldown/player.dodge.recharge_seconds)
 if not running:return
 var arrived:bool=true
 for rider in riders:
  if rider.position.x*rider.forward<479.:arrived=false
 if arrived:
  end_wait+=delta
  if end_wait>=.5 and pending.is_empty():_miss_pass()
func _miss_pass()->void:
 running=false
 for rider in riders:rider.cancel_input()
 _clear_actions();controls.hide()
 result_text.text="Pasada sin captura · sin punto\n\nTú %d - %d Luna\nNueva pasada desde los lados opuestos."%[scores[0],scores[1]]
 next_button.text="Otra pasada";result.show();_refresh()
func _resolve_round()->void:
 super._resolve_round()
 result_text.text=result_text.text.replace("el duelo","la justa")
 if finished:next_button.text="Repetir justa"
func _next_round()->void:
 if not finished and pending.is_empty():_reset_round()
 else:super._next_round()
func _refresh()->void:
 info.text="JUSTA CON LAZOS · %d - %d · mejor de tres\nManga %d · pasada %d · sin lanzas ni daño"%[scores[0],scores[1],round_number,maxi(1,pass_number)]
 guidance.text="PREPARADOS · %d · apunta ahora; suelta después de salir"%ceili(countdown) if countdown>0. else "Pasada automática · izquierda: arriba/abajo · levanta y apoya: SPRINT · derecha: apunta y suelta"
func _draw()->void:
 super._draw()
 draw_rect(Rect2(-520,-165,1040,330),Color("c8aa78"),false,4.)
 draw_rect(Rect2(-540,-6,1080,12),Color("593d26"))
 draw_line(Vector2(-540,-4),Vector2(540,-4),Color("e4b66f"),3.)
 draw_line(Vector2(-540,4),Vector2(540,4),Color("a66d39"),3.)
 for x in range(-540,541,60):
  draw_rect(Rect2(x-4,-11,8,22),Color("583c26"))
  draw_line(Vector2(x-2,-10),Vector2(x-2,9),Color("e9c082"),2.)
 for side in [-1.,1.]:
  var center:=Vector2(side*375.,-190.)
  draw_line(center,center+Vector2(-side*48.,0),Color("ffe9b5"),4.)
  draw_line(center+Vector2(-side*48.,0),center+Vector2(-side*34.,-11),Color("ffe9b5"),4.)
  draw_line(center+Vector2(-side*48.,0),center+Vector2(-side*34.,11),Color("ffe9b5"),4.)

func prestart_aim198()->bool:return countdown>0. and not result.visible

func victory_mode240()->String:return "joust"
