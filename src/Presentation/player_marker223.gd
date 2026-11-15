class_name PlayerMarker223
extends Node2D
## One ground marker for the human rider in every mode, independent of horse art.
static func install(body:Node2D,feet:Vector2=Vector2.ZERO)->void:
 if body is RaceRider190 and body.ai:return
 var marker:=PlayerMarker223.new();marker.name="PlayerMarker223";marker.position=feet;marker.show_behind_parent=true;body.add_child(marker)
func _draw()->void:
 draw_set_transform(Vector2.ZERO,0.,Vector2(1.,.48))
 draw_arc(Vector2.ZERO,34.,0.,TAU,48,Color("123b40"),12.,true)
 draw_arc(Vector2.ZERO,34.,0.,TAU,48,Color("effff8"),8.,true)
 draw_arc(Vector2.ZERO,34.,0.,TAU,48,Color("24d8bb"),5.,true)
 draw_set_transform(Vector2.ZERO)
 var points:=PackedVector2Array([Vector2(-10,28),Vector2(10,28),Vector2(0,18)])
 draw_colored_polygon(points,Color("24d8bb"))
 draw_polyline(PackedVector2Array([points[0],points[1],points[2],points[0]]),Color("effff8"),2.,true)
