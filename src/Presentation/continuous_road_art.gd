class_name ContinuousRoadArt
extends RefCounted
## Same one-straight derived art, geometry/coordinates remain untouched.
const STRIP=preload("res://art/world/derived88/ribbon.png")
const PIECES={"corner":preload("res://art/world/derived88/corner.png"),"t":preload("res://art/world/derived88/tee.png"),"cross":preload("res://art/world/derived88/cross.png"),"end":preload("res://art/world/derived88/end.png")}
static func ribbon(node:CanvasItem,points:PackedVector2Array,width:float=45):
 if points.size()<2:return
 var half=width*96.0/72.0/2
 var normals=[];var uv=[];var length=0.
 for i in points.size():
  var direction=(points[mini(i+1,points.size()-1)]-points[maxi(0,i-1)]).normalized()
  var miter=1.0
  if i>0 and i<points.size()-1:
   var outgoing=(points[i+1]-points[i]).normalized()
   miter=1.0/maxf(.7,absf(direction.orthogonal().dot(outgoing.orthogonal())))
  normals.append(direction.orthogonal()*half*miter)
  if i>0:length+=points[i].distance_to(points[i-1])
  uv.append(length/120.)
 for i in points.size()-1:
  var polygon=PackedVector2Array([points[i]+normals[i],points[i+1]+normals[i+1],points[i+1]-normals[i+1],points[i]-normals[i]])
  node.draw_polygon(polygon,PackedColorArray([Color.WHITE]),PackedVector2Array([Vector2(uv[i],1),Vector2(uv[i+1],1),Vector2(uv[i+1],0),Vector2(uv[i],0)]),STRIP)
static func piece(node:CanvasItem,kind:String,point:Vector2,rotation:float,width:float=45):
 var size=width*192/72
 node.draw_set_transform(point,rotation);node.draw_texture_rect(PIECES[kind],Rect2(-Vector2.ONE*size/2,Vector2.ONE*size),false);node.draw_set_transform(Vector2.ZERO)
static func rounded(points:PackedVector2Array,width:float)->PackedVector2Array:
 var out=PackedVector2Array([points[0]])
 for i in range(1,points.size()-1):
  var prev=points[i-1];var p=points[i];var next=points[i+1]
  var radius=minf(width*1.5,minf(prev.distance_to(p),p.distance_to(next))*.35)
  if radius<width*.8:
   out.append(p);continue
  var a=p+(prev-p).normalized()*radius;var b=p+(next-p).normalized()*radius
  out.append(a)
  for j in range(1,13):
   var t=j/12.;out.append(a.lerp(p,t).lerp(p.lerp(b,t),t))
 out.append(points[-1]);return out
static func access(node:CanvasItem,points:PackedVector2Array,width:float=32):
 # The derivative corner tile bends around a grid cell, not an arbitrary doorway.
 # The same strip follows a tangent fillet to keep existing access coordinates.
 ribbon(node,rounded(points,width),width)

static func junction_soil(node:CanvasItem,point:Vector2,radius:float=25):
 # Sample only the original soil, cover the interior leaf edge where paths join.
 var polygon=PackedVector2Array();var uvs=PackedVector2Array()
 for i in 32:
  var v=Vector2.from_angle(i*TAU/32.)
  polygon.append(point+v*radius);uvs.append(Vector2(.5,.5)+v*Vector2(.22,.22))
 node.draw_polygon(polygon,PackedColorArray([Color.WHITE]),uvs,STRIP)
