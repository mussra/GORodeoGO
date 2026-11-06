extends SceneTree
var sprites:Array[Sprite2D]=[]
var frame:int=0
var ready:bool=false
func _initialize()->void:call_deferred("setup")
func setup()->void:
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1280,720);root.add_child(bg)
 var title:=Label.new();title.text="GALAXY · cinco direcciones · muestra en motor, no partida Android";title.position=Vector2(25,20);title.add_theme_font_size_override("font_size",28);root.add_child(title)
 var dirs:Array=["walk_side","walk_diag_down","walk_down","walk_diag_up","walk_up"]
 for i in range(5):
  var sp:=Sprite2D.new();sp.position=Vector2(128+256*i,310);sp.scale=Vector2.ONE*2.3;sp.set_meta("anim",dirs[i]);root.add_child(sp);sprites.append(sp)
  var label:=Label.new();label.text=["Lateral","Diagonal baja","Frontal","Diagonal alta","Trasera"][i];label.position=Vector2(25+256*i,490);label.add_theme_font_size_override("font_size",22);root.add_child(label)
 var note:=Label.new();note.text="Nebulosa violeta y estrellas sobre la máscara. Sin precios, rarezas ni desbloqueos.\nCandidata de revisión, no APK nueva.";note.position=Vector2(35,615);note.add_theme_font_size_override("font_size",23);root.add_child(note)
 ready=true
func _process(_delta:float)->bool:
 if not ready:return false
 var f:int=(frame/5)%12
 for sp in sprites:
  var anim:String=sp.get_meta("anim");var path:String="res://art/player/%s/frame_%02d.png"%[anim,f]
  if ResourceLoader.exists(path):sp.texture=HorseAppearance.texture(load(path),anim,f,{"coat":19,"pattern":0,"mane":3,"eyes":21,"finish":"galaxy"})
 frame+=1
 if frame==60:call_deferred("shot")
 if frame>=180:quit()
 return false
func shot()->void:
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/galaxy-motion-sample.png")
