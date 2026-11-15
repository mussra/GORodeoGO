class_name TownEnclosures227
extends RefCounted
## V4 only. One deterministic contour owns drawing, collisions and map outlines.
const SHAPES:Array[String]=["rectángulo","rombo","estrella","círculo","cuadrado","pentágono"]
const THICKNESS:float=72.
const GATE_WIDTH:float=320.
const TRUNK_Y:float=3990.
static var cache:Dictionary={}
static func branch_flip231(seed_:int)->bool:
 return posmod(hash("town-branches231-%d"%seed_),2)==1
static func doors(seed_:int)->Dictionary:
 if SaveData.world_generator_version>=5:
  var flip:float=-1. if branch_flip231(seed_) else 1.
  return {"home":FloristJourney138.home_door(seed_),"east138":Vector2(10560,358),"west140":Vector2(10560,358-10240.*flip),"east140":Vector2(10560,358+10240.*flip)}
 return {"home":FloristJourney138.home_door(seed_),"east138":Vector2(10560,358),"west140":Vector2(-9920,358),"east140":Vector2(20800,358)}
static func contents(seed_:int,id:String)->Rect2:
 if id=="home":return Rect2(Vector2(-100,-420),Vector2(1930,1670))
 return Rect2(doors(seed_)[id]+Vector2(-800,-620),Vector2(1550,1120))
static func normalized(shape:int)->PackedVector2Array:
 if shape==0:return PackedVector2Array([Vector2(-1,-.8),Vector2(1,-.8),Vector2(1,.8),Vector2(-1,.8)])
 if shape==1:return PackedVector2Array([Vector2(0,-1),Vector2(1,0),Vector2(0,1),Vector2(-1,0)])
 if shape==4:return PackedVector2Array([Vector2(-1,-1),Vector2(1,-1),Vector2(1,1),Vector2(-1,1)])
 var out:=PackedVector2Array();var count:int=10 if shape==2 else 32 if shape==3 else 5
 for i in count:
  var radius:float=.70 if shape==2 and i%2==1 else 1.
  out.append(Vector2.from_angle(-PI*.5+i*TAU/count)*radius)
 return out
static func plans(seed_:int)->Dictionary:
 var cache_key:Vector2i=Vector2i(seed_,SaveData.world_generator_version)
 if cache.has(cache_key):return cache[cache_key]
 if cache.size()>32:cache.clear()
 var result:Dictionary={};var rng:=RandomNumberGenerator.new();rng.seed=hash("town-enclosures227-v4-%d"%seed_)
 var order:Array[int]=[0,1,2,3,4,5]
 for i in range(order.size()-1,0,-1):
  var j:int=rng.randi_range(0,i);var hold:int=order[i];order[i]=order[j];order[j]=hold
 for index in VillageCousins140.IDS.size():
  var id:String=VillageCousins140.IDS[index];var required:Rect2=contents(seed_,id);var center:Vector2=required.get_center();var shape:int=order[index]
  var unit:PackedVector2Array=normalized(shape);var half:Vector2=required.size*.5+Vector2(190,190)
  if shape in [3,4]:half=Vector2.ONE*maxf(half.x,half.y)
  var polygon:=PackedVector2Array();var scale_:float=1.
  # Scale the shape around the fixed contents, rather than moving any contents.
  for attempt in 32:
   polygon.clear()
   for p in unit:polygon.append(center+p*half*scale_)
   var fits:bool=true;var reserve:Rect2=required.grow(240.)
   for x in 5:
    for y in 5:
     var point:Vector2=reserve.position+reserve.size*Vector2(x/4.,y/4.)
     if not Geometry2D.is_point_in_polygon(point,polygon):fits=false
   if fits:break
   scale_*=1.08
  var gate:Vector2;var gate_edge:int=-1;var best_y:float=-INF
  for i in polygon.size():
   var a:Vector2=polygon[i];var b:Vector2=polygon[(i+1)%polygon.size()]
   if absf(a.x-b.x)<.001:continue
   var t:float=(center.x-a.x)/(b.x-a.x)
   if t<0. or t>1.:continue
   var point:Vector2=a.lerp(b,t)
   if point.y>best_y:gate=point;best_y=point.y;gate_edge=i
  var segments:Array=[];var posts:Array=[];var outward:=Vector2.DOWN
  # Remove a south-facing doorway across all intersected contour edges, also
  # when the gate falls on a diamond/star vertex or several circle segments.
  var cut:Rect2=Rect2(Vector2(gate.x-GATE_WIDTH*.5,gate.y-700.),Vector2(GATE_WIDTH,900.))
  for i in polygon.size():
   var a:Vector2=polygon[i];var b:Vector2=polygon[(i+1)%polygon.size()];var delta:Vector2=b-a
   var low:float=0.;var high:float=1.;var intersects:bool=true
   for axis in 2:
    if absf(delta[axis])<.001:
     if a[axis]<cut.position[axis] or a[axis]>cut.end[axis]:intersects=false
    else:
     var t1:float=(cut.position[axis]-a[axis])/delta[axis];var t2:float=(cut.end[axis]-a[axis])/delta[axis]
     low=maxf(low,minf(t1,t2));high=minf(high,maxf(t1,t2))
   if not intersects or high<=low:segments.append({"a":a,"b":b});continue
   if low>0.:
    var post:Vector2=a.lerp(b,low);segments.append({"a":a,"b":post});posts.append(post)
   if high<1.:
    var post:Vector2=a.lerp(b,high);segments.append({"a":post,"b":b});posts.append(post)
  var bounds:=Rect2(polygon[0],Vector2.ZERO)
  for p in polygon:bounds=bounds.expand(p)
  var approach:=PackedVector2Array([doors(seed_)[id]+Vector2(0,160),Vector2(gate.x,doors(seed_)[id].y+160)])
  if id=="home":approach=PackedVector2Array([Vector2(1600,470),Vector2(1740,470),Vector2(1740,1330),Vector2(gate.x,1330)])
  approach.append(gate-outward*110.);approach.append(gate+outward*130.)
  if SaveData.world_generator_version>=5 and id in ["west140","east140"]:
   approach.append(Vector2(gate.x,bounds.end.y+300.));approach.append(Vector2(15500.,bounds.end.y+300.));approach.append(Vector2(15500.,TRUNK_Y))
  else:approach.append(Vector2(gate.x,TRUNK_Y))
  result[id]={"id":id,"shape":shape,"shape_name":SHAPES[shape],"polygon":polygon,"segments":segments,"gate":gate,"posts":posts,"outward":outward,"center":center,"bounds":bounds,"contents":required,"road":approach}
 cache[cache_key]=result
 return result
