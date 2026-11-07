class_name WorldTaming
extends RefCounted
## Taming a wild horse: stay close and calm; rush it and it bolts (Ant, 7-nov-2026).
## Pure logic so unit tests drive it without a scene. Serenidad (calm) of the ridden
## horse sets how fast trust builds; temperament makes skittish horses slower.

const CALM_RANGE:float=170.0
const SPOOK_RANGE:float=120.0
const SAFE_SPEED:float=130.0
const STILL_SPEED:float=52.0
const BASE_FILL:float=0.22
const SPOOK_SECONDS:float=2.5
const FLEE_LEASH:float=610.0

static func new_state()->Dictionary:
 return {"progress":0.0,"spook":0.0}

## dist: player-to-horse distance; speed: player's current speed; calm: Serenidad of
## the ridden horse; temperament: wild horse 0..1 (higher = more skittish).
static func tick(state:Dictionary,dist:float,speed:float,calm:float,temperament:float,delta:float)->Dictionary:
 var out:Dictionary=state.duplicate()
 out.spook=maxf(0.0,float(out.get("spook",0.0))-delta)
 if speed>SAFE_SPEED and dist<SPOOK_RANGE:
  out.spook=SPOOK_SECONDS
  out.progress=maxf(0.0,float(out.progress)-2.0*delta)
  return out
 if float(out.spook)>0.0:return out
 if dist<CALM_RANGE and speed<=STILL_SPEED:
  var rate:float=BASE_FILL*clampf(calm,0.5,2.0)*(1.0-clampf(temperament,0.0,1.0)*0.6)
  out.progress=minf(1.0,float(out.progress)+rate*delta)
 return out

static func tamed(state:Dictionary)->bool:
 return float(state.get("progress",0.0))>=1.0

static func should_flee(state:Dictionary,dist:float)->bool:
 return float(state.get("spook",0.0))>0.0 and dist<CALM_RANGE*1.6

## Lasso on fleeing wild horses (Ant, 7-nov-2026 16:20): a landed rope holds the
## horse in place for HOLD_SECONDS; trust fills fast while held. Skittish
## temperaments resist the fill. If the hold ends before taming, the horse bolts.
const HOLD_SECONDS:float=4.0
const HOLD_FILL:float=0.30

static func hold_tick(state:Dictionary,temperament:float,delta:float)->Dictionary:
 var out:Dictionary=state.duplicate()
 var rate:float=HOLD_FILL*(1.0-clampf(temperament,0.0,1.0)*0.5)
 out.progress=minf(1.0,float(out.get("progress",0.0))+rate*delta)
 return out
