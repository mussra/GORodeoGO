class_name WorldTerrain103
extends RefCounted
## V3 data-only descriptors. Frozen V1/V2 remain untouched.
const CELL:float=80.
const ORIGIN:Vector2=Vector2(80,150)
const REGION_CELLS:int=64
const RIDGE_BAND:float=2560.
static var ridge_cache106:Dictionary={}
static func plan(seed:int)->Dictionary:
 var rng=RandomNumberGenerator.new();rng.seed=hash("terrain103-core-%d"%seed)
 var west:int=rng.randi_range(2,4);var east:int=rng.randi_range(8,10);var florist:int=rng.randi_range(13,15);var ranch:int=rng.randi_range(6,7)
 var doors={"ranch":Vector2i(ranch,0),"house_west":Vector2i(west,2),"house_east":Vector2i(east,2),"florist":Vector2i(florist,1)}
 var graph={};ModularWorldLayout93._path(graph,[Vector2i(0,4),Vector2i(19,4)])
 var branches={}
 for id in doors:
  var cell:Vector2i=doors[id]
  var join:int=cell.x
  if id!="ranch":join+=-1 if rng.randi_range(0,1)==0 else 1
  var corners=[Vector2i(join,4),Vector2i(join,3),Vector2i(cell.x,3),cell] if id!="ranch" else [Vector2i(join,4),cell]
  branches[id]=corners;ModularWorldLayout93._path(graph,corners)
 return {"graph":graph,"doors":doors,"branches":branches}
static func trunk(seed:int,region:int)->Array:
 var start:int=region*REGION_CELLS
 if region==0:return [Vector2i(start,4),Vector2i(start+REGION_CELLS,4)]
 var rng=RandomNumberGenerator.new();rng.seed=hash("terrain103-road-%d-%d"%[seed,region])
 var row:int=4+rng.randi_range(-3,3)
 return [Vector2i(start,4),Vector2i(start+8,4),Vector2i(start+8,row),Vector2i(start+24,row),Vector2i(start+24,4),Vector2i(start+REGION_CELLS,4)]
static func graph_for_chunk(seed:int,c:Vector2i)->Dictionary:
 var graph:Dictionary={}
 var bounds:Rect2=Rect2(Vector2(c)*1024.,Vector2.ONE*1024.).grow(160.)
 var first:int=floori((bounds.position.x-ORIGIN.x)/(REGION_CELLS*CELL))
 var last:int=floori((bounds.end.x-ORIGIN.x)/(REGION_CELLS*CELL))
 var all:Dictionary={}
 for region in range(first-1,last+2):ModularWorldLayout93._path(all,trunk(seed,region))
 if bounds.intersects(Rect2(0,0,1700,700)):
  var core:Dictionary=plan(seed).graph
  for cell in core:
   if not all.has(cell):all[cell]=[]
   for next in core[cell]:
    if not all[cell].has(next):all[cell].append(next)
 for cell in all:
  if bounds.has_point(ModularWorldLayout93.world(cell)):graph[cell]=all[cell]
 return graph
static func ridge(seed:int,region:int,band:int=0)->Dictionary:
 var key:String=str([seed,region,band])
 if ridge_cache106.has(key):return ridge_cache106[key]
 if ridge_cache106.size()>512:ridge_cache106.clear()
 var rng=RandomNumberGenerator.new();rng.seed=hash("terrain103-ridge-%d-%d-%d"%[seed,region,band])
 var column:int=region*REGION_CELLS+(20 if region==0 else rng.randi_range(36,52))
 var x:float=ORIGIN.x+column*CELL
 var width:float=rng.randi_range(100,150)
 var top:float=band*RIDGE_BAND-rng.randi_range(600,1200);var bottom:float=band*RIDGE_BAND+rng.randi_range(1150,1750)
 var gap_y:float=band*RIDGE_BAND+ORIGIN.y+4*CELL
 var result:Dictionary={"id":"ridge_%d_%d"%[region,band],"x":x,"port":Vector2(x,gap_y),"clearance":160.,"boxes":[Rect2(x-width/2.,top,width,gap_y-80.-top),Rect2(x-width/2.,gap_y+80.,width,bottom-gap_y-80.)]}
 ridge_cache106[key]=result
 return result
static func ridges_for_chunk(seed:int,c:Vector2i)->Array:
 var out:Array=[];var bounds:Rect2=Rect2(Vector2(c)*1024.,Vector2.ONE*1024.)
 var region:int=floori((bounds.position.x-ORIGIN.x)/(REGION_CELLS*CELL))
 var band:int=floori((bounds.position.y-ORIGIN.y-4*CELL)/RIDGE_BAND)
 for index in range(region-1,region+2):
  for strip in range(band-1,band+3):
   var data=ridge(seed,index,strip)
   for rect in data.boxes:
    var clipped:Rect2=rect.intersection(bounds)
    if clipped.has_area():out.append({"id":data.id,"box":clipped,"port":data.port})
 return out
static func blocked(seed:int,p:Vector2,margin:float=0.)->bool:
 var region:int=floori((p.x-ORIGIN.x)/(REGION_CELLS*CELL))
 var band:int=floori((p.y-ORIGIN.y-4*CELL)/RIDGE_BAND)
 for index in range(region-1,region+2):
  for strip in range(band-1,band+2):
   for box in ridge(seed,index,strip).boxes:
    if box.grow(margin).has_point(p):return true
 return false
static func safe_step(seed:int,a:Vector2,b:Vector2,margin:float=18.)->Vector2:
 var steps:int=maxi(1,ceili(a.distance_to(b)/8.));var last:Vector2=a
 for i in range(1,steps+1):
  var p:Vector2=a.lerp(b,float(i)/steps)
  if blocked(seed,p,margin):return last
  last=p
 return b
static func clear_spawn(seed:int,p:Vector2)->Vector2:
 if not blocked(seed,p,20.):return p
 for ring in range(1,81):
  for i in 16:
   var q:Vector2=p+Vector2.from_angle(i*TAU/16)*ring*12.
   if not blocked(seed,q,20.):return q
 return Vector2(INF,INF)
