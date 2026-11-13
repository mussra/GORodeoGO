class_name CountryPreview146
extends Node2D
signal return_requested
## Isolated topology/scale prototype. No access gate, ritual or save writes.
var seed:int=752026
var data:Dictionary
var ledger:Dictionary
var notice170:ToastStack
var player:CharacterBody2D
var camera:Camera2D
var aim_joystick:VirtualJoystick
var status:Label
var visited_cells:Dictionary={}
var river_clock:float=0.
var hud_canvas:Control
var touch_controls:CanvasLayer
var modal:Control
var travelling:bool=false
var last_error:String=""
var transaction:TravelTransaction147
var prior_player_processing:bool=true
var preview_rest166:float=0.
var travel_target:Dictionary={}
var travel_origin:Vector2
var travel_ledger:Dictionary={}
var curtain:SiestaCurtain147
var tree_sprite155:Sprite2D
var gauges154:Dictionary={}
var stamina154:Dictionary={}
var partial_route163:Dictionary={}
var map_button:Button
var _map_overlay:CountryMap148
var _map_notes159:MapNotesController159
var _note_dialog106:MapNoteDialog106
const GRASS=preload("res://art/world/alternative92/grass-cache.png")
const TREE=preload("res://art/world/supplied/tree_of_life150.png")
func _ready():
 ledger=initial_ledger149();seed=ledger.maps.water146.seed;data=CountryRoute146.plan(seed);visited_cells=ledger.maps.water146.explored.duplicate(true)
 texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED
 var trunk:=Sprite2D.new();trunk.texture=TREE;trunk.centered=false;trunk.position=data.tree_art.position;trunk.scale=data.tree_art.size/Vector2(TREE.get_size());trunk.z_index=24;tree_sprite155=trunk;trunk.material=ShaderMaterial.new();trunk.material.shader=preload("res://art/world/mother_tree155.gdshader");add_child(trunk)
 var solid:=StaticBody2D.new();solid.name="MotherTreeGround155";solid.collision_layer=128;var polygon:=CollisionPolygon2D.new();polygon.polygon=data.tree_solid;solid.add_child(polygon);add_child(solid)
 var river:PackedVector2Array=data.river
 for i in range(1,river.size()):
  var body:=StaticBody2D.new();body.collision_layer=128;body.position=(river[i-1]+river[i])/2.;body.rotation=(river[i]-river[i-1]).angle()
  var collision:=CollisionShape2D.new();var shape:=RectangleShape2D.new();shape.size=Vector2(river[i-1].distance_to(river[i]),CountryRoute146.WATER_RADIUS*2.);collision.shape=shape;body.add_child(collision);add_child(body)
 for point in river:
  var body:=StaticBody2D.new();body.collision_layer=128;body.position=point;var collision:=CollisionShape2D.new();var shape:=CircleShape2D.new();shape.radius=CountryRoute146.WATER_RADIUS;collision.shape=shape;body.add_child(collision);add_child(body)
 var coast_body:=StaticBody2D.new();coast_body.name="IslandShore156";coast_body.collision_layer=128;var coast_shape:=CollisionPolygon2D.new();coast_shape.build_mode=CollisionPolygon2D.BUILD_SEGMENTS;coast_shape.polygon=data.island;coast_body.add_child(coast_shape);add_child(coast_body)
 player=load("res://src/Presentation/world_player.gd").new();player.position=ledger.maps.water146.position;player.world_bounds=CountryRoute146.BOUNDS;add_child(player)
 camera=Camera2D.new();player.add_child(camera);camera.make_current()
 var layer:=CanvasLayer.new();layer.layer=20;add_child(layer)
 hud_canvas=Control.new();hud_canvas.mouse_filter=Control.MOUSE_FILTER_IGNORE;hud_canvas.size=Vector2(1280,720);layer.add_child(hud_canvas)
 var fit:Callable=func():
  var size_:Vector2=get_viewport().get_visible_rect().size;var k:float=minf(size_.x/1280.,size_.y/720.);hud_canvas.scale=Vector2.ONE*k;hud_canvas.position=(size_-Vector2(1280,720)*k)/2.
 get_viewport().size_changed.connect(fit);fit.call()
 var bar:=ColorRect.new();bar.mouse_filter=Control.MOUSE_FILTER_IGNORE;bar.color=Color("10252ded");bar.size=Vector2(1280,100);hud_canvas.add_child(bar)
 var title:=Label.new();title.text=session_title149();title.position=Vector2(20,10);title.add_theme_font_size_override("font_size",24);bar.add_child(title)
 var back:=Button.new();back.text="Salir a Frontera";back.position=Vector2(1040,10);back.size=Vector2(220,60);QuestButtonStyle.apply(back);back.pressed.connect(request_return);bar.add_child(back)
 map_button=Button.new();map_button.text="Mapa local";map_button.position=Vector2(850,10);map_button.size=Vector2(180,60);QuestButtonStyle.apply(map_button);map_button.pressed.connect(show_map);bar.add_child(map_button)
 status=Label.new();status.position=Vector2(20,50);status.add_theme_font_size_override("font_size",21);bar.add_child(status)
 gauges154=MountedStatus154.create(hud_canvas)
 var horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
 stamina154=WorldStamina.new_state(HorseStats.read(horse).get("power",.65));MountedStatus154.abilities(player,gauges154,horse)
 var touch:CanvasLayer=load("res://src/Presentation/touch_controls.tscn").instantiate();add_child(touch);touch_controls=touch
 var joy:VirtualJoystick=touch.get_node("MoveJoystick");var aim:VirtualJoystick=touch.get_node("AimJoystick");aim_joystick=aim;player.lasso.set_aim_joystick(aim);player.dodge.set_move_joystick(joy);JoystickAppearance.apply(self)
 _map_overlay=CountryMap148.new();_map_overlay.world=self;layer.add_child(_map_overlay)
 _map_notes159=MapNotesController159.new();add_child(_map_notes159)
 set_process(true);queue_redraw()
