class_name WorldTaming
extends RefCounted
## Taming a wild horse requires a landed lasso (Ant, 10-Nov-2026).
## Pure logic so unit tests drive it without a scene. Serenidad (calm) of the ridden
## No passive trust. Temperament and affinity affect the lasso fill only.

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
 # No passive trust, including affinity and calm bonuses. Only a landed rope fills.
 out.progress=minf(float(out.get("progress",0.0)),.999)

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
const HOLD_FILL:float=0.65

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

## Sementales desconfiados (Ant 8-nov 15:02): caballos salvajes de alto nivel
## (rapidos y temperamentales) no se dejan capturar salvo que el caballo
## equipado les resulte familiar: 2+ rasgos visibles compartidos o un Lider de
## manada de su tipo. Si no, huyen ANTES de entrar a tiro de lazo (max throw
## 220) y, si caen en el lazo, lo rompen casi al instante. Pistas progresivas.
const STALLION_MIN_SPEED:float=275.0
const STALLION_MIN_TEMPERAMENT:float=0.7
const STALLION_REQUIRED_MATCHES:int=2
const STALLION_FLEE_RANGE:float=260.0
const STALLION_BREAK_SECONDS:float=1.2
const STALLION_HINT_COOLDOWN:float=10.0

static func is_stallion(herd:Dictionary)->bool:
 var stats:Dictionary=herd.get("stats",{})
 return float(stats.get("speed",0.0))>=STALLION_MIN_SPEED and float(herd.get("temperament",0.0))>=STALLION_MIN_TEMPERAMENT

static func stallion_admits(matches:int,leader:bool)->bool:
 return leader or matches>=STALLION_REQUIRED_MATCHES

static func stallion_hint_key(stage:int)->String:
 return "WORLD_STALLION_HINT_%d"%clampi(stage+1,1,3)
