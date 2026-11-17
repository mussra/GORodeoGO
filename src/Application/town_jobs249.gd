class_name TownJobs249
extends RefCounted
## Per-office data, with the shared NpcQuests accept/event/return state machine.
static func key(town:String,role:String)->String:return town+"|"+role
static func job(seed_:int,town:String,role:String)->Dictionary:
 var node:=TownNetwork234.node_for(seed_,town)
 if node.is_empty() or role not in node.roles:return {}
 var id:=key(town,role)
 var q:Dictionary={"npc":role,"town":town,"role":role,"requires":"","goal":1,"reward":120}
 match role:
  "farmer":
   var animal:String="pig" if posmod(hash("job249-"+str(seed_)+town),2)==0 else "goat"
   var word:String="cerdo" if animal=="pig" else "cabra"
   q.merge({"title":("Un " if animal=="pig" else "Una ")+word+" para el granjero","kind":"capture_animal","target":animal,"active":"Entrega 1 "+word+" al granjero","text":"Me vendría bien "+("un " if animal=="pig" else "una ")+word+". Si ya tienes "+("uno, te lo compro" if animal=="pig" else "una, te la compro")+" por 40 puntos. Si no, puedes capturarlo con el lazo.","done":"Gracias. Ya tengo el animal que necesitaba.","reward":40},true)
  "florist":
   q.merge({"title":"Flores para la florista","kind":"collect_flower","target":id,"goal":3,"active":"Recoge 3 flores con aura y vuelve a la florista","text":"Necesito tres flores con aura azul de los alrededores. Te las marco en el mapa. Pasa por encima para recogerlas y vuelve a verme.","done":"¡Son las tres flores que necesitaba!"},true)
  "saddler":
   q.merge({"title":"La prueba del lazo","kind":"tame_horse","target":"horse","active":"Doma 1 caballo salvaje y vuelve al guarnicionero","text":"Quiero comprobar cómo funciona tu lazo. Doma un caballo salvaje y vuelve a contarme. El caballo se queda en tu cuadra.","done":"Buen trabajo con ese lazo. El caballo ya está en tu cuadra."},true)
  "loco":
   q.merge({"title":"¿Sigue abierto el camino?","kind":"visit_gate","target":id,"active":"Llega al punto marcado fuera de la puerta y vuelve","text":"¿Me haces un favor? Sigue el camino hasta el punto dorado que te marco, fuera de la puerta. Luego vuelve a contarme si se puede pasar.","done":"¡Entonces el camino sigue abierto! Gracias por comprobarlo.","reward":80},true)
 return q
static func definitions(seed_:int,states:Dictionary)->Dictionary:
 var out:Dictionary={}
 for id in states:
  var parts:=str(id).split("|")
  if parts.size()!=2:continue
  var q:=job(seed_,parts[0],parts[1])
  if not q.is_empty():out[id]=q
 return out
static func clean(raw:Variant,seed_:int)->Dictionary:
 return NpcQuests.clean(raw,definitions(seed_,raw)) if raw is Dictionary else {}
static func legacy_pending(town:String,role:String)->bool:
 if town!="home" or role not in ["farmer","florist"]:return false
 var npc:Dictionary=NpcQuests.NPCS[0 if role=="farmer" else 1]
 for id in npc.quests:
  var s:=NpcQuests.state(SaveData.world_quests,id)
  if s.status!="done" or not s.get("thanked",false):return true
 return false
static func delivered(town:String,role:String)->bool:
 if town=="home" and role in ["farmer","florist"]:return not legacy_pending(town,role)
 var state_:=NpcQuests.state(SaveData.world_jobs249,key(town,role))
 return state_.status=="done" and bool(state_.get("thanked",false))
static func inventory(animal:String)->int:
 return SaveData.pig_inventory104() if animal=="pig" else WorldLivestock104.available(SaveData.world_goat_captures,SaveData.world_goats_given249)
static func ready(q:Dictionary,state:Dictionary)->bool:
 return inventory(q.target)>=int(q.goal) if q.kind=="capture_animal" else state.status=="done"
static var point_cache:Dictionary={}
static func positions(seed_:int,q:Dictionary)->Array[Vector2]:
 var cache_key:String=str(seed_)+key(q.town,q.role)
 if point_cache.has(cache_key):return point_cache[cache_key]
 var result:Array[Vector2]=[]
 if q.kind=="collect_flower":result=WorldFlowers105.positions(seed_,6,TownNetwork234.node_for(seed_,q.town).door,key(q.town,q.role))
 elif q.kind=="visit_gate":result.append((TownEnclosures227.plans(seed_)[q.town].gate as Vector2)+Vector2(0,320))
 if point_cache.size()>128:point_cache.clear()
 point_cache[cache_key]=result;return result
static func record(kind:String,target:String,event_id:String)->Array[String]:
 return NpcQuests.record(SaveData.world_jobs249,kind,target,event_id,definitions(SaveData.world_seed,SaveData.world_jobs249))
static func objective_points()->Array:
 var out:Array=[]
 for id in SaveData.world_jobs249:
  var s:=NpcQuests.state(SaveData.world_jobs249,id)
  if s.status!="active":continue
  var q:Dictionary=definitions(SaveData.world_seed,{id:s}).get(id,{})
  if q.is_empty():continue
  var points:=positions(SaveData.world_seed,q)
  for i in points.size():
   var event:String=id+":"+str(i)
   if event not in s.events:out.append({"pos":points[i],"id":id,"event":event,"kind":q.kind,"target":q.target,"index":i})
 return out
