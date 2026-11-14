class_name TownIdentity215
extends RefCounted
const PATTERNS:=[0,6,10]
static func fresh(seed_:int)->Dictionary:
 var out:Dictionary={};var names:Array=[]
 for i in VillageCousins140.IDS.size():
  var id:String=VillageCousins140.IDS[i];var rng:=RandomNumberGenerator.new();rng.seed=hash("town215-v1-%d-%s"%[seed_,id])
  var coat:int=rng.randi_range(0,19);var pattern:int=[6,10,0,6][i]
  var base:=Color(HorseAppearance.COLORS[coat]);var spot:Color=Color("fff2cf") if base.get_luminance()<.45 else Color("30283f")
  var color_name:String="Morado" if coat==6 else HorseCollection.COATS[coat]
  var name_:String="Pueblo "+("Estrella " if pattern==6 else "Jirafa " if pattern==10 else "Liso ")+color_name
  var suffix:int=2;var original:String=name_
  while names.has(name_):name_=original+" "+str(suffix);suffix+=1
  names.append(name_)
  out[id]={"version":1,"coat":coat,"pattern":pattern,"base":base.to_html(false),"spot":spot.to_html(false),"name":name_}
 return out
static func clean(raw:Variant,seed_:int)->Dictionary:
 var out:=fresh(seed_)
 if not raw is Dictionary:return out
 for id in VillageCousins140.IDS:
  var look:Variant=raw.get(id)
  if not look is Dictionary or look.get("version",0)!=1 or look.get("pattern",-1) not in PATTERNS:continue
  if not look.get("base") is String or not Color.html_is_valid(look.base):continue
  if not look.get("spot") is String or not Color.html_is_valid(look.spot):continue
  if not look.get("name") is String or look.name.strip_edges().is_empty():continue
  out[id]={"version":1,"coat":clampi(int(look.get("coat",0)),0,19),"pattern":look.pattern,"base":look.base,"spot":look.spot,"name":look.name.left(64)}
 return out
static func look(state:Dictionary,id:String)->Dictionary:
 var looks:Dictionary=state.get("towns215",{})
 if looks.has(id):return looks[id]
 return fresh(int(state.get("seed",752026))).get(id,{})
static func title(state:Dictionary,id:String)->String:return str(look(state,id).get("name",VillageCousins140.LABELS.get(id,id)))
static func nearest(state:Dictionary,point:Vector2)->String:
 var choice:String="home";var best:float=INF
 for id in VillageCousins140.IDS:
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
 for id in VillageCousins140.IDS:
  if state.get("known",{}).get(id,false) or state.get("revealed215",{}).get(id,false):out.append(id)
 return out
