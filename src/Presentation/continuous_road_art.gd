class_name ContinuousRoadArt
extends RefCounted
## Same one-straight derived art, geometry/coordinates remain untouched.
const STRIP=preload("res://art/world/derived88/ribbon.png")
const PIECES={"corner":preload("res://art/world/derived88/corner.png"),"t":preload("res://art/world/derived88/tee.png"),"cross":preload("res://art/world/derived88/cross.png"),"end":preload("res://art/world/derived88/end.png")}
static func ribbon(node:CanvasItem,points:PackedVector2Array,width:float=45,junctions:Array=[]):
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
  var spans=[[0.0,1.0]]
  for junction in junctions:
   var inv:Transform2D=junction.frame.affine_inverse()
   var clip=_inside_interval(inv*points[i],inv*points[i+1],junction.half-Vector2.ONE*5)
   if clip.is_empty():continue
   var next=[]
   for span in spans:
    if clip[0]>span[0]:next.append([span[0],minf(span[1],clip[0])])
    if clip[1]<span[1]:next.append([maxf(span[0],clip[1]),span[1]])
   spans=next
  for span in spans:
   var a:float=span[0];var b:float=span[1]
   if b-a<.00001:continue
   var p=points[i].lerp(points[i+1],a);var q=points[i].lerp(points[i+1],b)
   var na:Vector2=normals[i].lerp(normals[i+1],a);var nb:Vector2=normals[i].lerp(normals[i+1],b)
   var ua=lerpf(uv[i],uv[i+1],a);var ub=lerpf(uv[i],uv[i+1],b)
   var polygon=PackedVector2Array([p+na,q+nb,q-nb,p-na])
   node.draw_polygon(polygon,PackedColorArray([Color.WHITE]),PackedVector2Array([Vector2(ua,1),Vector2(ub,1),Vector2(ub,0),Vector2(ua,0)]),STRIP)
static func _inside_interval(p:Vector2,q:Vector2,half:Vector2)->Array:
 var lo=0.0;var hi=1.0;var d=q-p
 for axis in 2:
  if absf(d[axis])<.000001:
   if absf(p[axis])>half[axis]:return []
  else:
   var a=(-half[axis]-p[axis])/d[axis];var b=(half[axis]-p[axis])/d[axis]
   lo=maxf(lo,minf(a,b));hi=minf(hi,maxf(a,b))
   if lo>hi:return []
 return [lo,hi]
static func draw_junction(node:CanvasItem,junction:Dictionary):
 var h:Vector2=junction.half;var polygon=PackedVector2Array();var uv=PackedVector2Array()
 for corner in [Vector2(-1,-1),Vector2(1,-1),Vector2(1,1),Vector2(-1,1)]:
  polygon.append(junction.frame*(corner*h))
  uv.append(Vector2.ONE*.5+(corner*.25).rotated(-junction.rotation))
 node.draw_polygon(polygon,PackedColorArray([Color.WHITE]),uv,PIECES[junction.kind])
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
static func access(node:CanvasItem,points:PackedVector2Array,width:float=32,junctions:Array=[]):
 # The derivative corner tile bends around a grid cell, not an arbitrary doorway.
 # The same strip follows a tangent fillet to keep existing access coordinates.
 ribbon(node,rounded(points,width),width,junctions)
