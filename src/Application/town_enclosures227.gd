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
 if SaveData.world_generator_version>=6:return TownNetwork234.doors(seed_)
 if SaveData.world_generator_version>=5:
  var flip:float=-1. if branch_flip231(seed_) else 1.
  return {"home":FloristJourney138.home_door(seed_),"east138":Vector2(10560,358),"west140":Vector2(10560,358-10240.*flip),"east140":Vector2(10560,358+10240.*flip)}
 return {"home":FloristJourney138.home_door(seed_),"east138":Vector2(10560,358),"west140":Vector2(-9920,358),"east140":Vector2(20800,358)}
static func contents(seed_:int,id:String)->Rect2:
 return TownContent318.bounds(seed_,id,doors(seed_)[id])
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
 var content_state:Array=[SaveData.world_garden212.get("anchors",{}),SaveData.world_edits] if SaveData.world_seed==seed_ else []
 var cache_key:String=str([seed_,SaveData.world_generator_version,hash(content_state)])
 if cache.has(cache_key):return cache[cache_key]
 if cache.size()>32:cache.clear()
 var result:Dictionary={};var rng:=RandomNumberGenerator.new();rng.seed=hash("town-enclosures227-v4-%d"%seed_)
 var order:Array[int]=[0,1,2,3,4,5]
 for i in range(order.size()-1,0,-1):
  var j:int=rng.randi_range(0,i);var hold:int=order[i];order[i]=order[j];order[j]=hold
 var ids:Array=doors(seed_).keys()
 for index in ids.size():
  var id:String=ids[index];var required:Rect2=contents(seed_,id);var center:Vector2=required.get_center();var shape:int=posmod(hash("town-shape236-%d-%s"%[seed_,id]),6) if SaveData.world_generator_version>=6 else order[index%order.size()]
  var unit:PackedVector2Array=normalized(shape);var half:Vector2=required.size*.5+Vector2(120,120)
  if shape in [3,4]:half=Vector2.ONE*maxf(half.x,half.y)
  var low_scale:float=0.;var high_scale:float=1.
  var reserve:Rect2=required.grow(120.)
  while not fits_contents318(unit,center,half,high_scale,reserve):high_scale*=1.15
  for attempt in 18:
   var middle:float=(low_scale+high_scale)*.5
   if fits_contents318(unit,center,half,middle,reserve):high_scale=middle
   else:low_scale=middle
  var polygon:=PackedVector2Array()
  for p in unit:polygon.append(center+p*half*(high_scale+0.0001))
  var gates:Dictionary=cardinal_gates318(polygon,center)
  var segments:Array=[];var posts:Array=[];var outward:=Vector2.DOWN
  for i in polygon.size():segments.append({"a":polygon[i],"b":polygon[(i+1)%polygon.size()]})
  for direction in gates:
   var entry:Dictionary=gates[direction];var clipped:Array=[]
   for segment in segments:
    var a:Vector2=segment.a;var b:Vector2=segment.b;var delta:Vector2=b-a
    var cut:Rect2=entry.cut;var low:float=0.;var high:float=1.;var intersects:bool=true
    for axis in 2:
     if absf(delta[axis])<.001:
      if a[axis]<cut.position[axis] or a[axis]>cut.end[axis]:intersects=false
     else:
      var t1:float=(cut.position[axis]-a[axis])/delta[axis];var t2:float=(cut.end[axis]-a[axis])/delta[axis]
      low=maxf(low,minf(t1,t2));high=minf(high,maxf(t1,t2))
    if not intersects or high<=low:clipped.append(segment);continue
    if low>0.:
     var post:Vector2=a.lerp(b,low);clipped.append({"a":a,"b":post});posts.append(post);entry.posts.append(post)
    if high<1.:
     var post:Vector2=a.lerp(b,high);clipped.append({"a":post,"b":b});posts.append(post);entry.posts.append(post)
   segments=clipped
  var gate:Vector2=gates.south.point
  var bounds:=Rect2(polygon[0],Vector2.ZERO)
  for p in polygon:bounds=bounds.expand(p)
  var approach:=PackedVector2Array([doors(seed_)[id]+Vector2(0,160),Vector2(gate.x,doors(seed_)[id].y+160)])
  if id=="home":
   var turn:Vector2=required.end+Vector2(35,35)
   approach=PackedVector2Array([Vector2(1600,470),Vector2(turn.x,470),turn,Vector2(gate.x,turn.y)])
  approach.append(gate-outward*110.);approach.append(gate+outward*130.)
  if SaveData.world_generator_version>=6:pass
  elif SaveData.world_generator_version>=5 and id in ["west140","east140"]:
   approach.append(Vector2(gate.x,bounds.end.y+300.));approach.append(Vector2(15500.,bounds.end.y+300.));approach.append(Vector2(15500.,TRUNK_Y))
  else:approach.append(Vector2(gate.x,TRUNK_Y))
  var access_roads:Array=[]
  for direction in gates:
   if direction=="south":continue
   var entry:Dictionary=gates[direction]
   access_roads.append(PackedVector2Array([entry.point-entry.outward*160.,entry.point+entry.outward*180.]))
  result[id]={"id":id,"shape":shape,"shape_name":SHAPES[shape],"polygon":polygon,"segments":segments,"gate":gate,"posts":posts,"outward":outward,"center":center,"bounds":bounds,"contents":required,"road":approach,"gates":gates,"access_roads318":access_roads}
 if SaveData.world_generator_version>=6:
  var network_roads:=TownNetwork234.roads(seed_,result)
  for id in result:result[id]["network_roads234"]=network_roads if id=="home" else []
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
 if SaveData.world_generator_version>=6:return {}
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
  var roads:Array=[plan.road];roads.append_array(plan.access_roads318)
  for road in roads:
   for i in road.size()-1:
    if p.distance_to(Geometry2D.get_closest_point_to_segment(p,road[i],road[i+1]))<=22.+margin:return true
 return false

