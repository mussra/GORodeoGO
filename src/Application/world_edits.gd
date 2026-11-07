class_name WorldEdits
extends RefCounted
## Frontier world editor data (Ant: "editor de mundo abierto, datos editables",
## 7-nov-2026). Edits are an ordered op list layered over the seeded chunks, so the
## original world never changes and edits travel with the save.
## Ops: {"type":"add_decor","kind":..,"pos":Vector2,"scale":float}
##      {"type":"remove_decor","pos":Vector2,"radius":float}  (drops any decor inside)
##      {"type":"add_pigs","pos":Vector2,"count":int}

const KINDS:Array[String]=["tree","pine","fruit_tree","bush","rock","cactus","flower"]

static func valid_op(op:Variant)->bool:
 if typeof(op)!=TYPE_DICTIONARY:return false
 var d:Dictionary=op
 match d.get("type",""):
  "add_decor":
   return d.get("kind","") in KINDS and d.get("pos") is Vector2 and clampf(float(d.get("scale",1.0)),0.4,2.0)==float(d.get("scale",1.0))
  "remove_decor":
   return d.get("pos") is Vector2 and float(d.get("radius",0.0))>0.0 and float(d.get("radius",0.0))<=400.0
  "add_pigs":
   return d.get("pos") is Vector2 and int(d.get("count",0))>=1 and int(d.get("count",0))<=6
 return false

static func sanitize(op:Dictionary)->Dictionary:
 var out:Dictionary=op.duplicate()
 if out.get("type")=="add_decor":out["scale"]=clampf(float(out.get("scale",1.0)),0.4,2.0)
 if out.get("type")=="add_pigs":out["count"]=clampi(int(out.get("count",2)),1,6)
 if out.get("type")=="remove_decor":out["radius"]=clampf(float(out.get("radius",120.0)),20.0,400.0)
 return out

## Apply the ops touching one chunk onto its generated content (pure function).
static func apply(chunk:Dictionary,edits:Array,cx:int,cy:int)->Dictionary:
 var out:Dictionary=chunk.duplicate(true)
 var origin:Vector2=Vector2(cx,cy)*WorldMap.CHUNK_SIZE
 var limit:Vector2=origin+Vector2.ONE*WorldMap.CHUNK_SIZE
 for e in edits:
  if not valid_op(e):continue
  var op:Dictionary=sanitize(e)
  var pos:Vector2=op.get("pos",Vector2.ZERO)
  match op["type"]:
   "add_decor":
    if pos.x>=origin.x-64 and pos.y>=origin.y-64 and pos.x<limit.x+64 and pos.y<limit.y+64:
     out["decor"].append({"kind":op["kind"],"pos":pos,"scale":float(op.get("scale",1.0)),"edited":true})
   "remove_decor":
    var kept:Array=[]
    for d in out.get("decor",[]):
     if (d["pos"] as Vector2).distance_to(pos)>float(op["radius"]):kept.append(d)
    out["decor"]=kept
   "add_pigs":
    if pos.x>=origin.x and pos.y>=origin.y and pos.x<limit.x and pos.y<limit.y:
     if out.get("pigs",{}).is_empty():out["pigs"]={"pos":pos,"count":int(op["count"]),"edited":true}
 return out

## Pigs placed by the editor need a stable id (same scheme as seeded pens).
static func edited_pen_id(pos:Vector2)->String:
 var c:Vector2i=WorldMap.chunk_at(pos)
 return "pig_%d_%d_edit"%[c.x,c.y]
