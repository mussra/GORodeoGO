class_name HorseAtlas
extends RefCounted
## Browse families first. Only a bounded color slice is built, never the full product.
static func signature(t:Dictionary)->String:
 return "%d/%d/%d/%d/%d/%d/%s/%s/%s/%s"%[int(t.coat),int(t.pattern),int(t.mane),HorseCollection.eye_index(t),HorseCollection.legs_index(t),HorseCollection.spots_index(t),str(t.get("finish","normal")),str(t.get("emblem",{})),str(t.get("coat_style238","flat")),str(t.get("spots_style238","flat"))]
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

## Presentation-only normalization of fields the portrait does not display.
## Never deletes, edits or merges owned horse records or breeding genes.
static func visible_key261(h:Dictionary)->String:
 var t:Dictionary=h.traits.duplicate(true)
 var pattern:int=int(t.pattern)
 if pattern in [0,4]:t.spots=-1;t.erase("spots_style238")
 elif t.get("spots_style238","")!="rainbow":
  var color_:Color=HorsePatternMap.color(t) if HorseCollection.spots_index(t)>=0 or pattern>=10 else Color(.96,.93,.85)
  t.spots=-1;t["visible_ink261"]=color_.to_html()
  if color_==Color(HorseAppearance.COLORS[int(t.coat)]) and pattern!=12:
   t.pattern=0;t.erase("visible_ink261");t.erase("spots_style238")
 if int(t.pattern)==0:t.erase("visible_ink261")
 var normalized:Dictionary={"traits":t,"stage":h.get("stage","adult"),"species":h.get("species","horse")}
 var stable:Array=[int(t.coat),int(t.pattern),int(t.mane),t.has("eyes"),HorseCollection.eye_index(t),HorseCollection.legs_index(t),t.get("visible_ink261",""),t.get("coat_style238","flat"),t.get("spots_style238","flat"),t.get("finish","normal"),t.get("emblem",{}),normalized.stage,normalized.species,h.get("unicorn_variant",""),h.get("master251",false)]
 return JSON.stringify(stable)
static func visible_groups261(entries:Array[Dictionary])->Array[Dictionary]:
 var out:Array[Dictionary]=[];var seen:Dictionary={}
 for entry in entries:
  var key:String=visible_key261(entry.horse)
  if not seen.has(key):
   var copy:Dictionary=entry.duplicate(false);copy["combinations261"]=1;copy["members261"]=[entry];out.append(copy);seen[key]=out.size()-1
  else:
   var group:Dictionary=out[int(seen[key])];group.combinations261+=1;group.members261.append(entry)
   if entry.owned and not group.owned:group.horse=entry.horse;group.owned=true
 return out

static func family_groups261(entries:Array[Dictionary])->Array[Dictionary]:
 var out:Array[Dictionary]=[];var seen:Dictionary={}
 for entry in entries:
  var t:Dictionary=entry.horse.traits
  var key:String=JSON.stringify([t.coat,t.pattern,t.mane,entry.horse.get("species","horse"),entry.horse.get("unicorn_variant","")])
  if not seen.has(key):
   var copy:Dictionary=entry.duplicate(false);copy["variants261"]=int(entry.get("combinations261",1));copy["family261"]=true;copy["family_members261"]=[entry];out.append(copy);seen[key]=out.size()-1
  else:
   var group:Dictionary=out[int(seen[key])];group.variants261+=int(entry.get("combinations261",1));group.family_members261.append(entry)
   if entry.owned and not group.owned:group.horse=entry.horse;group.owned=true
 for group in out:
  var members:Array[Dictionary]=[];members.assign(group.family_members261);group.variants261=visible_groups261(members).size()
 return out
