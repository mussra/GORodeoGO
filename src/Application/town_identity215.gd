class_name TownIdentity215
extends RefCounted
const PATTERNS:=[0,6,10]
static func fresh(seed_:int)->Dictionary:
 if SaveData.world_generator_version>=6:
  var all:Dictionary={}
  for id in ids234(seed_):all[id]=look236(seed_,id)
  return all
 var out:Dictionary={};var names:Array=[]
 for i in ids234(seed_).size():
  var id:String=ids234(seed_)[i];var rng:=RandomNumberGenerator.new();rng.seed=hash("town215-v1-%d-%s"%[seed_,id])
  var coat:int=rng.randi_range(0,19);var pattern:int=[6,10,0,6][i%4]
  var base:=Color(HorseAppearance.COLORS[coat]);var spot_index:int=spot_index216(seed_,id,coat);var spot:=Color(HorseAppearance.COLORS[spot_index])
  var color_name:String="Morado" if coat==6 else HorseCollection.COATS[coat]
  var name_:String="Pueblo "+("Estrella " if pattern==6 else "Jirafa " if pattern==10 else "Liso ")+color_name
  var suffix:int=2;var original:String=name_
  while names.has(name_):name_=original+" "+str(suffix);suffix+=1
  names.append(name_)
  out[id]={"version":2,"coat":coat,"spot_index":spot_index,"pattern":pattern,"base":base.to_html(false),"spot":spot.to_html(false),"name":name_}
 return out
static func clean(raw:Variant,seed_:int)->Dictionary:
 if SaveData.world_generator_version>=6:return fresh(seed_)
 var out:=fresh(seed_)
 if not raw is Dictionary:return out
 for id in ids234(seed_):
  var look:Variant=raw.get(id)
  if not look is Dictionary or look.get("version",0) not in [1,2] or look.get("pattern",-1) not in PATTERNS:continue
  if not look.get("base") is String or not Color.html_is_valid(look.base):continue
  if not look.get("spot") is String or not Color.html_is_valid(look.spot):continue
  if not look.get("name") is String or look.name.strip_edges().is_empty():continue
  var coat:int=clampi(int(look.get("coat",0)),0,19)
  var spot_index:int=clampi(int(look.get("spot_index",spot_index216(seed_,id,coat))),0,19)
  out[id]={"version":2,"coat":coat,"spot_index":spot_index,"pattern":look.pattern,"base":look.base,"spot":HorseAppearance.COLORS[spot_index] if look.get("version",1)<2 else look.spot,"name":look.name.left(64)}
 return out
static func look(state:Dictionary,id:String)->Dictionary:
 if SaveData.world_generator_version>=6:return look236(int(state.get("seed",SaveData.world_seed)),id)
 var looks:Dictionary=state.get("towns215",{})
 if looks.has(id):return looks[id]
 return fresh(int(state.get("seed",752026))).get(id,{})
static func title(state:Dictionary,id:String)->String:return str(look(state,id).get("name",VillageCousins140.LABELS.get(id,id)))
static func nearest(state:Dictionary,point:Vector2)->String:
 var choice:String="home";var best:float=INF
 for id in state.get("doors",{}):
  if not state.get("doors",{}).has(id):continue
  var distance:float=(state.doors[id] as Vector2).distance_squared_to(point)
  if distance<best:choice=id;best=distance
 return choice
static func hint(state:Dictionary,from_id:String)->Dictionary:
 var target:=VillageCousins140.next_unknown(state,from_id)
 if target.is_empty():return {}
 var out:=state.duplicate(true);out.hint215=target
 var revealed:Dictionary=out.get("revealed215",{}).duplicate(true);revealed[target]=true;out.revealed215=revealed
 return out
static func known_ids(state:Dictionary)->Array[String]:
 var out:Array[String]=[]
 for id in state.get("doors",{}):
  if state.get("known",{}).get(id,false) or state.get("revealed215",{}).get(id,false):out.append(id)
 return out

static func spot_index216(seed_:int,id:String,base_index:int)->int:
 var rng:=RandomNumberGenerator.new();rng.seed=hash("town216-spots-%d-%s"%[seed_,id])
 var base:=Color(HorseAppearance.COLORS[base_index]);var candidates:Array[int]=[]
 for index in HorseAppearance.COLORS.size():
  var color:=Color(HorseAppearance.COLORS[index])
  if index==base_index:continue
  var distance:float=Vector3(base.r-color.r,base.g-color.g,base.b-color.b).length()
  if distance>=.60:candidates.append(index)
 return candidates[rng.randi_range(0,candidates.size()-1)] if not candidates.is_empty() else (1 if base_index!=1 else 0)

static func ids234(seed_:int)->Array:
 return TownNetwork234.nodes(seed_).keys() if SaveData.world_generator_version>=6 else VillageCousins140.IDS

static var look_cache236:Dictionary={}
static func look236(seed_:int,id:String)->Dictionary:
 var key:String=str(seed_)+id
 if look_cache236.has(key):return look_cache236[key]
 var node:=TownNetwork234.node_for(seed_,id)
 if node.is_empty():return {}
 var rng:=RandomNumberGenerator.new();rng.seed=hash("identity236-%d-%s"%[seed_,id]);var coat:int=rng.randi_range(0,19);var pattern:int=[0,6,9,10][rng.randi_range(0,3)];var spot:int=spot_index216(seed_,id,coat)
 var pattern_name:String={0:"Liso",6:"Estrella",9:"Cebra",10:"Jirafa"}[pattern]
 var sector:String="Inicio" if id=="home" else "%d,%d"%[node.cell.x,node.cell.y]
 var name_:String=pattern_name+" "+HorseCollection.COATS[coat]+" / "+HorseCollection.COATS[spot]+" · "+sector
 var result:Dictionary={"version":2,"coat":coat,"spot_index":spot,"pattern":pattern,"base":HorseAppearance.COLORS[coat],"spot":HorseAppearance.COLORS[spot],"name":name_}
 if look_cache236.size()>512:look_cache236.clear()
 look_cache236[key]=result;return result