static func blocked(seed_:int,p:Vector2,margin:float=0.)->bool:
 for plan in plans(seed_).values():
  if not (plan.bounds as Rect2).grow(THICKNESS*.5+margin).has_point(p):continue
  for segment in plan.segments:
   if p.distance_to(Geometry2D.get_closest_point_to_segment(p,segment.a,segment.b))<=THICKNESS*.5+margin:return true
 return false
static func inside(seed_:int,p:Vector2,margin:float=0.)->bool:
 for plan in plans(seed_).values():
  if Geometry2D.is_point_in_polygon(p,plan.polygon):return true
  if margin>0. and (plan.bounds as Rect2).grow(margin).has_point(p):
   for segment in plan.segments:
    if p.distance_to(Geometry2D.get_closest_point_to_segment(p,segment.a,segment.b))<margin:return true
 return false
static func ridges(seed_:int,c:Vector2i)->Array:
 var out:Array=[];var chunk:Rect2=Rect2(Vector2(c)*1024.,Vector2.ONE*1024.)
 for plan in plans(seed_).values():
  if not (plan.bounds as Rect2).grow(THICKNESS).intersects(chunk):continue
  for segment in plan.segments:
   var box:Rect2=Rect2(segment.a,Vector2.ZERO).expand(segment.b).grow(THICKNESS*.5)
   if not box.intersects(chunk):continue
   out.append({"id":plan.id,"town227":plan.id,"a":segment.a,"b":segment.b,"box":box,"port":plan.gate})
 return out
static func graph(seed_:int,c:Vector2i)->Dictionary:
 var all:Dictionary={};var bounds:Rect2=Rect2(Vector2(c)*1024.,Vector2.ONE*1024.).grow(160.)
 var row:int=roundi((TRUNK_Y-ModularWorldLayout93.ORIGIN.y)/80.)
 var first:int=floori((bounds.position.x-ModularWorldLayout93.ORIGIN.x)/80.)-2;var last:int=ceili((bounds.end.x-ModularWorldLayout93.ORIGIN.x)/80.)+2
 ModularWorldLayout93._path(all,[Vector2i(first,row),Vector2i(last,row)])
 var core:Dictionary=WorldTerrain103.plan(seed_).graph
 for cell in core:all[cell]=core[cell].duplicate()
 var out:Dictionary={}
 for cell in all:
  if bounds.has_point(ModularWorldLayout93.world(cell)):out[cell]=all[cell]
 return out
static func access_contains(seed_:int,p:Vector2,margin:float=0.)->bool:
 for plan in plans(seed_).values():
  var road:PackedVector2Array=plan.road
  for i in road.size()-1:
   if p.distance_to(Geometry2D.get_closest_point_to_segment(p,road[i],road[i+1]))<=22.+margin:return true
 return false

static func roads_in_chunk(seed_:int,c:Vector2i)->Array:
 var out:Array=[];var bounds:=Rect2(Vector2(c)*1024.,Vector2.ONE*1024.)
 for plan in plans(seed_).values():
  var road:PackedVector2Array=plan.road
  for i in road.size()-1:
   var a:Vector2=road[i];var b:Vector2=road[i+1];var delta:Vector2=b-a;var low:float=0.;var high:float=1.;var valid:bool=true
   for axis in 2:
    if absf(delta[axis])<.001:
     if a[axis]<bounds.position[axis] or a[axis]>bounds.end[axis]:valid=false
    else:
     var t1:float=(bounds.position[axis]-a[axis])/delta[axis];var t2:float=(bounds.end[axis]-a[axis])/delta[axis]
     low=maxf(low,minf(t1,t2));high=minf(high,maxf(t1,t2))
   if valid and high>low:out.append({"a":a.lerp(b,low),"b":a.lerp(b,high)})
 return out

static func cousin_ids231()->Array[String]:
 return ["west140"] if SaveData.world_generator_version>=5 else VillageCousins140.IDS
static func cousin_lane231(state:Dictionary,id:String)->PackedVector2Array:
 var goal:=VillageCousins140.point(state,id)
 if SaveData.world_generator_version>=5:return PackedVector2Array([state.doors[id]+Vector2(0,160),goal])
 return PackedVector2Array([Vector2(goal.x,470),goal])
static func role231(id:String)->String:
 return {"home":"Granjero y Lucía", "east138":"Florista", "west140":"Cuidador de caballos", "east140":"Guarnicionero"}.get(id,"")
static func links231()->Array:
 return [["home","east138"],["east138","west140"],["east138","east140"]]
