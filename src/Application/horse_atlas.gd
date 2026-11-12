class_name HorseAtlas
extends RefCounted
## Browse families first. Only a bounded color slice is built, never the full product.
static func signature(t:Dictionary)->String:
 return "%d/%d/%d/%d/%d/%d/%s/%s"%[int(t.coat),int(t.pattern),int(t.mane),HorseCollection.eye_index(t),HorseCollection.legs_index(t),HorseCollection.spots_index(t),str(t.get("finish","normal")),str(t.get("emblem",{}))]
static func owned(t:Dictionary,horses:Array)->Dictionary:
 var key:=signature(t)
 for horse in horses:
  if signature(horse.traits)==key:return horse
 return {}
static func contrast_ok(t:Dictionary)->bool:
 var spot:int=HorseCollection.spots_index(t)
 if spot<0:return true
 if int(t.pattern)==0:return false
 var a:=Color(HorseAppearance.COLORS[int(t.coat)]);var b:=Color(HorseAppearance.COLORS[spot])
 return Vector3(a.r-b.r,a.g-b.g,a.b-b.b).length()>=.48
static func traits(base:Dictionary,filters:Dictionary)->Dictionary:
 var t:=base.duplicate(true)
 for key in ["spots","eyes","legs"]:
  if filters.has(key):t[key]=filters[key]
 return t
static func variants(base:Dictionary,filters:Dictionary,horses:Array)->Array[Dictionary]:
 var out:Array[Dictionary]=[]
 var colors:Array=[-1]
 if int(base.pattern)>0:
  for i in HorseCollection.COATS.size():colors.append(i)
 for color in colors:
  if filters.has("spots") and color!=int(filters.spots):continue
  var t:=traits(base,filters);t.spots=color
  var found:=owned(t,horses)
  out.append({"horse":found if not found.is_empty() else {"traits":t,"name":HorseCollection.COATS[int(t.coat)],"stage":"adult"},"owned":not found.is_empty()})
 # Keep all owned records in this family, including eye/leg/finish variants.
 var present:Dictionary={}
 for entry in out:
  if entry.owned:present[entry.horse.id]=true
 for h in horses:
  if present.has(h.id):continue
  if int(h.traits.coat)!=int(base.coat) or int(h.traits.pattern)!=int(base.pattern) or int(h.traits.mane)!=int(base.mane):continue
  var matches:bool=true
  for prop in ["spots","eyes","legs"]:
   if filters.has(prop):
    var value:int=HorseCollection.spots_index(h.traits) if prop=="spots" else (HorseCollection.eye_index(h.traits) if prop=="eyes" else HorseCollection.legs_index(h.traits))
    if value!=int(filters[prop]):matches=false
  if matches:out.append({"horse":h,"owned":true})
 out=HorseFilters.apply(out,filters)
 out=owned_first_order(out)
 return out
static func properties()->Array:
 var out:Array=[]
 for key in ["spots","eyes","legs"]:
  var values:Array=[]
  if key!="eyes":values.append({"value":-1,"label":"Original"})
  var names:Array=HorseCollection.EYES if key=="eyes" else HorseCollection.COATS
  for i in names.size():values.append({"value":i,"label":names[i]})
  out.append({"id":key,"label":{"spots":"Color manchas","eyes":"Ojos","legs":"Patas bajas"}[key],"values":values})
 return out

## Filtered Atlas results enumerate actual spot colors, not family representatives.
## Eyes/legs stay bounded to the requested slice, never a full Cartesian product.
static func filtered_entries(filters:Dictionary,horses:Array,owned_first:bool=true)->Array[Dictionary]:
 var out:Array[Dictionary]=[]
 var owned_by_signature:Dictionary={}
 for h in horses:owned_by_signature[signature(h.traits)]=h
 for coat in HorseCollection.COATS.size():
  if filters.has("coat") and coat!=int(filters.coat):continue
  for pattern in HorseCollection.PATTERNS.size():
   if filters.has("pattern") and pattern!=int(filters.pattern):continue
   for mane in HorseCollection.MANES.size():
    if filters.has("mane") and mane!=int(filters.mane):continue
    var base:Dictionary=traits({"coat":coat,"pattern":pattern,"mane":mane},filters)
    for entry in variants(base,filters,[]):
     var key:String=signature(entry.horse.traits)
     if owned_by_signature.has(key):entry={"horse":owned_by_signature[key],"owned":true}
     out.append(entry)
 # Preserve owned variants outside the generated eye/leg/finish slice, but never
 # substitute a family match for exact ownership or add a duplicate signature.
 var seen:Dictionary={}
 for entry in out:
  if entry.owned:seen[str(entry.horse.id)]=true
 for h in horses:
  var key:String=signature(h.traits)
  if seen.has(str(h.id)):continue
  var matches:bool=true
  for prop in ["spots","eyes","legs"]:
   if filters.has(prop):
    var value:int=HorseCollection.spots_index(h.traits) if prop=="spots" else (HorseCollection.eye_index(h.traits) if prop=="eyes" else HorseCollection.legs_index(h.traits))
    if value!=int(filters[prop]):matches=false
  if matches:out.append({"horse":h,"owned":true});seen[str(h.id)]=true
 out=HorseFilters.apply(out,filters)
 if owned_first:out=owned_first_order(out)
 return out

static func owned_first_order(entries:Array[Dictionary])->Array[Dictionary]:
 var out:Array[Dictionary]=[]
 for entry in entries:
  if entry.owned:out.append(entry)
 for entry in entries:
  if not entry.owned:out.append(entry)
 return out