func _process(delta:float):
 river_clock+=delta
 if tree_sprite155!=null:tree_sprite155.material.set_shader_parameter("rider_uv",(player.position+Vector2(0,-35)-data.tree_art.position)/data.tree_art.size)
 if travelling or is_instance_valid(modal) or is_instance_valid(_note_dialog106):return
 var riding166:bool=player.is_physics_processing() and player.velocity.length()>5.
 if persists149():SaveData.siesta_rest166=SiestaRest166.tick(SaveData.siesta_rest166,delta,riding166)
 else:preview_rest166=SiestaRest166.tick(preview_rest166,delta,riding166)
 MountedStatus154.abilities(player,gauges154,SaveData.horse_collection.find(SaveData.horse_collection.selected))
 stamina154=MountedStatus154.stamina(player,gauges154,stamina154,delta,on_road154(player.position))
 var next:=CountryLedger146.record_position(ledger,player.position)
 if not next.is_empty():ledger=next
 CountryExploration148.reveal(visited_cells,player.position)
 status.text="Sitios encontrados: %d/3 · sigue la orilla río arriba · arte provisional"%ledger.maps.water146.visited.size()
 queue_redraw()
func _draw():
 if data.is_empty():return
 draw_rect(CountryRoute146.BOUNDS.grow(100000.),Color("1e728b"))
 var island:PackedVector2Array=data.island;var loop:PackedVector2Array=island.duplicate();loop.append(island[0])
 draw_polyline(loop,Color("46a6b7"),480.,true);draw_polyline(loop,Color("78c9ca"),290.,true);draw_polyline(loop,Color("f2e3ac"),150.,true)
 var uvs:=PackedVector2Array()
 for point_ in island:uvs.append(point_/Vector2(GRASS.get_size()))
 draw_colored_polygon(island,Color.WHITE,uvs,GRASS)
 draw_polyline(loop,Color("e3cf91"),82.,true)
 var foam:=PackedVector2Array()
 for i in island.size():
  var inward:Vector2=(CountryRoute146.BOUNDS.get_center()-island[i]).normalized();var pulse:float=sin(river_clock*.9+i*TAU/float(island.size())*3.)*10.
  foam.append(island[i]-inward*(120.+pulse))
 foam.append(foam[0]);draw_polyline(foam,Color("d6f6ee99"),8.,true)
 draw_polyline(data.approach,Color("6d522d"),112.,true);draw_polyline(data.approach,Color("bf8952"),90.,true)
 draw_polyline(data.bank,Color("6d522d"),112.,true);draw_polyline(data.bank,Color("bf8952"),90.,true)
 draw_polyline(data.river,Color("37666c"),205.,true);draw_polyline(data.river,Color("4e9caf"),180.,true);draw_polyline(data.river,Color("6bb9c5"),112.,true)
 var river:PackedVector2Array=data.river
 for i in range(1,river.size()):
  var direction:Vector2=(river[i]-river[i-1]).normalized();var normal:=direction.orthogonal()
  for k in 12:
   var point:Vector2=river[i-1].lerp(river[i],fposmod(k/12.+river_clock*.035,1.))
   draw_line(point-normal*18.,point+normal*18.,Color("c8f4ef88"),3.,true)
 draw_circle(data.source,120.,Color("b8ece7"));draw_circle(data.source,78.,Color("4e9caf"))
 # Rainbow marks the linked entry only; no activation condition is invented.
 for i in 6:draw_arc(data.entry+Vector2(0,-70),90.+i*9.,PI,TAU,32,Color.from_hsv(i/7.,.55,.95),7.,true)
 draw_circle(data.entry,12.,Color("fff0b3"))