static func roads_in_chunk(seed_:int,c:Vector2i)->Array:
 var out:Array=[];var bounds:=Rect2(Vector2(c)*1024.,Vector2.ONE*1024.)
 var routes:Array=[]
 for plan in plans(seed_).values():
  routes.append(plan.road);routes.append_array(plan.access_roads318)
 if SaveData.world_generator_version>=6:routes.append_array(TownNetwork234.roads(seed_,plans(seed_)))
 for road in routes:
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
 return [] if SaveData.world_generator_version>=6 else ["west140"] if SaveData.world_generator_version>=5 else VillageCousins140.IDS
static func cousin_lane231(state:Dictionary,id:String)->PackedVector2Array:
 var goal:=VillageCousins140.point(state,id)
 if SaveData.world_generator_version>=5:return PackedVector2Array([state.doors[id]+Vector2(0,160),goal])
 return PackedVector2Array([Vector2(goal.x,470),goal])
static func role231(id:String)->String:
 return TownNetwork234.role_text(SaveData.world_seed,id) if SaveData.world_generator_version>=6 else {"home":"Granjero y Lucía", "east138":"Florista", "west140":"Cuidador de caballos", "east140":"Guarnicionero"}.get(id,"")
static func links231()->Array:
 return [["home","east138"],["east138","west140"],["east138","east140"]]

static func cardinal_gates318(polygon:PackedVector2Array,center:Vector2)->Dictionary:
 var out:Dictionary={}
 var directions:Dictionary={"north":Vector2.UP,"south":Vector2.DOWN,"east":Vector2.RIGHT,"west":Vector2.LEFT}
 for name_ in directions:
  var normal:Vector2=directions[name_];var tangent:=Vector2(-normal.y,normal.x);var best:float=-INF
  var extreme:float=-INF;var lateral:float=0.;var count_:int=0
  for vertex in polygon:
   var depth:float=(vertex-center).dot(normal)
   if depth>extreme+.01:extreme=depth;lateral=(vertex-center).dot(tangent);count_=1
   elif absf(depth-extreme)<.01:lateral+=(vertex-center).dot(tangent);count_+=1
  var origin:Vector2=center+tangent*(lateral/maxi(count_,1))
  for i in polygon.size():
   var a:Vector2=polygon[i]-origin;var b:Vector2=polygon[(i+1)%polygon.size()]-origin
   var ta:float=a.dot(tangent);var tb:float=b.dot(tangent)
   if absf(ta-tb)<.001:continue
   var t:float=-ta/(tb-ta)
   if t<0. or t>1.:continue
   best=maxf(best,a.lerp(b,t).dot(normal))
  var point:Vector2=origin+normal*best
  # One half-plane strip, cut through every edge near the radial extremity.
  var cut:Rect2
  var reach:float=best+2000.
  if name_=="south":cut=Rect2(origin+Vector2(-GATE_WIDTH*.5,0),Vector2(GATE_WIDTH,reach))
  elif name_=="north":cut=Rect2(origin+Vector2(-GATE_WIDTH*.5,-reach),Vector2(GATE_WIDTH,reach))
  elif name_=="east":cut=Rect2(origin+Vector2(0,-GATE_WIDTH*.5),Vector2(reach,GATE_WIDTH))
  else:cut=Rect2(origin+Vector2(-reach,-GATE_WIDTH*.5),Vector2(reach,GATE_WIDTH))
  out[name_]={"point":point,"outward":normal,"posts":[],"cut":cut}
 return out

static func fits_contents318(unit:PackedVector2Array,center:Vector2,half:Vector2,scale_:float,reserve:Rect2)->bool:
 var polygon:=PackedVector2Array()
 for p in unit:polygon.append(center+p*half*scale_)
 for x in 5:
  for y in 5:
   if not Geometry2D.is_point_in_polygon(reserve.position+reserve.size*Vector2(x/4.,y/4.),polygon):return false
 return true
