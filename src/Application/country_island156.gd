class_name CountryIsland156
extends RefCounted
## Rounded, gently uneven coast inside the finite test country.
## Same contour for the shore, sea collision and safe-arrival checks.
static func coastline()->PackedVector2Array:
 var result:=PackedVector2Array();var center:=CountryRoute146.BOUNDS.get_center();var half:Vector2=CountryRoute146.BOUNDS.size/2.-Vector2.ONE*170.
 for i in 128:
  var angle:float=TAU*i/128.;var c:float=cos(angle);var s:float=sin(angle);var ripple:float=.97+.012*sin(angle*5.+.7)+.009*sin(angle*9.)
  result.append(center+Vector2(signf(c)*pow(absf(c),.48)*half.x,signf(s)*pow(absf(s),.48)*half.y)*ripple)
 return result
static func blocked(poly:PackedVector2Array,point:Vector2,radius:float)->bool:
 if not Geometry2D.is_point_in_polygon(point,poly):return true
 for i in poly.size():
  if Geometry2D.get_closest_point_to_segment(point,poly[i],poly[(i+1)%poly.size()]).distance_to(point)<radius:return true
 return false
