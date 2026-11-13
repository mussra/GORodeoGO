class_name SiestaRest166
extends RefCounted
## Active riding only, independent of the device clock and shared across maps.
const SECONDS:float=300.
const REFUSAL:String="No puedo estar durmiendo todo el día, ¿sabes?"
static func clean(value:Variant)->float:
 if typeof(value) not in [TYPE_FLOAT,TYPE_INT] or not is_finite(float(value)):return 0.
 return clampf(float(value),0.,SECONDS)
static func tick(remaining:float,delta:float,riding:bool)->float:
 if not riding or delta<=0. or not is_finite(delta):return clean(remaining)
 return maxf(0.,clean(remaining)-minf(delta,.25))
