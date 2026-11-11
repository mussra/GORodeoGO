extends Node2D
func _ready():
 get_tree().root.size=Vector2i(1280,720)
 for row in 5:
  var values=[0.,.25,.5,.75,1.]
  var label=Label.new();label.text="Recarga %d%%"%roundi(values[row]*100);label.position=Vector2(40,48+row*118);add_child(label)
  for col in 3:
   var g=RadialGauge.new();g.skill=["stamina","dodge","jump"][col];g.size=Vector2(76,76);g.position=Vector2(240+col*105,30+row*118);g.set_state(true,values[row]);add_child(g)
 var title=Label.new();title.text="Arte de Ant a 76 x 76 px. Sector dinámico: 0 / 25 / 50 / 75 / 100%.";title.position=Vector2(40,640);add_child(title)
 var transparent=RadialGauge.new();transparent.position=Vector2(720,30);transparent.size=Vector2(304,304);add_child(transparent)
 capture.call_deferred()
func _draw():
 draw_rect(Rect2(0,0,1280,720),Color("32653a"))
 for x in 16:
  for y in 16:
   draw_rect(Rect2(704+x*20,14+y*20,20,20),Color("89bdb7") if (x+y)%2==0 else Color("10252d"))
func capture():
 await get_tree().create_timer(.2).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/skill-clocks76-preview84.png");get_tree().quit()
