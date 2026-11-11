class_name ModularWorldLayout93
extends RefCounted
## New orthogonal layout. Never reads/writes an existing world's edits or saves.
const CELL=80.0
const ORIGIN=Vector2(80,150)
const DOORS={"ranch":Vector2i(6,0),"house_west":Vector2i(3,2),"house_east":Vector2i(8,2),"florist":Vector2i(12,2)}
const DIRS=[Vector2i.UP,Vector2i.RIGHT,Vector2i.DOWN,Vector2i.LEFT]
static func graph()->Dictionary:
 var g={}
 _path(g,[Vector2i(0,4),Vector2i(14,4)])
 _path(g,[Vector2i(6,0),Vector2i(6,6)])
 _path(g,[Vector2i(5,4),Vector2i(5,3),Vector2i(3,3),Vector2i(3,2)])
 _path(g,[Vector2i(7,4),Vector2i(7,3),Vector2i(8,3),Vector2i(8,2)])
 _path(g,[Vector2i(11,4),Vector2i(11,3),Vector2i(12,3),Vector2i(12,2)])
 _path(g,[Vector2i(2,4),Vector2i(2,5),Vector2i(4,5),Vector2i(4,6),Vector2i(8,6),Vector2i(8,5),Vector2i(6,5)])
 return g
static func _path(g:Dictionary,corners:Array):
 for i in range(corners.size()-1):
  var p:Vector2i=corners[i];var end:Vector2i=corners[i+1];var step=Vector2i(signi(end.x-p.x),signi(end.y-p.y))
  while p!=end:
   var q=p+step
   if not g.has(p):g[p]=[]
   if not g.has(q):g[q]=[]
   if not g[p].has(q):g[p].append(q)
   if not g[q].has(p):g[q].append(p)
   p=q
static func piece(g:Dictionary,cell:Vector2i)->Dictionary:
 var bits=[]
 for direction in DIRS:bits.append(int(g[cell].has(cell+direction)))
 var bases={"straight":[0,1,0,1],"corner":[0,0,1,1],"t":[0,1,1,1],"cross":[1,1,1,1],"end":[0,0,0,1],"dot":[0,0,0,0]}
 for name in bases:
  for rotation in 4:
   var candidate=[]
   for i in 4:candidate.append(bases[name][posmod(i-rotation,4)])
   if candidate==bits:return {"kind":name,"rotation":rotation,"ports":bits}
 return {}
static func world(cell:Vector2i)->Vector2:return ORIGIN+Vector2(cell)*CELL
static func nearest_distance(point:Vector2)->float:
 var g=graph();var result=INF
 for cell in g:
  for next in g[cell]:result=minf(result,point.distance_to(Geometry2D.get_closest_point_to_segment(point,world(cell),world(next))))
 return result