func request_return():
 if not travelling and not is_instance_valid(modal):return_requested.emit()
func _lock_player():
 prior_player_processing=player.is_physics_processing();player.cancel_input();player.velocity=Vector2.ZERO;player.set_physics_process(false);touch_controls.visible=false
func _unlock_player():
 player.set_physics_process(prior_player_processing and not _map_overlay.expanded and not is_instance_valid(_note_dialog106));touch_controls.visible=not _map_overlay.expanded and not is_instance_valid(_note_dialog106)
func close_modal(resume:bool=true):
 if modal==_map_overlay:_map_overlay.expanded=false;_map_overlay._layout()
 elif is_instance_valid(modal):modal.queue_free()
 modal=null
 if resume and not travelling:_unlock_player()
func show_map():
 if travelling:return
 if _map_overlay.expanded:close_modal();return
 if is_instance_valid(modal):return
 _map_notes159.capture();_lock_player();modal=_map_overlay;_map_overlay.expanded=true;_map_overlay.pan=Vector2.ZERO;_map_overlay._layout();_map_overlay._set_zoom(1.)
func _toggle_map()->void:show_map()
func _open_map_note106(pos:Vector2)->void:_map_notes159.open(pos)
func map_note_horses159()->Array:return []
func map_note_host159()->Node:return hud_canvas.get_parent()
func map_note_message159(text:String)->void:last_error=text;status.text=text
func map_note_store159(note:Dictionary)->bool:
 var before:=ledger.duplicate(true);var notes:Dictionary=ledger.maps.water146.notes.duplicate(true)
 for rows in notes.values():
  for i in range(rows.size()-1,-1,-1):
   if rows[i].id==note.id:rows.remove_at(i)
 var key:=WorldNotes106.region_key(note.pos)
 if not notes.has(key):notes[key]=[]
 notes[key].append(note.duplicate(true));ledger.maps.water146.notes=WorldNotes106.clean(notes)
 if persists149() and not prepare_travel149():ledger=before;return false
 _map_overlay._terrain_valid=false;return true
func map_note_delete159(id:String)->bool:
 var before:=ledger.duplicate(true);var notes:Dictionary=ledger.maps.water146.notes.duplicate(true)
 for key in notes.keys():
  for i in range(notes[key].size()-1,-1,-1):
   if notes[key][i].id==id:notes[key].remove_at(i)
  if notes[key].is_empty():notes.erase(key)
 ledger.maps.water146.notes=notes
 if persists149() and not prepare_travel149():ledger=before;return false
 _map_overlay._terrain_valid=false;return true
