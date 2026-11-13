class_name WorldDiscoveryMap159
extends Control
## Self-drawing discovery map (Ant 11:29): explored chunks show their caminos,
## ranch, trees/rocks, seen pig pens and missions; unseen stays hidden; player
## marker; drag to scroll, +/- to zoom. Content comes from the persisted
## discovered chunks, so it is saved with the game. Cartoon style.
## Small corner minimap like the arena one (Ant 17:54: "pequeño como el otro"):
## tap the small map to expand it; X / back / Mapa button closes.
var world: Node2D
var expanded: bool = false
var zoom: float = 1.0
var pan: Vector2 = Vector2.ZERO
var _selected_note162:String=""
var _note_pan162:Vector2=Vector2.ZERO
var _dragging: bool = false
var _drag_from: Vector2 = Vector2.ZERO
var _pan_from: Vector2 = Vector2.ZERO
var _pulse: float = 0.0
var _close_btn: Button = null
var _zoom_btns: Array = []
var _zoom_slider106:HSlider
var _note_help106:Label
var _zoom_label106:Label
var _cache_clock106:float=0.
var _draw_origin106:Vector2=Vector2.ZERO
var _touch_index106:int=-1
var _touches108:Dictionary={}
var _pinch_distance108:float=0.
var _pinch_mid108:Vector2
var _pinch_used108:bool=false
var _notes162:Button
var _sites144:Button
var _find108:Button
var _markers108:Control
var _press_time106:float=0.
var _long_pressed106:bool=false
var _last_point106:Vector2
var _clip106:Control
var _background106:Control
# Retain terrain draw commands. Only the rider marker animates each frame.
# Hash values, not array identity: edits can be appended or changed in place.
var _terrain: Control
var _terrain_signature: int = 0
var _terrain_valid: bool = false
var _map_geometry: Dictionary = {}
var terrain_rebuilds: int = 0

func _ensure_terrain() -> void:
 if _terrain == null:
  _terrain = Control.new()
  _terrain.mouse_filter = Control.MOUSE_FILTER_IGNORE
  _terrain.show_behind_parent = true
  _terrain.draw.connect(_draw_terrain)
  add_child(_terrain)
  move_child(_terrain, 0) # Terrain must stay below X and both zoom buttons.
 if _background106==null:
  _background106=Control.new();_background106.mouse_filter=Control.MOUSE_FILTER_IGNORE;_background106.show_behind_parent=true
  _background106.draw.connect(func():
   _background106.draw_style_box(MapAppearance.frame(),Rect2(Vector2.ZERO,size))
   _background106.draw_rect(Rect2(Vector2(12,12),(size-Vector2(24,24)).max(Vector2.ZERO)),MapAppearance.floor_color("10252d")))
  add_child(_background106);move_child(_background106,0);move_child(_terrain,1)
 var signature = hash([content_signature159(),size,expanded,zoom,pan])
 if _terrain_valid and signature == _terrain_signature:return
 _terrain_signature = signature
 _terrain_valid = true
 var data = _cells()
 var area = Rect2(Vector2(12, 82 if expanded else 12), (size - Vector2(24, 174 if expanded else 24)).max(Vector2(32,32)))
 var cols: int = data.maxs.x - data.mins.x + 1
 var rows: int = data.maxs.y - data.mins.y + 1
 var cell: float = maxf(.0001,minf(72.0, minf((area.size.x - 16.0) / cols, (area.size.y - 16.0) / rows))) * (zoom if expanded else 1.0)
 var content = Vector2(cols, rows) * cell
 var limit = ((content - area.size) / 2.0) + Vector2(12,12)
 limit.x = maxf(limit.x, 0.0);limit.y = maxf(limit.y, 0.0)
 if expanded:limit=limit.max(_note_pan162.abs())
 pan = pan.clamp(-limit, limit)
 _map_geometry = {"data":data,"area":area,"cell":cell,"origin":area.position + (area.size - content) / 2.0 + (pan if expanded else Vector2.ZERO)}
 # Store the normalized pan so clamping does not trigger a second rebuild.
 _terrain_signature = hash([content_signature159(),size,expanded,zoom,pan])
 if _clip106==null:
  _clip106=Control.new();_clip106.mouse_filter=Control.MOUSE_FILTER_IGNORE;_clip106.clip_contents=true;_clip106.show_behind_parent=true;add_child(_clip106)
  _terrain.reparent(_clip106)
  _markers108=Control.new();_markers108.mouse_filter=Control.MOUSE_FILTER_IGNORE;_markers108.draw.connect(_draw_markers108);_clip106.add_child(_markers108)
 _clip106.position=area.position;_clip106.size=area.size
 _draw_origin106=_map_geometry.origin;_terrain.position=Vector2.ZERO
 terrain_rebuilds += 1
 _terrain.queue_redraw()
 _background106.queue_redraw()

