class_name HorseAppearanceGroups118
extends RefCounted
## Presentation grouping only: never merges IDs, stats, training or ancestry.
static func key(h:Dictionary)->String:
 var t:Dictionary=h.traits
 var emblem:Dictionary={}
 if HorseEmblem.valid(t.get("emblem")):
  emblem=t.emblem.duplicate(true);emblem.sort()
 var look:Dictionary=HorseGalaxyLook.state(h)
 return JSON.stringify([int(t.coat),int(t.pattern),int(t.mane),HorseCollection.eye_index(t),t.has("eyes"),HorseCollection.legs_index(t),HorseCollection.spots_index(t),str(t.get("finish","normal")),emblem,str(h.get("stage","adult")),str(h.get("species","horse")),str(h.get("unicorn_variant","")),look.get("percent",0),look.get("master",false)])
static func groups(horses:Array)->Array[Dictionary]:
 var out:Array[Dictionary]=[];var by_key:Dictionary={}
 for h in horses:
  var k:String=key(h)
  if not by_key.has(k):by_key[k]=out.size();out.append({"key":k,"horses":[]})
  out[int(by_key[k])].horses.append(h)
 return out
