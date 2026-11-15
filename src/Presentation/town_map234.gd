class_name TownMap234
extends Control
signal closed
var seed_:int=0
var show_all:bool=false
var points:Dictionary={}
var node_data:Dictionary={}
func _ready():
 if seed_==0:seed_=SaveData.world_seed
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=180;mouse_filter=Control.MOUSE_FILTER_STOP
 var back:=Button.new();back.text="Volver al juego";back.position=Vector2(1020,22);back.size=Vector2(230,52);QuestButtonStyle.apply(back);add_child(back);back.pressed.connect(func():closed.emit())
 resized.connect(queue_redraw);queue_redraw()
func _draw():
 var factor:=Vector2(size.x/1280.,size.y/720.);draw_set_transform(Vector2.ZERO,0,factor)
 draw_style_box(RanchTheme.box(Color("10252d"),Color("b89d6a"),8),Rect2(12,12,1256,696))
 var font:=ThemeDB.fallback_font
 draw_string(font,Vector2(32,49),"PUEBLOS · semilla "+str(seed_),HORIZONTAL_ALIGNMENT_LEFT,-1,29,Color("fff2d6"))
 draw_string(font,Vector2(32,83),"Árbol de recomendaciones · N arriba · cada color es un oficio · volver por el camino sí es posible",HORIZONTAL_ALIGNMENT_LEFT,-1,19,Color("c4d7cf"))
 node_data=TownNetwork234.base_nodes(seed_);var bounds:=Rect2(Vector2.ZERO,Vector2.ONE)
 for node in node_data.values():bounds=bounds.expand((node.door-Vector2(1000,358))/TownNetwork234.STEP)
 var k:float=minf(1080./maxf(1.,bounds.size.x),450./maxf(1.,bounds.size.y));points={}
 for node in node_data.values():points[node.id]=Vector2(640,375)+((node.door-Vector2(1000,358))/TownNetwork234.STEP-bounds.get_center())*k
 var colors:Dictionary={"loco":Color("c19be0"),"farmer":Color("bdd681"),"florist":Color("eeabbd"),"saddler":Color("e2c084")}
 var known:Dictionary=SaveData.world_cousins140.get("revealed215",{})
 for node in node_data.values():
  for role in node.targets:
   var target:String=node.targets[role]
   if not show_all and not known.has(target):continue
   var a:Vector2=points[node.id];var b:Vector2=points[target];var color:Color=colors[role];draw_line(a,b,color,3.,true)
   var head:Vector2=a.lerp(b,.72);var direction:Vector2=(b-a).normalized();draw_colored_polygon(PackedVector2Array([head+direction*7,head-direction*5+direction.orthogonal()*5,head-direction*5-direction.orthogonal()*5]),color)
 for node in node_data.values():
  if not show_all and node.id!="home" and not known.has(node.id):continue
  var p:Vector2=points[node.id];draw_circle(p,14.,Color("344b4c"));draw_arc(p,14.,0,TAU,20,Color("e3cea4"),2.)
  draw_string(font,p+Vector2(-20,-20),"Inicio" if node.id=="home" else node.id.trim_prefix("town"),HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("fff2d6"))
  for index in node.roles.size():draw_circle(p+Vector2(-9+index*6,0),3.,colors[node.roles[index]])
 var legend_x:float=35.
 for role in TownNetwork234.ROLES:
  draw_circle(Vector2(legend_x,650),6.,colors[role]);draw_string(font,Vector2(legend_x+14,656),TownNetwork234.NAMES[role],HORIZONTAL_ALIGNMENT_LEFT,-1,20,Color("fff2d6"));legend_x+=285.
 draw_string(font,Vector2(32,690),"Pueblos infinitos al explorar · recomendaciones hasta tres generaciones"+(" · VISTA QA COMPLETA" if show_all else " · solo destinos recomendados"),HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("c4d7cf"))
 draw_set_transform(Vector2.ZERO)
