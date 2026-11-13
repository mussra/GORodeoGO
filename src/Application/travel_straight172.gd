class_name TravelStraight172
extends RefCounted
## Sweep the player's real collision body; callers load each traversed area first.
static func segment(player:CharacterBody2D,from:Vector2,to:Vector2)->Dictionary:
 var transform_:Transform2D=player.global_transform;transform_.origin=from
 var result:=KinematicCollision2D.new()
 if player.test_move(transform_,to-from,result,.08,true):
  var distance:float=maxf(0.,result.get_travel().length()-4.)
  return {"pos":from.move_toward(to,distance),"stopped":true}
 return {"pos":to,"stopped":false}
static func stop(route:Dictionary,pos:Vector2)->void:
 route.pos=pos;route.stopped172=true;route.advance=route.path[0].distance_to(pos)
 route.path=PackedVector2Array([route.path[0],pos])
 route.wake172="El caballo se ha detenido antes de un obstáculo o de terreno desconocido. Te despiertas aquí; tendrás que seguir a caballo."
