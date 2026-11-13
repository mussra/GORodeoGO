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
   if typeof(note.get("created_at",0)) in [TYPE_INT,TYPE_FLOAT] and float(note.get("created_at",0))>0.:rows[-1]["created_at"]=int(note.created_at)
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

static func list162(notes:Dictionary)->Array[Dictionary]:
 var result:Array[Dictionary]=[]
 for rows in clean(notes).values():
  for note in rows:result.append(note.duplicate(true))
 result.sort_custom(func(a:Dictionary,b:Dictionary):
  if int(a.get("created_at",0))!=int(b.get("created_at",0)):return int(a.get("created_at",0))>int(b.get("created_at",0))
  return str(a.id)<str(b.id))
 return result
static func date162(note:Dictionary)->String:
 var stamp:int=int(note.get("created_at",0))
 if stamp<=0:return "Sin fecha registrada"
 var date:=Time.get_datetime_dict_from_unix_time(stamp)
 return "%02d/%02d/%04d · %02d:%02d UTC"%[date.day,date.month,date.year,date.hour,date.minute]
