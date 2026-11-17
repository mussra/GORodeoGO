class_name HorseStats
extends RefCounted
## Demo tuning, not final balance. No relation to color or rarity.
const BASE={"speed":260.0,"handling":900.0,"power":0.6,"dodge":1.0,"calm":1.0}
static func read(h:Dictionary)->Dictionary:
 var raw:Variant=h.get("stats",BASE)
 var s:Dictionary=raw if raw is Dictionary else BASE
 var out:Dictionary={}
 out.speed=clampf(number(s.get("speed",260.0),260.0),240,300)
 out.handling=clampf(number(s.get("handling",900.0),900.0),600,1500)
 out.power=clampf(number(s.get("power",0.6),0.6),0.5,0.9)
 out.dodge=clampf(number(s.get("dodge",1.0),1.0),0.75,1.0)
 # Serenidad (Ant, 7-nov-2026): how fast the horse calms bulls and wild horses.
 out.calm=calm_factor(s.get("calm",1.0))
 if not h.get("growth_capped255",false):
  for spec in HorseSummary185.STATS:
   var key:String=spec[1]
   out[key]=clampf(out[key]+VictoryGrowth251.bonus(key,int(h.get("growth251",{}).get(key,0))),spec[2],spec[3])
 return out
# Bake legacy growth into bounded saved properties once; keep historical counts
# for diminishing returns, never add those counts a second time.
static func cap255(h:Dictionary)->void:
 h.stats=read(h);h.growth_capped255=true
static func grow255(h:Dictionary,key:String,steps:int=1)->void:
 cap255(h)
 for spec in HorseSummary185.STATS:
  if spec[1]!=key or h.stats[key]>=spec[3]:continue
  var counts:Dictionary=h.get("growth251",{}).duplicate(true)
  var old:int=int(counts.get(key,0));var next:int=old+steps
  h.stats[key]=minf(spec[3],h.stats[key]+VictoryGrowth251.bonus(key,next)-VictoryGrowth251.bonus(key,old))
  counts[key]=next;h.growth251=counts
static func inherit(a:Dictionary,b:Dictionary)->Dictionary:
 var x:=read(a);var y:=read(b);var out:Dictionary={}
 for k in BASE:out[k]=(x[k]+y[k])*.5
 return out

static func number(v:Variant,fallback:float)->float:
 if typeof(v) not in [TYPE_FLOAT,TYPE_INT]:return fallback
 return float(v) if is_finite(float(v)) else fallback

## Shared bounds for horse-read values and active calming. Invalid saves keep base pace.
static func calm_factor(value:Variant)->float:return clampf(number(value,1.0),0.5,2.0)
static func mounted_calm(collection:HorseCollection)->float:
 return read(collection.find(collection.selected)).calm
