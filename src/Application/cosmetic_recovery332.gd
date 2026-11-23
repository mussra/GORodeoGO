class_name CosmeticRecovery332
extends RefCounted
## Recover only enumerated appearance fields, never IDs, rewards or genealogy.
## The caller must still run the original strict validators and protect disk writes.
static func traits(raw:Variant,changes:Array,required:Array=['coat','pattern','mane'])->Variant:
 if not raw is Dictionary:return raw
 var out:Dictionary=raw.duplicate(true)
 var bounds:Dictionary={'coat':HorseCollection.COATS.size(),'pattern':HorseCollection.PATTERNS.size(),'mane':HorseCollection.MANES.size(),'eyes':HorseCollection.EYES.size(),'spots':HorseCollection.COATS.size(),'legs':HorseCollection.COATS.size()}
 for key in bounds:
  if not out.has(key):continue # Missing required structure is not cosmetic corruption.
  var low:int=-1 if key in ['spots','legs'] and key not in required else 0
  if not out[key] is int or out[key]<low or out[key]>=bounds[key]:
   out[key]=0;changes.append(key)
 for key in ['coat_style238','spots_style238']:
  if out.has(key) and out[key] not in ['flat','rainbow']:
   out[key]='flat';changes.append(key)
 return out
static func collection(raw:Variant,changes:Array)->Variant:
 if not raw is Dictionary:return raw
 var out:Dictionary=raw.duplicate(true)
 for group in ['horses','ancestors']:
  if not out.get(group,[]) is Array:continue
  for h in out.get(group,[]):
   if h is Dictionary and h.has('traits'):h.traits=traits(h.traits,changes)
 return out
static func policy(raw:Variant,changes:Array)->Variant:
 if not raw is Dictionary:return raw
 var out:Dictionary=raw.duplicate(true)
 if out.has('towns'):out.towns=towns(out.towns,changes)
 if out.get('herds') is Dictionary:
  for rows in out.herds.values():
   if not rows is Array:continue
   for i in rows.size():rows[i]=traits(rows[i],changes,['coat','pattern','mane','eyes','spots'])
 return out
static func towns(raw:Variant,changes:Array)->Variant:
 if not raw is Dictionary:return raw
 var out:Dictionary=raw.duplicate(true)
 if not out.get('towns215') is Dictionary:return out
 for look in out.towns215.values():
  if not look is Dictionary or look.get('version',0) not in [1,2]:continue
  for key in ['coat','spot_index','pattern']:
   if not look.has(key):continue
   var max_:int=HorseCollection.PATTERNS.size() if key=='pattern' else HorseCollection.COATS.size()
   if not look[key] is int or look[key]<0 or look[key]>=max_:
    look[key]=0;changes.append('town/'+key)
  for key in ['base','spot']:
   if look.has(key) and (not look[key] is String or not Color.html_is_valid(look[key])):
    look[key]=HorseAppearance.COLORS[0];changes.append('town/'+key)
 return out
