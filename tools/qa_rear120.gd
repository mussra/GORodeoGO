extends Control
var canvas:Control
func text(value:String,pos:Vector2,size_:int):
 var l=Label.new();l.text=value;l.position=pos;l.add_theme_font_size_override("font_size",size_);canvas.add_child(l)
func tex(texture:Texture2D,pos:Vector2,size_:Vector2):
 var r=TextureRect.new();r.texture=texture;r.position=pos;r.size=size_;r.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;r.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;r.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;canvas.add_child(r);return r
func movement(kind:String,option:int,traits:Dictionary)->Texture2D:
 if option==0:return PixelLabTrial.pose_texture(kind,"side",0,traits)
 var plain=traits.duplicate(true);plain.pattern=0
 var base=PixelLabTrial.pose_texture(kind,"side",0,plain).get_image();if base.is_compressed():base.decompress()
 var source:Image=load("res://art/experimental/pixellab/%s/side/frame_00.png"%kind).get_image();if source.is_compressed():source.decompress()
 var mask:Image=load("res://art/experimental/pixellab_masks_review_v5/%s/side/color_00.png"%kind).get_image();if mask.is_compressed():mask.decompress()
 for y in base.get_height():
  for x in base.get_width():
   var m=mask.get_pixel(x,y);if m.r<.5 or m.g>m.r:continue
   var px:float=x;var py:float=y
   var coverage:float=0.
   if option==1:coverage=(1.-smoothstep(41.,43.,px))*smoothstep(67.+sin(px*.8)*1.3,69.+sin(px*.8)*1.3,py)
   elif option==2:coverage=(1.-smoothstep(38.+sin(py*.4)*2.,40.+sin(py*.4)*2.,px))*smoothstep(57.+sin(px*.65)*3.,59.+sin(px*.65)*3.,py)
   else:
    var d=Vector2((px-28.)/16.,(py-55.)/13.).length();coverage=1.-smoothstep(.82+sin(px*.65+py*.4)*.06,1.08,d)
   var original=source.get_pixel(x,y);var shade=clampf(maxf(original.r,maxf(original.g,original.b))*255./205.,.25,1.18)
   var c=Color("f4edd8")*shade;c.a=base.get_pixel(x,y).a;base.set_pixel(x,y,base.get_pixel(x,y).lerp(c,coverage))
 return ImageTexture.create_from_image(base)
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(896,414);SaveData.hat_color="blue"
 var t={"coat":0,"pattern":3,"mane":5,"eyes":0,"finish":"normal"}
 var titles=["Actual · corte rectangular","A · calcetines traseros bajos","B · medias traseras irregulares","C · grupa ovalada orgánica"]
 var notes=["Referencia actual: bloque y borde recto.","Blanco solo en la parte baja de las patas traseras.","Más altura en patas traseras, borde irregular sin corte recto.","Mancha redondeada en la grupa; sin cubrir toda la pierna."]
 var expressions=["p.x<520. && p.y>410.","p.x<560. && p.y>650.+sin(p.x*.07)*10.","p.x<535.+sin(p.y*.045)*16. && p.y>540.+sin(p.x*.06)*22.","length((p-vec2(440.,500.))/vec2(110.,110.))<1.+sin(p.x*.065+p.y*.04)*.07"]
 for option in 4:
  if canvas:remove_child(canvas);canvas.queue_free()
  canvas=Control.new();canvas.position=(get_viewport_rect().size-Vector2(1280,720))/2;add_child(canvas)
  var bg=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1280,720);canvas.add_child(bg)
  text(titles[option],Vector2(30,30),30);text(notes[option],Vector2(30,80),23)
  text("Retrato",Vector2(30,130),24);text("Montado · lado",Vector2(520,130),24);text("Salvaje · lado",Vector2(900,130),24)
  var r=TextureRect.new();HorsePortrait.apply(r,t,"blue");r.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;r.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;r.position=Vector2(20,155);r.size=Vector2(460,460);canvas.add_child(r)
  if option>0:
   var shader=Shader.new();shader.code=FileAccess.get_file_as_string("res://art/portraits/portrait.gdshader").replace("p.x<520. && p.y>410.",expressions[option]);r.material.shader=shader
  tex(movement("rider",option,t),Vector2(505,200),Vector2(310,310));tex(movement("horse",option,t),Vector2(880,200),Vector2(310,310))
  tex(movement("rider",option,t),Vector2(615,510),Vector2(96,96));tex(movement("horse",option,t),Vector2(990,510),Vector2(96,96))
  text("Ampliado y tamaño original",Vector2(545,620),22)
  text("PREVIEW · no cambia el juego · vista lateral, sin validar todas las animaciones",Vector2(30,678),21)
  await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/trasera120-%d.png"%option)
 get_tree().quit()
