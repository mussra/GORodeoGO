class_name TravelEstimate237
extends RefCounted
## Route-following model, not a guarantee. Uses the exact mounted stamina rules.
static func seconds(distance:float,horse:Dictionary,energy:Dictionary={},nutrition:float=1.)->float:
 var stats:=HorseStats.read(horse);var state:Dictionary=energy.duplicate(true) if not energy.is_empty() else WorldStamina.new_state(stats.power)
 var remaining:float=maxf(0.,distance);var elapsed:float=0.;var dt:float=.25
 while remaining>0. and elapsed<86400.:
  var gait:int=WorldStamina.cap_gait(state,WorldGait.GALOPE);var speed:float=WorldGait.speed_for(gait,stats.speed)
  var step:float=minf(dt,remaining/maxf(1.,speed));remaining-=speed*step;elapsed+=step;state=WorldStamina.tick(state,gait,true,step,true,nutrition)
 return elapsed
static func route(seed_:int,town:String,role:String)->Dictionary:
 var ids:=TownNetwork234.recommendation_path(seed_,town,role);var plans:=TownEnclosures227.plans(seed_);var distance:float=0.;var paths:Array=[]
 for i in range(ids.size()-1):
  var path:=TownNetwork234.link_path(seed_,ids[i],ids[i+1],plans)
  for j in path.size()-1:distance+=path[j].distance_to(path[j+1])
  paths.append(path)
 if not ids.is_empty():
  distance+=TownNetwork234.point(seed_,town,role).distance_to(plans[town].gate)
  var last:String=ids[-1];distance+=TownNetwork234.point(seed_,last,role).distance_to(plans[last].gate)
 return {"distance":distance,"hops":ids.size()-1,"ids":ids,"paths":paths}
static func text(seconds_:float)->String:
 var low:int=int(floor(seconds_*.8/10.))*10;var high:int=int(ceil(seconds_*1.2/10.))*10
 return clock(low)+" - "+clock(high)
static func clock(seconds_:int)->String:return "%d min %02d s"%[seconds_/60,seconds_%60]

static func between248(seed_:int,from:String,to:String,role:String="")->float:
 var plans:Dictionary=TownEnclosures227.plans(seed_);var nodes:Dictionary=TownNetwork234.nodes(seed_)
 var from_point:Vector2=TownNetwork234.point(seed_,from,role) if role in nodes.get(from,{}).get("roles",[]) else TownNetwork234.node_for(seed_,from).door
 var to_point:Vector2=TownNetwork234.point(seed_,to,role) if role in nodes.get(to,{}).get("roles",[]) else TownNetwork234.node_for(seed_,to).door
 var access:float=from_point.distance_to(plans[from].gate)+to_point.distance_to(plans[to].gate)
 var edges:Dictionary={}
 for id in nodes:edges[id]=[]
 for n in nodes.values():
  var parent:String=n.parent
  if parent.is_empty() and n.id.begins_with('extra:'):parent=TownNetwork234.cell_node(seed_,TownNetwork234.territory_parent(seed_,n.cell)).id
  if parent in nodes:
   var path:=TownNetwork234.link_path(seed_,parent,n.id,plans);var distance_:float=0.
   for i in path.size()-1:distance_+=path[i].distance_to(path[i+1])
   edges[parent].append({'id':n.id,'distance':distance_});edges[n.id].append({'id':parent,'distance':distance_})
 var todo:Array=[{'id':from,'distance':0.}];var distances:Dictionary={from:0.}
 while not todo.is_empty():
  todo.sort_custom(func(a,b):return a.distance<b.distance)
  var next:Dictionary=todo.pop_front()
  if next.id==to:return next.distance+access
  if next.distance>distances[next.id]:continue
  for edge in edges.get(next.id,[]):
   var d:float=next.distance+edge.distance
   if d<distances.get(edge.id,INF):distances[edge.id]=d;todo.append({'id':edge.id,'distance':d})
 var delta:Vector2=TownNetwork234.node_for(seed_,from).door-TownNetwork234.node_for(seed_,to).door
 return absf(delta.x)+absf(delta.y)+access
static func minutes248(seconds_:float)->String:
 var minutes_:int=maxi(1,roundi(seconds_/60.))
 return 'Tardarás aproximadamente %d %s con ese caballo.'%[minutes_,'minuto' if minutes_==1 else 'minutos']
