class_name ProgressionEconomy165
extends RefCounted
## Internal points only. Foundation, not wired to purchases until the save/UI block.
## Cosmetic IDs are separate from inherited genetic finish (normal/original/galaxy).
const VERSION:int=1
const GOAT_CAPTURE_POINTS:int=40
const CONTRACT_GOAL:int=5
const CONTRACT_REWARD:int=400
const EXTRAS:Dictionary={
 "adorn_silver":{"name":"Adornos de plata","price":6000,"pigs":20,"goats":15,"contracts":4},
 "adorn_gold":{"name":"Adornos de oro","price":12000,"pigs":40,"goats":30,"contracts":8},
 "finish_gold":{"name":"Oro brillante","price":24000,"pigs":80,"goats":60,"contracts":16},
 "finish_crystal":{"name":"Cristal","price":42000,"pigs":160,"goats":120,"contracts":32},
 "finish_ice":{"name":"Hielo","price":66000,"pigs":280,"goats":220,"contracts":56}
}
static func victory_points(level:int,highest:int)->int:
 if not EquipmentCatalog.REWARDS.has(level):return 0
 var full:int=int(EquipmentCatalog.REWARDS[level])
 return full if level>highest else clampi(roundi(full*.05),10,400)
static func missing(id:String,points:int,pigs:int,goats:int,contracts:int)->Dictionary:
 if not EXTRAS.has(id):return {"unknown":true}
 var item:Dictionary=EXTRAS[id];var out:Dictionary={}
 for entry in [["points",item.price,points],["pigs",item.pigs,pigs],["goats",item.goats,goats],["contracts",item.contracts,contracts]]:
  if int(entry[2])<int(entry[1]):out[entry[0]]=int(entry[1])-maxi(0,int(entry[2]))
 return out
static func new_contract(completed:int=0)->Dictionary:
 return {"version":VERSION,"completed":maxi(0,completed),"active":false,"ready":false,"events":[]}
static func target(state:Dictionary)->String:return "pig" if int(state.get("completed",0))%2==0 else "goat"
static func accept(state:Dictionary)->bool:
 if state.get("active",false) or state.get("ready",false):return false
 state.active=true;state.events=[];return true
static func record(state:Dictionary,kind:String,event_id:String)->bool:
 if not state.get("active",false) or state.get("ready",false) or kind!=target(state) or event_id.is_empty() or state.events.has(event_id):return false
 state.events.append(event_id)
 if state.events.size()>=CONTRACT_GOAL:state.active=false;state.ready=true
 return true
static func claim(state:Dictionary)->int:
 if not state.get("ready",false) or state.get("events",[]).size()!=CONTRACT_GOAL:return 0
 state.completed=int(state.completed)+1;state.active=false;state.ready=false;state.events=[];return CONTRACT_REWARD
static func clean(raw:Variant)->Dictionary:
 if not raw is Dictionary or typeof(raw.get("version"))!=TYPE_INT or raw.version!=VERSION:return new_contract()
 if typeof(raw.get("completed"))!=TYPE_INT or raw.completed<0:return new_contract()
 var out:=new_contract(raw.completed)
 if not raw.get("events") is Array:return out
 var ids:Array=[]
 for id in raw.events:
  if id is String and not id.is_empty() and not ids.has(id) and ids.size()<CONTRACT_GOAL:ids.append(id)
 var ready:bool=raw.get("ready",false)==true and ids.size()==CONTRACT_GOAL
 var active:bool=raw.get("active",false)==true and ids.size()<CONTRACT_GOAL
 if ready or active:out.events=ids;out.ready=ready;out.active=active
 return out
