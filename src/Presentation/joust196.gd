extends "res://src/Presentation/duel193.gd"
## Nonviolent, isolated test mode: automatic opposite passes, shared lazo; planned regate.
var pass_number:int=0
var end_wait:float=0.
func _ready()->void:
 RaceCupSession194.active=false
 super._ready()
 ModeText203.apply(info,28);ModeText203.apply(guidance,26)
 guidance.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;guidance.offset_top=-84.
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
 for x in range(-480,481,60):draw_line(Vector2(x,0),Vector2(x+28,0),Color("f2dda8"),2.)
 for side in [-1.,1.]:
  var center:=Vector2(side*375.,-190.)
  draw_line(center,center+Vector2(-side*48.,0),Color("ffe9b5"),4.)
  draw_line(center+Vector2(-side*48.,0),center+Vector2(-side*34.,-11),Color("ffe9b5"),4.)
  draw_line(center+Vector2(-side*48.,0),center+Vector2(-side*34.,11),Color("ffe9b5"),4.)

func prestart_aim198()->bool:return countdown>0. and not result.visible
