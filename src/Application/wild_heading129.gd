class_name WildHeading129
extends RefCounted
## Stable movement and sprite sectors, only for riderless wild horses.
const TURN_RATE:float=TAU*2./3. #240 degrees/second, independent of tick rate.
const MIN_MOTION:float=12.
const SECTOR_MARGIN:float=deg_to_rad(8.)
const FLIP_DEADZONE:float=.18
const VIEW_HOLD:float=.10
static func steer(current:Vector2,wanted:Vector2,delta:float)->Vector2:
 if wanted.length()<MIN_MOTION or current.length()<MIN_MOTION:return wanted
 var angle:float=rotate_toward(current.angle(),wanted.angle(),TURN_RATE*maxf(delta,0.))
 return Vector2.from_angle(angle)*wanted.length()
static func view(motion:Vector2,previous:String)->String:
 if motion.length()<MIN_MOTION:return previous
 var angle:float=atan2(absf(motion.y),absf(motion.x))
 var side:float=atan2(1.,1.6);var vertical:float=atan2(1.,.45)
 # Widen the current sector. Equality stays in the existing pose.
 if previous=="side" and angle<=side+SECTOR_MARGIN:return previous
 if previous in ["up","down"] and angle>=vertical-SECTOR_MARGIN:
  if (previous=="up" and motion.y<=0.) or (previous=="down" and motion.y>=0.):return previous
 if previous in ["diag_up","diag_down"] and angle>=side-SECTOR_MARGIN and angle<=vertical+SECTOR_MARGIN:
  if (previous=="diag_up" and motion.y<=0.) or (previous=="diag_down" and motion.y>=0.):return previous
 if angle<side:return "side"
 if angle<vertical:return "diag_down" if motion.y>0. else "diag_up"
 return "down" if motion.y>0. else "up"
static func flip(motion:Vector2,previous:bool)->bool:
 if motion.length()<MIN_MOTION:return previous
 var x:float=motion.normalized().x
 if absf(x)<=FLIP_DEADZONE+.000001:return previous
 return x<0.
