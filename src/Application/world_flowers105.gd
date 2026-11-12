class_name WorldFlowers105
extends RefCounted
static var cache:Dictionary={}
const IDS:Array[String]=["florist_blue105","florist_gold105"]
const Decor=preload("res://src/Presentation/world_decor.gd")
static func color_for(id:String)->Color:return Color("68cfff") if id==IDS[0] else Color("ffc955")
static func positions(seed:int,version:int,door:Vector2,id:String)->Array[Vector2]:
 var key:String=str([seed,version,door,id])
 if cache.has(key):return cache[key]
 if cache.size()>32:cache.clear()
 # Only uncollected slots move. Existing event IDs/counts stay valid.
 var out:Array[Vector2]=[]
 var offsets:Array=[Vector2(-1100,-800),Vector2(1000,-1100),Vector2(-1800,500)] if id==IDS[0] else [Vector2(1200,900),Vector2(-900,1400),Vector2(2100,-200)]
 var rng:=RandomNumberGenerator.new();rng.seed=hash("quest-flowers139-%d-%d-%s"%[seed,version,id])
 var surface:=WorldRoadSurface94.new(seed,version>=2,false,version>=2,version)
 for offset in offsets:
  var base:Vector2=door+offset+Vector2(rng.randf_range(-100.,100.),rng.randf_range(-100.,100.))
  var selected:Vector2=base
  for attempt in 256:
   var candidate:Vector2=base if attempt==0 else base+Vector2.from_angle((attempt%16)*TAU/16.)*float(1+attempt/16)*20.
   if version>=3 and WorldTerrain103.blocked(seed,candidate,35.):continue
   if surface.contains(candidate,80.):continue
   if not clear_ground(seed,candidate):continue
   selected=candidate;break
  out.append(selected)
 cache[key]=out
 return out
static func clear_ground(seed:int,p:Vector2)->bool:
 # Inspect deterministic obstacles, without deleting trees or migrating terrain.
 var chunk:Vector2i=WorldMap.chunk_at(p)
 for dx in range(-1,2):
  for dy in range(-1,2):
   var data:Dictionary=WorldMap.generate_legacy(seed,chunk.x+dx,chunk.y+dy)
   for d in data.get("decor",[]):
    var box:Rect2=Decor.solid_box(d.kind,d.pos,d.scale)
    if box.has_area() and box.grow(45.).has_point(p):return false
   var pigs:Dictionary=data.get("pigs",{})
   if not pigs.is_empty() and Rect2(pigs.pos-Vector2(190,150),Vector2(380,300)).has_point(p):return false
 return true
static func event_id(id:String,index:int)->String:return id+":"+str(index)