func _layout() -> void:
 var viewport: Vector2 = get_viewport_rect().size
 var previous_size:Vector2=size
 size = Vector2(minf(700, viewport.x - 80), minf(470, viewport.y - 105)) if expanded else Vector2(180, 112)
 position = (viewport - size) / 2.0 if expanded else Vector2(18, minimap_top159())
 if size!=previous_size:_terrain_valid=false
 if _sites144!=null:_sites144.visible=expanded;_sites144.size=Vector2(170,56)
 if _notes162!=null:_notes162.visible=expanded;_notes162.position=Vector2(200,16);_notes162.size=Vector2(104,56)
 if _find108!=null:
  _find108.visible=expanded;_find108.position=Vector2(size.x-380,16);_find108.size=Vector2(272,56)
 if _zoom_btns.size()==2:
  _zoom_btns[0].position=Vector2(24,size.y-76);_zoom_btns[1].position=Vector2(size.x-88,size.y-76)
 if _zoom_slider106!=null:
  _zoom_slider106.position=Vector2(105,size.y-64);_zoom_slider106.size=Vector2(size.x-210,40)
  _note_help106.visible=expanded;_note_help106.position=Vector2(96,size.y-24);_note_help106.size=Vector2(size.x-192,20);_note_help106.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
  _zoom_slider106.visible=expanded;_zoom_label106.position=Vector2(size.x/2.-40,size.y-98);_zoom_label106.visible=expanded

func _process(delta: float) -> void:
 if visible:
  _pulse += delta
  _layout()
  if _close_btn != null:
   _close_btn.visible = expanded
  for b in _zoom_btns:
   b.visible = expanded
  _cache_clock106+=delta
  if not _terrain_valid or (not _dragging and _cache_clock106>.3):
   _cache_clock106=0.;_ensure_terrain()
  if _dragging and not _pinch_used108 and not _long_pressed106 and expanded and Time.get_ticks_msec()/1000.-_press_time106>.6 and _last_point106.distance_to(_drag_from)<12.:
   _long_pressed106=true
   world._open_map_note106(_map_point106(_drag_from))
  queue_redraw()

