class_name UnicornRitual175
extends RefCounted
## Read-only preparation. No conversion effect is installed before final art review.
const RULE:int=1
const SOURCE_RADIUS:float=120.
const ORDER:Array[String]=["blue","pink","green","red","black"]
const PALETTE:Dictionary={"blue":Color("477ce7"),"pink":Color("e98bc3"),"green":Color("50ad79"),"red":Color("cd4a59"),"black":Color("151827")}
static func ancestry(c:HorseCollection,id:String)->Dictionary:
 var by_id:Dictionary={}
 for h in HorseGenealogy.records(c):
  if by_id.has(h.id):return {}
  by_id[h.id]=h
 if not by_id.has(id):return {}
 var distances:Dictionary={id:0};var pending:Array[String]=[id];var cursor:int=0
 while cursor<pending.size():
  var current:String=pending[cursor];cursor+=1
  var h:Dictionary=by_id[current]
  if not c.valid_traits(h.get("traits")):return {}
  var parents:Variant=h.get("parents")
  if not parents is Array or parents.size() not in [0,2]:return {}
  if parents.size()==2 and parents[0]==parents[1]:return {}
  for parent in parents:
   if not parent is String or not by_id.has(parent) or parent==id:return {}
   if not distances.has(parent):distances[parent]=int(distances[current])+1;pending.append(parent)
 # Reject cycles anywhere in the reachable pedigree, without recursive depth limits.
 var resolved:Dictionary={};var changed:bool=true
 while changed:
  changed=false
  for current in pending:
   if resolved.has(current):continue
   var ready:bool=true
   for parent in by_id[current].parents:
    if not resolved.has(parent):ready=false;break
   if ready:resolved[current]=true;changed=true
 if resolved.size()!=pending.size():return {}
 var entries:Array[Dictionary]=[]
 for current in pending:
  if current==id:continue
  entries.append({"id":current,"distance":int(distances[current]),"weight":pow(.5,int(distances[current])),"traits":by_id[current].traits.duplicate(true)})
 entries.sort_custom(func(a,b):return a.id<b.id)
 return {"rule":RULE,"entries":entries}
static func nearest(color:Color)->String:
 var best:String=ORDER[0];var distance:float=INF
 for key in ORDER:
  var target:Color=PALETTE[key];var d:float=pow(color.r-target.r,2)+pow(color.g-target.g,2)+pow(color.b-target.b,2)
  if d<distance:distance=d;best=key
 return best
static func variant(c:HorseCollection,id:String)->Dictionary:
 var graph:=ancestry(c,id)
 if graph.is_empty() or graph.entries.is_empty():return {}
 var scores:Dictionary={}
 for key in ORDER:scores[key]=0.
 for entry in graph.entries:
  var t:Dictionary=entry.traits
  var coat:Color=Color(HorseAppearance.COLORS[int(t.coat)])
  scores[nearest(coat)]+=float(entry.weight)/3.
  # Rainbow is a spectrum, not the red colour at the capped mane index.
  for sample in 12:
   var fraction:float=(float(sample)+.5)/12.
   var mane:Color=HorseAppearance.rainbow_color113(fraction) if int(t.mane)==5 else Color(HorseAppearance.MANES[int(t.mane)])
   var eye:Color=HorseAppearance.eye_color_at(HorseCollection.eye_index(t),Vector2(fraction,fposmod(fraction*.618+.17,1.)))
   scores[nearest(mane)]+=float(entry.weight)/36.
   scores[nearest(eye)]+=float(entry.weight)/36.
 var winner:String=ORDER[0]
 for key in ORDER:
  if float(scores[key])>float(scores[winner])+0.00000001:winner=key
 return {"rule":RULE,"variant":winner,"scores":scores,"ancestors":graph.entries}
static func prepare(c:HorseCollection,id:String,country_id:String,position:Vector2,data:Dictionary)->Dictionary:
 var h:Dictionary=c.find(id);var reasons:Array[String]=[]
 if h.is_empty():return {"eligible":false,"missing":["Caballo no disponible"]}
 if c.selected!=id:reasons.append("Monta este caballo")
 if h.get("species","")=="unicorn":reasons.append("Ya se transformó")
 if not c.is_adult(id):reasons.append("Necesita ser adulto")
 if not GalaxyPure143.is_pure(h):reasons.append("Necesita ser Galaxy puro de nacimiento")
 if not HorseMastery.galaxy_master(h):reasons.append("Necesita completar una campaña con esta montura")
 var source:Vector2=data.get("sites",{}).get("source",Vector2(INF,INF))
 if country_id!=CountryRoute146.ID or not source.is_finite() or not position.is_finite() or position.distance_to(source)>SOURCE_RADIUS:reasons.append("Acércate a la fuente")
 elif not data.has("island") or CountryRoute146.blocked(data,position):reasons.append("Acércate por la orilla transitable")
 var result:=variant(c,id)
 if result.is_empty():reasons.append("Genealogía incompleta")
 return {"eligible":reasons.is_empty(),"missing":reasons,"ancestry":result,"visual_ready":false,"effect_enabled":false}
