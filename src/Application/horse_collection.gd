class_name HorseCollection
extends RefCounted
## Isolated trial collection. Provisional stats; no economy, sex or parent consumption.
const COATS=["Negro","Blanco","Dorado","Azul","Verde","Rojo","Violeta","Turquesa","Rosa","Naranja","Castaño","Gris","Crema","Cobre","Lima","Marino","Lavanda","Coral","Celeste","Ciruela"]
const PATTERNS=["Liso","Parches","Moteado","Trasera blanca","Patas claras","Corazones","Estrellas","Triángulos","Rombos","Cebra"]
const MANES=["Negra","Blanca","Dorada","Azul","Roja","Arcoíris"]
const RARITIES=["Común","Poco frecuente","Raro","Ultra raro","Legendario"]
const EYES=COATS+["Arcoíris","Galaxy"]
static func eye_index(t:Dictionary)->int:return int(t.get("eyes",10))
var horses:Array[Dictionary]=[]
var ancestors:Array[Dictionary]=[]
var selected:String="original"
var next_id:int=1
var birth_credits:int=0
var bought_offers:Array[String]=[]
func seed_trial()->void:
 if not horses.is_empty():return
 horses=[{"id":"original","name":"Original","parents":[],"traits":{"coat":10,"pattern":0,"mane":1,"finish":"original"}}]
func add_trial_parents()->void:
 if not find("trial_a").is_empty():return
 horses.append_array([{ "id":"trial_a","name":"Azul de prueba","can_jump":true,"parents":[],"stats":{"speed":280.0,"handling":900.0,"power":0.6,"dodge":0.85},"traits":{"coat":3,"pattern":1,"mane":2,"finish":"normal"}}, {"id":"trial_b","name":"Arcoíris de prueba","parents":[],"stats":{"speed":260.0,"handling":1250.0,"power":0.8,"dodge":1.0},"traits":{"coat":6,"pattern":0,"mane":5,"finish":"normal"}}])
func add_random_trial_pair()->Array[Dictionary]:
 var rng:=RandomNumberGenerator.new();rng.randomize()
 var added:Array[Dictionary]=[]
 for i in range(2):
  var n:int=horses.size()+1
  while not find("random_trial_%d"%n).is_empty():n+=1
  var h:Dictionary={"id":"random_trial_%d"%n,"name":"Prueba aleatoria %d"%n,"parents":[],"stage":"adult","traits":{"coat":rng.randi_range(0,COATS.size()-1),"pattern":rng.randi_range(0,PATTERNS.size()-1),"mane":rng.randi_range(0,MANES.size()-1),"eyes":rng.randi_range(0,EYES.size()-1),"finish":"normal"}}
  h["can_jump"]=i==0;h.name=suggest_name(h.traits);horses.append(h);added.append(h)
 return added
func grant_achievement(level:int)->Dictionary:
 var id:String="achievement_%d"%level
 if not known_record(id).is_empty():return {}
 var rng:=RandomNumberGenerator.new();rng.randomize()
 var h:Dictionary={"id":id,"name":"Hallazgo de nivel %d"%level,"parents":[],"traits":{"coat":rng.randi_range(0,19),"pattern":rng.randi_range(0,PATTERNS.size()-1),"mane":rng.randi_range(0,5),"eyes":rng.randi_range(0,EYES.size()-1),"finish":"normal"},"stats":{"speed":rng.randf_range(260,285),"handling":rng.randf_range(900,1300),"power":rng.randf_range(0.6,0.8),"dodge":rng.randf_range(0.85,1.0)}}
 var offer:Dictionary=HorseMarket.offers(level)[rng.randi_range(0,5)]
 h.traits=offer.traits.duplicate(true);h["can_jump"]=level>=3;h.name=suggest_name(h.traits);horses.append(h);return h
func find(id:String)->Dictionary:
 for h in horses:
  if h.id==id:return h
 return {}
func valid_traits(v:Variant)->bool:
 if not v is Dictionary:return false
 for k in ["coat","pattern","mane"]:
  if typeof(v.get(k))!=TYPE_INT:return false
 if v.has("eyes") and (typeof(v.eyes)!=TYPE_INT or v.eyes<0 or v.eyes>=EYES.size()):return false
 return v.coat>=0 and v.coat<20 and v.pattern>=0 and v.pattern<PATTERNS.size() and v.mane>=0 and v.mane<6 and v.get("finish","normal") in ["normal","original","galaxy"]
func preview(a:String,b:String,choices:Dictionary)->Dictionary:
 if a==b or find(a).is_empty() or find(b).is_empty() or not is_adult(a) or not is_adult(b):return {}
 var inherited_finish:String=str(find(b if choices.get("finish",0)==1 else a).traits.get("finish","normal"))
 var t:Dictionary={"finish":"galaxy" if inherited_finish=="galaxy" else "normal"}
 for k in ["coat","pattern","mane","eyes"]:
  var source:String=b if choices.get(k,0)==1 else a
  t[k]=eye_index(find(source).traits) if k=="eyes" else find(source).traits[k]
 return t
