class_name TownRoutes249
extends RefCounted
## Source office and destination stay separate; persisted coordinates are not identity.
static func position_for(state:Dictionary,id:String)->Vector2:
 if SaveData.world_generator_version>=6:
  var node:=TownNetwork234.node_for(int(state.get("seed",SaveData.world_seed)),id)
  if not node.is_empty():return node.door
 return VillageCousins140.point(state,id)
static func clean(raw:Variant,seed_:int)->Dictionary:
 var out:Dictionary={}
 if not raw is Dictionary:return out
 for id in raw:
  var row:Variant=raw[id]
  if not row is Dictionary:continue
  var town:String=str(row.get("town",""));var role:String=str(row.get("role",""));var target:String=str(row.get("target",""))
  var node:=TownNetwork234.node_for(seed_,town);var dest:=TownNetwork234.node_for(seed_,target)
  if node.is_empty() or dest.is_empty() or role not in node.roles or role not in dest.roles or town==target:continue
  out[TownJobs249.key(town,role)]={"town":town,"role":role,"target":target}
 return out
static func destinations(state:Dictionary)->Dictionary:
 var result:Dictionary={};var seed_:int=int(state.get("seed",SaveData.world_seed))
 var routes:=clean(state.get("routes249",{}),seed_)
 # Recover only exact direct recommendations recorded by the old version.
 for heard in state.get("heard247",{}):
  if routes.has(heard) or state.heard247[heard]!="direct":continue
  var parts:=str(heard).split("|")
  if parts.size()!=2:continue
  var node:=TownNetwork234.node_for(seed_,parts[0]);var target:String=node.get("targets",{}).get(parts[1],"")
  if target.is_empty() or not state.get("revealed215",{}).has(target):continue
  routes[heard]={"town":parts[0],"role":parts[1],"target":target}
 for row in routes.values():
  var label_:String=TownNetwork234.NAMES[row.role]+" de "+TownIdentity215.display_name248(state,row.town)
  if not result.has(row.target):result[row.target]=[]
  if label_ not in result[row.target]:result[row.target].append(label_)
 return result
static func source_label(state:Dictionary,id:String)->String:
 var rows:Array=destinations(state).get(id,[])
 return " / ".join(rows)