func _ready() -> void:
 mouse_filter = Control.MOUSE_FILTER_STOP
 # Ant 22:54 ("el mapa se sale con el zoom"): never paint outside the box.
 clip_contents = true
 # clear close affordances (Ant 7-nov-2026: "no lo puedo cerrar"):
 # X button, tap without drag, or Android back (ui_cancel in the world)
 var close := Button.new()
 close.text = "X"
 close.set_anchors_preset(Control.PRESET_TOP_RIGHT)
 close.offset_left = -90
 close.offset_top = 16
 close.offset_right = -16
 close.offset_bottom = 72
 QuestButtonStyle.apply(close);close.add_theme_font_size_override("font_size", 32)
 close.pressed.connect(world._toggle_map)
 add_child(close)
 _close_btn = close
 _find108=Button.new();_find108.text="Encontrar mi caballo";QuestButtonStyle.apply(_find108);_find108.add_theme_font_size_override("font_size",19);_find108.pressed.connect(_find_player108);add_child(_find108)
 var minus := Button.new()
 minus.text = "-"
 minus.position = Vector2(24, size.y - 84)
 minus.size = Vector2(64, 56)
 QuestButtonStyle.apply(minus);minus.add_theme_font_size_override("font_size",34)
 minus.pressed.connect(func(): _set_zoom(zoom / 1.4))
 add_child(minus)
 _zoom_btns.append(minus)
 var plus := Button.new()
 plus.text = "+"
 plus.position = Vector2(96, size.y - 84)
 plus.size = Vector2(64, 56)
 QuestButtonStyle.apply(plus);plus.add_theme_font_size_override("font_size",34)
 plus.pressed.connect(func(): _set_zoom(zoom * 1.4))
 add_child(plus)
 _zoom_btns.append(plus)
 _zoom_slider106=HSlider.new();_zoom_slider106.min_value=.5;_zoom_slider106.max_value=32.;_zoom_slider106.step=.05;_zoom_slider106.value=zoom;_zoom_slider106.scrollable=false
 var track=StyleBoxFlat.new();track.bg_color=Color("876739");track.set_corner_radius_all(6);track.content_margin_top=6.;track.content_margin_bottom=6.;_zoom_slider106.add_theme_stylebox_override("slider",track)
 var thumb_image:Image=Image.create(30,30,false,Image.FORMAT_RGBA8)
 for x in 30:
  for y in 30:
   if Vector2(x-15,y-15).length()<14.:thumb_image.set_pixel(x,y,Color("ffdf8c"))
 var thumb:ImageTexture=ImageTexture.create_from_image(thumb_image);_zoom_slider106.add_theme_icon_override("grabber",thumb);_zoom_slider106.add_theme_icon_override("grabber_highlight",thumb)
 _zoom_slider106.value_changed.connect(_set_zoom);add_child(_zoom_slider106)
 _zoom_label106=Label.new();_zoom_label106.add_theme_font_size_override("font_size",20);add_child(_zoom_label106)
 _sites144=Button.new();_sites144.text="Sitios visitados";_sites144.tooltip_text="Toca un círculo dorado para viajar. Mantén pulsado el terreno para añadir una nota.";_sites144.position=Vector2(20,16);_sites144.size=Vector2(230,56);QuestButtonStyle.apply(_sites144);_sites144.pressed.connect(func():show_sites159());add_child(_sites144)
 _notes162=Button.new();_notes162.text="Notas";QuestButtonStyle.apply(_notes162);_notes162.pressed.connect(func():world._map_notes159.show_list162());add_child(_notes162)
 _note_help106=Label.new();_note_help106.text="Mantén pulsado el mapa para añadir o editar una nota";_note_help106.position=Vector2(24,29);_note_help106.add_theme_font_size_override("font_size",14);_note_help106.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(_note_help106)
 _layout();_set_zoom(zoom)
 restore_minimap179.call_deferred()

func restore_minimap179()->void:
 visible=true
 _layout();_terrain_valid=false;_ensure_terrain()
 if _close_btn!=null:_close_btn.visible=expanded
 for b in _zoom_btns:b.visible=expanded
 queue_redraw()

func _set_zoom(z: float) -> void:
 zoom = clampf(z, 0.5, 32.0)
 if _zoom_slider106!=null:_zoom_slider106.set_value_no_signal(zoom);_zoom_label106.text="%.1fx"%zoom
 _ensure_terrain();queue_redraw()

func _map_point106(point:Vector2)->Vector2:
 _ensure_terrain()
 return ((point-_map_geometry.origin)/_map_geometry.cell+Vector2(_map_geometry.data.mins))*cell_size159()
func _begin_drag106(point:Vector2)->void:
 _dragging=true;_drag_from=point;_last_point106=point;_pan_from=pan;_press_time106=Time.get_ticks_msec()/1000.;_long_pressed106=false
func _drag106(point:Vector2)->void:
 _last_point106=point
 if not expanded or _long_pressed106:return
 var data:Dictionary=_map_geometry.data;var content:Vector2=Vector2(data.maxs-data.mins+Vector2i.ONE)*_map_geometry.cell
 var limit:Vector2=((content-_map_geometry.area.size)*.5+Vector2.ONE*12.).max(Vector2.ZERO).max(_note_pan162.abs())
 pan=(_pan_from+point-_drag_from).clamp(-limit,limit)
 _map_geometry.origin=_map_geometry.area.position+(_map_geometry.area.size-content)*.5+pan
 _terrain.position=_map_geometry.origin-_draw_origin106
 if _terrain.position.length()>250.:_ensure_terrain()
 queue_redraw()
