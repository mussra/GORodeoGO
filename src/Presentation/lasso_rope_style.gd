class_name LassoRopeStyle
extends RefCounted
## Same rope outline, twisted highlights and loop in flight and while held.
static func draw_cord(item:CanvasItem,points:PackedVector2Array):
 item.draw_polyline(points,Color("62452d"),5,true)
 item.draw_polyline(points,Color("e9c98e"),3,true)
 for i in range(1,points.size(),2):item.draw_line(points[i]-Vector2(1,1),points[i]+Vector2(1,1),Color("ad814d"),1,true)
static func draw_loop(item:CanvasItem,center:Vector2):
 var points=PackedVector2Array()
 for i in 33:points.append(center+Vector2(cos(i*TAU/32)*22,sin(i*TAU/32)*11))
 item.draw_polyline(points,Color("62452d"),5,true)
 item.draw_polyline(points,Color("f4d69d"),2.8,true)
static func rider_hand(rider:Node2D)->Vector2:
 if rider.has_method("effect_hand_local"):return rider.to_global(rider.effect_hand_local())
 return rider.to_global(Vector2(8,-12))
