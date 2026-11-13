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
 var route:PackedVector2Array=graph.get_point_path(endpoints[0],endpoints[1]);var length:float=0.
 for i in range(1,route.size()):length+=route[i-1].distance_to(route[i])
 if length<FINAL_MANUAL*2.:return {}
 var remaining:float=length*.5;var half:=PackedVector2Array([origin])
 for i in range(1,route.size()):
  var distance:float=route[i-1].distance_to(route[i])
  if distance<.01:continue
  if remaining<=distance:half.append(route[i-1].lerp(route[i],remaining/distance));break
  half.append(route[i]);remaining-=distance
 return {"path":half,"pos":half[-1],"length":length,"advance":length*.5,"allowed":allowed}
static func frontier(origin:Vector2,goal:Vector2)->Dictionary:
 var known:Dictionary={}
 for key in SaveData.world_discovered:known[str(key)]=true
 var roads:Array=[];var bounds:=Rect2(origin,Vector2.ZERO).expand(goal).grow(1200.)
 var count:int=0
 for key in known:
  var parts:PackedStringArray=str(key).split(",");var c:=Vector2i(int(parts[0]),int(parts[1]))
  if not bounds.intersects(Rect2(Vector2(c)*1024.,Vector2.ONE*1024.)):continue
  count+=1
  if count>2500:return {}
  if SaveData.world_generator_version>=2:
   var graph:Dictionary=WorldNominal98.graph_for_chunk(SaveData.world_seed,c,SaveData.world_generator_version)
   for cell in graph:
    for next in graph[cell]:
     if cell.x<next.x or (cell.x==next.x and cell.y<next.y):roads.append(PackedVector2Array([ModularWorldLayout93.world(cell),ModularWorldLayout93.world(next)]))
  else:
   var row:=PackedVector2Array();var column:=PackedVector2Array()
   for i in range(floori(c.x*1024./80.),ceili((c.x+1)*1024./80.)+1):
    var x:float=i*80.;row.append(Vector2(x,WorldMap.trail_y_at(SaveData.world_seed,x)))
   for i in range(floori(c.y*1024./80.),ceili((c.y+1)*1024./80.)+1):
    var y:float=i*80.;column.append(Vector2(WorldMap.branch_x_at(SaveData.world_seed,y),y))
   roads.append(row);roads.append(column)
 var allowed:Callable=func(point:Vector2)->bool:
  var c:=WorldMap.chunk_at(point)
  return known.has(WorldMap.chunk_key(c.x,c.y)) and (SaveData.world_generator_version<3 or not WorldTerrain103.blocked(SaveData.world_seed,point,18.))
 return plan(origin,goal,roads,allowed)
static func country(origin:Vector2,goal:Vector2,data:Dictionary,cells:Dictionary)->Dictionary:
 var allowed:Callable=func(point:Vector2)->bool:return cells.has(Vector2i((point/CountryExploration148.CELL).floor())) and not CountryRoute146.blocked(data,point)
 return plan(origin,goal,[data.approach,data.upstream],allowed)
