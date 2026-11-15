class_name HerdTown217
extends RefCounted
const VERSION:=1
static func fresh(seed_:int,towns:Dictionary,discovered:Array,roaming:Dictionary,captured:Array)->Dictionary:
 var excluded:Dictionary={}
 for key in discovered:excluded[str(key)]=true
 for row in roaming.get("horses",{}).values():excluded[WorldMap.chunk_key(row.origin.x,row.origin.y)]=true
 for id in captured:
  if str(id).begins_with("herd_"):excluded[str(id).trim_prefix("herd_").split("#")[0]]=true
 return {"version":VERSION,"seed":seed_,"towns":towns.duplicate(true),"excluded":excluded,"herds":{}}
static func eligible(state:Dictionary,cx:int,cy:int)->bool:
 return state.get("version",0)==VERSION and not state.get("excluded",{}).has(WorldMap.chunk_key(cx,cy))
static func influence(towns:Dictionary,point:Vector2)->Dictionary:
 var rows:Array=[];var total:float=0.;var strength:float=0.
 for id in VillageCousins140.IDS:
  if not towns.get("doors",{}).has(id):continue
  var distance:float=(towns.doors[id] as Vector2).distance_to(point)
  var weight:float=clampf((3000.-distance)/2000.,0.,1.)
  if weight<=0.:continue
  rows.append({"id":id,"weight":weight});total+=weight;strength=maxf(strength,weight)
 return {"rows":rows,"total":total,"strength":strength}
static func colored(members_:Array,state:Dictionary,cx:int,cy:int)->Array:
 var out:Array=members_.duplicate(true)
 if out.is_empty() or not eligible(state,cx,cy):return out
 var point:Vector2=out[0].pos;var family:=influence(state.towns,point)
 if family.total<=0.:return out
 var rng:=RandomNumberGenerator.new();rng.seed=hash("herd-town217-v1-%d-%d-%d"%[state.seed,cx,cy])
 var first:Dictionary={}
 for i in out.size():
  var pick:float=rng.randf()*family.total;var town:String=family.rows[-1].id
  for row in family.rows:
   pick-=row.weight
   if pick<=0.:town=row.id;break
  var look:=TownIdentity215.look(state.towns,town);var traits:Dictionary=out[i].traits
  if rng.randf()<.70*family.strength:traits.pattern=int(look.pattern)
  var roll:float=rng.randf()
  if roll<.60*family.strength:traits.coat=int(look.coat)
  elif roll<.85*family.strength:
   var nearby:=near_colors(int(look.coat));traits.coat=nearby[rng.randi_range(0,nearby.size()-1)]
  if rng.randf()<.60*family.strength:traits.spots=int(look.get("spot_index",1))
  else:traits.spots=WorldHerd.contrasting_spots(int(traits.coat),rng.randi())
  if int(traits.spots)==int(traits.coat):traits.spots=WorldHerd.contrasting_spots(int(traits.coat),rng.randi())
  if i==0:first=traits.duplicate(true)
 # At least one visible difference, even when the random draws chose one family.
 if out.size()>=3 and out.all(func(h):return int(h.traits.coat)==int(first.coat) and int(h.traits.pattern)==int(first.pattern) and int(h.traits.spots)==int(first.spots)):
  var palette:=near_colors(int(first.coat));out[-1].traits.coat=palette[0]
 return out
static func near_colors(index:int)->Array[int]:
 var base:=Color(HorseAppearance.COLORS[index]);var choices:Array[int]=[]
 for i in HorseAppearance.COLORS.size():
  if i!=index:choices.append(i)
 choices.sort_custom(func(a:int,b:int):return Vector3(Color(HorseAppearance.COLORS[a]).r-base.r,Color(HorseAppearance.COLORS[a]).g-base.g,Color(HorseAppearance.COLORS[a]).b-base.b).length_squared()<Vector3(Color(HorseAppearance.COLORS[b]).r-base.r,Color(HorseAppearance.COLORS[b]).g-base.g,Color(HorseAppearance.COLORS[b]).b-base.b).length_squared())
 return choices.slice(0,3)
static func apply_saved(members_:Array,state:Dictionary,cx:int,cy:int)->Array:
 var key:=WorldMap.chunk_key(cx,cy);var rows:Array=state.get("herds",{}).get(key,[])
 if rows.size()!=members_.size():return members_
 var out:=members_.duplicate(true)
 for i in out.size():out[i].traits=rows[i].duplicate(true)
 return out
static func valid(raw:Dictionary,seed_:int)->bool:
 if raw.get("version",0)!=VERSION or raw.get("seed",0)!=seed_:return false
 if not raw.get("towns") is Dictionary or VillageCousins140.clean(raw.towns,seed_).is_empty():return false
 if not raw.get("excluded") is Dictionary or not raw.get("herds") is Dictionary:return false
 for rows in raw.herds.values():
  if not rows is Array or rows.size()<3 or rows.size()>5:return false
  for traits in rows:
   if not traits is Dictionary:return false
   for key in ["coat","pattern","mane","eyes","spots"]:
    if not traits.get(key) is int:return false
   if traits.coat<0 or traits.coat>=20 or traits.pattern<0 or traits.pattern>=HorseCollection.PATTERNS.size():return false
   if traits.spots<0 or traits.spots>=20 or traits.mane<0 or traits.mane>=HorseCollection.MANES.size():return false
   if traits.eyes<0 or traits.eyes>=HorseCollection.EYES.size():return false
 return true
static func explanation(towns:Dictionary,id:String)->String:
 var look:=TownIdentity215.look(towns,id)
 var base:String=HorseCollection.COATS[int(look.coat)].to_lower()
 var spot:String=HorseCollection.COATS[int(look.get("spot_index",1))].to_lower()
 var plural:Dictionary={"negro":"negras","blanco":"blancas","dorado":"doradas","azul":"azules","verde":"verdes","rojo":"rojas","violeta":"violetas","turquesa":"turquesas","rosa":"rosas","naranja":"naranjas","castaño":"castañas","gris":"grises","crema":"crema","cobre":"cobre","lima":"lima","marino":"marinas","lavanda":"lavanda","coral":"coral","celeste":"celestes","ciruela":"ciruela"}
 var pattern:String="el muro liso "+base if int(look.pattern)==0 else ("las estrellas " if int(look.pattern)==6 else "las manchas de jirafa ")+str(plural.get(spot,spot))+" sobre "+base
 return "Aquí ves "+pattern+". Los caballos salvajes de por aquí suelen parecerse al pueblo, pero en cada manada hay distintos colores y dibujos."

static func dialogue220(places:Dictionary,towns:Dictionary,id:String)->String:
 if places.get("teach217","")==id:return explanation(towns,id)
 if places.get("teach_far220","")==id:return "Si quieres caballos diferentes, aléjate de los pueblos."
 return VillageCousins140.clue(id)
