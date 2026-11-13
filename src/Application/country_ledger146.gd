class_name CountryLedger146
extends RefCounted
## Pure transition plans. Not wired to SaveData or production entry yet.
## The existing frontier stays the authority for its own chunks/notes/quests.
const VERSION:int=2
static func fresh(seed_:int,generator:int)->Dictionary:
 return {"version":VERSION,"origin_seed":seed_,"origin_generator":generator,"active":"frontier","maps":{},"links":{}}
# Stored positions are rider centers, not teleport destinations. Actual feet can
# legally stand closer than the conservative 18px travel margin. Reload still
# validates the real shared player shape against physics before activation.
static func valid(raw:Variant,seed_:int,generator:int)->bool:
 if seed_<=0 or generator not in [1,2,3]:return false
 if not raw is Dictionary or raw.get("version",0) not in [1,VERSION] or raw.get("origin_seed",0)!=seed_ or raw.get("origin_generator",0)!=generator:return false
 if not raw.get("maps") is Dictionary or not raw.get("links") is Dictionary or raw.get("active","") not in ["frontier",CountryRoute146.ID]:return false
 for id in raw.maps:
  if id!=CountryRoute146.ID or not raw.maps[id] is Dictionary:return false
  var map_:Dictionary=raw.maps[id]
  if map_.get("generator",0)!=1 or typeof(map_.get("seed"))!=TYPE_INT or map_.seed<=0 or typeof(map_.get("position"))!=TYPE_VECTOR2 or not map_.position.is_finite():return false
  if not map_.get("visited") is Dictionary or not map_.get("notes") is Dictionary:return false
  if raw.version>=2:
   if not map_.get("explored") is Dictionary or map_.explored.size()>700:return false
   for cell in map_.explored:
    if typeof(cell)!=TYPE_VECTOR2I or typeof(map_.explored[cell])!=TYPE_BOOL or not map_.explored[cell]:return false
    if cell.x<0 or cell.y<0 or cell.x>24 or cell.y>27:return false
  var data:=CountryRoute146.plan(map_.seed)
  if CountryRoute146.blocked(data,map_.position,0.):return false
  for place in map_.visited:
   if place not in ["entry","tree","source"] or typeof(map_.visited[place])!=TYPE_BOOL:return false
  if not raw.links.has(id):return false
 for id in raw.links:
  if id!=CountryRoute146.ID or not raw.links[id] is Dictionary or not raw.maps.has(id):return false
  var link:Dictionary=raw.links[id]
  if link.get("from","")!="frontier" or link.get("portal","")!="rainbow146" or typeof(link.get("position"))!=TYPE_VECTOR2 or not link.position.is_finite():return false
 if raw.active!= "frontier" and not raw.maps.has(raw.active):return false
 return true
static func enter(state:Dictionary,origin:Vector2,new_seed:int)->Dictionary:
 if not valid(state,int(state.get("origin_seed",0)),int(state.get("origin_generator",0))) or state.active!="frontier" or not origin.is_finite() or new_seed<=0:return {}
 var next:=upgrade(state);var id:=CountryRoute146.ID
 if not next.maps.has(id):
  var data:=CountryRoute146.plan(new_seed)
  next.maps[id]={"seed":new_seed,"generator":1,"position":data.entry,"visited":{"entry":true},"notes":{},"explored":{}}
 next.links[id]={"from":"frontier","portal":"rainbow146","position":origin};next.active=id
 return next
static func record_position(state:Dictionary,position_:Vector2)->Dictionary:
 if not valid(state,int(state.get("origin_seed",0)),int(state.get("origin_generator",0))):return {}
 if state.get("active","")=="frontier" or not state.get("maps",{}).has(state.active):return {}
 var next:=upgrade(state);var map_:Dictionary=next.maps[next.active];var data:=CountryRoute146.plan(map_.seed)
 if not position_.is_finite() or CountryRoute146.blocked(data,position_,0.):return {}
 map_.position=position_;CountryExploration148.reveal(map_.explored,position_)
 for site in data.sites:
  if position_.distance_to(data.sites[site])<180.:map_.visited[site]=true
 return next
static func home(state:Dictionary)->Dictionary:
 if not valid(state,int(state.get("origin_seed",0)),int(state.get("origin_generator",0))):return {}
 if state.get("active","")=="frontier":return {"map":"frontier","kind":"ranch"}
 if not state.get("maps",{}).has(state.active):return {}
 return {"map":state.active,"kind":"entry","position":CountryRoute146.plan(state.maps[state.active].seed).entry}
static func leave(state:Dictionary,position_:Vector2)->Dictionary:
 var next:=record_position(state,position_)
 if next.is_empty():return {}
 var target:Dictionary=next.links[next.active].duplicate(true);next.active="frontier"
 return {"state":next,"arrival":target.position,"map":"frontier"}

static func upgrade(state:Dictionary)->Dictionary:
 if not valid(state,int(state.get("origin_seed",0)),int(state.get("origin_generator",0))):return {}
 var next:=state.duplicate(true)
 if next.version==1:
  next.version=VERSION
  for map_ in next.maps.values():
   map_.explored={};CountryExploration148.reveal(map_.explored,map_.position)
 return next
static func record_exploration(state:Dictionary,position_:Vector2,cells:Dictionary)->Dictionary:
 var next:=record_position(state,position_)
 if next.is_empty():return {}
 next.maps[next.active].explored=cells.duplicate(true);CountryExploration148.reveal(next.maps[next.active].explored,position_)
 return next if valid(next,next.origin_seed,next.origin_generator) else {}