func show_sites(already_locked:bool=false):
 if travelling or is_instance_valid(modal):return
 if not already_locked:_lock_player()
 var sheet:=NavigationSheet.new();sheet.title="SITIOS DE ESTE PAÍS";modal=sheet
 for site in available_sites170():sheet.entries.append({"id":site.id,"title":site.name,"hint":"Sitio visitado · siesta" if persists149() else "Sitio visitado · siesta sin guardado"})
 sheet.closed.connect(close_modal);sheet.selected.connect(func(id:String):modal=null;choose_site.call_deferred(id,true));hud_canvas.add_child(sheet)
func travel_reason()->String:
 if travelling:return "Espera a que termine el viaje."
 if player.lasso.is_in_flight() or player.lasso.is_charging():return "Termina el lazo antes de viajar."
 if player._stun_time_remaining>0. or player._jump_time>0.:return "Espera a terminar el movimiento antes de viajar."
 return ""
func choose_site(id:String,already_locked:bool=false):
 if travelling or is_instance_valid(modal):return
 var target:=destination170(id)
 var reason_:String=travel_reason()
 if target.is_empty() or not reason_.is_empty():
  last_error="Ese sitio no está visitado." if target.is_empty() else reason_
  if already_locked:_unlock_player()
  return
 if not already_locked:_lock_player()
 var confirmation:=SiestaConfirmation148.new();confirmation.destination=target.name;confirmation.preview=not persists149();modal=confirmation
 confirmation.cancelled.connect(close_modal);confirmation.confirmed.connect(func():close_modal(false);start_siesta(id,true));hud_canvas.add_child(confirmation)
func start_siesta(id:String,already_locked:bool=false)->bool:
 if is_instance_valid(modal):return false
 last_error="";var reason_:String=travel_reason();var target:=destination170(id)
 if target.is_empty() or not reason_.is_empty():
  last_error="Ese sitio no está visitado." if target.is_empty() else reason_
  if already_locked and not travelling:_unlock_player()
  return false
 if (SaveData.siesta_rest166 if persists149() else preview_rest166)>0.:
  if not already_locked:_lock_player()
  travelling=true;curtain=SiestaCurtain147.new();add_child(curtain)
  await curtain.refuse_rest166();curtain.queue_free();curtain=null;travelling=false;_unlock_player();last_error=SiestaRest166.REFUSAL;return false
 if not prepare_travel149():
  last_error="No se pudo guardar el origen. No has viajado."
  if already_locked:_unlock_player()
  return false
 if not already_locked:_lock_player()
 partial_route163=SiestaRoute163.country(player.position,target.pos,data,visited_cells)
 if partial_route163.is_empty():
  last_error="Ya estamos cerca. Este último tramo lo hacemos a caballo." if player.position.distance_to(target.pos)<SiestaRoute163.FINAL_MANUAL*2. else "No encuentro paso por el terreno que conocemos. Habrá que explorar cómo rodearlo.";map_notice170(last_error);_unlock_player();return false
 target=target.duplicate(true);target.pos=partial_route163.pos
 travelling=true;travel_target=target;travel_origin=player.position;travel_ledger=ledger.duplicate(true)
 curtain=SiestaCurtain147.new();curtain.destination=target.name;curtain.horse=SaveData.horse_collection.find(SaveData.horse_collection.selected);curtain.hat=SaveData.hat_color;add_child(curtain)
 player.cancel_input()
 var walking_ok:bool=await curtain.close_eye(player,partial_route163.path)
 if not walking_ok:
  TravelStraight172.stop(partial_route163,player.position);travel_target.pos=player.position
 transaction=TravelTransaction147.new();var result:=await transaction.run(_load_travel148,_validate_travel148,_commit_travel148,_restore_travel148)
 if not result.ok:last_error="No se pudo guardar la llegada. Sigues en el origen." if result.reason=="save" else "No hay llegada libre. Sigues en el origen."
 curtain.message.text=(str(partial_route163.wake172) if partial_route163.get("stopped172",false) else "Has avanzado en línea recta hacia "+str(target.name)) if result.ok else last_error
 await curtain.open_eye()
 curtain.queue_free();curtain=null;travelling=false;_unlock_player()
 if result.ok and partial_route163.get("stopped172",false):map_notice170(str(partial_route163.wake172))
 return result.ok
func _load_travel148()->bool:
 await get_tree().physics_frame
 var swept:=TravelStraight172.segment(player,travel_origin,travel_target.pos)
 if swept.stopped:TravelStraight172.stop(partial_route163,swept.pos);travel_target.pos=swept.pos
 return true
