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
## stand still and the rope snaps. Roped + tired fills the capture fast and
## pays well. Same lasso/capture machinery as before; only pig behaviour is
## new. All knobs here.
const CHASE_MODE:bool=true  # false restores the walk-up trust capture
const CHASE_TRIGGER_RANGE:float=260.0
const CHASE_FLEE_SPEED:float=225.0  # trote (~187) can't catch it; galope (260) can
const CHASE_TIRE_SECONDS:float=7.0  # running this long tires the pig
const CHASE_ROPED_TIRE_MULT:float=1.5  # roped running tires it faster
const CHASE_RECOVER_SECONDS:float=5.0  # tired rest before it can run again
const CHASE_RESTED_FRACTION:float=0.35  # fraction of the run budget restored
const CHASE_ROPE_BREAK_STILL_SECONDS:float=0.9  # rider-still tolerance while roped
const CHASE_ROPE_STILL_SPEED:float=60.0
const CHASE_TIRED_FILL:float=0.8  # capture fill/s while roped+tired
const CHASE_ROPE_MAX_SECONDS:float=20.0  # safety net; chase rules end it first
const CHASE_REWARD_POINTS:int=40

static func new_chase_state()->Dictionary:
 return {"progress":0.0,"flee":false,"run":0.0,"rest":0.0,"still":0.0,"tired":false,"break_rope":false}

## dist: player-to-pig distance; speed: player's speed; roped: lasso on it.
static func chase_tick(state:Dictionary,dist:float,speed:float,roped:bool,delta:float)->Dictionary:
 var out:Dictionary=state.duplicate()
 out.break_rope=false
 if bool(out.tired):
  out.flee=false
  if roped:
   out.progress=minf(1.0,float(out.progress)+CHASE_TIRED_FILL*delta)
  else:
   out.rest=float(out.rest)+delta
   if float(out.rest)>=CHASE_RECOVER_SECONDS:
    out.tired=false;out.rest=0.0
    out.run=CHASE_TIRE_SECONDS*CHASE_RESTED_FRACTION
  return out
 out.rest=0.0
 var fleeing:bool=roped or dist<CHASE_TRIGGER_RANGE
 out.flee=fleeing
 if fleeing:
  out.run=minf(CHASE_TIRE_SECONDS,float(out.run)+delta*(CHASE_ROPED_TIRE_MULT if roped else 1.0))
  if float(out.run)>=CHASE_TIRE_SECONDS:
   out.tired=true;out.flee=false
 if roped:
  out.still=float(out.still)+delta if speed<CHASE_ROPE_STILL_SPEED else 0.0
  if float(out.still)>=CHASE_ROPE_BREAK_STILL_SECONDS:
   out.break_rope=true
 else:
  out.still=0.0
 return out

## After a rope break the pig bolts but keeps its fatigue: re-roping a
## half-tired pig is worth it.
static func after_rope_break(state:Dictionary)->Dictionary:
 var out:Dictionary=new_chase_state()
 out.run=float(state.get("run",0.0));out.flee=true
 return out
