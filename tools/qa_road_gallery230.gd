extends Node2D
var after:bool=false
var groups:Array=[]
func _ready():
 get_tree().root.size=Vector2i(960,540);after=OS.get_cmdline_user_args().has("after")
 groups=[ [PackedVector2Array([Vector2(-150,0),Vector2(150,0)]),PackedVector2Array([Vector2(0,0),Vector2(0,-125)])], [PackedVector2Array([Vector2(-150,0),Vector2(150,0)]),PackedVector2Array([Vector2(0,125),Vector2(0,-125)])], [PackedVector2Array([Vector2(-150,0),Vector2(0,0),Vector2(0,-125)])], [PackedVector2Array([Vector2(0,125),Vector2(0,0),Vector2(-110,-110)]),PackedVector2Array([Vector2(0,0),Vector2(110,-110)])] ]
 queue_redraw();run.call_deferred()
func _draw():
 texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED
 for x in 10:
  for y in 6:draw_texture_rect(LoadingParade.GRASS170,Rect2(x*128,y*128,128,128),false)
 for index in 4:
  draw_set_transform(Vector2(320+index%2*640,205+int(index/2)*350))
  var lanes:Array=[]
  for path in groups[index]:lanes.append({"points":path,"width":32.})
  if not after:
   for path in groups[index]:ContinuousRoadArt.ribbon(self,path,32.)
  else:
   for p in RoadNetwork230.polygons(lanes):
    draw_colored_polygon(p,Color("697f30"))
    for inner in Geometry2D.offset_polygon(p,-3.,Geometry2D.JOIN_ROUND):
     var uv:=PackedVector2Array()
     for point in inner:uv.append(point/Vector2(192,50))
     draw_polygon(inner,PackedColorArray([Color.WHITE]),uv,RoadNetwork230.texture())
  draw_string(ThemeDB.fallback_font,Vector2(-130,-145),["T","Cruce X","Esquina","Bifurcación Y"][index],HORIZONTAL_ALIGNMENT_LEFT,-1,24,Color("fff1cd"))
 draw_set_transform(Vector2.ZERO)
func run():
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/roads230-gallery-"+("after" if after else "before")+"-960.png");get_tree().quit()
