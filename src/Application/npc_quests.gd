class_name NpcQuests
extends RefCounted
## Data only: the same accept/event/completion flow serves every NPC/objective.
const NPCS=[{"id":"farmer","name":"Granjero","position":Vector2(310,190),"placeholder":false,"quests":["farmer_pigs","farmer_goats"]},{"id":"florist","name":"Florista","position":Vector2(1110,212),"quests":["florist_blue105","florist_gold105"]}]
const QUESTS={
 "florist_blue105":{"npc":"florist","title":"Flores azules con aura","kind":"collect_flower","target":"florist_blue105","goal":3,"requires":"","text":"Necesito tres flores azules. Son las del dibujo, rodeadas por un aura azul. Recógelas pasando por encima, sin lazo.","active":"Florista: flores azules con aura","done":"¡Has recogido las tres flores azules! Gracias."},
 "florist_gold105":{"npc":"florist","title":"Flores doradas con aura","kind":"collect_flower","target":"florist_gold105","goal":3,"requires":"florist_blue105","text":"Ahora necesito tres flores doradas. Busca las del dibujo con aura dorada y pasa por encima.","active":"Florista: flores doradas con aura","done":"¡Has recogido las tres flores doradas! Gracias."},
 "east_flower":{"npc":"story","title":"Una flor al este","kind":"find_object","target":"east_flower","goal":1,"requires":"","trigger":{"axis":"east","chunks":15,"comparison":"gt"},"text":"Has cruzado más de 15 bloques hacia el este. Hay una flor silvestre especial cerca: búscala.","active":"Más de 15 bloques al este: encuentra la flor azul","done":"Has encontrado la flor del este."},
 "farmer_pigs":{"npc":"farmer","title":"Un favor para el granjero","kind":"capture_animal","target":"pig","goal":3,"requires":"","text":"¿Me harías un favor? Necesito tres cerdos salvajes para mi negocio. Persíguelos con el lazo hasta capturarlos.","active":"Captura 3 cerdos salvajes","done":"¡Has capturado los tres cerdos! Puedes guardarlos o vendérmelos al precio indicado."},
 "farmer_goats":{"npc":"farmer","title":"Ahora, las cabras","kind":"capture_animal","target":"goat","goal":3,"requires":"farmer_pigs","text":"Gracias por los cerdos. Ahora necesito tres cabras salvajes. ¿Me ayudas con ellas?","active":"Captura 3 cabras salvajes","done":"¡Las tres cabras están a salvo! Gracias por ayudarme."}
}
static func state(states:Dictionary,id:String)->Dictionary:return states.get(id,{"status":"locked","count":0,"events":[]})
static func available(states:Dictionary,id:String,definitions:Dictionary=QUESTS)->bool:
 if not definitions.has(id):return false
 var required:String=definitions[id].get("requires","")
 return required.is_empty() or state(states,required).status=="done"
static func accept(states:Dictionary,id:String,definitions:Dictionary=QUESTS)->bool:
 if not available(states,id,definitions) or state(states,id).status!="locked":return false
 states[id]={"status":"active","count":0,"events":[]};return true
static func record(states:Dictionary,kind:String,target:String,event_id:String,definitions:Dictionary=QUESTS)->Array[String]:
 var changed:Array[String]=[]
 if event_id.is_empty():return changed
 for id in definitions:
  var q:Dictionary=definitions[id];var s:Dictionary=state(states,id)
  if s.status!="active" or q.kind!=kind or q.target!=target or s.events.has(event_id):continue
  s.events.append(event_id);s.count=mini(int(q.goal),int(s.count)+1)
  if s.count>=int(q.goal):s.status="done"
  states[id]=s;changed.append(id)
 return changed
static func can_capture(states:Dictionary,target:String)->bool:
 for id in QUESTS:
  if QUESTS[id].kind=="capture_animal" and QUESTS[id].target==target and state(states,id).status in ["active","done"]:return true
 return false
static func next_for(states:Dictionary,npc:Dictionary)->String:
 for id in npc.quests:
  if state(states,id).status=="done" and not bool(state(states,id).get("thanked",false)):return id
 for id in npc.quests:
  if state(states,id).status!="done" and available(states,id):return id
 return str(npc.quests[-1])
static func clean(raw:Variant)->Dictionary:
 var out:Dictionary={}
 if not raw is Dictionary:return out
 for id in QUESTS:
  if not raw.has(id) or not raw[id] is Dictionary:continue
  var s:Dictionary=raw[id]
  if s.get("status","") not in ["active","done"] or not s.get("events",[]) is Array:continue
  var count_value:Variant=s.get("count",0)
  if not count_value is int or count_value<0:continue
  var events:Array=[]
  for event in s.events:
   if event is String and not events.has(event):events.append(event)
  var n:int=mini(int(QUESTS[id].goal),mini(count_value,events.size()))
  out[id]={"status":"done" if n==int(QUESTS[id].goal) else "active","count":n,"events":events}
  if s.has("thanked"):out[id]["thanked"]=bool(s.get("thanked",false))
  if s.get("spawn") is Vector2 and s.spawn.is_finite():out[id]["spawn"]=s.spawn
 return out

static func trigger_matches(rule:Dictionary,position:Vector2)->bool:
 var value:float=0.0
 match str(rule.get("axis","distance")):
  "east":value=position.x/WorldMap.CHUNK_SIZE
  "west":value=-position.x/WorldMap.CHUNK_SIZE
  "north":value=-position.y/WorldMap.CHUNK_SIZE
  "south":value=position.y/WorldMap.CHUNK_SIZE
  "distance":value=position.length()/WorldMap.CHUNK_SIZE
  _:return false
 var limit:float=float(rule.get("chunks",0))
 return value>limit if rule.get("comparison","gt")=="gt" else value>=limit
static func activate_triggers(states:Dictionary,position:Vector2)->Array[String]:
 var activated:Array[String]=[]
 for id in QUESTS:
  var q:Dictionary=QUESTS[id]
  if not q.has("trigger") or state(states,id).status!="locked" or not available(states,id):continue
  if trigger_matches(q.trigger,position) and accept(states,id):
   states[id]["spawn"]=position+Vector2(95,0);activated.append(id)
 return activated

static func acknowledge(states:Dictionary,id:String)->bool:
 if state(states,id).status!="done" or bool(state(states,id).get("thanked",false)):return false
 states[id]["thanked"]=true;return true
static func hud_text(states:Dictionary)->String:
 var lines:PackedStringArray=[]
 for id in QUESTS:
  var s:Dictionary=state(states,id);var q:Dictionary=QUESTS[id]
  if s.status=="active":lines.append(q.active+" · %d/%d"%[s.count,q.goal])
  elif s.status=="done" and q.npc in ["farmer","florist"] and not bool(s.get("thanked",false)):
   lines.append("Completado: "+q.active+" · %d/%d · habla con el granjero"%[q.goal,q.goal])
 return " · ".join(lines) if not lines.is_empty() else "Encargos: habla con el granjero del rancho"
