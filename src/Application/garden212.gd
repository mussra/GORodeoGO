class_name Garden212
extends RefCounted
const VERSION:=1
const GROW_DISTANCE:=900.0
const FOOD_SECONDS:=120.0
const DRAIN_MULT:=0.85
static func fresh()->Dictionary:
 return {"version":VERSION,"anchors":{},"stage":"locked","seeds":0,"crops":0,"watered":false,"distance":0.0,"discovered":false,"harvests":0,"food":{"horse":"","left":0.0}}
static func clean(raw:Variant)->Dictionary:
 if not raw is Dictionary or raw.get("version",0)!=VERSION:return fresh()
 var out:=fresh()
 if raw.get("stage","") not in ["locked","intro","search","empty","growing","ripe"]:return out
 out.stage=raw.stage
 var anchors:Variant=raw.get("anchors",{})
 if anchors is Dictionary and ["home","plot","sample"].all(func(k):return anchors.get(k) is Vector2 and anchors[k].is_finite()):out.anchors=anchors.duplicate(true)
 for key in ["seeds","crops","harvests"]:
  if not raw.get(key,0) is int or raw.get(key,0)<0:return fresh()
  out[key]=mini(9999,raw.get(key,0))
 out.watered=raw.get("watered",false)==true;out.discovered=raw.get("discovered",false)==true
 out.distance=clampf(HorseStats.number(raw.get("distance",0.0),0.0),0.,GROW_DISTANCE)
 var food:Variant=raw.get("food",{})
 if food is Dictionary and food.get("horse","") is String:
  out.food={"horse":food.get("horse",""),"left":clampf(HorseStats.number(food.get("left",0.),0.),0.,FOOD_SECONDS)}
 return out
static func action(state:Dictionary,action_:String,horse:String="")->Dictionary:
 var out:=clean(state)
 match action_:
  "introduce":
   if out.stage!="locked":return {}
   out.stage="intro"
  "accept":
   if out.stage!="intro":return {}
   out.stage="search"
  "sample":
   if out.stage!="search":return {}
   out.stage="empty";out.seeds=1
  "plant":
   if out.stage!="empty" or out.seeds<1:return {}
   out.seeds-=1;out.stage="growing";out.watered=false;out.distance=0.
  "water":
   if out.stage!="growing" or out.watered:return {}
   out.watered=true
  "harvest":
   if out.stage!="ripe":return {}
   out.stage="empty";out.crops+=3;out.seeds+=1;out.harvests+=1;out.discovered=true;out.distance=0.;out.watered=false
  "feed":
   if out.crops<1 or horse.is_empty() or out.food.left>0.:return {}
   out.crops-=1;out.food={"horse":horse,"left":FOOD_SECONDS}
  _:return {}
 return out
static func tick(state:Dictionary,distance:float,seconds:float)->Dictionary:
 var out:=state.duplicate(true)
 if out.stage=="growing" and out.watered:
  out.distance=minf(GROW_DISTANCE,float(out.distance)+maxf(0.,distance))
  if out.distance>=GROW_DISTANCE:out.stage="ripe"
 if out.food.left>0.:
  out.food.left=maxf(0.,float(out.food.left)-maxf(0.,seconds))
  if out.food.left<=0.:out.food.horse=""
 return out
static func multiplier(state:Dictionary,horse:String)->float:
 return DRAIN_MULT if state.food.left>0. and state.food.horse==horse else 1.0
static func summary(state:Dictionary)->String:
 match state.stage:
  "locked":return "La florista puede presentarte al hortelano de su parcela."
  "intro":return "Soy el hortelano. ¿Cuidamos esta parcela? Trae una zanahoria silvestre para conservar sus semillas y aprender a cultivarla."
  "search":return "Busca la muestra silvestre marcada cerca de la floristería."
  "empty":return "Parcela libre. Conservas %d semilla(s) y %d zanahoria(s)."%[state.seeds,state.crops]
  "growing":return "Riega la parcela para empezar." if not state.watered else "Brote cuidado · %d%%. Explora a caballo y vuelve; no se marchita."%int(state.distance/GROW_DISTANCE*100.)
  "ripe":return "Zanahorias listas. Cosecha: tres para los caballos y una semilla para replantar."
 return ""
