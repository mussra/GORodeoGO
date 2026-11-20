class_name ControlsTutorial323
extends Control
## Safe practice area: no saves, captures, points or changes to real input settings.
var mode323:int=0
var time323:float=0.
var touched323:bool=false
var finger323:int=-1
var origin323:Vector2
var pointer323:Vector2
var rider323:Sprite2D
var motion323:Vector2=Vector2.ZERO
var aim323:Vector2=Vector2.RIGHT
var distance323:float=0.
var released323:float=0.
var label323:Label
var practiced323:bool=false
func _ready()->void:
 mouse_filter=Control.MOUSE_FILTER_STOP
 rider323=Sprite2D.new();HorsePortrait.apply(rider323,{"coat":10,"pattern":0,"mane":1});rider323.scale=Vector2.ONE*(95./rider323.texture.get_height());add_child(rider323)
 label323=Label.new();label323.position=Vector2(20,354);label323.size=Vector2(430,44);label323.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;label323.add_theme_font_size_override("font_size",20);add_child(label323)
 reset323(mode323)
func reset323(mode_:int)->void:
 mode323=mode_;time323=0.;touched323=false;finger323=-1;practiced323=false;motion323=Vector2.ZERO;aim323=Vector2.RIGHT;distance323=0.;released323=0.
 if is_instance_valid(rider323):rider323.position=Vector2(220,150)
func _process(delta:float)->void:
 time323+=delta;released323=maxf(0.,released323-delta)
 var phase:float=fmod(time323,5.)
 if mode323==0:
  if touched323:rider323.position=(rider323.position+motion323*80.*delta).clamp(Vector2(90,90),Vector2(370,214))
  elif not practiced323:rider323.position=Vector2(220,150)+Vector2(sin(time323*1.5)*65.,cos(time323*1.5)*20.)
 else:
  rider323.position=Vector2(175,155)
  if touched323:
   var drag:Vector2=pointer323-origin323;aim323=drag.normalized() if drag.length()>4. else Vector2.RIGHT;distance323=clampf(drag.length()*1.5,0.,140.)
  elif not practiced323:
   aim323=Vector2(1.,-.3+sin(time323)*.15).normalized();distance323=clampf(phase/3.,0.,1.)*140. if phase<3. else 140. if phase<3.7 else 0.
  elif released323<=0.:distance323=0.
 label323.text="¡Bien! Puedes seguir practicando" if practiced323 else "Demostración · prueba tú en el recuadro"
 queue_redraw()
func _draw()->void:
 var gold:=Color("f7cf7c");var teal:=Color("76ddd0");var white:=Color("fff2d8")
 draw_style_box(RanchTheme.box(Color("173b3a"),gold,22),Rect2(0,0,470,345))
 draw_line(Vector2(235,248),Vector2(235,330),Color("6d9b94"),2.)
 var font:=ThemeDB.fallback_font
 draw_string(font,Vector2(30,285),"IZQUIERDO",HORIZONTAL_ALIGNMENT_LEFT,-1,21,gold)
 draw_string(font,Vector2(280,285),"DERECHO",HORIZONTAL_ALIGNMENT_LEFT,-1,21,gold)
 draw_string(font,Vector2(48,314),"Mover",HORIZONTAL_ALIGNMENT_LEFT,-1,19,white)
 draw_string(font,Vector2(284,314),"Apuntar / lazo",HORIZONTAL_ALIGNMENT_LEFT,-1,19,white)
 var base:=Vector2(110,230) if mode323==0 else Vector2(355,230)
 var ghost:Vector2=base+Vector2(28.,-22.)*sin(minf(fmod(time323,5.)/3.,1.)*PI*.5)
 var at:Vector2=pointer323 if touched323 else ghost
 draw_arc(base,38.,0,TAU,48,teal,2.,true);draw_line(base,at,teal,4.,true)
 draw_circle(at,17.,gold);draw_circle(at,10.,Color("fff2d8"));draw_arc(at,24.,0,TAU,40,Color(1.,.9,.6,.5),2.,true)
 if mode323==1 and distance323>0.:
  var start:Vector2=rider323.position+Vector2(16,-22);var target:Vector2=start+aim323*distance323
  draw_line(start,target,gold,3.,true);draw_arc(target,19.+(1.-released323)*10. if released323>0. else 19.,0,TAU,48,gold,3.,true)
  draw_circle(target,4.,white)
  draw_string(font,Vector2(25,43),"Arrastra para apuntar · suelta para lanzar",HORIZONTAL_ALIGNMENT_LEFT,-1,18,white)
 else:draw_string(font,Vector2(25,43),"Arrastra el dedo izquierdo para moverte",HORIZONTAL_ALIGNMENT_LEFT,-1,18,white)
func press323(at:Vector2,id:int=0)->void:
 if (mode323==0 and at.x>=235.) or (mode323==1 and at.x<235.):return
 touched323=true;finger323=id;origin323=at;pointer323=at;motion323=Vector2.ZERO
func drag323(at:Vector2)->void:
 pointer323=at;motion323=(at-origin323).limit_length(55.)/55.;practiced323=practiced323 or motion323.length()>.12
func release323()->void:
 if touched323 and mode323==1:released323=1.;practiced323=distance323>5.
 touched323=false;finger323=-1;motion323=Vector2.ZERO
func _gui_input(event:InputEvent)->void:
 if event is InputEventScreenTouch:
  if event.pressed:press323(event.position,event.index)
  elif event.index==finger323:release323()
  accept_event()
 elif event is InputEventScreenDrag and event.index==finger323:drag323(event.position);accept_event()
 elif event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT:
  if event.pressed:press323(event.position)
  else:release323()
  accept_event()
 elif event is InputEventMouseMotion and touched323:drag323(event.position);accept_event()
