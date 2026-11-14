class_name WorldPlaces144
extends RefCounted
## Known sites, not arbitrary discovered terrain. Existing map only, additive state.
static func fresh(seed_:int,generator:int)->Dictionary:return {"version":1,"seed":seed_,"generator":generator,"visited":{},"visit_order217":["home"],"teach217":"","legacy_order217":false}
static func clean(raw:Variant,seed_:int,generator:int)->Dictionary:
 var out:=fresh(seed_,generator)
 if not raw is Dictionary or raw.get("version",0)!=1 or raw.get("seed",0)!=seed_ or raw.get("generator",0)!=generator or not raw.get("visited") is Dictionary:return out
 var order:Variant=raw.get("visit_order217")
 if order is Array:
  out.visit_order217=[]
  for id in order:
   if id in VillageCousins140.IDS and not out.visit_order217.has(id):out.visit_order217.append(id)
  out.teach217=str(raw.get("teach217","")) if raw.get("teach217","") in VillageCousins140.IDS else ""
  out.legacy_order217=raw.get("legacy_order217",false)==true
 elif not raw.visited.is_empty():out.visit_order217=[];out.legacy_order217=true
 for id in raw.visited:
  if id in ["ranch","home","east138","west140","east140"] and typeof(raw.visited[id])==TYPE_BOOL and raw.visited[id]:out.visited[id]=true
 return out
static func sites(seed_:int,generator:int,cousins:Dictionary)->Array[Dictionary]:
 var out:Array[Dictionary]=[{"id":"ranch","name":"Rancho","pos":WorldNominal98.home() if generator>=2 else Vector2(0,160)}]
 if generator>=3 and not cousins.is_empty():
  for id in VillageCousins140.IDS:
   if id=="home":continue # Same home village, no duplicate travel button.
   var point:Vector2=VillageCousins140.point(cousins,id)
   out.append({"id":id,"name":TownIdentity215.title(cousins,id),"pos":Vector2(point.x+130.,470.)})
 return out
static func visit(state:Dictionary,position_:Vector2,candidates:Array,known_cousins:Dictionary={})->bool:
 var changed:bool=false
 for site in candidates:
  # Conversation proves that town was visited; loading its chunk does not.
  if not state.visited.has(site.id) and (position_.distance_to(site.pos)<180. or known_cousins.get(site.id,false)):
   state.visited[site.id]=true;changed=true
   var town_id:String="home" if site.id=="ranch" else str(site.id)
   if town_id in VillageCousins140.IDS and not state.visit_order217.has(town_id):
    state.visit_order217.append(town_id)
    if state.teach217.is_empty() and (state.visit_order217.size()==2 or (state.legacy_order217 and town_id!="home")):state.teach217=town_id
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
