class_name WorldFlowerTarget105
extends Node2D
## Ant's six-petal replacement. Shared artwork, dynamic colour and aura preserved.
var color:Color=Color("68cfff")
var pulse:float=0.
static func glyph(node:CanvasItem,center:Vector2,radius:float,tint:Color)->void:
 if radius<=4.:
  # Tiny map dots cannot retain a detailed illustration at8px.
  for i in 6:
   var p:Vector2=center+Vector2.from_angle(i*TAU/6)*radius*.65
   node.draw_circle(p,radius*.52,tint)
  node.draw_circle(center,radius*.38,Color("fff2bc"));return
 AntIcons188.draw_texture_fit(node,AntIcons188.flower(tint),Rect2(center-Vector2.ONE*radius*1.17,Vector2.ONE*radius*2.34))
func _process(delta:float)->void:pulse+=delta;queue_redraw()
func _draw()->void:
 draw_circle(Vector2.ZERO,46.+sin(pulse*2)*3,Color(color,.14))
 draw_arc(Vector2.ZERO,42.,0,TAU,48,Color(color,.7),2.,true)
 draw_line(Vector2(0,4),Vector2(0,18),Color("38754c"),4.)
 glyph(self,Vector2(0,-7),15.,color)
