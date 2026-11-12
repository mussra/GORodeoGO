extends Control
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);SaveData.hat_color="blue"
 var t={"coat":0,"pattern":3,"mane":5,"eyes":0,"finish":"normal"}
 var views=["side","down","up","diag_down","diag_up"]
 for kind in ["rider","horse"]:
  var out=Image.create(96*9,112*5,false,Image.FORMAT_RGBA8);out.fill(Color("284238"))
  for row in 5:
   for frame in 9:
    var image=PixelLabTrial.pose_texture(kind,views[row],frame,t).get_image();out.blend_rect(image,Rect2i(0,0,96,96),Vector2i(frame*96,row*112))
  out.resize(96*9*3,112*5*3,Image.INTERPOLATE_NEAREST);out.save_png("/downloads/trasera122-"+kind+"-45poses.png")
 var bg=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1280,720);add_child(bg)
 var title=Label.new();title.text="B · medias traseras irregulares · integración";title.position=Vector2(30,25);title.add_theme_font_size_override("font_size",30);add_child(title)
 var portrait=TextureRect.new();HorsePortrait.apply(portrait,t,"blue");portrait.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;portrait.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;portrait.position=Vector2(20,85);portrait.size=Vector2(420,500);add_child(portrait)
 for row in 2:
  for col in 5:
   var tex=TextureRect.new();tex.texture=PixelLabTrial.pose_texture("rider" if row==0 else "horse",views[col],4,t);tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;tex.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;tex.position=Vector2(450+col*155,150+row*220);tex.size=Vector2(150,150);add_child(tex)
   var label=Label.new();label.text=views[col];label.position=Vector2(450+col*155,305+row*220);add_child(label)
 var label=Label.new();label.text="Retrato + montado/salvaje · los traseros quedan ocultos vistos de frente";label.position=Vector2(30,650);label.add_theme_font_size_override("font_size",23);add_child(label)
 await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/trasera122-resumen.png")
 var extra=Image.create(96*8,112,false,Image.FORMAT_RGBA8);extra.fill(Color("284238"))
 var col:int=0
 for anim in ["idle","jump_side","jump_down","jump_up","jump_diag_down","jump_diag_up","stunned"]:
  var path="res://art/player/"+anim+("/frame_0.png" if anim=="stunned" else "/frame_00.png")
  var image=HorseAppearance.texture(load(path),anim,0,t).get_image();extra.blend_rect(image,Rect2i(0,0,96,96),Vector2i(col*96,0));col+=1
 var foal=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,t).get_image();foal.resize(96,96,Image.INTERPOLATE_NEAREST);extra.blend_rect(foal,Rect2i(0,0,96,96),Vector2i(7*96,0));extra.resize(96*8*3,112*3,Image.INTERPOLATE_NEAREST);extra.save_png("/downloads/trasera122-otros.png")
 for pose in 2:
  var image=HorseRest107.texture(pose,t).get_image();image.resize(112*5,96*5,Image.INTERPOLATE_NEAREST);image.save_png("/downloads/trasera122-reposo%d.png"%pose)
 if OS.get_environment("REAR122_FIXTURE")=="1":
  SaveData.hat_color="original"
  var expected=JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/horse_patterns84_sha256.json"))
  for kind in ["horse","rider"]:
   for view in views:
    for frame in [0,4,8]:
     var image=PixelLabTrial.pose_texture(kind,view,frame,{"coat":3,"mane":1,"pattern":3,"finish":"normal"}).get_image()
     var hash_=HashingContext.new();hash_.start(HashingContext.HASH_SHA256);hash_.update(image.get_data());expected[kind+view+str(frame)+"3"]=hash_.finish().hex_encode()
  var file=FileAccess.open("res://tests/fixtures/horse_patterns84_sha256.json",FileAccess.WRITE);file.store_string(JSON.stringify(expected,"  "))
 get_tree().quit()
