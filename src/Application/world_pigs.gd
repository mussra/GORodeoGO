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

## Lasso hold (Ant 17:55: the rope must work for pigs too): fast fill while held.
const HOLD_FILL:float=0.5

static func hold_tick(state:Dictionary,delta:float)->Dictionary:
 var out:Dictionary=state.duplicate()
 out.flee=false
 out.progress=minf(1.0,float(out.get("progress",0.0))+HOLD_FILL*delta)
 return out

static func captured(state:Dictionary)->bool:
 return float(state.get("progress",0.0))>=1.0

## Pig chase mode (Ant, 8-nov-2026): pigs FLEE and the rider chases them with
## the lasso. A fleeing pig tires after a long run; rope it and KEEP MOVING -
## exceed the rope distance and the rope snaps. Roped + tired fills the capture fast and
## pays well. Same lasso/capture machinery as before; only pig behaviour is
## new. All knobs here.
const CHASE_MODE:bool=true  # false restores the walk-up trust capture
const CHASE_TRIGGER_RANGE:float=260.0
const CHASE_FLEE_SPEED:float=225.0  # trote (~187) can't catch it; galope (260) can
const CHASE_TIRE_SECONDS:float=AnimalFatigue.RUN_SECONDS  # running this long tires the pig
const CHASE_ROPED_TIRE_MULT:float=AnimalFatigue.ROPED_MULTIPLIER  # roped running tires it faster
const CHASE_RECOVER_SECONDS:float=AnimalFatigue.RECOVER_SECONDS  # tired rest before it can run again
const CHASE_RESTED_FRACTION:float=AnimalFatigue.RESTED_FRACTION  # fraction of the run budget restored
const CHASE_TIRED_FILL:float=1.0  # capture fill/s while roped+tired
const CHASE_ROPE_MAX_SECONDS:float=20.0  # safety net; chase rules end it first
const CHASE_REWARD_POINTS:int=40
const CHASE_ROPE_RANGE:float=240.0
const MIN_ROPED_RUN_SECONDS:float=3.0

## New rope keeps existing fatigue; exhaustion is the capture window (11-Nov).
static func begin_rope(state:Dictionary)->Dictionary:
 var out:Dictionary=state.duplicate();out.progress=0.0;out["rope_run"]=0.0
 return out


static func new_chase_state()->Dictionary:
 return {"progress":0.0,"flee":false,"run":0.0,"rest":0.0,"still":0.0,"tired":false,"break_rope":false}

## dist: player-to-pig distance; speed: player's speed; roped: lasso on it.
static func chase_tick(state:Dictionary,dist:float,_speed:float,roped:bool,delta:float)->Dictionary:
 var out:Dictionary=state.duplicate()
 out.break_rope=false
 if roped and dist>CHASE_ROPE_RANGE:
  out=AnimalFatigue.tick(out,dist<CHASE_TRIGGER_RANGE,false,delta)
  out.break_rope=true;out.progress=0.0
  return out
 out.lasso_panic170=maxf(0.,float(out.get("lasso_panic170",0.))-delta)
 out=AnimalFatigue.tick(out,roped or dist<CHASE_TRIGGER_RANGE or out.lasso_panic170>0.,roped,delta)
 out["rope_run"]=float(out.get("rope_run",0.0))+(delta if roped and not out.tired else 0.0)
 out.still=0.0
 return out

## Break preserves remaining fatigue, already recovering from the break tick.
static func after_rope_break(state:Dictionary)->Dictionary:
 var out:Dictionary=new_chase_state()
 out.run=float(state.get("run",0.0));out.tired=bool(state.get("tired",false));out.rest=float(state.get("rest",0.0));out.flee=not out.tired
 return out
