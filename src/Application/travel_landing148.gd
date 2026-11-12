class_name TravelLanding148
extends RefCounted
## Map adapters supply terrain validity. The player's actual collision shape is shared.
static func find(player:CharacterBody2D,pos:Vector2,terrain_blocked:Callable)->Vector2:
 if not pos.is_finite():return Vector2(INF,INF)
 var shape:CollisionShape2D=player.get_node_or_null("CollisionShape2D")
 if shape==null or shape.shape==null:return Vector2(INF,INF)
 var query:=PhysicsShapeQueryParameters2D.new();query.shape=shape.shape;query.collision_mask=player.collision_mask;query.exclude=[player.get_rid()]
 for radius in [0.,24.,48.,72.,96.]:
  for i in (1 if radius==0. else 8):
   var candidate:Vector2=pos+Vector2.RIGHT.rotated(i*TAU/8.)*radius
   if terrain_blocked.call(candidate):continue
   query.transform=shape.global_transform;query.transform.origin+=candidate-player.global_position
   if player.get_world_2d().direct_space_state.intersect_shape(query,1).is_empty():return candidate
 return Vector2(INF,INF)
