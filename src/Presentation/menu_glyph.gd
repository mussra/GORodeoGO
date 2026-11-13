class_name MenuGlyph
extends Control
var kind:String="collection"
const CELLS={"collection":5,"editor":5,"breed":6,"atlas":7,"map":7,"home":9,"exit":10,"training":11,"genealogy":12}
func _ready()->void:mouse_filter=Control.MOUSE_FILTER_IGNORE
func _draw()->void:
 if CELLS.has(kind):AntIcons187.draw_fit(self,CELLS[kind],Rect2(2,2,56,56))
 elif kind=="market":
  # Cell8 is clipped at the source edge; retain the existing vector coin.
  var ink:=Color("81d9dc");draw_circle(Vector2(29,29),22,ink,false,2.0);draw_line(Vector2(29,12),Vector2(29,46),ink,2.0);draw_polyline(PackedVector2Array([Vector2(39,19),Vector2(22,19),Vector2(18,26),Vector2(37,32),Vector2(35,40),Vector2(18,40)]),ink,2.0)
