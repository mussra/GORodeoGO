class_name WorldAwareness110
extends RefCounted
## Tunable deterministic perception. No random capture failure.
const QUIET_SPEED:float=130.
const QUIET_NOTICE:float=190.
const FAST_NOTICE:float=320.
const CLOSE_FLEE:float=85.
const ALERT_SECONDS:float=.85
const FAST_ALERT_SECONDS:float=.45
const CLOSE_ALERT_SECONDS:float=.2
const COVER_MULTIPLIER:float=.3
const PANIC_SECONDS:float=6.
const NEIGHBOR_RANGE:float=500. # Legacy perception tuning, not the lasso-impact radius.
const LASSO_IMPACT_RADIUS128:float=300.
static func lasso_impact_near128(animal:Vector2,impact:Vector2)->bool:
 return animal.distance_squared_to(impact)<=LASSO_IMPACT_RADIUS128*LASSO_IMPACT_RADIUS128
const COVER_CHECK_SECONDS:float=.2
static func tick(state:Dictionary,dist:float,speed:float,covered:bool,delta:float)->Dictionary:
 var out:Dictionary=state.duplicate()
 var cover:float=COVER_MULTIPLIER if covered else 1.
 var notice:float=(FAST_NOTICE if speed>QUIET_SPEED else QUIET_NOTICE)*cover
 var seen:bool=dist<notice or dist<40.
 out.alert110=seen
 if not seen:out.notice_time110=0.;return out
 out.notice_time110=float(out.get("notice_time110",0.))+delta
 var threshold:float=CLOSE_ALERT_SECONDS if dist<40. else (FAST_ALERT_SECONDS if speed>QUIET_SPEED else ALERT_SECONDS)
 if (speed>QUIET_SPEED or dist<CLOSE_FLEE*cover or dist<40.) and out.notice_time110>=threshold:out.spook=maxf(float(out.get("spook",0.)),WorldTaming.SPOOK_SECONDS)
 return out
## A spatial index of current occlusion rectangles, not all generated terrain.
const GRID:float=128.
static func build_index(owners:Dictionary)->Dictionary:
 var index:Dictionary={}
 for rows in owners.values():
  for rect:Rect2 in rows:
   var lo:Vector2i=Vector2i((rect.position/GRID).floor());var hi:Vector2i=Vector2i((rect.end/GRID).floor())
   for x in range(lo.x,hi.x+1):
    for y in range(lo.y,hi.y+1):
     var key:Vector2i=Vector2i(x,y)
     if not index.has(key):index[key]=[]
     index[key].append(rect)
 return index
static func covered(index:Dictionary,animal:Vector2,rider:Vector2)->bool:
 var lo:Vector2i=Vector2i((animal.min(rider)/GRID).floor());var hi:Vector2i=Vector2i((animal.max(rider)/GRID).floor())
 for x in range(lo.x,hi.x+1):
  for y in range(lo.y,hi.y+1):
   for rect:Rect2 in index.get(Vector2i(x,y),[]):
    if rect.has_point(rider) or Geometry2D.segment_intersects_segment(animal,rider,rect.position,Vector2(rect.end.x,rect.position.y))!=null or Geometry2D.segment_intersects_segment(animal,rider,Vector2(rect.end.x,rect.position.y),rect.end)!=null or Geometry2D.segment_intersects_segment(animal,rider,rect.end,Vector2(rect.position.x,rect.end.y))!=null or Geometry2D.segment_intersects_segment(animal,rider,Vector2(rect.position.x,rect.end.y),rect.position)!=null:return true
 return false
