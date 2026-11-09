class_name WorldGoats
extends RefCounted
## Prototype rules, Ant 9-Nov: flee until roped, then charge the rider.
const FLEE_SPEED:float=205.0
const CHARGE_SPEED:float=235.0
const CONTACT_RANGE:float=46.0
const SURVIVE_SECONDS:float=5.0
const ROPE_RANGE:float=240.0
static func new_state()->Dictionary:
 return {"progress":0.0,"flee":true,"break_rope":false,"contact":false}
static func tick(state:Dictionary,dist:float,roped:bool,delta:float)->Dictionary:
 var out:Dictionary=state.duplicate()
 out.break_rope=false;out.contact=false;out.flee=not roped
 if not roped:
  out.progress=0.0
 elif dist<=CONTACT_RANGE:
  out.break_rope=true;out.contact=true;out.progress=0.0
 elif dist>ROPE_RANGE:
  out.break_rope=true;out.progress=0.0
 else:
  out.progress=minf(1.0,float(out.progress)+delta/SURVIVE_SECONDS)
 return out