func _end_drag106(point:Vector2)->void:
 if not _dragging:return
 if not _long_pressed106 and point.distance_to(_drag_from)<12.:
  if not expanded:world._toggle_map()
  else:_select_site144(point)
 _dragging=false;_ensure_terrain()
func _select_site144(point:Vector2)->void:
 var nearest:String="";var distance:float=24.
 for site in available159():
  var mapped:Vector2=_to_map(site.pos,_map_geometry.data.mins,_map_geometry.cell,_map_geometry.origin)
  var d:float=point.distance_to(mapped)
  if d<distance:distance=d;nearest=site.id
 if not nearest.is_empty():choose159(nearest)

func _zoom_at108(z:float,from:Vector2,to:Vector2)->void:
 var anchor:Vector2=_map_point106(from)
 _set_zoom(z)
 var after:Vector2=_to_map(anchor,_map_geometry.data.mins,_map_geometry.cell,_map_geometry.origin)
 pan+=to-after;_ensure_terrain();queue_redraw()
func _find_player108()->void:
 _ensure_terrain()
 var point:Vector2=_to_map(world.player.position,_map_geometry.data.mins,_map_geometry.cell,_map_geometry.origin)
 pan+=_map_geometry.area.get_center()-point;_ensure_terrain();queue_redraw()
func _pinch_state108()->void:
 var points:Array=_touches108.values()
 _pinch_distance108=(points[0] as Vector2).distance_to(points[1])
 _pinch_mid108=(points[0]+points[1])*.5
func _gui_input(event: InputEvent) -> void:
 if event is InputEventScreenTouch:
  if event.pressed:
   _touches108[event.index]=event.position
   if _touches108.size()==1:
    _touch_index106=event.index;_pinch_used108=false;_begin_drag106(event.position)
   elif _touches108.size()>=2:
    _pinch_used108=true;_dragging=false;_pinch_state108()
  else:
   _touches108.erase(event.index)
   if not _pinch_used108:_end_drag106(event.position)
   if _touches108.is_empty():_touch_index106=-1;_dragging=false;_pinch_used108=false
   elif _touches108.size()==1:
    _touch_index106=_touches108.keys()[0];_begin_drag106(_touches108.values()[0])
   else:_pinch_state108()
  accept_event()
 elif event is InputEventScreenDrag and _touches108.has(event.index):
  _touches108[event.index]=event.position
  if _touches108.size()>=2 and expanded:
   var before:Vector2=_pinch_mid108;var distance:float=_pinch_distance108;_pinch_state108()
   if distance>1.:_zoom_at108(zoom*_pinch_distance108/distance,before,_pinch_mid108)
  elif event.index==_touch_index106:_drag106(event.position)
  accept_event()
 elif event is InputEventMouse and _touch_index106<0 and event.device!=InputEvent.DEVICE_ID_EMULATION:
  if event is InputEventMouseButton:
   if event.button_index==MOUSE_BUTTON_LEFT:
    if event.pressed:_begin_drag106(event.position)
    else:_end_drag106(event.position)
   elif event.pressed and expanded and event.button_index==MOUSE_BUTTON_WHEEL_UP:_zoom_at108(zoom*1.15,event.position,event.position)
   elif event.pressed and expanded and event.button_index==MOUSE_BUTTON_WHEEL_DOWN:_zoom_at108(zoom/1.15,event.position,event.position)
  elif event is InputEventMouseMotion and _dragging:_drag106(event.position)

