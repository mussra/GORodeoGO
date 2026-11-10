class_name AnimalDirection
extends RefCounted
## Same five-view sectors as the horse, mirrored for the three leftward views.
## Pure visual choice: does not alter velocity, collision or capture geometry.
static func view(direction:Vector2)->String:
 var ax:float=absf(direction.x);var ay:float=absf(direction.y)
 if ax>ay*1.6:return "side"
 if ax>ay*.45:return "diag_down" if direction.y>0 else "diag_up"
 return "down" if direction.y>0 else "up"
static func mirrored(direction:Vector2)->bool:
 return direction.x<0 and view(direction) not in ["up","down"]
static func available_view(direction:Vector2,available:Array)->String:
 var wanted:String=view(direction)
 if wanted in available:return wanted
 # Until a view has been supplied, use the actual legacy cardinal rather
 # than claiming a diagonal is present or manufacturing a rotated sprite.
 var cardinal:String=("down" if direction.y>0 else "up") if absf(direction.y)>absf(direction.x)*1.2 else "side"
 return cardinal if cardinal in available else "side"
