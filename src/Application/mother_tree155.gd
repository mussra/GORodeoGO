class_name MotherTree155
extends RefCounted
## Ground footprint traced from the supplied lower trunk and root silhouette.
## The crown is overhead, not a solid wall blocking the route around it.
const SOURCE_SIZE:Vector2=Vector2(1176,1008)
static var OUTLINE=PackedVector2Array([Vector2(230,931),Vector2(250,941),Vector2(247,957),Vector2(273,959),Vector2(271,978),Vector2(305,968),Vector2(316,978),Vector2(345,970),Vector2(354,990),Vector2(461,1002),Vector2(514,990),Vector2(515,1004),Vector2(579,984),Vector2(590,997),Vector2(611,990),Vector2(626,993),Vector2(633,1003),Vector2(723,1001),Vector2(732,987),Vector2(767,995),Vector2(771,985),Vector2(825,992),Vector2(841,987),Vector2(835,972),Vector2(846,963),Vector2(883,955),Vector2(912,970),Vector2(915,954),Vector2(938,951),Vector2(923,917),Vector2(932,905),Vector2(911,890),Vector2(915,878),Vector2(884,875),Vector2(886,862),Vector2(861,856),Vector2(872,840),Vector2(848,839),Vector2(845,826),Vector2(831,831),Vector2(803,781),Vector2(751,764),Vector2(728,700),Vector2(680,650),Vector2(478,650),Vector2(481,679),Vector2(504,707),Vector2(498,729),Vector2(476,745),Vector2(421,758),Vector2(399,794),Vector2(383,783),Vector2(364,787),Vector2(359,793),Vector2(386,810),Vector2(372,816),Vector2(354,840),Vector2(309,850)])
static func footprint(art:Rect2)->PackedVector2Array:
 var points:=PackedVector2Array()
 for pixel in OUTLINE:points.append(art.position+pixel/SOURCE_SIZE*art.size)
 return points
static func blocked(poly:PackedVector2Array,point:Vector2,radius:float)->bool:
 if Geometry2D.is_point_in_polygon(point,poly):return true
 for i in poly.size():
  if Geometry2D.get_closest_point_to_segment(point,poly[i],poly[(i+1)%poly.size()]).distance_to(point)<radius:return true
 return false
