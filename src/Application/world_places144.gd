class_name WorldPlaces144
extends RefCounted
## Known sites, not arbitrary discovered terrain. Existing map only, additive state.
static func fresh(seed_:int,generator:int)->Dictionary:return {"version":1,"seed":seed_,"generator":generator,"visited":{}}
static func clean(raw:Variant,seed_:int,generator:int)->Dictionary:
 var out:=fresh(seed_,generator)
 if not raw is Dictionary or raw.get("version",0)!=1 or raw.get("seed",0)!=seed_ or raw.get("generator",0)!=generator or not raw.get("visited") is Dictionary:return out
 for id in raw.visited:
  if id in ["ranch","home","east138","west140","east140"] and typeof(raw.visited[id])==TYPE_BOOL and raw.visited[id]:out.visited[id]=true
 return out
static func sites(seed_:int,generator:int,cousins:Dictionary)->Array[Dictionary]:
 var out:Array[Dictionary]=[{"id":"ranch","name":"Rancho","pos":WorldNominal98.home() if generator>=2 else Vector2(0,160)}]
 if generator>=3 and not cousins.is_empty():
  for id in VillageCousins140.IDS:
   if id=="home":continue # Same home village, no duplicate travel button.
   var point:Vector2=VillageCousins140.point(cousins,id)
   out.append({"id":id,"name":VillageCousins140.LABELS[id],"pos":Vector2(point.x+130.,470.)})
 return out
static func visit(state:Dictionary,position_:Vector2,candidates:Array,known_cousins:Dictionary={})->bool:
 var changed:bool=false
 for site in candidates:
  # Conversation proves that town was visited; loading its chunk does not.
  if not state.visited.has(site.id) and (position_.distance_to(site.pos)<180. or known_cousins.get(site.id,false)):
   state.visited[site.id]=true;changed=true
 return changed
static func available(state:Dictionary,candidates:Array)->Array[Dictionary]:
 var out:Array[Dictionary]=[]
 for site in candidates:
  if state.get("visited",{}).get(site.id,false):out.append(site.duplicate(true))
 return out
static func destination(state:Dictionary,candidates:Array,id:String)->Dictionary:
 for site in available(state,candidates):
  if site.id==id:return site
 return {}
