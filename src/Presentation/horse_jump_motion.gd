class_name HorseJumpMotion
extends RefCounted
## Shared corral/frontier jump: only fence layer is ignored, solid corridor/landing checked.
static func try_ahead(a)->bool:
 if a._jump_cooldown>0 or a._stun_time_remaining>0 or a.dodge.drawing:return false
 var direction=a.velocity.normalized()
 var ray=PhysicsRayQueryParameters2D.create(a.global_position,a.global_position+direction*62,HorseJump.FENCE_LAYER,[a.get_rid()])
 if a.get_world_2d().direct_space_state.intersect_ray(ray).is_empty():return false
 return request(a,direction)
static func request(a,direction:Vector2)->bool:
 if not a.can_jump or a._jump_time>0 or a._jump_cooldown>0 or a._stun_time_remaining>0 or direction.length()<.2:return false
 var landing=a.global_position+direction.normalized()*HorseJump.DISTANCE
 if not a.world_bounds.grow(-28).has_point(landing):return false
 var query=PhysicsShapeQueryParameters2D.new();query.shape=a.get_node("CollisionShape2D").shape;query.collision_mask=a.collision_mask;query.exclude=[a.get_rid()];query.transform=Transform2D(0,landing)
 if not a.get_world_2d().direct_space_state.intersect_shape(query,1).is_empty():return false
 query.collision_mask=a.collision_mask & ~HorseJump.FENCE_LAYER
 for i in range(1,9):
  query.transform=Transform2D(0,a.global_position.lerp(landing,float(i)/8))
  if not a.get_world_2d().direct_space_state.intersect_shape(query,1).is_empty():return false
 a._jump_z=a.z_index;a.z_index=30
 a._jump_direction=direction.normalized();a._jump_from=a.global_position;a._jump_mask=a.collision_mask
 a.cancel_input();a._jump_time=HorseJump.DURATION;a.collision_mask&=~HorseJump.FENCE_LAYER;a._jump_cooldown=1.2*a.jump_recovery_multiplier
 if a._sprite_swap.has_sprite():a._jump_sprite_base=a._sprite_swap._sprite.position;a._jump_sprite_scale=a._sprite_swap._sprite.scale
 a.jump_started.emit();return true
static func process(a,delta:float)->void:
 a._jump_time=maxf(0,a._jump_time-delta);var t=1-a._jump_time/HorseJump.DURATION
 a.velocity=a._jump_direction*HorseJump.DISTANCE/HorseJump.DURATION
 var hit=a.move_and_collide(a.velocity*delta)
 var info=SpriteSwap.direction_suffix(a._jump_direction)
 if a._sprite_swap.has_sprite():
  a._sprite_swap.play("jump_"+info[0]);a._sprite_swap.set_flip_h(info[1]);a._sprite_swap._sprite.pause();a._sprite_swap._sprite.frame=mini(7,int(t*8))
  var sprite=a._sprite_swap._sprite;sprite.position=a._jump_sprite_base+Vector2(0,-HorseJump.arc(t));sprite.scale=a._jump_sprite_scale*Vector2(1+.08*sin(PI*t),1-.08*sin(PI*t))
 a.queue_redraw()
 if hit!=null:a._jump_time=0
 if a._jump_time<=0:finish(a,false)
static func finish(a,interrupted:bool)->void:
 a._jump_time=0;a.collision_mask=a._jump_mask;a.z_index=a._jump_z
 if interrupted or a.test_move(a.global_transform,Vector2.ZERO):a.global_position=a._jump_from
 if a._sprite_swap.has_sprite():a._sprite_swap._sprite.position=a._jump_sprite_base;a._sprite_swap._sprite.scale=a._jump_sprite_scale
 a.velocity=Vector2.ZERO;a.jump_finished.emit();a.queue_redraw()
