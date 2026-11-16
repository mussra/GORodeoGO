class_name TownWallArt242
extends RefCounted
## One continuous visual contour per town. Physics remains TownEnclosures227.
static var cache:Dictionary={}
static func chains(segments:Array)->Array:
 var remaining:Array=segments.duplicate(true);var out:Array=[]
 while not remaining.is_empty():
  var first:Dictionary=remaining.pop_back();var path:=PackedVector2Array([first.a,first.b]);var changed:bool=true
  while changed:
   changed=false
   for i in remaining.size():
    var segment:Dictionary=remaining[i]
    if path[-1].distance_to(segment.a)<.1:path.append(segment.b)
    elif path[-1].distance_to(segment.b)<.1:path.append(segment.a)
    elif path[0].distance_to(segment.b)<.1:path.insert(0,segment.a)
    elif path[0].distance_to(segment.a)<.1:path.insert(0,segment.b)
    else:continue
    remaining.remove_at(i);changed=true;break
  out.append(path)
 return out
static func geometry(plan:Dictionary)->Dictionary:
 var key:int=hash([plan.segments,TownEnclosures227.THICKNESS])
 if cache.has(key):return cache[key]
 if cache.size()>96:cache.clear()
 var outer:Array=[];var surface:Array=[];var inset:Array=[]
 for path in chains(plan.segments):
  outer.append_array(Geometry2D.offset_polyline(path,TownEnclosures227.THICKNESS*.5+4.,Geometry2D.JOIN_ROUND,Geometry2D.END_ROUND))
  surface.append_array(Geometry2D.offset_polyline(path,TownEnclosures227.THICKNESS*.5,Geometry2D.JOIN_ROUND,Geometry2D.END_ROUND))
  inset.append_array(Geometry2D.offset_polyline(path,TownEnclosures227.THICKNESS*.5-5.,Geometry2D.JOIN_ROUND,Geometry2D.END_ROUND))
 var result:Dictionary={'outer':outer,'surface':surface,'inset':inset};cache[key]=result;return result
static func draw(node:CanvasItem,seed_:int,chunk:Vector2i):
 var box:=Rect2(Vector2(chunk)*1024.,Vector2.ONE*1024.)
 var clip:=PackedVector2Array([box.position,Vector2(box.end.x,box.position.y),box.end,Vector2(box.position.x,box.end.y)])
 for plan in TownEnclosures227.plans(seed_).values():
  if not (plan.bounds as Rect2).grow(80.).intersects(box):continue
  var polygons:Dictionary=geometry(plan);var look:=TownIdentity215.look(SaveData.world_cousins140,plan.id)
  for polygon in polygons.outer:
   for part in Geometry2D.intersect_polygons(polygon,clip):node.draw_colored_polygon(part,Color('514537'))
  for polygon in polygons.surface:
   for part in Geometry2D.intersect_polygons(polygon,clip):node.draw_colored_polygon(part,Color('ead7aa'))
  for polygon in polygons.inset:
   for part in Geometry2D.intersect_polygons(polygon,clip):
    var uv:=PackedVector2Array()
    for point in part:uv.append(point/128.)
    node.draw_polygon(part,PackedColorArray([Color.WHITE]),uv,TownPaint215.texture(look))
