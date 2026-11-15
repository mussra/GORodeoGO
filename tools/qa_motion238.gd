extends Node
var actors:Array=[]
var title:Label
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720)
 var bg:=ColorRect.new();bg.size=Vector2(1280,720);bg.color=Color("10252d");add_child(bg)
 title=Label.new();title.position=Vector2(28,12);title.add_theme_font_size_override("font_size",25);add_child(title)
 for k in 6:
  var x:int=25+(k%3)*420;var y:int=65+(k/3)*310
  var l:=Label.new();l.text=HorseCollection.PATTERNS[12+k];l.position=Vector2(x,y);l.add_theme_font_size_override("font_size",25);add_child(l)
  var t:Dictionary={"coat":12,"pattern":12+k,"spots":0,"mane":1,"finish":"normal","coat_style238":"rainbow" if k%2==0 else "flat","spots_style238":"rainbow" if k%2==1 else "flat"}
  for kind in ["rider","horse"]:
   var view:=TextureRect.new();view.position=Vector2(x+(0 if kind=="rider" else 190),y+45);view.size=Vector2(185,220);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;add_child(view);actors.append([view,t,kind])
 var n:int=0
 for dir in ["side","down","up","diag_down","diag_up"]:
  for f in 18:
   title.text="Pelajes integrados · "+dir+" · animación real del juego"
   for actor in actors:actor[0].texture=PixelLabTrial.pose_texture(actor[2],dir,f%9,actor[1])
   await get_tree().process_frame;await RenderingServer.frame_post_draw
   get_viewport().get_texture().get_image().save_png("/downloads/wild238/motion-%03d.png"%n);n+=1
 print("MOTION238 frames ",n);get_tree().quit()
