class_name FloristJourney138
extends RefCounted
## Additive V3 expansion. No changes to old generators or inherited quest state.
const VERSION:int=1
const SPECIES:Array[String]=["red","violet"]
static func fresh(discovered:Array)->Dictionary:
 var last:int=0
 for key in discovered:
  var parts:String=str(key)
  var pair:PackedStringArray=parts.split(",")
  if pair.size()!=2 or not pair[0].is_valid_int():continue
  var c:Vector2i=Vector2i(int(pair[0]),0)
  last=maxi(last,c.x)
 return {"version":VERSION,"region":maxi(1,floori(float(last+3)/5.)+1),"quests":{},"fields":{}}
static func clean(raw:Variant)->Dictionary:
 if not raw is Dictionary or raw.get("version",0)!=VERSION:return {}
 if not raw.get("region") is int or raw.region<1 or raw.region>100000:return {}
 if not raw.get("quests",{}) is Dictionary or not raw.get("fields",{}) is Dictionary:return {}
 var out:Dictionary={"version":VERSION,"region":raw.region,"quests":{},"fields":{}}
 for species in SPECIES:
  var q:Variant=raw.get("quests",{}).get(species,{})
  if not q is Dictionary:continue
  if q.get("stage","") not in ["active","sample","done"]:continue
  out.quests[species]={"stage":q.stage,"route":str(q.get("route","")) if q.get("route","") in ["direct","field",""] else ""}
  # A field exists only with its own recorded delivery. Never infer from old quests.
  if q.stage=="done" and raw.get("fields",{}).get(species,false)==true:out.fields[species]=true
 return out
static func stage(state:Dictionary,species:String)->String:return state.get("quests",{}).get(species,{}).get("stage","locked")
static func current(state:Dictionary)->String:
 for species in SPECIES:
  if stage(state,species)!="done":return species
 return ""
static func begin(state:Dictionary,species:String)->bool:
 if species!=current(state) or stage(state,species)!="locked":return false
 state.quests[species]={"stage":"active","route":""};return true
static func sample(state:Dictionary,species:String,route:String)->bool:
 if route not in ["direct","field"] or stage(state,species)!="active":return false
 state.quests[species]={"stage":"sample","route":route};return true
static func deliver(state:Dictionary,species:String)->bool:
 if stage(state,species)!="sample":return false
 state.quests[species].stage="done";state.fields[species]=true;return true
static func title(species:String)->String:return "amapolas" if species=="red" else "violetas"
static func door(state:Dictionary)->Vector2:
 return Vector2(int(state.get("region",1))*5120.+320.,358.)
static func home_door(seed_:int)->Vector2:return ModularWorldLayout93.world(WorldTerrain103.plan(seed_).doors.florist)
static func field_rect(state:Dictionary,species:String,planted:bool=false,seed_:int=0)->Rect2:
 if planted:
  var home:Vector2=home_door(seed_)
  return Rect2(home+Vector2(-720. if species=="red" else -370.,510.),Vector2(280,220))
 return Rect2(Vector2(int(state.get("region",1))*5120.,-1170. if species=="red" else 1150.),Vector2(2048,1024))
static func sample_point(state:Dictionary,species:String)->Vector2:
 return Vector2(int(state.get("region",1))*5120.+465.,-210. if species=="red" else 1210.)
static func descriptors(state:Dictionary,seed_:int)->Array:
 if state.is_empty():return []
 var out:Array=[]
 for species in SPECIES:
  out.append({"id":"wild138:"+species,"species":species,"planted":false,"rect":field_rect(state,species),"seed":hash(str(seed_)+species+"wild138")})
  if state.get("fields",{}).get(species,false):out.append({"id":"grown138:"+species,"species":species,"planted":true,"rect":field_rect(state,species,true,seed_),"seed":hash(str(seed_)+species+"grown138")})
 return out
static func boundary(field:Dictionary)->PackedVector2Array:
 var r:Rect2=field.rect
 if field.planted:return PackedVector2Array([r.position,Vector2(r.end.x,r.position.y),r.end,Vector2(r.position.x,r.end.y)])
 var rng=RandomNumberGenerator.new();rng.seed=field.seed
 var out=PackedVector2Array();var corners:Array=[r.position,Vector2(r.end.x,r.position.y),r.end,Vector2(r.position.x,r.end.y)]
 for edge in 4:
  var a:Vector2=corners[edge];var b:Vector2=corners[(edge+1)%4];var tangent:Vector2=(b-a).normalized();var normal:=Vector2(tangent.y,-tangent.x)
  var n:int=16 if edge%2==0 else 8
  for j in n:out.append(a.lerp(b,float(j)/n)+normal*rng.randf_range(65,135))
 for pass_ in 2:
  var smooth=PackedVector2Array()
  for j in out.size():
   smooth.append(out[j].lerp(out[(j+1)%out.size()],.25));smooth.append(out[j].lerp(out[(j+1)%out.size()],.75))
  out=smooth
 return out
static func hud(state:Dictionary)->String:
 var species:String=current(state)
 if species.is_empty():return "Floristas: entregas terminadas. Tus dos cultivos siguen creciendo junto a la tienda."
 match stage(state,species):
  "active":
   if state.quests[species].get("route","")=="field":return "Desde la florista del Este, sigue el camino al "+("norte" if species=="red" else "sur")+" y recoge una muestra de "+title(species)+"."
   return "Florista: sigue el camino hacia el este hasta el siguiente pueblo. Pide una muestra de "+title(species)+" a su florista o pregúntale dónde encontrarla."
  "sample":return "Tienes la muestra de "+title(species)+". Vuelve a la florista del rancho y entrégala."
 return "Florista: habla con ella para el siguiente encargo entre poblados."

static func lane(state:Dictionary)->PackedVector2Array:
 var d:Vector2=door(state)
 return PackedVector2Array([Vector2(d.x,470),d])
static func on_lane(state:Dictionary,p:Vector2,margin:float=0.)->bool:
 if state.is_empty():return false
 for points in lanes(state):
  for i in points.size()-1:
   if p.distance_to(Geometry2D.get_closest_point_to_segment(p,points[i],points[i+1]))<=18.+margin:return true
 return false

static func lanes(state:Dictionary)->Array:
 var out:Array=[lane(state)]
 for species in SPECIES:
  var point:Vector2=sample_point(state,species)
  out.append(PackedVector2Array([Vector2(point.x,470),point]))
 return out
static func route_from_home(state:Dictionary,seed_:int)->PackedVector2Array:
 var out:=PackedVector2Array()
 var branch:Array=WorldTerrain103.plan(seed_).branches.florist.duplicate();branch.reverse()
 for cell in branch:out.append(ModularWorldLayout93.world(cell))
 out.append(ModularWorldLayout93.world(Vector2i(64,4)))
 for region in range(1,int(state.region)):
  var trunk:Array=WorldTerrain103.trunk(seed_,region)
  for cell in trunk:out.append(ModularWorldLayout93.world(cell))
 out.append(Vector2(door(state).x,470));out.append(door(state))
 return out
