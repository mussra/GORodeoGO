class_name HorseStats
extends RefCounted
## Demo tuning, not final balance. No relation to color or rarity.
const BASE={"speed":260.0,"handling":900.0,"power":0.6,"dodge":1.0}
static func read(h:Dictionary)->Dictionary:
 var raw:Variant=h.get("stats",BASE)
 var s:Dictionary=raw if raw is Dictionary else BASE
 var out:Dictionary={}
 out.speed=clampf(number(s.get("speed",260.0),260.0),240,300)
 out.handling=clampf(number(s.get("handling",900.0),900.0),600,1500)
 out.power=clampf(number(s.get("power",0.6),0.6),0.5,0.9)
 out.dodge=clampf(number(s.get("dodge",1.0),1.0),0.75,1.0)
 return out
static func inherit(a:Dictionary,b:Dictionary)->Dictionary:
 var x:=read(a);var y:=read(b);var out:Dictionary={}
 for k in BASE:out[k]=maxf(x[k],y[k])
 return out

static func number(v:Variant,fallback:float)->float:
 if typeof(v) not in [TYPE_FLOAT,TYPE_INT]:return fallback
 return float(v) if is_finite(float(v)) else fallback
