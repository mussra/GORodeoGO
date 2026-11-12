class_name WorldWildRoads94
extends RefCounted
## World-only constraint. Levels without a road provider retain their rules.
const FOOTPRINT:float=18.
static func provider(animal:Node)->Callable:
 var node:Node=animal.get_parent()
 while node!=null:
  if node.has_method("road_surface_contains94"):return Callable(node,"road_surface_contains94")
  node=node.get_parent()
 return Callable()
static func clear_spawn(point:Vector2,road:Callable)->Vector2:
 if not road.is_valid() or not road.call(point,FOOTPRINT):return point
 for ring in range(1,65):
  for i in 16:
   var candidate:Vector2=point+Vector2.from_angle(i*TAU/16)*ring*12.
   if not road.call(candidate,FOOTPRINT):return candidate
 # No legal position: fail closed. Caller must not put the animal on a road.
 return Vector2(INF,INF)
static func segment_clear(a:Vector2,b:Vector2,road:Callable)->bool:
 if not road.is_valid():return true
 var steps:int=maxi(1,ceili(a.distance_to(b)/4.))
 for i in range(steps+1):
  if road.call(a.lerp(b,float(i)/steps),FOOTPRINT):return false
 return true
static func safe_step(a:Vector2,b:Vector2,road:Callable)->Vector2:
 if not road.is_valid():return b
 if segment_clear(a,b,road):return b
 # Slide along the verge, never teleport across a road even on a long frame.
 var step:Vector2=b-a
 for angle in [PI/4,-PI/4,PI/2,-PI/2]:
  var candidate:Vector2=a+step.rotated(angle)
  if segment_clear(a,candidate,road):return candidate
 return a
static func bind_spawn(animal:Node2D,road:Callable)->void:
 var safe:Vector2=clear_spawn(animal.global_position,road)
 if not safe.is_finite():animal.hide();animal.set_process(false);animal.set_physics_process(false);return
 animal.global_position=safe
 animal.home=animal.position