func landing155(requested:Vector2)->Vector2:
 var terrain:Callable=func(pos:Vector2)->bool:return CountryRoute146.blocked(data,pos)
 # Keep a legal saved coastal position exactly. Reuse the shared actual-shape
 # query, rather than treating its center as an 18px teleport safety circle.
 var result:=TravelLanding148.find(player,requested,func(pos:Vector2)->bool:return pos!=requested or CountryRoute146.blocked(data,pos,0.))
 if result.is_finite():return result
 result=TravelLanding148.find(player,requested,terrain)
 if result.is_finite():return result
 var outlines:Array[PackedVector2Array]=[]
 if MotherTree155.blocked(data.tree_solid,requested,18.):outlines.append(data.tree_solid)
 if CountryIsland156.blocked(data.island,requested,18.):outlines.append(data.island)
 if outlines.is_empty():return result
 # A save from the previous, smaller footprint can lie inside a new root.
 # Reposition only after an actual physics-safe arrival has been found.
 var candidates:Array[Vector2]=[]
 for poly in outlines:
  for i in poly.size():
   var near:=Geometry2D.get_closest_point_to_segment(requested,poly[i],poly[(i+1)%poly.size()])
   for j in 8:candidates.append(near+Vector2.RIGHT.rotated(j*TAU/8.)*48.)
 candidates.sort_custom(func(a:Vector2,b:Vector2):return requested.distance_squared_to(a)<requested.distance_squared_to(b))
 for candidate in candidates:
  result=TravelLanding148.find(player,candidate,terrain)
  if result.is_finite():return result
 return Vector2(INF,INF)
func _validate_travel148()->Vector2:
 return TravelLanding148.find(player,travel_target.pos,func(pos:Vector2)->bool:return pos!=travel_target.pos or CountryRoute146.blocked(data,pos) or (not partial_route163.is_empty() and not partial_route163.allowed.call(pos)))
func _commit_travel148(pos:Vector2)->bool:
 var next:=CountryLedger146.record_position(ledger,pos)
 if next.is_empty():return false
 next.maps.water146.explored=travel_ledger.maps.water146.explored.duplicate(true);next.maps.water146.visited=travel_ledger.maps.water146.visited.duplicate(true)
 player.position=pos;ledger=next;preview_rest166=SiestaRest166.SECONDS;camera.reset_smoothing();return true
func _restore_travel148()->bool:
 player.position=travel_origin;ledger=travel_ledger.duplicate(true);camera.reset_smoothing();return true
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel"):
  if travelling:pass
  elif is_instance_valid(_note_dialog106):_map_notes159.close()
  elif is_instance_valid(modal):close_modal()
  else:request_return()
  get_viewport().set_input_as_handled()

func initial_ledger149()->Dictionary:
 return CountryLedger146.enter(CountryLedger146.fresh(maxi(1,SaveData.world_seed),SaveData.world_generator_version),SaveData.world_position,seed)
func session_title149()->String:return "País nuevo · maqueta sin guardado ni ritual"
func persists149()->bool:return false
func prepare_travel149()->bool:return true

func on_road154(point:Vector2)->bool:
 for path in [data.approach,data.bank]:
  for i in range(1,path.size()):
   if Geometry2D.get_closest_point_to_segment(point,path[i-1],path[i]).distance_to(point)<=45.:return true
 return false

func available_sites170()->Array[Dictionary]:
 var out:=CountryExploration148.available(ledger,data)
 out.append_array(SiestaDestinations170.notes(ledger.maps.water146.notes,func(pos:Vector2)->bool:return visited_cells.has(Vector2i((pos/CountryExploration148.CELL).floor()))))
 return out
func destination170(id:String)->Dictionary:
 for site in available_sites170():
  if site.id==id:return site
 return {}

func map_notice170(text:String)->void:
 last_error=text
 if notice170==null:
  notice170=ToastStack.new();notice170.z_index=100;hud_canvas.add_child(notice170)
 notice170.wide170=true;notice170._layout();notice170.set_top(110.);notice170.clear();notice170.push(text)
