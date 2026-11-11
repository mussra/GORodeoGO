extends Node2D
func _ready():
 get_tree().root.size=Vector2i(1280,1000)
 queue_redraw();capture.call_deferred()
func _draw():
 draw_rect(Rect2(0,0,1280,1000),Color("32653a"))
 for i in 4:
  for k in ["corner","t","cross","end"]:
   var col=["corner","t","cross","end"].find(k)
   var pos=Vector2(180+col*290,120+i*230)
   RoadTiles.junction(self,k,pos,i*PI*.5,45.0)
func capture():
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/road-junctions84.png");get_tree().quit()