func _cells() -> Dictionary:
 var out: Dictionary = {"cells": [], "mins": Vector2i.ZERO, "maxs": Vector2i.ZERO}
 var mins := Vector2i(1 << 30, 1 << 30)
 var maxs := Vector2i(-(1 << 30), -(1 << 30))
 for key in SaveData.world_discovered:
  var parts := str(key).split(",")
  if parts.size() != 2:
   continue
  var c := Vector2i(int(parts[0]), int(parts[1]))
  out.cells.append(c)
  mins = Vector2i(mini(mins.x, c.x), mini(mins.y, c.y))
  maxs = Vector2i(maxi(maxs.x, c.x), maxi(maxs.y, c.y))
 mins = Vector2i(mini(mins.x, 0), mini(mins.y, 0))
 maxs = Vector2i(maxi(maxs.x, 0), maxi(maxs.y, 0))
 out.mins = mins
 out.maxs = maxs
 return out

func _chunk_rect(c: Vector2i, mins: Vector2i, cell: float, origin: Vector2) -> Rect2:
 return Rect2(origin + Vector2(c - mins) * cell, Vector2.ONE * cell)

func _to_map(pos: Vector2, mins: Vector2i, cell: float, origin: Vector2) -> Vector2:
 return origin + (pos / cell_size159() - Vector2(mins)) * cell

func _draw_terrain() -> void:

 var area: Rect2 = _map_geometry.area
 _terrain.draw_set_transform(-area.position)
 if area.size.x <= 0.0 or area.size.y <= 0.0:return

 var data: Dictionary = _map_geometry.data
 if (data.cells as Array).is_empty():return
 var mins: Vector2i = data.mins
 var cell: float = _map_geometry.cell
 var origin: Vector2 = _map_geometry.origin
 var font: Font = get_theme_default_font()
 var lod_buckets106:Dictionary={}
 for c in data.cells:
  var r: Rect2 = _chunk_rect(c, mins, cell, origin)
  if not Rect2(Vector2.ZERO,size).grow(300.).intersects(r):continue
  if cell<8.:
   var bucket:Vector2i=Vector2i((r.position/3.).floor())
   if not lod_buckets106.has(bucket):lod_buckets106[bucket]=true;_terrain.draw_rect(Rect2(Vector2(bucket)*3.,Vector2.ONE*maxf(3.,cell)),Color("3f7a45"))
   if SaveData.world_generator_version>=3:
    for ridge in WorldTerrain103.ridges_for_chunk(SaveData.world_seed,c):
     var box:Rect2=ridge.box;_terrain.draw_rect(Rect2(_to_map(box.position,mins,cell,origin),Vector2(maxf(1.,box.size.x/1024.*cell),maxf(1.,box.size.y/1024.*cell))),Color("777384"))
   _draw_fields138(c,mins,cell,origin)
   continue
  # cartoon ground tile with a soft rim
  _terrain.draw_rect(r.grow(1.0), Color.TRANSPARENT, true)
  _terrain.draw_rect(r, MapAppearance.terrain_over_base("3f7a45"), true)
  var chunk: Dictionary = WorldEdits.apply(WorldMap.generate(SaveData.world_seed, c.x, c.y), SaveData.world_edits, c.x, c.y)
  _draw_fields138(c,mins,cell,origin)
  _draw_trails(c, mins, cell, origin, r)
  _draw_decor(chunk, mins, cell, origin, r)
  if WorldMap.is_ranch_chunk(c.x, c.y):
   _draw_ranch(r)
  var pen: Dictionary = chunk.get("pigs", {})
  if not pen.is_empty():
   var pid: String = WorldEdits.edited_pen_id(pen.get("pos", Vector2.ZERO)) if pen.get("edited", false) else WorldMap.pig_id(c.x, c.y)
   var pc: Vector2 = _to_map(pen.get("pos", Vector2.ZERO), mins, cell, origin)
   var col: Color = Color("f2a7b8") if not SaveData.world_pigs.has(pid) else Color("f2a7b866")
   _terrain.draw_circle(pc, maxf(3.0, cell * 0.07), col)
  _mission_mark(c, r, font, cell)
