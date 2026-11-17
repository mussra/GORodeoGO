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

## Shared pig/horse wall escape. The ordinary legal step stays unchanged;
## tangent candidates are tested only when the direct move is mostly blocked.
static func slide248(position:Vector2,threat:Vector2,wanted:Vector2,direct:Vector2,legal:Callable)->Vector2:
 if wanted.is_zero_approx() or direct.distance_to(position)>=wanted.length()*.8:return direct
 var best:Vector2=direct;var score:float=-INF
 for angle in [PI/4,-PI/4,PI/2,-PI/2,3*PI/4,-3*PI/4,PI]:
  var candidate:Vector2=legal.call(wanted.rotated(angle))
  if candidate.distance_to(position)<wanted.length()*.5:continue
  var value:float=candidate.distance_squared_to(threat)
  if value>score:best=candidate;score=value
 return best

## Commit to a legal wall tangent briefly, instead of choosing the opposite
## equal-scoring tangent each frame. A blocked commitment is abandoned at once.
static func slide249(position:Vector2,threat:Vector2,wanted:Vector2,direct:Vector2,legal:Callable,memory:Dictionary,delta:float)->Vector2:
 if wanted.is_zero_approx():memory.clear();return direct
 var previous:Vector2=memory.get("heading",Vector2.ZERO)
 var hold:float=maxf(0.,float(memory.get("hold",0.))-delta)
 if hold>0. and not previous.is_zero_approx():
  var committed:Vector2=legal.call(previous*wanted.length())
  if committed.distance_to(position)>=wanted.length()*.75:
   memory.hold=hold;return committed
 if direct.distance_to(position)>=wanted.length()*.8:
  memory.clear();return direct
 var best:Vector2=direct;var score:float=-INF
 for angle in [PI/4,-PI/4,PI/2,-PI/2,3*PI/4,-3*PI/4,PI]:
  var candidate:Vector2=legal.call(wanted.rotated(angle))
  var step:Vector2=candidate-position
  if step.length()<wanted.length()*.5:continue
  # Continuity is a tie-breaker strong enough to prevent a wall-side seesaw.
  var away:Vector2=(position-threat).normalized()
  var value:float=step.normalized().dot(away)+step.normalized().dot(previous)*.8
  if value>score:best=candidate;score=value
 if best.distance_to(position)>=wanted.length()*.5:
  memory.heading=(best-position).normalized();memory.hold=.55
 else:memory.clear()
 return best
