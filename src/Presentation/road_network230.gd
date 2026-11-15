class_name RoadNetwork230
extends RefCounted
## Pure visual union of existing routes. No seed, path, save or physics mutation.
static var cache:Dictionary={}
static var dirt:Texture2D
static func lanes(seed_:int,c:Vector2i,version:int)->Array:
 var bounds:=Rect2(Vector2(c)*1024.,Vector2.ONE*1024.).grow(180.);var out:Array=[]
 for dx in range(-1,2):
  for dy in range(-1,2):
   var graph:Dictionary=WorldNominal98.graph_for_chunk(seed_,c+Vector2i(dx,dy),version)
   for cell in graph:
    var a:Vector2=ModularWorldLayout93.world(cell)
    for other in graph[cell]:
     var b:Vector2=ModularWorldLayout93.world(other)
     if a.x>b.x or (a.x==b.x and a.y>b.y):continue
     if bounds.grow(100).has_point(a) or bounds.grow(100).has_point(b):out.append({"points":PackedVector2Array([a,b]),"width":30.})
 if version>=4:
  for plan in TownEnclosures227.plans(seed_).values():out.append({"points":plan.road,"width":40.})
 if not SaveData.world_cousins140.is_empty():
  for id in TownEnclosures227.cousin_ids231():
   out.append({"points":TownEnclosures227.cousin_lane231(SaveData.world_cousins140,id),"width":32.})
 if not SaveData.world_flora138.is_empty():
  for lane in FloristJourney138.lanes(SaveData.world_flora138):out.append({"points":lane,"width":32.})
 if SaveData.world_garden212.stage!="locked" and not SaveData.world_garden212.anchors.is_empty():out.append({"points":Garden212.lane214(SaveData.world_garden212.anchors.plot),"width":32.})
 return out.filter(func(lane):
  var points:PackedVector2Array=lane.points
  for i in points.size()-1:
   if Rect2(points[i],Vector2.ZERO).expand(points[i+1]).grow(100).intersects(bounds):return true
  return false)
static func unite(polygons:Array)->Array:
 var result:Array=[]
 for source in polygons:
  var next:PackedVector2Array=source;var i:int=0
  while i<result.size():
   var merged:Array=Geometry2D.merge_polygons(next,result[i])
   if merged.size()==1:
    next=merged[0];result.remove_at(i);i=0
   else:i+=1
  result.append(next)
 return result
static func polygons(lanes_:Array)->Array:
 var raw:Array=[];var seen:Dictionary={}
 for lane in lanes_:
  var points:PackedVector2Array=lane.points;var clean:=PackedVector2Array()
  for point in points:
   if clean.is_empty() or clean[-1].distance_to(point)>.1:clean.append(point)
  if clean.size()<2:continue
  # Identical graph edges appear in adjacent graph queries. Union them once.
  var key:String=str([clean,lane.width])
  if seen.has(key):continue
  seen[key]=true
  raw.append_array(Geometry2D.offset_polyline(clean,float(lane.width)*.5,Geometry2D.JOIN_ROUND,Geometry2D.END_ROUND))
 var joined:=unite(raw);var softened:Array=[]
 # Closing rounds the inner shoulders of T/X/Y joins without internal borders.
 for polygon in joined:softened.append_array(Geometry2D.offset_polygon(polygon,10.,Geometry2D.JOIN_ROUND))
 joined=unite(softened);softened=[]
 for polygon in joined:softened.append_array(Geometry2D.offset_polygon(polygon,-10.,Geometry2D.JOIN_ROUND))
 return softened
static func geometry(seed_:int,c:Vector2i,version:int)->Array:
 var key:String=str([seed_,c,version,SaveData.world_cousins140.get("doors",{}),SaveData.world_flora138.get("region",0),SaveData.world_garden212.stage!="locked",SaveData.world_garden212.anchors])
 if cache.has(key):return cache[key]
 if cache.size()>64:cache.clear()
 var result:Array=polygons(lanes(seed_,c,version));cache[key]=result;return result
static func texture()->Texture2D:
 if dirt==null:
  var source:=ContinuousRoadArt.STRIP.get_image()
  if source.is_compressed():source.decompress()
  var center:Image=source.get_region(Rect2i(0,23,192,50));dirt=ImageTexture.create_from_image(center)
 return dirt
static func draw(node:CanvasItem,seed_:int,c:Vector2i,version:int):
 var rect:=Rect2(Vector2(c)*1024.,Vector2.ONE*1024.)
 var clip:=PackedVector2Array([rect.position,Vector2(rect.end.x,rect.position.y),rect.end,Vector2(rect.position.x,rect.end.y)])
 for polygon in geometry(seed_,c,version):
  for border in Geometry2D.intersect_polygons(polygon,clip):node.draw_colored_polygon(border,Color("697f30"))
  for inset in Geometry2D.offset_polygon(polygon,-3.,Geometry2D.JOIN_ROUND):
   for inside in Geometry2D.intersect_polygons(inset,clip):
    var uv:=PackedVector2Array()
    for p in inside:uv.append(p/Vector2(192,50))
    node.draw_polygon(inside,PackedColorArray([Color.WHITE]),uv,texture())
