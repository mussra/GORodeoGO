class_name WorldRoadJunctions
extends RefCounted
## Visual junctions only. Original path data and save geometry remain intact.
static func layout(seed:int)->Array:
 var x=0.0
 for i in 16:x=WorldMap.branch_x_at(seed,WorldMap.trail_y_at(seed,x))
 var p=Vector2(x,WorldMap.trail_y_at(seed,x))
 var out=[_junction(seed,p,"cross",0,45,45,true)]
 p=Vector2(-67,WorldMap.trail_y_at(seed,-67))
 out.append(_junction(seed,p,"t",PI,32,45,false))
 p=Vector2(WorldMap.branch_x_at(seed,480),480)
 out.append(_junction(seed,p,"cross",0,45,32,true))
 p=Vector2(WorldMap.branch_x_at(seed,530),530)
 out.append(_junction(seed,p,"t",-PI/2,45,32,true))
 return out
static func _junction(seed:int,p:Vector2,kind:String,rotation:float,vertical_width:float,horizontal_width:float,vertical:bool)->Dictionary:
 var right=Vector2.RIGHT;var down=Vector2.DOWN
 if vertical:
  down=Vector2(WorldMap.branch_x_at(seed,p.y+1)-WorldMap.branch_x_at(seed,p.y-1),2).normalized()
 else:
  right=Vector2(2,WorldMap.trail_y_at(seed,p.x+1)-WorldMap.trail_y_at(seed,p.x-1)).normalized()
 # The middle 96x96px contains the complete junction, no large square overlay.
 var half=Vector2(vertical_width,horizontal_width)*192./72./4.
 return {"kind":kind,"rotation":rotation,"frame":Transform2D(right,down,p),"half":half,"center":p}
