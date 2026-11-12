class_name WorldGoatPopulation112
extends RefCounted
## Independent V3 additive stream. Never consumes the horse/terrain generator RNG.
const CHANCE:float=.38
const MIN_GROUP:int=2
const MAX_GROUP:int=4
static func members(seed_:int,c:Vector2i,version:int,surface:WorldRoadSurface94=null)->Array:
 if version<3 or c==Vector2i.ZERO:return []
 var rng=RandomNumberGenerator.new();rng.seed=hash("wild-goats-v3-%d-%d-%d"%[seed_,c.x,c.y])
 if rng.randf()>CHANCE:return []
 if surface==null:surface=WorldRoadSurface94.new(seed_,true,false,true,version)
 var center:Vector2=Vector2(c)*WorldMap.CHUNK_SIZE+Vector2(rng.randf_range(160,864),rng.randf_range(160,864))
 var out:Array=[];var count:int=rng.randi_range(MIN_GROUP,MAX_GROUP)
 for i in count:
  for attempt in 20:
   var point:Vector2=center+Vector2.from_angle(rng.randf()*TAU)*rng.randf_range(30,95)
   if WorldTerrain103.blocked(seed_,point,45.):continue
   if surface.contains(point,45.):continue
   out.append({"pos":point,"id":"goat:v3:%d:%d,%d:%d"%[seed_,c.x,c.y,i]});break
 return out
