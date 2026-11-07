class_name WorldMap
extends RefCounted
## Frontera: seeded chunk generation for the bounded open-world test (Ant, 7-nov-2026).
## The ranch anchors chunk (0,0); every other chunk derives from the world seed, so the
## frontier can grow forever while discovered chunks never change once seen.

const CHUNK_SIZE:float=1024.0
const DECOR_KINDS:Array[String]=["tree","tree","pine","pine","fruit_tree","bush","rock","cactus","flower","flower","flower"]
const PIG_CHANCE:float=0.16
const TRAIL_WIDTH:float=46.0
const TRAIL_NODE:float=512.0
const TRAIL_WANDER:float=260.0
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
 if not is_ranch_chunk(cx,cy) and rng.randf()<PIG_CHANCE:
  chunk.pigs={"pos":origin+Vector2(rng.randf_range(200,CHUNK_SIZE-200),rng.randf_range(200,CHUNK_SIZE-200)),"count":rng.randi_range(2,4)}
 if not is_ranch_chunk(cx,cy) and rng.randf()<HERD_CHANCE:
  chunk.herd={"pos":origin+Vector2(rng.randf_range(220,CHUNK_SIZE-220),rng.randf_range(220,CHUNK_SIZE-220)),"traits":{"coat":rng.randi_range(0,HorseCollection.COATS.size()-1),"pattern":rng.randi_range(0,HorseCollection.PATTERNS.size()-1),"mane":rng.randi_range(0,HorseCollection.MANES.size()-1),"eyes":rng.randi_range(0,HorseCollection.EYES.size()-1),"finish":"normal"},"temperament":rng.randf_range(0.0,1.0),"calm":rng.randf_range(0.5,1.5)}
 return chunk

## A herd chunk the player discovers becomes a found mission (Ant: misiones por
## encargo o encontradas). The mission id is the chunk key itself.
static func herd_mission_id(cx:int,cy:int)->String:
 return "herd_"+chunk_key(cx,cy)

## Dirt trails (Ant: caminos, 7-nov-2026). A main trail wanders east-west from the
## ranch and a branch wanders south-north; both come from the world seed, so every
## device draws the same caminos. Purely visual: the rider can always leave them.
static func _trail_node(tag:String,seed:int,i:int)->float:
 if i==0:return 0.0
 var rng:=RandomNumberGenerator.new()
 rng.seed=hash("trail-%s-%d-%d"%[tag,seed,i])
 return rng.randf_range(-TRAIL_WANDER,TRAIL_WANDER)

static func _trail_wander(tag:String,seed:int,t:float)->float:
 var i:=floori(t/TRAIL_NODE)
 var f:=clampf(t/TRAIL_NODE-i,0.0,1.0)
 f=f*f*(3.0-2.0*f)
 return lerpf(_trail_node(tag,seed,i),_trail_node(tag,seed,i+1),f)

static func trail_y_at(seed:int,x:float)->float:
 return _trail_wander("x",seed,x)

static func branch_x_at(seed:int,y:float)->float:
 return _trail_wander("y",seed,y)

static func trail_distance(seed:int,pos:Vector2)->float:
 return minf(absf(pos.y-trail_y_at(seed,pos.x)),absf(pos.x-branch_x_at(seed,pos.y)))

static func on_trail(seed:int,pos:Vector2)->bool:
 return trail_distance(seed,pos)<TRAIL_WIDTH

static func pig_id(cx:int,cy:int)->String:
 return "pig_"+chunk_key(cx,cy)
