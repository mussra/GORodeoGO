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
 var colors:Array=[-1] if int(base.pattern)==0 else []
 if int(base.pattern)>0:
  colors.append(-1)
  for i in HorseCollection.COATS.size():
   var a:=Color(HorseAppearance.COLORS[int(base.coat)]);var b:=Color(HorseAppearance.COLORS[i])
   if Vector3(a.r-b.r,a.g-b.g,a.b-b.b).length()>=.48:colors.append(i)
 for color in colors:
  if filters.has("spots") and color!=int(filters.spots):continue
  var t:=traits(base,filters);t.spots=color
  var found:=owned(t,horses)
  out.append({"horse":found if not found.is_empty() else {"traits":t,"name":HorseCollection.COATS[int(t.coat)],"stage":"adult"},"owned":not found.is_empty()})
 out.sort_custom(func(a,b):return a.owned and not b.owned)
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
