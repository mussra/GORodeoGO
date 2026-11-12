class_name WorldNotes106
extends RefCounted
static func clean(raw:Variant)->Dictionary:
 var out:Dictionary={}
 if not raw is Dictionary:return out
 for region in raw:
  if not region is String or not raw[region] is Array:continue
  var rows:Array=[]
  for note in raw[region]:
   if not note is Dictionary or not note.get("id") is String or not note.get("pos") is Vector2 or not note.pos.is_finite() or not note.get("text") is String:continue
   rows.append({"id":note.id,"pos":note.pos,"text":note.text.left(240),"icon":str(note.get("icon","pin")),"horse":str(note.get("horse","")),"photo":str(note.get("photo",""))})
  if not rows.is_empty():out[region]=rows
 return out
static func region_key(pos:Vector2)->String:
 var c:Vector2i=Vector2i((pos/(1024.*16.)).floor())
 return "%d,%d"%[c.x,c.y]
static func nearest(notes:Dictionary,pos:Vector2,radius:float)->Dictionary:
 var best:Dictionary={};var distance:float=radius
 for rows in notes.values():
  for note in rows:
   var d:float=pos.distance_to(note.pos)
   if d<distance:best=note;distance=d
 return best
