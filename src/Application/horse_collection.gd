class_name HorseCollection
extends RefCounted
## Isolated trial collection. No economy, functional stats, sex or parent consumption.
const COATS=["Negro","Blanco","Dorado","Azul","Verde","Rojo","Violeta","Turquesa","Rosa","Naranja","Castaño","Gris","Crema","Cobre","Lima","Marino","Lavanda","Coral","Celeste","Ciruela"]
const PATTERNS=["Liso","Parches","Moteado","Trasera blanca","Patas claras"]
const MANES=["Negra","Blanca","Dorada","Azul","Roja","Arcoíris"]
const RARITIES=["Común","Poco frecuente","Raro","Ultra raro","Legendario"]
var horses:Array[Dictionary]=[]
var selected:String="original"
var next_id:int=1
func seed_trial()->void:
 if not horses.is_empty():return
 horses=[{"id":"original","name":"Original","parents":[],"traits":{"coat":10,"pattern":0,"mane":1,"finish":"original"}}]
func add_trial_parents()->void:
 if not find("trial_a").is_empty():return
 horses.append_array([{ "id":"trial_a","name":"Azul de prueba","parents":[],"stats":{"speed":280.0,"handling":900.0,"power":0.6,"dodge":0.85},"traits":{"coat":3,"pattern":1,"mane":2,"finish":"normal"}}, {"id":"trial_b","name":"Arcoíris de prueba","parents":[],"stats":{"speed":260.0,"handling":1250.0,"power":0.8,"dodge":1.0},"traits":{"coat":6,"pattern":0,"mane":5,"finish":"normal"}}])
func grant_achievement(level:int)->Dictionary:
 var id:String="achievement_%d"%level
 if not find(id).is_empty():return {}
 var rng:=RandomNumberGenerator.new();rng.randomize()
 var h:Dictionary={"id":id,"name":"Hallazgo de nivel %d"%level,"parents":[],"traits":{"coat":rng.randi_range(0,19),"pattern":rng.randi_range(0,4),"mane":rng.randi_range(0,5),"finish":"normal"},"stats":{"speed":rng.randf_range(260,285),"handling":rng.randf_range(900,1300),"power":rng.randf_range(0.6,0.8),"dodge":rng.randf_range(0.85,1.0)}}
 horses.append(h);return h
func find(id:String)->Dictionary:
 for h in horses:
  if h.id==id:return h
 return {}
func valid_traits(v:Variant)->bool:
 if not v is Dictionary:return false
 for k in ["coat","pattern","mane"]:
  if typeof(v.get(k))!=TYPE_INT:return false
 return v.coat>=0 and v.coat<20 and v.pattern>=0 and v.pattern<5 and v.mane>=0 and v.mane<6 and v.get("finish","normal") in ["normal","original","galaxy"]
func preview(a:String,b:String,choices:Dictionary)->Dictionary:
 if a==b or find(a).is_empty() or find(b).is_empty():return {}
 var t:Dictionary={"finish":"normal"}
 for k in ["coat","pattern","mane"]:
  var source:String=b if choices.get(k,0)==1 else a
  t[k]=find(source).traits[k]
 return t
func breed(a:String,b:String,choices:Dictionary)->Dictionary:
 var t:=preview(a,b,choices)
 if t.is_empty():return {}
 var child:Dictionary={"id":"child_%d"%next_id,"name":"Cría %d"%next_id,"parents":[a,b],"traits":t,"stats":HorseStats.inherit(find(a),find(b))}
 next_id+=1;horses.append(child);return child
func export_state()->Dictionary:
 return {"horses":horses.duplicate(true),"selected":selected,"next_id":next_id}
func restore(v:Variant)->bool:
 if not v is Dictionary or not v.get("horses") is Array:return false
 var clean:Array[Dictionary]=[];var ids:Dictionary={}
 for h in v.horses:
  if not h is Dictionary or typeof(h.get("id"))!=TYPE_STRING or h.id.is_empty() or ids.has(h.id) or not valid_traits(h.get("traits")):return false
  if not h.get("parents") is Array or h.parents.size() not in [0,2]:return false
  if typeof(h.get("name"))!=TYPE_STRING:return false
  for parent in h.parents:
   if typeof(parent)!=TYPE_STRING or not ids.has(parent):return false
  ids[h.id]=true;clean.append(h.duplicate(true))
 if clean.is_empty() or not ids.has("original"):return false
 horses=clean;selected=str(v.get("selected","original"))
 if not ids.has(selected):selected="original"
 next_id=maxi(int(v.get("next_id",1)),1)
 while ids.has("child_%d"%next_id):next_id+=1
 return true
