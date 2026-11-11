class_name WorldGoats
extends RefCounted
## Prototype rules, Ant 9-Nov: flee until roped, then charge the rider.
const FLEE_SPEED:float=205.0
const CHARGE_SPEED:float=235.0
const CONTACT_RANGE:float=46.0
const SURVIVE_SECONDS:float=AnimalFatigue.CAPTURE_SECONDS # exhausted capture, no old survival timer
const ROPE_RANGE:float=240.0
static func new_state()->Dictionary:
 return {"progress":0.0,"flee":false,"break_rope":false,"contact":false,"run":0.0,"rest":0.0,"tired":false}
static func tick(state:Dictionary,dist:float,roped:bool,delta:float)->Dictionary:
 var out:Dictionary=state.duplicate()
 out.break_rope=false;out.contact=false;out.flee=not roped
 if roped and dist<=CONTACT_RANGE and not bool(out.get("tired",false)):
  out=AnimalFatigue.tick(out,dist<260.0,false,delta)
  out.break_rope=true;out.contact=true;out.progress=0.0
 elif roped and dist>ROPE_RANGE:
  out=AnimalFatigue.tick(out,dist<260.0,false,delta)
  out.break_rope=true;out.progress=0.0
 else:
  out=AnimalFatigue.tick(out,roped or dist<260.0,roped,delta)
  out.flee=not roped and not out.tired and dist<260.0
 return out
