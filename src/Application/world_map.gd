class_name WorldMap
extends RefCounted
## Frontera: seeded chunk generation for the bounded open-world test (Ant, 7-nov-2026).
## The ranch anchors chunk (0,0); every other chunk derives from the world seed, so the
## frontier can grow forever while discovered chunks never change once seen.

const CHUNK_SIZE:float=1024.0
const DECOR_KINDS:Array[String]=["tree","rock","bush","cactus"]
const HERD_CHANCE:float=0.22
const RANCH_CLEAR_RADIUS:float=340.0

static func chunk_key(cx:int,cy:int)->String:
 return "%d,%d"%[cx,cy]

static func chunk_at(pos:Vector2)->Vector2i:
 return Vector2i(floori(pos.x/CHUNK_SIZE),floori(pos.y/CHUNK_SIZE))

static func is_ranch_chunk(cx:int,cy:int)->bool:
 return cx==0 and cy==0

## Deterministic content for one chunk: decoration plus an optional wild-horse herd.
static func generate(seed:int,cx:int,cy:int)->Dictionary:
 var rng:=RandomNumberGenerator.new()
 rng.seed=hash("rancho-frontera-%d-%d-%d"%[seed,cx,cy])
 var origin:=Vector2(cx,cy)*CHUNK_SIZE
 var chunk:Dictionary={"decor":[],"herd":{}}
 var decor_count:int=5 if is_ranch_chunk(cx,cy) else rng.randi_range(6,14)
 for i in decor_count:
  var pos:=origin+Vector2(rng.randf_range(48,CHUNK_SIZE-48),rng.randf_range(48,CHUNK_SIZE-48))
  if is_ranch_chunk(cx,cy) and pos.length()<RANCH_CLEAR_RADIUS:continue
  chunk.decor.append({"kind":DECOR_KINDS[rng.randi_range(0,DECOR_KINDS.size()-1)],"pos":pos,"scale":rng.randf_range(0.7,1.4)})
 if not is_ranch_chunk(cx,cy) and rng.randf()<HERD_CHANCE:
  chunk.herd={"pos":origin+Vector2(rng.randf_range(220,CHUNK_SIZE-220),rng.randf_range(220,CHUNK_SIZE-220)),"traits":{"coat":rng.randi_range(0,HorseCollection.COATS.size()-1),"pattern":rng.randi_range(0,HorseCollection.PATTERNS.size()-1),"mane":rng.randi_range(0,HorseCollection.MANES.size()-1),"eyes":rng.randi_range(0,HorseCollection.EYES.size()-1),"finish":"normal"},"temperament":rng.randf_range(0.0,1.0),"calm":rng.randf_range(0.5,1.5)}
 return chunk

## A herd chunk the player discovers becomes a found mission (Ant: misiones por
## encargo o encontradas). The mission id is the chunk key itself.
static func herd_mission_id(cx:int,cy:int)->String:
 return "herd_"+chunk_key(cx,cy)
