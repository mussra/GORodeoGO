extends Control
var session:Node2D
func _ready():mouse_filter=Control.MOUSE_FILTER_IGNORE
func _draw():
 draw_style_box(MapAppearance.frame(),Rect2(Vector2.ZERO,size))
 draw_string(ThemeDB.fallback_font,Vector2(10,20),"PISTA · 4 VALLAS",HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color("fff8e8"))
 for i in session.POINTS.size():
  var p:Vector2=Vector2(10,28)+session.POINTS[i]/Vector2(1280,720)*(size-Vector2(20,30))
  var axis:Vector2=MemoryFence208.half_axis(i).normalized()*9.
  draw_line(p-axis,p+axis,session.COLORS[i],4.)
 var rider:Vector2=Vector2(10,28)+session.player.position/Vector2(1280,720)*(size-Vector2(20,30))
 draw_circle(rider,4.,Color.WHITE)