func _draw_fields138(c:Vector2i,mins:Vector2i,cell:float,origin:Vector2)->void:
 if SaveData.world_generator_version<3 or SaveData.world_flora138.is_empty():return
 var box:=Rect2(Vector2(c)*1024.,Vector2.ONE*1024.)
 var clip:=PackedVector2Array([box.position,Vector2(box.end.x,box.position.y),box.end,Vector2(box.position.x,box.end.y)])
 for field in FloristJourney138.descriptors(SaveData.world_flora138,SaveData.world_seed):
  if not (field.rect as Rect2).grow(150).intersects(box):continue
  for polygon in Geometry2D.intersect_polygons(FloristJourney138.boundary(field),clip):
   var screen:=PackedVector2Array()
   for p in polygon:screen.append(_to_map(p,mins,cell,origin))
   if screen.size()>=3:_terrain.draw_colored_polygon(screen,Color("b37a72") if field.species=="red" else Color("7e7b93"))

 for points in FloristJourney138.lanes(SaveData.world_flora138):
  for segment in Geometry2D.intersect_polyline_with_polygon(points,clip):
   for i in segment.size()-1:_terrain.draw_line(_to_map(segment[i],mins,cell,origin),_to_map(segment[i+1],mins,cell,origin),Color("bb9460"),maxf(1.,cell*.03))
 if not SaveData.world_cousins140.is_empty():
  for id in VillageCousins140.IDS:
   var cousin:Vector2=VillageCousins140.point(SaveData.world_cousins140,id)
   var lane:=PackedVector2Array([Vector2(cousin.x,470),cousin])
   for segment in Geometry2D.intersect_polyline_with_polygon(lane,clip):
    for i in segment.size()-1:_terrain.draw_line(_to_map(segment[i],mins,cell,origin),_to_map(segment[i+1],mins,cell,origin),Color("bb9460"),maxf(1.,cell*.03))
   if box.has_point(cousin):
    var point:Vector2=_to_map(cousin,mins,cell,origin)
    _terrain.draw_circle(point,3.,Color("efb950"))
    if expanded and cell>24.:_terrain.draw_string(get_theme_default_font(),point+Vector2(8,0),str(VillageCousins140.LABELS[id]),HORIZONTAL_ALIGNMENT_LEFT,-1,14,Color("fff2bc"))
 var destination:Vector2=FloristJourney138.door(SaveData.world_flora138)
 if box.has_point(destination):
  var point:Vector2=_to_map(destination,mins,cell,origin)
  _terrain.draw_rect(Rect2(point-Vector2(3,3),Vector2(6,6)),Color("f2d987"))
  if expanded and cell>24.:_terrain.draw_string(get_theme_default_font(),point+Vector2(8,0),"Florista del Este",HORIZONTAL_ALIGNMENT_LEFT,-1,14,Color("fff2bc"))

func _draw() -> void:
 if _markers108!=null:_markers108.queue_redraw()
func _draw_markers108()->void:
 if not _terrain_valid:_ensure_terrain()
 if (_map_geometry.data.cells as Array).is_empty():return
 var mins: Vector2i = _map_geometry.data.mins
 var cell: float = _map_geometry.cell
 var origin: Vector2 = _map_geometry.origin-_map_geometry.area.position
 # player marker (Ant 7-nov-2026: "ver claramente donde esta mi vaquero"):
 # pulsing ring, high-contrast dot and facing arrow
 var ppos: Vector2 = _to_map(world.player.position, mins, cell, origin)
 if expanded:
  for site in available159():
   var point:Vector2=_to_map(site.pos,mins,cell,origin)
   _markers108.draw_circle(point,8.,Color("efb950"))
   _markers108.draw_arc(point,11.,0,TAU,24,Color("fff1d2"),2.)

 for rows in notes159().values():
  for note in rows:
   var point:Vector2=_to_map(note.pos,mins,cell,origin)
   if Rect2(Vector2(12,12),(size-Vector2(24,100 if expanded else 24)).max(Vector2.ZERO)).has_point(point):
    if expanded and str(note.id)==_selected_note162:_markers108.draw_arc(point,15.+sin(_pulse*3.)*2.,0,TAU,32,Color("fff1d2"),3.)
    _markers108.draw_circle(point,8.,Color("f2bc51"));_markers108.draw_circle(point,3.,Color("413126"))
 for flower in flowers159().values():
  var point:Vector2=_to_map(flower.position,mins,cell,origin)
  if Rect2(Vector2.ZERO,size).has_point(point):
   _markers108.draw_circle(point,7.,Color(flower.color,.25));WorldFlowerTarget105.glyph(_markers108,point,4.,flower.color)
 MapPlayerMarker99.draw(_markers108,ppos,world.player.velocity,_pulse)

