class_name RaceCourse190
extends RefCounted
## Closed oval. All distances and gate checks are in world coordinates.
const WIDTH:float=380.
static var selected:int=0
static var start_selected:bool=false
const TITLES=["1 · Óvalo", "2 · Curvas del valle", "3 · Circuito serpiente", "4 · Cruce del molino"]
var variant:int=0
var fences:Array[float]=[]
const GATES:int=16
var points:PackedVector2Array=PackedVector2Array()
var lengths:Array[float]=[0.]
var length:float=0.
var _project_frame:int=-1
var _projection_cache:Dictionary={}
func _init(index:int=0)->void:
 variant=clampi(index,0,3)
 for i in 193:
  var a:float=i*TAU/192.
  var point:=Vector2(2300.*sin(a),-1500.*cos(a))
  if variant==1:point.x+=500.*sin(2.*a)
  elif variant==2:point.x+=420.*sin(3.*a);point.y+=170.*sin(2.*a)
  if variant==3:
   var t:float=a-PI*.5
   point=Vector2(2300.*sin(t),-1200.*sin(2.*t))
  points.append(point)
  if i>0:length+=points[i].distance_to(points[i-1]);lengths.append(length)
 points[-1]=points[0]
 for gate in [3,7,11,15]:fences.append(length*gate/16.)
func at(distance:float)->Vector2:
 var s:float=fposmod(distance,length)
 var i:int=clampi(lengths.bsearch(s),1,points.size()-1)
 return points[i-1].lerp(points[i],(s-lengths[i-1])/(lengths[i]-lengths[i-1]))
func tangent(distance:float)->Vector2:return (at(distance+8)-at(distance-8)).normalized()
func project(p:Vector2)->Dictionary:
 var frame:int=Engine.get_physics_frames()
 if frame!=_project_frame:_projection_cache.clear();_project_frame=frame
 if _projection_cache.has(p):return _projection_cache[p]
 var best:float=INF;var best_point:=Vector2.ZERO;var best_s:float=0.
 for i in range(points.size()-1):
  var v:Vector2=points[i+1]-points[i];var t:float=clampf((p-points[i]).dot(v)/v.length_squared(),0.,1.);var q:Vector2=points[i]+v*t;var d:float=p.distance_squared_to(q)
  if d<best:best=d;best_point=q;best_s=lengths[i]+v.length()*t
 var result:Dictionary={"point":best_point,"s":best_s,"distance":sqrt(best)}
 _projection_cache[p]=result
 return result
func constrain(p:Vector2)->Vector2:
 var q:Dictionary=project(p)
 return q.point+(p-q.point).limit_length(WIDTH*.5-18.)
func crossed_gate(previous:Vector2,current:Vector2,index:int)->bool:
 var s:float=length*index/GATES;var center:Vector2=at(s);var forward:Vector2=tangent(s)
 var a:float=(previous-center).dot(forward);var b:float=(current-center).dot(forward)
 if a>0. or b<=0. or current.distance_to(previous)>300.:return false
 var crossing:Vector2=previous.lerp(current,-a/(b-a))
 return absf((crossing-center).dot(forward.orthogonal()))<=WIDTH*.5+2.
func score(p:Vector2,next_gate:int)->float:
 if next_gate>GATES:return length
 var s:float=project(p).s;var passed:float=length*(next_gate-1)/GATES
 if next_gate==GATES and s<length/GATES:s+=length
 return passed+clampf(s-passed,0.,length/GATES)

func ai_lane(distance:float,preferred:float,jumper:bool)->float:
 if jumper:return preferred
 for fence in fences:
  var ahead:float=fposmod(fence-distance,length)
  var behind:float=fposmod(distance-fence,length)
  if ahead<430. or behind<120.:return 132.
 return preferred

## Branch-aware local projection for a crossing. The previous route distance, not
## the closest remote branch, decides which road this rider is following.
func route_project(p:Vector2,hint:float)->Dictionary:
 if variant!=3:return project(p)
 var best:float=INF;var result:Dictionary={}
 for i in range(points.size()-1):
  var midpoint:float=(lengths[i]+lengths[i+1])*.5
  var unwrapped:float=hint+fposmod(midpoint-hint+length*.5,length)-length*.5
  if absf(unwrapped-hint)>260.:continue
  var v:Vector2=points[i+1]-points[i];var t:float=clampf((p-points[i]).dot(v)/v.length_squared(),0.,1.)
  var q:Vector2=points[i]+v*t;var d:float=p.distance_squared_to(q)
  if d<best:
   best=d
   var at_s:float=lengths[i]+v.length()*t
   result={"point":q,"s":hint+fposmod(at_s-hint+length*.5,length)-length*.5,"distance":sqrt(d)}
 return result
func crossing_zone(p:Vector2)->bool:return variant==3 and p.length()<270.
func route_score(p:Vector2,gate:int,hint:float)->float:
 if variant!=3:return score(p,gate)
 if gate>GATES:return length
 var passed:float=length*(gate-1)/GATES
 return passed+clampf(hint-passed,0.,length/GATES)
