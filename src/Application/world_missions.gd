class_name WorldMissions
extends RefCounted
## Frontera missions (Ant, 7-nov-2026): two real kinds, both end in taming.
## - Encontrada (found): discovering a herd chunk offers its mission.
## - Encargo (assigned): the ranch board assigns one not-yet-done herd at a time.
## States live in SaveData.world_missions: "offered" (found), "encargo", "done".

const ENCARGO_RANGE_CHUNKS:int=4

## Discovering a chunk with a live herd creates a found mission. Returns the id or "".
static func on_chunk_discovered(cx:int,cy:int,chunk:Dictionary)->String:
 if chunk.get("herd",{}).is_empty():return ""
 var id:String=WorldMap.herd_mission_id(cx,cy)
 if SaveData.world_tamed.has(id):return ""
 if not SaveData.world_missions.has(id):
  SaveData.set_world_mission(id,"offered")
 return id

## The ranch board assigns the closest not-done herd mission within range,
## preferring herds the player already found. Returns the encargo herd id or "".
static func assign_encargo(seed:int)->String:
 for id in SaveData.world_missions:
  if SaveData.world_missions[id]=="encargo":return id
 var best:String=""
 var best_d:float=1e9
 for radius in range(1,ENCARGO_RANGE_CHUNKS+1):
  for cx in range(-radius,radius+1):
   for cy in range(-radius,radius+1):
    if maxi(absi(cx),absi(cy))!=radius:continue
    if WorldMap.is_ranch_chunk(cx,cy):continue
    var chunk:Dictionary=WorldMap.generate(seed,cx,cy)
    if chunk.get("herd",{}).is_empty():continue
    var id:String=WorldMap.herd_mission_id(cx,cy)
    if SaveData.world_tamed.has(id) or SaveData.world_missions.get(id,"")=="done":continue
    var herd:Dictionary=chunk.herd
    var d:float=(herd.get("pos",Vector2.ZERO) as Vector2).length()
    if SaveData.world_missions.get(id,"")=="offered":d*=0.5
    if d<best_d:best_d=d;best=id
  if not best.is_empty():break
 if best.is_empty():return ""
 SaveData.set_world_mission(best,"encargo")
 return best

static func current_encargo()->String:
 for id in SaveData.world_missions:
  if SaveData.world_missions[id]=="encargo":return id
 return ""

static func complete(id:String)->void:
 if SaveData.world_missions.has(id):SaveData.set_world_mission(id,"done")

static func counts()->Dictionary:
 var out:Dictionary={"offered":0,"encargo":0,"done":0}
 for id in SaveData.world_missions:
  var s:String=SaveData.world_missions[id]
  if out.has(s):out[s]+=1
 return out

## Chunk coords of a mission herd id ("herd_cx,cy"), for map markers.
static func herd_chunk(id:String)->Vector2i:
 var p:=id.trim_prefix("herd_").split(",")
 return Vector2i(int(p[0]),int(p[1])) if p.size()==2 else Vector2i.ZERO
