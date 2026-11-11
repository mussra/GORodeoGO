extends Node
var canvas:SubViewport
func label(t:String,p:Vector2):
 var l=Label.new();l.text=t;l.position=p;l.add_theme_font_size_override("font_size",18);canvas.add_child(l)
func _ready():run.call_deferred()
func run():
 var master=OS.get_cmdline_user_args().has("master")
 var kind="horse" if OS.get_cmdline_user_args().has("horse") else "rider"
 canvas=SubViewport.new();canvas.size=Vector2i(1440,1320);canvas.render_target_update_mode=SubViewport.UPDATE_ALWAYS;add_child(canvas)
 var bg=ColorRect.new();bg.size=Vector2(1440,1320);bg.color=Color("10252d");canvas.add_child(bg)
 var c=HorseCollection.new();c.seed_trial();var h=c.find("original");h.traits.finish="galaxy"
 for n in range(1,21 if master else 20):HorseMastery.record(c,h.id,n)
 label("Galaxy maestro100%" if master else "Galaxy normal95%",Vector2(20,8))
 for view_i in 5:
  var view=["side","down","up","diag_down","diag_up"][view_i]
  for i in 9:
   var tex=TextureRect.new();tex.position=Vector2(i*160,40+view_i*250);tex.size=Vector2(156,210);tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;tex.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;tex.texture=PixelLabTrial.pose_texture(kind,view,i,h.traits,h);canvas.add_child(tex);label(view+" "+str(i),tex.position+Vector2(10,210))
 await get_tree().create_timer(.5).timeout;await RenderingServer.frame_post_draw
 canvas.get_texture().get_image().save_png("/downloads/galaxy-frames-%s-%s83.png"%[kind,"master" if master else "normal"]);get_tree().quit()
