class_name WorldHerdPositions139
extends RefCounted
## Sparse persistent overrides. Stable origin IDs, indexed by CURRENT chunk.
var state:Dictionary={}
var chunks:Dictionary={}
static func clean(raw:Variant,seed_:int)->Dictionary:
 var out:Dictionary={"version":1,"seed":seed_,"horses":{}}
 if not raw is Dictionary or raw.get("version",0)!=1 or raw.get("seed",0)!=seed_ or not raw.get("horses") is Dictionary:return out
 for id in raw.horses:
  var row:Variant=raw.horses[id]
  if not id is String or not row is Dictionary:continue
  if not row.get("origin") is Vector2i or not row.get("index") is int or row.index<0 or row.index>4:continue
  if id!=WorldHerd.member_id(row.origin.x,row.origin.y,row.index):continue
  if not row.get("pos") is Vector2 or not row.pos.is_finite() or row.pos.abs().x>100000000. or row.pos.abs().y>100000000.:continue
  out.horses[id]={"origin":row.origin,"index":row.index,"pos":row.pos}
 return out
func setup(raw:Variant,seed_:int):
 state=clean(raw,seed_);chunks.clear()
 for id in state.horses:_add(id,state.horses[id].pos)
func _add(id:String,pos:Vector2):
 var c:=WorldMap.chunk_at(pos)
 if not chunks.has(c):chunks[c]={}
 chunks[c][id]=true
func erase(id:String):
 if not state.horses.has(id):return
 var c:=WorldMap.chunk_at(state.horses[id].pos)
 if chunks.has(c):
  chunks[c].erase(id)
  if chunks[c].is_empty():chunks.erase(c)
 state.horses.erase(id)
func put(id:String,origin:Vector2i,index:int,pos:Vector2):
 if not pos.is_finite():return
 if state.horses.has(id):
  if state.horses[id].pos==pos:return
  var old:=WorldMap.chunk_at(state.horses[id].pos)
  if old!=WorldMap.chunk_at(pos) and chunks.has(old):
   chunks[old].erase(id)
   if chunks[old].is_empty():chunks.erase(old)
 state.horses[id]={"origin":origin,"index":index,"pos":pos};_add(id,pos)
func in_chunk(c:Vector2i)->Array:return chunks.get(c,{}).keys()
static func live_key(origin:Vector2i,index:int)->String:return WorldMap.chunk_key(origin.x,origin.y)+"#"+str(index)
