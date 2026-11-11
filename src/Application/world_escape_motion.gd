class_name WorldEscapeMotion
extends RefCounted
## Preserve home bounds without an invisible wall that pins fleeing animals.
## Normal free movement is unchanged. At the edge, choose a moving tangent
## inside the same radius that increases distance from the threat.
static func bounded_step(position:Vector2,home:Vector2,threat:Vector2,wanted:Vector2,radius:float)->Vector2:
 if wanted.is_zero_approx():return position
 var limit:float=maxf(radius,position.distance_to(home))
 var direct:Vector2=position+wanted
 if direct.distance_to(home)<=limit:return direct
 var best:Vector2=position;var score:float=-INF
 for angle in [0.0,PI/4,-PI/4,PI/2,-PI/2,3*PI/4,-3*PI/4,PI]:
  var candidate:Vector2=home+(position+wanted.rotated(angle)-home).limit_length(limit)
  if candidate.distance_to(position)<wanted.length()*.25:continue
  var value:float=candidate.distance_squared_to(threat)
  if value>score:best=candidate;score=value
 return best
