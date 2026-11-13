class_name FoalGrowth174
extends RefCounted
## Care is earned only by future successful play, never elapsed clock or old credits.
const TARGET:int=10
static func sessions(h:Dictionary)->int:
 return clampi(int(h.get("growth174",0)),0,TARGET)
static func ready(h:Dictionary)->bool:
 return h.get("stage","adult")=="foal" and sessions(h)>=TARGET
static func advance(c:HorseCollection)->int:
 var count:int=0
 for h in c.horses:
  if h.get("stage","adult")!="foal" or sessions(h)>=TARGET:continue
  h["growth174"]=sessions(h)+1;count+=1
 return count
static func mature(c:HorseCollection,id:String)->bool:
 var h:Dictionary=c.find(id)
 if not ready(h):return false
 h["stage"]="adult";return true
static func valid(value:Variant)->bool:
 return typeof(value)==TYPE_INT and value>=0 and value<=TARGET
static func text(h:Dictionary)->String:
 return "Crianza: %d/%d cuidados. Cada victoria o encargo repetible cobrado cuida a las crías del rancho. No consume puntos ni pasa por esperar."%[sessions(h),TARGET]
