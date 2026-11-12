class_name WorldFlowers105
extends RefCounted
static var cache:Dictionary={}
const IDS:Array[String]=["florist_blue105","florist_gold105"]
static func color_for(id:String)->Color:return Color("68cfff") if id==IDS[0] else Color("ffc955")
static func positions(seed:int,version:int,door:Vector2,id:String)->Array[Vector2]:
 var key:String=str([seed,version,door,id])
 if cache.has(key):return cache[key]
 if cache.size()>32:cache.clear()
 var out:Array[Vector2]=[];var offset:int=1 if id==IDS[0] else 4
 for i in 3:
  var p:Vector2=Vector2(door.x+(i+offset)*80.,500.) if version>=2 else door+Vector2(220+(i+offset)*90.,200.)
  if version>=3:p=WorldTerrain103.clear_spawn(seed,p)
  out.append(p)
 cache[key]=out
 return out
static func event_id(id:String,index:int)->String:return id+":"+str(index)
