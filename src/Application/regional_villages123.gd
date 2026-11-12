class_name RegionalVillages123
extends RefCounted
## Additive data contract only. Does not move/replace NPCs or rewrite old quests.
## Stable town IDs are separate from display names and stream chunk IDs.
const VERSION:int=1
const THANKS:String="Aquí hemos terminado. Gracias por tu ayuda. Ya no tengo más encargos para ti en este pueblo."
const PROFILES:Dictionary={
 "meadow":{"label":"Pradera · pueblo de muestra","farmer_target":"pig","flowers":["blue1"],"quest_flower":"blue1"},
 "mountain":{"label":"Montaña · pueblo de muestra","farmer_target":"goat","flowers":["blue1","blue2","daisy1","daisy2","red1","red2","sun1","violet","purple","tulip1"],"quest_flower":"violet"}
}
static func quest_id(town_id:String,role:String)->String:return "town123:"+town_id+":"+role+":1"
static func definitions(town_id:String,profile_id:String)->Dictionary:
 if town_id.is_empty() or not PROFILES.has(profile_id):return {}
 var profile:Dictionary=PROFILES[profile_id]
 var farmer:String=quest_id(town_id,"farmer");var florist:String=quest_id(town_id,"florist")
 var animal:String="cerdos" if profile.farmer_target=="pig" else "cabras"
 return {
  farmer:{"npc":"farmer","title":"Animales de esta región","kind":"capture_animal","target":profile.farmer_target,"goal":3,"requires":"","text":"Necesito tres "+animal+" de esta región.","active":"Captura 3 "+animal,"done":"Gracias por traer los tres "+animal+"."},
  florist:{"npc":"florist","title":"Flores de esta región","kind":"collect_flower","target":town_id+":"+profile.quest_flower,"goal":3,"requires":"","text":"Necesito tres flores de este campo, del tipo señalado.","active":"Recoge 3 flores regionales","done":"Gracias por las tres flores de esta región."}
 }
static func npc(town_id:String,profile_id:String,role:String)->Dictionary:
 return {"id":role,"name":"Granjero" if role=="farmer" else "Florista","town_id123":town_id,"profile123":profile_id,"regional_close123":true,"quests":[quest_id(town_id,role)]}
static func all_done(states:Dictionary,npc_:Dictionary)->bool:
 if npc_.get("quests",[]).is_empty():return false
 for id in npc_.quests:
  if NpcQuests.state(states,id).status!="done":return false
 return true
## Independent namespace and schema, validates only explicitly registered towns.
## Unknown town records stay separate until their registry/version is available.
static func pack(states_by_town:Dictionary)->Dictionary:return {"version":VERSION,"towns":states_by_town.duplicate(true)}
static func unpack(raw:Variant,registry:Dictionary)->Dictionary:
 if not raw is Dictionary or raw.get("version",0)!=VERSION or not raw.get("towns") is Dictionary:return {}
 var out:Dictionary={}
 for town_id in registry:
  var definitions_:Dictionary=definitions(town_id,registry[town_id])
  var states:Variant=raw.towns.get(town_id,{})
  if not states is Dictionary:continue
  out[town_id]={}
  for id in definitions_:
   var s:Variant=states.get(id,{})
   if not s is Dictionary or s.get("status","") not in ["active","done"] or not s.get("events") is Array:continue
   var events:Array=[]
   for e in s.events:
    if e is String and not e.is_empty() and not events.has(e):events.append(e)
   var count_:int=mini(definitions_[id].goal,events.size())
   out[town_id][id]={"status":"done" if count_>=definitions_[id].goal else "active","count":count_,"events":events,"thanked":s.get("thanked",false)==true}
 return out
