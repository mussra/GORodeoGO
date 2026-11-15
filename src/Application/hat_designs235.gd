class_name HatDesigns235
extends RefCounted
## Permanent wardrobe, independent of current ownership. Stores coat, pattern and pattern color, without retaining the horse.
static func from_horse(horse:Dictionary)->String:
 var t:Dictionary=horse.get("traits",{})
 var finish:int=14 if t.get("finish","")=="galaxy" else 13 if t.get("finish","")=="rainbow" else int(t.get("pattern",0))
 var coat:int=int(t.get("coat",10));var ink:int=int(t.get("spots",-1))
 if ink<0:ink=0 if Color(HorseAppearance.COLORS[coat]).get_luminance()>.4 else 1
 if finish in [0,13,14]:ink=0
 return HatAppearance.encode235(coat,finish,ink)
static func clean(raw:Variant)->Dictionary:
 var out:Dictionary={}
 if raw is Dictionary:
  for key in raw:
   if key is String and key.begins_with("hat:") and HatAppearance.sanitize(key)==key and raw[key]==true:out[key]=true
 return out
static func collect(known:Dictionary,collection:HorseCollection)->Dictionary:
 var out:=clean(known)
 for horse in collection.horses:out[from_horse(horse)]=true
 return out
