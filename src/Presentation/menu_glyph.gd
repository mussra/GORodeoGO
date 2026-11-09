class_name MenuGlyph
extends Control
var kind:String="collection"
func _ready()->void:mouse_filter=Control.MOUSE_FILTER_IGNORE
func _draw()->void:
 var ink:=Color("81d9dc")
 match kind:
  "collection","editor":
   for y in range(2):
    for x in range(2):draw_rect(Rect2(8+x*22,8+y*22,16,16),ink,false,2.0)
  "breed":
   draw_circle(Vector2(15,20),10,ink,false,2.0);draw_circle(Vector2(43,20),10,ink,false,2.0);draw_line(Vector2(20,30),Vector2(29,45),ink,2.0);draw_line(Vector2(38,30),Vector2(29,45),ink,2.0);draw_circle(Vector2(29,47),5,ink,false,2.0)
  "atlas","map":
   draw_polyline(PackedVector2Array([Vector2(7,12),Vector2(28,17),Vector2(49,12),Vector2(49,45),Vector2(28,50),Vector2(7,45),Vector2(7,12)]),ink,2.0);draw_line(Vector2(28,17),Vector2(28,50),ink,2.0)
  "market":
   draw_circle(Vector2(29,29),22,ink,false,2.0);draw_line(Vector2(29,12),Vector2(29,46),ink,2.0);draw_polyline(PackedVector2Array([Vector2(39,19),Vector2(22,19),Vector2(18,26),Vector2(37,32),Vector2(35,40),Vector2(18,40)]),ink,2.0)
  "home":
   draw_polyline(PackedVector2Array([Vector2(6,27),Vector2(29,7),Vector2(52,27)]),ink,2.0);draw_rect(Rect2(13,26,32,25),ink,false,2.0);draw_rect(Rect2(25,35,9,16),ink,false,2.0)
  "exit":
   draw_polyline(PackedVector2Array([Vector2(24,8),Vector2(9,8),Vector2(9,50),Vector2(24,50)]),ink,2.0);draw_line(Vector2(23,29),Vector2(51,29),ink,2.0);draw_polyline(PackedVector2Array([Vector2(40,19),Vector2(51,29),Vector2(40,39)]),ink,2.0)
  "training":
   draw_polyline(PackedVector2Array([Vector2(10,46),Vector2(10,30),Vector2(25,30),Vector2(25,18),Vector2(43,18),Vector2(43,9)]),ink,3.0);draw_line(Vector2(34,17),Vector2(43,8),ink,2.0);draw_line(Vector2(43,8),Vector2(51,17),ink,2.0)
  "genealogy":
   draw_line(Vector2(29,16),Vector2(29,30),ink,2.0);draw_line(Vector2(13,30),Vector2(45,30),ink,2.0)
   for point in [Vector2(29,10),Vector2(13,44),Vector2(45,44)]:
    draw_circle(point,6,ink,false,2.0)
   draw_line(Vector2(13,30),Vector2(13,38),ink,2.0);draw_line(Vector2(45,30),Vector2(45,38),ink,2.0)
