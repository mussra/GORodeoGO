class_name WorldPigs
extends RefCounted
## Wild pigs (Ant: "otro animal, como cerdos, que se pueden capturar", 7-nov-2026).
## Kid-friendly capture: walk up slowly and stay close; rush and they scatter.
## Pure logic so unit tests drive it without a scene. Pigs are braver than horses:
## no lingering spook, they just refuse to fill while you move fast nearby.

const CAPTURE_RANGE:float=140.0
const SAFE_SPEED:float=110.0
const STILL_SPEED:float=70.0
const BASE_FILL:float=0.55
const FLEE_LEASH:float=420.0

static func new_state()->Dictionary:
 return {"progress":0.0,"flee":false}

## dist: player-to-pig distance; speed: player's current speed.
static func tick(state:Dictionary,dist:float,speed:float,delta:float)->Dictionary:
 var out:Dictionary=state.duplicate()
 out.flee=false
 if speed>SAFE_SPEED and dist<CAPTURE_RANGE*1.4:
  out.flee=true
  out.progress=maxf(0.0,float(out.progress)-1.5*delta)
  return out
 if dist<CAPTURE_RANGE and speed<=STILL_SPEED:
  out.progress=minf(1.0,float(out.progress)+BASE_FILL*delta)
 return out

static func captured(state:Dictionary)->bool:
 return float(state.get("progress",0.0))>=1.0
