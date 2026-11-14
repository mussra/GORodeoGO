class_name RaceMap191
extends Control
## Fit the actual circuit, gates, fences and live race order, never a generic oval.
var race:Node
var expanded:bool=false
var _map_touches209:Dictionary={}
func _ready()->void:
 mouse_filter=Control.MOUSE_FILTER_STOP
 tooltip_text="Mapa de carrera · toca para ampliar"
func layout()->void:
 if expanded:
  set_anchors_and_offsets_preset(Control.PRESET_CENTER);offset_left=-370.;offset_right=370.;offset_top=-230.;offset_bottom=230.
 else:
  set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT);offset_left=-254.;offset_right=-16.;offset_top=122.;offset_bottom=324.
func geometry()->Dictionary:
 var bounds:=Rect2(race.course.points[0],Vector2.ZERO)
 for p in race.course.points:bounds=bounds.expand(p)
 bounds=bounds.grow(RaceCourse190.WIDTH*.5+24.)
 var area:=Rect2(Vector2(18,36),size-Vector2(36,72))
 var k:float=minf(area.size.x/bounds.size.x,area.size.y/bounds.size.y)
 return {"origin":area.get_center()-bounds.get_center()*k,"scale":k}
func point(p:Vector2,g:Dictionary)->Vector2:return g.origin+p*g.scale
func _draw()->void:
 if not is_instance_valid(race):return
 draw_style_box(RanchTheme.box(Color("102d35"),Color("77b9b2"),12),Rect2(Vector2.ZERO,size))
 var g:=geometry();var path:=PackedVector2Array()
 for p in race.course.points:path.append(point(p,g))
 var width:float=maxf(8.,RaceCourse190.WIDTH*g.scale)
 draw_polyline(path,Color("70533d"),width+4.,true);draw_polyline(path,Color("e0bd88"),width,true)
 for i in 8:
  var s:float=race.course.length*(i+.4)/8.;var at:=point(race.course.at(s),g);var forward:Vector2=race.course.tangent(s);var side:=forward.orthogonal()
  draw_polyline(PackedVector2Array([at-forward*4.+side*3.,at+forward*3.,at-forward*4.-side*3.]),Color("5b4938"),1.4,true)
 for s in race.course.fences:
  var center:Vector2=race.course.at(s);var side:Vector2=race.course.tangent(s).orthogonal()
  draw_line(point(center-side*175.,g),point(center+side*40.,g),Color("9a5934"),3.,true)
 if race.course.variant==3:
  var cross:=point(Vector2.ZERO,g)
  draw_circle(cross,8.,Color("ffcd74"))
  draw_string(ThemeDB.fallback_font,cross+Vector2(10,-5),"CRUCE",HORIZONTAL_ALIGNMENT_LEFT,-1,12,Color("fff1cd"))
 var gate:float=race.course.length*mini(race.player.next_gate,16)/16.
 var at:=point(race.course.at(gate),g)
 draw_arc(at,9.,0,TAU,24,Color("8bffcf"),2.,true)
 var home:=point(race.course.at(0.),g);var side:Vector2=race.course.tangent(0.).orthogonal()
 draw_line(home-side*(width*.5+3.),home+side*(width*.5+3.),Color.WHITE,3.,true)
 for rider in race.riders:
  var p:=point(rider.position,g)
  draw_circle(p,6.5 if rider==race.player else 4.5,Color("10252e"))
  draw_circle(p,4.5 if rider==race.player else 3.,rider.tint)
  if rider==race.player:
   var heading:Vector2=rider.velocity.normalized() if rider.velocity.length()>5. else race.course.tangent(rider.route_s)
   draw_colored_polygon(PackedVector2Array([p+heading*10.,p+heading*4.+heading.orthogonal()*4.,p+heading*4.-heading.orthogonal()*4.]),rider.tint)
 draw_string(ThemeDB.fallback_font,Vector2(14,26),"MAPA · "+("TOCA PARA CERRAR" if expanded else "TOCA +"),HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("fff1cd"))
 draw_string(ThemeDB.fallback_font,Vector2(14,size.y-13),"Meta | Puerta ○ Valla ━",HORIZONTAL_ALIGNMENT_LEFT,-1,17,Color("fff8e8"))
func toggle()->void:
 expanded=not expanded
 if expanded:race.player.cancel_input();get_tree().paused=true
 else:get_tree().paused=false
 layout();queue_redraw()
func _gui_input(event:InputEvent)->void:
 if event is InputEventMouseButton and event.device!=InputEvent.DEVICE_ID_EMULATION and event.pressed and event.button_index==MOUSE_BUTTON_LEFT:
  toggle();accept_event()
func _input(event:InputEvent)->void:
 if event.get_meta("riding209",false):return
 if event is InputEventScreenTouch and visible:
  if event.pressed and get_global_rect().has_point(event.position):
   _map_touches209[event.index]={"origin":event.position,"dragged":false}
   get_viewport().set_input_as_handled()
  elif not event.pressed and _map_touches209.has(event.index):
   var state:Dictionary=_map_touches209[event.index];_map_touches209.erase(event.index)
   get_viewport().set_input_as_handled()
   if not state.dragged and event.position.distance_to(state.origin)<GameplayGestures209.DRAG_DISTANCE and get_global_rect().has_point(event.position):toggle()
 elif event is InputEventScreenDrag and _map_touches209.has(event.index):
  if event.position.distance_to(_map_touches209[event.index].origin)>=GameplayGestures209.DRAG_DISTANCE:_map_touches209[event.index].dragged=true
  get_viewport().set_input_as_handled()
