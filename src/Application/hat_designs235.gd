class_name HatDesigns235
extends RefCounted
## Permanent wardrobe, independent of current ownership. Stores coat, pattern and pattern color, without retaining the horse.
static func from_horse(horse:Dictionary)->String:
 var t:Dictionary=horse.get("traits",{})
 var finish:int=14 if t.get("finish","")=="galaxy" else 13 if t.get("finish","")=="rainbow" else int(t.get("pattern",0))
 var coat:int=int(t.get("coat",10));var ink:int=int(t.get("spots",-1))
 if t.get("finish","") not in ["galaxy","rainbow"] and finish>=12 and finish<=17:finish+=8
 coat=HorseCollection.swatch239(coat);ink=HorseCollection.swatch239(ink)
 if t.get("coat_style238","")=="rainbow":coat=20
 if t.get("spots_style238","")=="rainbow":ink=20
 if ink<0:ink=0 if int(t.get("pattern",0))>=12 or Color(HorseAppearance.COLORS[HorseCollection.base239(coat)]).get_luminance()>.4 else 1
 if finish in [0,13,14]:ink=0
 return HatAppearance.encode238(coat,finish,ink)
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