func _draw_trails(c: Vector2i, mins: Vector2i, cell: float, origin: Vector2, r: Rect2) -> void:
 if WorldNominal98.enabled():
  if SaveData.world_generator_version>=3:
   for ridge in WorldTerrain103.ridges_for_chunk(SaveData.world_seed,c):
    var box:Rect2=ridge.box
    _terrain.draw_rect(Rect2(_to_map(box.position,mins,cell,origin),box.size/cell_size159()*cell),Color("777384"))
  var graph=WorldNominal98.graph_for_chunk(SaveData.world_seed,c,SaveData.world_generator_version)
  for tile in graph:
   var p=ModularWorldLayout93.world(tile)
   if WorldMap.chunk_at(p)!=c:continue
   for next in graph[tile]:
    _terrain.draw_line(_to_map(p,mins,cell,origin),_to_map(p.lerp(ModularWorldLayout93.world(next),.5),mins,cell,origin),Color("a5825a"),maxf(1.,cell*.03),true)
  return
 # clip every dot to its own discovered tile: unseen world stays hidden
 var seed: int = SaveData.world_seed
 var worigin: Vector2 = Vector2(c) * cell_size159()
 var col := Color("a5825a")
 var dot: float = maxf(2.0, cell * 0.055)
 var clip: Rect2 = r.grow(dot * 0.5)
 for i in range(0, 9):
  var wx: float = worigin.x + i * cell_size159() / 8.0
  var p1 := Vector2(wx, WorldMap.trail_y_at(seed, wx))
  var m1: Vector2 = _to_map(p1, mins, cell, origin)
  if clip.has_point(m1):
   _terrain.draw_circle(m1, dot, col)
  var wy: float = worigin.y + i * cell_size159() / 8.0
  var p2 := Vector2(WorldMap.branch_x_at(seed, wy), wy)
  var m2: Vector2 = _to_map(p2, mins, cell, origin)
  if clip.has_point(m2):
   _terrain.draw_circle(m2, dot, col)

 if c==Vector2i.ZERO:
  for lane in WorldPaths.access_lanes(seed):
   for j in lane.size()-1:
    _terrain.draw_line(_to_map(lane[j],mins,cell,origin),_to_map(lane[j+1],mins,cell,origin),col,maxf(1.0,cell*.03),true)

func _draw_decor(chunk: Dictionary, mins: Vector2i, cell: float, origin: Vector2, r: Rect2) -> void:
 var dot: float = maxf(1.6, cell * 0.035)
 for d in chunk.get("decor", []):
  if SaveData.world_generator_version>=3 and not d.get("edited",false):
   if CousinLayer140.reserved(SaveData.world_cousins140,d.pos) or FlowerExpansion138.reserve(SaveData.world_flora138,d.pos) or FlowerExpansion138.exclude_decor(SaveData.world_flora138,SaveData.world_seed,d):continue
  if WorldNominal98.enabled() and not WorldNominal98.keep_decor(d,world._get_surface98()):continue
  if SaveData.world_generator_version>=3 and WorldTerrain103.blocked(SaveData.world_seed,d.pos,40.):continue
  var p: Vector2 = _to_map(d["pos"], mins, cell, origin)
  if not r.grow(4.0).has_point(p):
   continue
  match d.get("kind", ""):
   "tree", "fruit_tree":
    _terrain.draw_circle(p, dot * 1.4, Color("2f5d33"))
   "pine":
    _terrain.draw_colored_polygon(PackedVector2Array([p + Vector2(-dot * 1.4, dot), p + Vector2(0, -dot * 1.6), p + Vector2(dot * 1.4, dot)]), Color("2f5d33"))
   "rock":
    _terrain.draw_circle(p, dot, Color("9fabb6"))
   "bush":
    _terrain.draw_circle(p, dot, Color("63a06b"))
   "cactus":
    _terrain.draw_rect(Rect2(p - Vector2(dot * 0.5, dot), Vector2(dot, dot * 2.0)), Color("3e7d46"))
   "flower":
    _terrain.draw_circle(p, dot, Color("e86a8a"))

