class_name CountryMap148
extends Control
signal closed
signal selected(id:String)
signal sites_requested
var world:CountryPreview146
var canvas:Control
var map_area:Rect2=Rect2(300,100,500,500)
var marker_points:Dictionary={}
var touches:Dictionary={}
var first_touch:Vector2
var moved:bool=false
func _ready():
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=170;MenuInputGuard.install(self)
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas);canvas.draw.connect(draw_map)
 MenuNavigation.header(canvas,"MAPA LOCAL · prueba guardada" if world.persists149() else "MAPA LOCAL · maqueta",func():closed.emit())
 var note:=Label.new();note.text="Solo lo explorado · toca un sitio visitado para viajar\nVolver a casa lleva a la entrada de este país, no al rancho.";note.position=Vector2(220,620);note.add_theme_font_size_override("font_size",21);canvas.add_child(note)
 var sites:=Button.new();sites.text="Sitios visitados";sites.position=Vector2(850,200);sites.size=Vector2(260,60);sites.pressed.connect(func():sites_requested.emit());canvas.add_child(sites)
 var home:=Button.new();home.text="Volver a casa";home.position=Vector2(850,290);home.size=Vector2(260,60);home.pressed.connect(func():selected.emit("entry"));canvas.add_child(home)
 if world.persists149():
  var menu:=Button.new();menu.text="Guardar y menú";menu.position=Vector2(850,490);menu.size=Vector2(260,60);menu.pressed.connect(func():world.suspend_to_menu152());canvas.add_child(menu)
 var disclaimer:=Label.new();disclaimer.text="Prueba con guardado.\nSin puerta normal ni ritual." if world.persists149() else "En esta maqueta\nno se guarda el progreso.";disclaimer.position=Vector2(850,390);disclaimer.add_theme_font_size_override("font_size",21);canvas.add_child(disclaimer)
 resized.connect(layout);layout()
func layout():
 var k:float=minf(size.x/1280.,size.y/720.);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2.;refresh_markers();canvas.queue_redraw()
func point(pos:Vector2)->Vector2:return map_area.position+(pos-CountryRoute146.BOUNDS.position)/CountryRoute146.BOUNDS.size*map_area.size
func draw_map():
 canvas.draw_style_box(MapAppearance.frame(),map_area.grow(5.));canvas.draw_rect(map_area,Color("071b24"))
 for cell in world.visited_cells:
  var rect:=Rect2(Vector2(cell)*CountryExploration148.CELL,Vector2.ONE*CountryExploration148.CELL).intersection(CountryRoute146.BOUNDS)
  var mapped:=Rect2(point(rect.position),rect.size/CountryRoute146.BOUNDS.size*map_area.size)
  canvas.draw_rect(mapped,Color("4d7947"))
  # Clip terrain to each explored cell. No unseen river or road leaks through fog.
  for entry in [[world.data.approach,Color("cb9d63"),3.],[world.data.bank,Color("cb9d63"),3.],[world.data.river,Color("6bb9c5"),6.]]:
   var path:PackedVector2Array=entry[0]
   for i in range(1,path.size()):
    var a:Vector2=path[i-1];var b:Vector2=path[i];var count_:int=maxi(1,ceili(a.distance_to(b)/24.))
    for j in count_:
     var p:Vector2=a.lerp(b,float(j)/count_);var q:Vector2=a.lerp(b,float(j+1)/count_)
     if rect.has_point((p+q)/2.):canvas.draw_line(point(p),point(q),entry[1],entry[2],true)
 for site in CountryExploration148.available(world.ledger,world.data):
  var pos:Vector2=point(site.pos);canvas.draw_circle(pos,11.,Color("071b24"));canvas.draw_circle(pos,8.,Color("f7d984"));var label_width:float=ThemeDB.fallback_font.get_string_size(site.name,HORIZONTAL_ALIGNMENT_LEFT,-1,18).x
  var offset:=Vector2(-label_width-15,-12) if pos.x>map_area.get_center().x else Vector2(15,-12)
  canvas.draw_string(ThemeDB.fallback_font,pos+offset,site.name,HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("fff2c5"))
 var rider:Vector2=point(world.player.position);canvas.draw_circle(rider,6.,Color("071b24"));canvas.draw_circle(rider,4.,Color("f4fcff"))
func refresh_markers():
 marker_points.clear()
 for site in CountryExploration148.available(world.ledger,world.data):marker_points[site.id]=point(site.pos)
func select_at(screen:Vector2):
 var local:Vector2=canvas.get_global_transform_with_canvas().affine_inverse()*screen
 for id in marker_points:
  if local.distance_to(marker_points[id])<24.:selected.emit(id);return
func _input(event:InputEvent):
 if event is InputEventScreenTouch:
  var local:Vector2=canvas.get_global_transform_with_canvas().affine_inverse()*event.position
  if event.pressed and map_area.has_point(local):
   touches[event.index]=event.position
   if touches.size()==1:first_touch=event.position;moved=false
   else:moved=true
   get_viewport().set_input_as_handled()
  elif not event.pressed and touches.has(event.index):
   touches.erase(event.index);get_viewport().set_input_as_handled()
   if touches.is_empty() and not moved and event.position.distance_to(first_touch)<12.:select_at(event.position)
 elif event is InputEventScreenDrag and touches.has(event.index):
  if event.position.distance_to(first_touch)>=12.:moved=true
  get_viewport().set_input_as_handled()
 elif event is InputEventMouseButton and event.device!=InputEvent.DEVICE_ID_EMULATION and event.button_index==MOUSE_BUTTON_LEFT and not event.pressed:
  select_at(event.position)
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel"):closed.emit();get_viewport().set_input_as_handled()
