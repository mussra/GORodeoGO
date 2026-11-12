class_name RiderGaitVisual
extends RefCounted
## Shared rider presentation only. Does not choose movement speed or stamina.
## Existing walk frames remain the fallback until a genuine second cycle exists.
static func from_speed(speed:float,top_speed:float)->int:
 var ratio:float=speed/maxf(top_speed,1.0)
 if ratio>.8:return WorldGait.GALOPE
 if ratio>.5:return WorldGait.TROTE
 return WorldGait.PASO
static func apply(swap:SpriteSwap,velocity:Vector2,top_speed:float,gait:int,delta:float)->String:
 if not swap.has_sprite():return ""
 if velocity.length()<12.0:
  swap.rest_pose107(delta);swap.set_gait_pose(Vector2.ZERO,delta,false);return "idle"
 swap.rest107.reset();swap.restore_movement107()
 var facing:Array=SpriteSwap.direction_suffix(velocity)
 var anim:String="walk_"+facing[0]
 var dedicated:bool=gait==WorldGait.GALOPE and swap.has_animation("gallop_"+facing[0])
 if dedicated:anim="gallop_"+facing[0]
 swap.play(anim);swap.set_flip_h(facing[1])
 # Normalize against this gait's full movement speed, then apply its cadence.
 # Same result in world and levels at the same gait and relative speed.
 var reference:float=WorldGait.speed_for(gait,top_speed)/WorldGait.pace_for(gait)
 swap.set_motion_speed(velocity.length(),reference)
 var pose:Vector2=WorldGait.pose_for(gait)
 if dedicated:pose.y=0.0
 swap.set_gait_pose(pose,delta,true)
 return anim
