class_name AnimalFatigue
extends RefCounted
## Shared pig/goat exhaustion and recovery. No owner, rendering or save writes.
const RUN_SECONDS:float=7.0
const ROPED_MULTIPLIER:float=1.5
const RECOVER_SECONDS:float=5.0
const RESTED_FRACTION:float=.35
const CAPTURE_SECONDS:float=1.0
static func tick(state:Dictionary,running:bool,roped:bool,delta:float)->Dictionary:
 var out:Dictionary=state.duplicate()
 out["run"]=float(out.get("run",0));out["rest"]=float(out.get("rest",0));out["tired"]=bool(out.get("tired",false));out["progress"]=float(out.get("progress",0))
 if out.tired:
  out["flee"]=false
  if roped:
   out.progress=minf(1.0,out.progress+delta/CAPTURE_SECONDS)
   if out.progress>=1.0-.00001:out.progress=1.0
  else:
   out.progress=0.0;out.rest+=delta
   if out.rest>=RECOVER_SECONDS-.00001:
    out.tired=false;out.rest=0.0;out.run=RUN_SECONDS*RESTED_FRACTION;out.flee=running
  return out
 out.rest=0.0;out.progress=0.0;out["flee"]=running
 if running:
  out.run=minf(RUN_SECONDS,out.run+delta*(ROPED_MULTIPLIER if roped else 1.0))
  if out.run>=RUN_SECONDS-.00001:out.tired=true;out.flee=false
 elif not roped:out.run=maxf(0.0,out.run-delta*RUN_SECONDS/RECOVER_SECONDS)
 return out
static func energy(state:Dictionary)->float:
 if bool(state.get("tired",false)):
  return clampf(float(state.get("rest",0))/RECOVER_SECONDS*(1.0-RESTED_FRACTION),0,1)
 return clampf(1.0-float(state.get("run",0))/RUN_SECONDS,0,1)
