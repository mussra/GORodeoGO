extends Node
var canvas:SubViewport
func text(t:String,p:Vector2,w:float):
 var l=Label.new();l.text=t;l.position=p;l.size.x=w;l.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;l.add_theme_font_size_override("font_size",22);canvas.add_child(l)
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");canvas=SubViewport.new();canvas.size=Vector2i(1440,1040);canvas.render_target_update_mode=SubViewport.UPDATE_ALWAYS;add_child(canvas)
 var bg=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1440,1040);canvas.add_child(bg)
 text("Galaxy maestro · gameplay / beber · estudio de poses",Vector2(0,12),1440)
 var c=HorseCollection.new();c.seed_trial();var h=c.find("original");h.traits.finish="galaxy"
 for n in range(1,21):HorseMastery.record(c,h.id,n)
 var views=["side","down","up","diag_down","diag_up"]
 for row in 3:
  for col in 5:
   var origin=Vector2(col*288,60+row*315);var tex=TextureRect.new();tex.position=origin;tex.size=Vector2(280,280);tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;tex.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;canvas.add_child(tex)
   if row==0:tex.texture=PixelLabTrial.pose_texture("rider",views[col],0,h.traits,h)
   elif row==1:tex.texture=PixelLabTrial.pose_texture("horse",views[col],4,h.traits,h)
   elif col<2:tex.texture=HorseDrink.texture(col,h.traits,"original",h)
   else:tex.texture=HorseAppearance.texture(load("res://art/player/%s/frame_%s.png"%[["idle","jump_side","stunned"][col-2],"0" if col==4 else "00"]),["idle","jump_side","stunned"][col-2],0,h.traits,null,null,HorseGalaxyLook.state(h))
   text(("Montado " if row==0 else "Libre ")+views[col] if row<2 else (["Beber arriba","Beber abajo","Idle clásico","Salto clásico","Aturdido"][col]),origin+Vector2(0,280),288)
 await get_tree().create_timer(.5).timeout;await RenderingServer.frame_post_draw
 canvas.get_texture().get_image().save_png("/downloads/galaxy-game83.png");get_tree().quit()
