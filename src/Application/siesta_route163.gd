class_name SiestaRoute163
extends RefCounted
## One route/half-distance calculation; worlds supply existing roads and validity.
const STEP:float=80.
const FINAL_MANUAL:float=120.
static func clear(a:Vector2,b:Vector2,allowed:Callable)->bool:
 var count:int=maxi(1,ceili(a.distance_to(b)/20.))
 for i in count+1:
  if not allowed.call(a.lerp(b,float(i)/count)):return false
 return true
static func plan(origin:Vector2,goal:Vector2,roads:Array,allowed:Callable)->Dictionary:
 var graph:=AStar2D.new();var ids:Dictionary={}
 for road in roads:
  for i in range(1,road.size()):
   var a:Vector2=road[i-1];var b:Vector2=road[i];var count:int=maxi(1,ceili(a.distance_to(b)/STEP));var previous:int=-1
   for j in count+1:
    var point:Vector2=a.lerp(b,float(j)/count).round()
    if not allowed.call(point):previous=-1;continue
    if not ids.has(point):ids[point]=ids.size();graph.add_point(ids[point],point)
    var id:int=ids[point]
    if previous>=0 and previous!=id and clear(graph.get_point_position(previous),point,allowed):graph.connect_points(previous,id)
    previous=id
 if graph.get_point_count()==0:return {}
 var endpoints:Array[int]=[]
 for point in [origin,goal]:
  var candidates:Array=ids.keys();candidates.sort_custom(func(a:Vector2,b:Vector2):return point.distance_squared_to(a)<point.distance_squared_to(b))
  var endpoint:int=graph.get_available_point_id();graph.add_point(endpoint,point);endpoints.append(endpoint)
  var joined:int=0
  for candidate in candidates:
   if point.distance_to(candidate)>1000.:break
   if clear(point,candidate,allowed):
    graph.connect_points(endpoint,ids[candidate]);joined+=1
    if joined>=1:break
  if joined==0:return {}
 var route:PackedVector2Array=graph.get_point_path(endpoints[0],endpoints[1])
 return half170(route,allowed)
static func half170(route:PackedVector2Array,allowed:Callable)->Dictionary:
 var length:float=0.
 for i in range(1,route.size()):length+=route[i-1].distance_to(route[i])
 if length<FINAL_MANUAL*2.:return {}
 var remaining:float=length*.5;var half:=PackedVector2Array([route[0]])
 for i in range(1,route.size()):
  var distance:float=route[i-1].distance_to(route[i])
  if distance<.01:continue
  if remaining<=distance:half.append(route[i-1].lerp(route[i],remaining/distance));break
  half.append(route[i]);remaining-=distance
 return {"path":half,"pos":half[-1],"length":length,"advance":length*.5,"allowed":allowed}
## A road is helpful, not mandatory: the player can have ridden across grass.
## This fallback explores only already-seen terrain, with continuous obstacle checks.
static func terrain170(origin:Vector2,goal:Vector2,known_cells:Dictionary,cell_size:float,allowed:Callable)->Dictionary:
 if clear(origin,goal,allowed):return half170(PackedVector2Array([origin,goal]),allowed)
 var component:Dictionary={};var queue:Array[Vector2i]=[Vector2i((origin/cell_size).floor())];var cursor:int=0
 while cursor<queue.size():
  var cell:Vector2i=queue[cursor];cursor+=1
  if component.has(cell) or not known_cells.has(cell):continue
  component[cell]=true
  for delta in [Vector2i.RIGHT,Vector2i.LEFT,Vector2i.UP,Vector2i.DOWN]:
   var next:Vector2i=cell+delta
   if known_cells.has(next) and not component.has(next):queue.append(next)
 if not component.has(Vector2i((goal/cell_size).floor())):return {}
 var graph:=AStar2D.new();var ids:Dictionary={}
 for cell in component:
  var box:=Rect2(Vector2(cell)*cell_size,Vector2.ONE*cell_size)
  for x in range(ceili(box.position.x/STEP),ceili(box.end.x/STEP)):
   for y in range(ceili(box.position.y/STEP),ceili(box.end.y/STEP)):
    var key:=Vector2i(x,y);var point:=Vector2(key)*STEP
    if allowed.call(point):ids[key]=graph.get_available_point_id();graph.add_point(ids[key],point)
 for key in ids:
  for delta in [Vector2i.RIGHT,Vector2i.DOWN,Vector2i(1,1),Vector2i(-1,1)]:
   var next:Vector2i=key+delta
   if ids.has(next) and clear(Vector2(key)*STEP,Vector2(next)*STEP,allowed):graph.connect_points(ids[key],ids[next])
 var endpoints:Array[int]=[]
 for point in [origin,goal]:
  var endpoint:int=graph.get_available_point_id();graph.add_point(endpoint,point);endpoints.append(endpoint)
  var anchor:=Vector2i((point/STEP).round());var joined:int=0
  for ring in range(1,7):
   for x in range(-ring,ring+1):
    for y in range(-ring,ring+1):
     if maxi(absi(x),absi(y))!=ring and ring>1:continue
     var key:=anchor+Vector2i(x,y)
     if ids.has(key) and clear(point,Vector2(key)*STEP,allowed):graph.connect_points(endpoint,ids[key]);joined+=1
   if joined>0:break
  if joined==0:return {}
 return half170(graph.get_point_path(endpoints[0],endpoints[1]),allowed)
static func frontier(origin:Vector2,goal:Vector2)->Dictionary:
 var known:Dictionary={}
 for key in SaveData.world_discovered:known[str(key)]=true
 var allowed:Callable=func(point:Vector2)->bool:
  var c:=WorldMap.chunk_at(point)
  return known.has(WorldMap.chunk_key(c.x,c.y)) and (SaveData.world_generator_version<3 or not WorldTerrain103.blocked(SaveData.world_seed,point,18.))
 return direct172(origin,goal,allowed)
static func country(origin:Vector2,goal:Vector2,data:Dictionary,cells:Dictionary)->Dictionary:
 var allowed:Callable=func(point:Vector2)->bool:return cells.has(Vector2i((point/CountryExploration148.CELL).floor())) and not CountryRoute146.blocked(data,point)
 return direct172(origin,goal,allowed)
## Sleep is deliberately naive: never route around an obstacle.
static func direct172(origin:Vector2,goal:Vector2,allowed:Callable)->Dictionary:
 var length:float=origin.distance_to(goal)
 if length<FINAL_MANUAL*2. or not allowed.call(origin):return {}
 var aim:Vector2=origin.lerp(goal,.5);var steps:int=maxi(1,ceili(origin.distance_to(aim)/8.));var last:Vector2=origin;var stopped:bool=false
 for i in range(1,steps+1):
  var point:Vector2=origin.lerp(aim,float(i)/steps)
  if not allowed.call(point):stopped=true;break
  last=point
 if stopped:last=last.move_toward(origin,24.)
 if origin.distance_to(last)<1.:return {}
 return {"path":PackedVector2Array([origin,last]),"pos":last,"length":length,"advance":origin.distance_to(last),"allowed":allowed,"stopped172":stopped,"wake172":"El caballo se ha detenido antes de un obstáculo o de terreno desconocido. Te despiertas aquí; tendrás que seguir a caballo." if stopped else ""}
