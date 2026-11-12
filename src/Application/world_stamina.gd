class_name WorldStamina
extends RefCounted
## Horse stamina in the open world (Ant, 7-nov-2026 11:39): galloping drains,
## trotting drains a little, walking/standing recover. Empty forces a gentle
## walk for a few seconds - a breather, never a punishment. ALL knobs live here.
## Levels keep this OFF (approved balance); enable there only with Ant's OK.
const LEVELS_ENABLED:bool=false  # do not flip without telling Ant first

const MAX:float=100.0
## Ant (8-nov-2026): horses must last much longer for long trips. The worst
## horse now endures DOUBLE: every drain is divided by this one knob.
const ENDURANCE_MULT:float=2.0
## Reversible balance default: roads consume 35% less stamina, not zero.
const ROAD_DRAIN_MULT:float=0.65
const DRAIN_GALOPE:float=8.0    # ~12s of full gallop (x ENDURANCE_MULT)
const DRAIN_TROTE:float=2.5     # trotting is cheap but not free
const REGEN_PASO:float=9.0
const REGEN_IDLE:float=14.0
const FORCE_PASO_SECONDS:float=4.0  # gentle breather after emptying
const GALOPE_MIN:float=30.0     # gallop again from here

## Better horses last longer (Ant: optional idea; power 0..1 -> x0.85..x1.15).
static func max_for(power:float)->float:
 return MAX*(0.85+clampf(power,0.0,1.0)*0.3)

static func new_state(power:float=0.65)->Dictionary:
 return {"value":max_for(power),"max":max_for(power),"forced_left":0.0}

## gait: current WorldGait; moving: the horse is actually covering ground.
static func tick(state:Dictionary,gait:int,moving:bool,delta:float,on_road:bool=false)->Dictionary:
 var out:Dictionary=state.duplicate()
 var v:float=float(out.value)
 var drain_mult:float=ROAD_DRAIN_MULT if on_road else 1.0
 if moving and gait==WorldGait.GALOPE:v-=DRAIN_GALOPE/ENDURANCE_MULT*delta*drain_mult
 elif moving and gait==WorldGait.TROTE:v-=DRAIN_TROTE/ENDURANCE_MULT*delta*drain_mult
 elif moving:v+=REGEN_PASO*delta
 else:v+=REGEN_IDLE*delta
 out.value=clampf(v,0.0,float(out.max))
 if float(out.value)<=0.0 and float(out.forced_left)<=0.0:
  out.forced_left=FORCE_PASO_SECONDS
 elif float(out.forced_left)>0.0:
  out.forced_left=maxf(0.0,float(out.forced_left)-delta)
 return out

## The gait the horse can actually hold right now.
static func cap_gait(state:Dictionary,gait:int)->int:
 if float(state.get("forced_left",0.0))>0.0:return mini(gait,WorldGait.PASO)
 if float(state.get("value",0.0))<GALOPE_MIN:return mini(gait,WorldGait.TROTE)
 return gait

static func just_tired(before:Dictionary,after:Dictionary)->bool:
 return float(before.get("forced_left",0.0))<=0.0 and float(after.get("forced_left",0.0))>0.0

static func ratio(state:Dictionary)->float:
 return float(state.value)/maxf(1.0,float(state.max))
