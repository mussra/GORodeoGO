class_name RanchPastures141
extends RefCounted
const PAGE_SIZE:int=12
static func rarity(h:Dictionary)->int:return 4 if h.get("species","")=="unicorn" else HorseMarket.tier(h)
static func horses(collection:HorseCollection,tier:int)->Array[Dictionary]:
 var out:Array[Dictionary]=[]
 for h in collection.horses:
  if tier<0 or rarity(h)==tier:out.append(h)
 return out
static func page(collection:HorseCollection,tier:int,index:int)->Array[Dictionary]:
 var all_:Array[Dictionary]=horses(collection,tier)
 var start:int=clampi(index,0,maxi(0,ceili(float(all_.size())/PAGE_SIZE)-1))*PAGE_SIZE
 var out:Array[Dictionary]=[]
 for i in range(start,mini(start+PAGE_SIZE,all_.size())):out.append(all_[i])
 return out
static func family(collection:HorseCollection,id:String)->Array[Dictionary]:
 var child:Dictionary=collection.find(id)
 if child.is_empty():return []
 var out:Array[Dictionary]=[]
 for parent in child.parents:
  var h:Dictionary=collection.known_record(str(parent))
  if not h.is_empty():out.append(h)
 out.append(child);return out
