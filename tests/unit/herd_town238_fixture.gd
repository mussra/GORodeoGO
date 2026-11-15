class_name HerdTown238Fixture
extends RefCounted
const VERSION:=2
static func fresh(seed_:int,towns:Dictionary,_discovered:Array,_roaming:Dictionary,_captured:Array)->Dictionary:
 # Ant approved updating discovered wild herds on 15 November. Captured IDs
 # are protected individually when preparing a herd, never by excluding siblings.
 return {"version":VERSION,"seed":seed_,"towns":towns.duplicate(true),"excluded":{},"herds":{},"revised226":{}}
static func upgraded226(state:Dictionary)->Dictionary:
 var out:=state.duplicate(true)
 if out.get("version",0)==1:
  out.version=VERSION;out.excluded={};out.revised226={}
 return out
static func eligible(state:Dictionary,_cx:int,_cy:int)->bool:
 return state.get("version",0)==VERSION
static func influence(towns:Dictionary,point:Vector2)->Dictionary:
 var rows:Array=[];var total:float=0.;var strength:float=0.
 for id in towns.get("doors",{}):
  if not towns.get("doors",{}).has(id):continue
  var distance:float=(towns.doors[id] as Vector2).distance_to(point)
  var weight:float=clampf((3000.-distance)/2000.,0.,1.)
  if weight<=0.:continue
  rows.append({"id":id,"weight":weight});total+=weight;strength=maxf(strength,weight)
 return {"rows":rows,"total":total,"strength":strength}
static func colored(members_:Array,state:Dictionary,cx:int,cy:int,captured:Array=[])->Array:
 var out:Array=members_.duplicate(true)
 if out.is_empty() or not eligible(state,cx,cy):return out
 var rng:=RandomNumberGenerator.new();rng.seed=hash("herd-town226-v2-%d-%d-%d"%[state.seed,cx,cy])
 var first:Dictionary={};var mutable:Array[int]=[]
 for i in out.size():
  if captured.has(WorldMap.herd_mission_id(cx,cy)) or captured.has(str(out[i].get("member_id",""))):continue
  var point:Vector2=out[i].pos;var family:=influence(state.towns,point)
  if family.total<=0.:continue
  var town:String=TownIdentity215.nearest(state.towns,point)
  var look:=TownIdentity215.look(state.towns,town);var traits:Dictionary=out[i].traits
  if rng.randf()<.70*family.strength:traits.pattern=int(look.pattern)
  var roll:float=rng.randf()
  if roll<.60*family.strength:traits.coat=int(look.coat)
  elif roll<.85*family.strength:
   var nearby:=near_colors(int(look.coat));traits.coat=nearby[rng.randi_range(0,nearby.size()-1)]
  # The visible rule is an invariant for every local wild individual, not a
  # pair of probabilities that may both miss. Keep variety in the other trait.
  if int(traits.coat)!=int(look.coat) and int(traits.pattern)!=int(look.pattern):
   if rng.randf()<.5:traits.coat=int(look.coat)
   else:traits.pattern=int(look.pattern)
  if rng.randf()<.60*family.strength:traits.spots=int(look.get("spot_index",1))
  else:traits.spots=WorldHerd.contrasting_spots(int(traits.coat),rng.randi())
  if int(traits.spots)==int(traits.coat):traits.spots=WorldHerd.contrasting_spots(int(traits.coat),rng.randi())
  mutable.append(i)
  if first.is_empty():first=traits.duplicate(true)
 # Change only a secondary trait in the rare uniform draw. Never remove the
 # sole town trait, nor modify a captured sibling to introduce variation.
 if mutable.size()>=2 and mutable.all(func(i):return int(out[i].traits.coat)==int(first.coat) and int(out[i].traits.pattern)==int(first.pattern) and int(out[i].traits.spots)==int(first.spots)):
  var traits:Dictionary=out[mutable[-1]].traits
  for variant in 20:
   var spot:int=WorldHerd.contrasting_spots(int(traits.coat),variant)
   if spot!=int(traits.spots):traits.spots=spot;break
 return out
static func near_colors(index:int)->Array[int]:
 var base:=Color(HorseAppearance.COLORS[index]);var choices:Array[int]=[]
 for i in 20:
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
 if raw.get("version",0) not in [1,VERSION] or raw.get("seed",0)!=seed_:return false
 if raw.get("version",0)==VERSION and not raw.get("revised226") is Dictionary:return false
 for revision in raw.get("revised226",{}).values():
  if revision!=true:return false
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
 return "Aquí ves "+pattern+". Los caballos salvajes de por aquí llevan el color o el dibujo del pueblo. En cada manada hay variedad en el otro rasgo."

static func dialogue220(places:Dictionary,towns:Dictionary,id:String)->String:
 if places.get("teach217","")==id:return explanation(towns,id)
 if places.get("teach_far220","")==id:return "Si quieres caballos diferentes, aléjate de los pueblos."
 return VillageCousins140.clue(id)