func breed(a:String,b:String,choices:Dictionary)->Dictionary:
 var t:=preview(a,b,choices)
 if t.is_empty():return {}
 var child:Dictionary={"id":"child_%d"%next_id,"name":"Cría %d"%next_id,"parents":[a,b],"stage":"foal","traits":t,"stats":HorseStats.inherit(find(a),find(b))}
 child["can_jump"]=HorseJump.capable(find(a)) or HorseJump.capable(find(b));child.name=suggest_name(t);next_id+=1;horses.append(child);return child
func export_state()->Dictionary:
 return {"birth_credits":birth_credits,"bought_offers":bought_offers.duplicate(),"ancestors":ancestors.duplicate(true),"horses":horses.duplicate(true),"selected":selected,"next_id":next_id}
func restore(v:Variant)->bool:
 if not v is Dictionary or not v.get("horses") is Array:return false
 var offers_state:Variant=v.get("bought_offers",[])
 if not offers_state is Array:return false
 for offer in offers_state:
  if not offer is String:return false
 var clean:Array[Dictionary]=[];var ids:Dictionary={};var by_id:Dictionary={}
 var known:Variant=v.get("ancestors",[])
 if not known is Array:return false
 var clean_ancestors:Array[Dictionary]=[]
 for group in [known,v.horses]:
  for h in group:
   if not h is Dictionary or typeof(h.get("id"))!=TYPE_STRING or h.id.is_empty() or ids.has(h.id) or not valid_traits(h.get("traits")):return false
   if not h.get("parents") is Array or h.parents.size() not in [0,2] or typeof(h.get("name"))!=TYPE_STRING:return false
   if h.id=="original" and not h.parents.is_empty():return false
   if h.parents.size()==2 and h.parents[0]==h.parents[1]:return false
   if h.get("stage","adult") not in ["foal","adult"]:return false
   ids[h.id]=true;by_id[h.id]=h
   if group==known:clean_ancestors.append(h.duplicate(true))
   else:clean.append(h.duplicate(true))
 for h in by_id.values():
  for parent in h.parents:
   if typeof(parent)!=TYPE_STRING or not ids.has(parent):return false
 # Validate all dependencies without relying on ownership/list order.
 var resolved:Dictionary={};var progress:bool=true
 while progress:
  progress=false
  for h in by_id.values():
   if resolved.has(h.id):continue
   var ready:bool=true
   for parent in h.parents:
    if not resolved.has(parent):ready=false
   if ready:resolved[h.id]=true;progress=true
 if resolved.size()!=ids.size() or clean.is_empty() or not ids.has("original"):return false
 var adult_id:String=""
 for h in clean:
  if h.get("stage","adult")=="adult":adult_id=h.id;break
 if adult_id.is_empty():return false
 horses=clean;ancestors=clean_ancestors;selected=str(v.get("selected",adult_id))
 if not is_adult(selected):selected=adult_id
 var offers:Variant=v.get("bought_offers",[])
 if not offers is Array:return false
 bought_offers.clear()
 for offer in offers:
  if not offer is String:return false
  bought_offers.append(offer)
 birth_credits=maxi(0,int(v.get("birth_credits",0)))
 next_id=maxi(int(v.get("next_id",1)),1)
 while ids.has("child_%d"%next_id):next_id+=1
 return true

func is_adult(id:String)->bool:
 var h:=find(id)
 return not h.is_empty() and h.get("stage","adult")=="adult"
func mature_trial(id:String)->bool:
 var h:=find(id)
 if h.is_empty():return false
 h["stage"]="adult";return true

## Suggested names do not overwrite saved names, including player-authored names.
func suggest_name(traits:Dictionary)->String:
 var base:String=COATS[int(traits.coat)]+" "+["liso","manchado","moteado","de trasera blanca","de patas claras","con corazones","con estrellas","con triángulos","con rombos","cebra"][int(traits.pattern)]
 var candidate:String=base;var suffix:int=2
 var names:Array=[]
 for h in horses:names.append(str(h.name).to_lower())
 while names.has(candidate.to_lower()):
  candidate=base+" "+str(suffix);suffix+=1
 return candidate
func rename_horse(id:String,value:String)->bool:
 var h:Dictionary=find(id)
 var clean:String=value.strip_edges()
 if h.is_empty() or clean.is_empty() or clean.length()>60:return false
 h.name=clean
 return true

func known_record(id:String)->Dictionary:
 var owned:=find(id)
 if not owned.is_empty():return owned
 for a in ancestors:
  if a.id==id:return a
 return {}
func register_ancestor(record:Dictionary)->bool:
 if not known_record(str(record.get("id",""))).is_empty():return false
 var candidate:=export_state();candidate.ancestors.append(record.duplicate(true))
 return restore(candidate)
