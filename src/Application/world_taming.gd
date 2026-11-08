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
static func tick(state:Dictionary,dist:float,speed:float,calm:float,temperament:float,delta:float,bonus:float=1.0,spook_secs:float=SPOOK_SECONDS)->Dictionary:
 var out:Dictionary=state.duplicate()
 out.spook=maxf(0.0,float(out.get("spook",0.0))-delta)
 if speed>SAFE_SPEED and dist<SPOOK_RANGE:
  out.spook=spook_secs
  out.progress=maxf(0.0,float(out.progress)-2.0*delta)
  return out
 if float(out.spook)>0.0:return out
 if dist<CALM_RANGE and speed<=STILL_SPEED:
  var rate:float=BASE_FILL*clampf(calm,0.5,2.0)*(1.0-clampf(temperament,0.0,1.0)*0.6)*bonus
  out.progress=minf(1.0,float(out.progress)+rate*delta)
 return out

static func tamed(state:Dictionary)->bool:
 return float(state.get("progress",0.0))>=1.0

static func should_flee(state:Dictionary,dist:float)->bool:
 return float(state.get("spook",0.0))>0.0 and dist<CALM_RANGE*1.6

## Lasso on fleeing wild horses (Ant, 7-nov-2026 16:20, restored 21:47): a
## landed rope holds the horse IN PLACE for HOLD_SECONDS; trust fills fast
## while held, and when it fills the horse is captured. Skittish temperaments
## resist the fill.
const HOLD_SECONDS:float=4.0
const HOLD_FILL:float=0.30

static func hold_tick(state:Dictionary,temperament:float,delta:float,bonus:float=1.0)->Dictionary:
 var out:Dictionary=state.duplicate()
 var rate:float=HOLD_FILL*(1.0-clampf(temperament,0.0,1.0)*0.5)*bonus
 out.progress=minf(1.0,float(out.get("progress",0.0))+rate*delta)
 return out

## Afinidad genetica (Ant 8-nov 2026 13:33): si el caballo equipado comparte
## rasgos visibles con el salvaje (pelaje, patron, crin), el salvaje confia
## mas: +25% de velocidad de llenado por rasgo (max +75%) y, con 2+ rasgos,
## el susto dura menos. Los ojos no cuentan (no se ven a distancia).
const AFFINITY_BONUS_PER_TRAIT:float=0.25
const AFFINITY_SPOOK_SECONDS:float=1.5
## "Lider de manada": caballo criado con 3+ generaciones y rasgos fijados;
## los salvajes de sus 3 rasgos no huyen: curiosidad y confianza inicial.
const LEADER_START_PROGRESS:float=0.25
const CURIOUS_SECONDS:float=3.0

static func affinity_matches(ridden:Dictionary,wild:Dictionary)->int:
 var n:int=0
 for key in ["coat","pattern","mane"]:
  if int(ridden.get(key,-1))==int(wild.get(key,-2)):n+=1
 return n

static func affinity_bonus(matches:int)->float:
 return 1.0+AFFINITY_BONUS_PER_TRAIT*float(clampi(matches,0,3))

static func spook_seconds(matches:int)->float:
 return AFFINITY_SPOOK_SECONDS if matches>=2 else SPOOK_SECONDS
