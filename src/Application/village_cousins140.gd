class_name VillageCousins140
extends RefCounted
## Additive V3 journal and stable four-town registry. No recipe/unlock changes.
const IDS:Array[String]=["home","east138","west140","east140"]
const LABELS:Dictionary={"home":"Pueblo del rancho","east138":"Camino del Este","west140":"Caserío del Oeste","east140":"Caserío del Este Lejano"}
const CLUES:Array[String]=[
 "En el Atlas hay caballos legendarios todavía por descubrir. Nadie sabe qué son, pero la genética dice que deben existir. ¡Y yo nunca discuto con un árbol genealógico!",
 "Cuidado con los cuernos... ¿Toros? Yo no he dicho toros. ¿O sí?",
 "Encontré un cuerno recto y simétrico. No parecía de toro. Si solo había uno, igual no le faltaba el otro.",
 "He oído hablar de una fuente mágica. Dicen que su agua devuelve estrellas aunque sea de día. No sé dónde está; no voy a mandarte a un sitio que ni yo sabría encontrar."
]
static func fresh(seed_:int,discovered:Array,flora:Dictionary)->Dictionary:
 var left:int=0;var right:int=0
 for item in discovered:
  var parts:PackedStringArray=str(item).split(",")
  if parts.size()!=2 or not parts[0].is_valid_int():continue
  left=mini(left,int(parts[0]));right=maxi(right,int(parts[0]))
 var west:int=mini(-1,floori(float(left-2)/5.))
 var east:int=maxi(int(flora.get("region",1))+1,ceili(float(right+2)/5.))
 var home:Vector2=FloristJourney138.home_door(seed_)
 var doors:Dictionary={"home":home,"east138":FloristJourney138.door(flora),"west140":Vector2(west*5120.+320.,358.),"east140":Vector2(east*5120.+320.,358.)}
 return {"version":1,"seed":seed_,"doors":doors,"known":{},"arrivals":{}}
static func clean(raw:Variant,seed_:int)->Dictionary:
 if not raw is Dictionary or raw.get("version",0)!=1 or raw.get("seed",0)!=seed_:return {}
 if not raw.get("doors") is Dictionary:return {}
 var out:Dictionary={"version":1,"seed":seed_,"doors":{},"known":{},"arrivals":{}}
 for id in IDS:
  var p:Variant=raw.doors.get(id)
  if not p is Vector2 or not p.is_finite():return {}
  out.doors[id]=p
  if raw.get("known",{}) is Dictionary and raw.known.get(id,false)==true:out.known[id]=true
  if raw.get("arrivals",{}) is Dictionary and raw.arrivals.get(id,"") in ["norte","sur","este","oeste"]:out.arrivals[id]=raw.arrivals[id]
 return out
static func point(state:Dictionary,id:String)->Vector2:return state.doors[id]+Vector2(-380,130)
static func direction(from:Vector2,to:Vector2)->String:
 var gap:Vector2=to-from
 if gap.length_squared()<1.:return ""
 return ("este" if gap.x>0 else "oeste") if absf(gap.x)>=absf(gap.y) else ("sur" if gap.y>0 else "norte")
static func clue(id:String)->String:return CLUES[IDS.find(id)] if id in IDS else ""
static func hear(state:Dictionary,id:String)->bool:
 if id not in IDS or state.known.get(id,false):return false
 state.known[id]=true;return true
static func next_unknown(state:Dictionary,from_id:String)->String:
 var nearest:float=INF;var choice:String=""
 if from_id not in IDS:return choice
 for id in IDS:
  if id==from_id or state.known.get(id,false):continue
  var distance:float=point(state,from_id).distance_squared_to(point(state,id))
  if distance<nearest:nearest=distance;choice=id
 return choice
static func cousin_hint(state:Dictionary,from_id:String)->String:
 var target:String=next_unknown(state,from_id)
 if target.is_empty():return "Ya conoces a todos mis primos de estos cuatro pueblos. No conozco otro por aquí."
 var side:String=direction(point(state,from_id),point(state,target))
 var arrival:String=state.arrivals.get(from_id,"")
 var lead:String=("¿Vienes del "+arrival+"? ") if not arrival.is_empty() else ""
 return lead+"Todavía no conoces a mi primo de "+str(LABELS[target])+". Sigue el camino hacia el "+side+" para llegar a su pueblo."
static func journal(state:Dictionary)->String:
 var text:String="Primos conocidos · %d/4\n"%state.known.size()
 for id in IDS:
  if state.known.get(id,false):text+="\n"+str(LABELS[id])+"\n"+clue(id)+"\n"
 return text
static func surprised(horse:Dictionary)->bool:return horse.get("species","")=="unicorn"
