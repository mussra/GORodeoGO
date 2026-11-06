class_name JumpFence
extends StaticBody2D
var fence_size:Vector2=Vector2(150,14)
func _ready()->void:
 collision_layer=32;collision_mask=0
 var shape:=CollisionShape2D.new();var rect:=RectangleShape2D.new();rect.size=fence_size;shape.shape=rect;add_child(shape);queue_redraw()
func _draw()->void:
 var half:float=fence_size.x/2
 for y in [-18,-4]:
  draw_line(Vector2(-half,y+6),Vector2(half,y+6),Color("513625"),8,true)
  draw_line(Vector2(-half,y+3),Vector2(half,y+3),Color("bd8b51"),5,true)
 for x in [-half,0,half]:
  draw_line(Vector2(x,8),Vector2(x,-26),Color("68452d"),9,true)
  draw_line(Vector2(x-2,5),Vector2(x-2,-25),Color("cea56c"),3,true)
