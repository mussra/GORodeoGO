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
 # After a fleeing crossing, return to the nearest verge before resuming
 # ordinary wandering/following. No new crossing is allowed in this state.
 if road.call(a,FOOTPRINT):
  var safe:Vector2=clear_spawn(a,road)
  return a.move_toward(safe,a.distance_to(b)) if safe.is_finite() else a
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
 terrain_spawn(animal)
static func terrain_step(animal:Node2D,a:Vector2,b:Vector2)->Vector2:
 var node:Node=animal.get_parent()
 while node!=null:
  if node.has_method("mountain_step103"):return node.mountain_step103(a,b)
  node=node.get_parent()
 return b
static func terrain_spawn(animal:Node2D)->void:
 var node:Node=animal.get_parent()
 while node!=null:
  if node.has_method("mountain_spawn103"):
   var safe:Vector2=node.mountain_spawn103(animal.global_position)
   if safe.is_finite():
    var road:Callable=provider(animal)
    if road.is_valid() and road.call(safe,FOOTPRINT):
     var found:bool=false
     for ring in range(1,81):
      for i in 16:
       var candidate:Vector2=safe+Vector2.from_angle(i*TAU/16)*ring*12.
       if not road.call(candidate,FOOTPRINT) and node.mountain_step103(candidate,candidate)==candidate and node.mountain_spawn103(candidate)==candidate:
        safe=candidate;found=true;break
      if found:break
    animal.global_position=safe;animal.home=animal.position
   else:animal.hide();animal.set_process(false);animal.set_physics_process(false)
   return
  node=node.get_parent()
