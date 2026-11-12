class_name CountryRoute146
extends RefCounted
## Isolated country prototype. One source -> river -> roots, with a walkable bank.
## Not connected to the existing frontier until entry/ritual rules are chosen.
const ID:String="water146"
const BOUNDS:Rect2=Rect2(0,0,12500,14000)
const WATER_RADIUS:float=90.
static func plan(seed_:int)->Dictionary:
 var rng:=RandomNumberGenerator.new();rng.seed=hash("country146-%d"%seed_)
 var shift:=Vector2(rng.randi_range(-180,180),rng.randi_range(-100,100))
 var river:=PackedVector2Array([Vector2(10600,2400),Vector2(10500,4000),Vector2(10200,5800),Vector2(9900,7600),Vector2(9500,9300),Vector2(5800,10800)])
 var bank:=PackedVector2Array()
 for i in river.size():river[i]+=shift;bank.append(river[i]+Vector2(1600 if i==river.size()-1 else 360,0))
 var entry:=Vector2(1500,12500)+shift
 var approach:=PackedVector2Array([entry,Vector2(6160,12500)+shift,bank[-1]])
 var upstream:=PackedVector2Array()
 for i in range(bank.size()-1,-1,-1):upstream.append(bank[i])
 var tree:=Rect2(Vector2(4200,8800)+shift,Vector2(1700,2100))
 return {"id":ID,"version":1,"seed":seed_,"entry":entry,"tree":tree,"tree_art":Rect2(Vector2(1000,4300)+shift,Vector2(8000,6840)),"roots":river[-1],"source":river[0],"river":river,"bank":bank,"approach":approach,"upstream":upstream,"sites":{"entry":entry,"tree":bank[-1],"source":bank[0]}}
static func distance_to_path(point:Vector2,path:PackedVector2Array)->float:
 var distance:float=INF
 for i in range(1,path.size()):distance=minf(distance,point.distance_to(Geometry2D.get_closest_point_to_segment(point,path[i-1],path[i])))
 return distance
static func blocked(data:Dictionary,point:Vector2,radius:float=18.)->bool:
 return not BOUNDS.grow(-radius).has_point(point) or (data.tree as Rect2).grow(radius).has_point(point) or distance_to_path(point,data.river)<WATER_RADIUS+radius
static func path_clear(data:Dictionary,path:PackedVector2Array,radius:float=18.)->bool:
 if path.is_empty():return false
 for i in range(1,path.size()):
  var steps:int=maxi(1,ceili(path[i-1].distance_to(path[i])/12.))
  for j in range(steps+1):
   if blocked(data,path[i-1].lerp(path[i],float(j)/steps),radius):return false
 return true
static func safe_step(data:Dictionary,from:Vector2,to:Vector2)->Vector2:
 var steps:int=maxi(1,ceili(from.distance_to(to)/8.));var last:Vector2=from
 for i in range(1,steps+1):
  var point:Vector2=from.lerp(to,float(i)/steps)
  if blocked(data,point):return last
  last=point
 return last
