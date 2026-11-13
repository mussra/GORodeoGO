class_name SiestaDestinations170
extends RefCounted
## Notes/photos are locations, not a moving animal tracker. Never expose unknown terrain.
static func notes(notes_:Dictionary,known:Callable)->Array[Dictionary]:
 var out:Array[Dictionary]=[]
 for note in WorldNotes106.list162(notes_):
  if not known.call(note.pos):continue
  var title:String=str(note.text).strip_edges().replace("\n"," ").left(48)
  if title.is_empty():title="Captura guardada" if not str(note.photo).is_empty() else "Nota guardada"
  out.append({"id":"note170:"+str(note.id),"name":title,"pos":note.pos,"note170":true})
 return out