func _draw_ranch(r: Rect2) -> void:
 if WorldNominal98.enabled():
  var point=_to_map(WorldNominal98.home(),_map_geometry.data.mins,_map_geometry.cell,_map_geometry.origin)
  _terrain.draw_circle(point,maxf(3.,r.size.x*.06),Color("f2d987"));return
 # little house: brown body + red roof, cartoon icon for home
 var center: Vector2 = r.position + Vector2(r.size.x * 0.16, r.size.y * 0.2)
 var s: float = maxf(4.0, r.size.x * 0.09)
 _terrain.draw_rect(Rect2(center - Vector2(s, s * 0.4), Vector2(s * 2.0, s * 1.2)), Color("8a5a33"))
 _terrain.draw_colored_polygon(PackedVector2Array([center + Vector2(-s * 1.2, -s * 0.4), center + Vector2(0, -s * 1.3), center + Vector2(s * 1.2, -s * 0.4)]), Color("b4452f"))

func _mission_mark(c: Vector2i, r: Rect2, font: Font, cell: float) -> void:
 var mission_id: String = WorldMap.herd_mission_id(c.x, c.y)
 var state: String = SaveData.world_missions.get(mission_id, "")
 var pos: Vector2 = r.position + Vector2(r.size.x - cell * 0.34, r.size.y - cell * 0.1)
 if SaveData.world_tamed.has(mission_id) or state == "done":
  _terrain.draw_circle(pos - Vector2(cell * 0.12, cell * 0.24), cell * 0.14, Color("b3f6df"))
  _terrain.draw_string(font, pos - Vector2(cell * 0.22, cell * 0.14), "✓", HORIZONTAL_ALIGNMENT_LEFT, -1, maxi(1,int(cell * 0.34)), Color("1d2a26"))
 elif state == "encargo":
  _terrain.draw_circle(pos - Vector2(cell * 0.12, cell * 0.24), cell * 0.14, Color("f2d987"))
  _terrain.draw_string(font, pos - Vector2(cell * 0.17, cell * 0.14), "!", HORIZONTAL_ALIGNMENT_LEFT, -1, maxi(1,int(cell * 0.34)), Color("1d2a26"))
 elif state == "offered":
  _terrain.draw_circle(pos - Vector2(cell * 0.12, cell * 0.24), cell * 0.14, Color("ffffff"))
  _terrain.draw_string(font, pos - Vector2(cell * 0.2, cell * 0.14), "?", HORIZONTAL_ALIGNMENT_LEFT, -1, maxi(1,int(cell * 0.34)), Color("1d2a26"))

func cell_size159()->float:return WorldMap.CHUNK_SIZE
func content_signature159()->int:return hash([SaveData.world_seed,SaveData.world_discovered,SaveData.world_edits,SaveData.world_pigs,SaveData.world_missions,SaveData.world_tamed,SaveData.world_flora138,SaveData.world_cousins140])
func available159()->Array[Dictionary]:return world._travel144.available() if world._travel144!=null else []
func notes159()->Dictionary:return SaveData.world_notes106
func flowers159()->Dictionary:return world._flower_nodes105
func show_sites159()->void:
 if world._travel144!=null:world._travel144.show_sites()
func choose159(id:String)->void:
 if world._travel144!=null:world._travel144.choose(id)

func minimap_top159()->float:return 84.

func center_note162(note:Dictionary)->void:
 _selected_note162=str(note.id)
 _ensure_terrain()
 var data:Dictionary=_map_geometry.data
 var target:Vector2=note.pos
 var point:Vector2=_to_map(target,data.mins,_map_geometry.cell,_map_geometry.origin)
 pan+=_map_geometry.area.get_center()-point;_note_pan162=pan;_terrain_valid=false;_ensure_terrain();queue_redraw()
