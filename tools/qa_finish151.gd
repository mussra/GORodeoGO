extends Node
var runners:Array[TextureRect]=[]
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 var canvas:=Control.new();canvas.size=Vector2(1280,720);add_child(canvas)
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1280,720);canvas.add_child(bg)
 var title:=Label.new();title.text="Oro brillante · Cristal · Hielo";title.position=Vector2(35,22);title.add_theme_font_size_override("font_size",32);canvas.add_child(title)
 var sub:=Label.new();sub.text="Con el jinete montado · mismo acabado, solo sobre el caballo";sub.position=Vector2(35,75);sub.add_theme_font_size_override("font_size",23);canvas.add_child(sub)
 for i in 3:
  var x:float=32+i*416
  var label:=Label.new();label.text=SpecialFinish145.NAMES[i];label.position=Vector2(x+15,150);label.add_theme_font_size_override("font_size",28);canvas.add_child(label)
  var pad:=ColorRect.new();pad.color=Color("294738") if i==1 else Color("28404a");pad.position=Vector2(x,205);pad.size=Vector2(385,400);canvas.add_child(pad)
  for k in 7:
   var line:=ColorRect.new();line.color=Color("ffffff0b");line.position=Vector2(x+k*60.,205);line.size=Vector2(1,400);canvas.add_child(line)
  var runner:=TextureRect.new();runner.position=Vector2(x,205);runner.size=Vector2(385,400);runner.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;runner.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;runner.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;canvas.add_child(runner);runners.append(runner)
 var note:=Label.new();note.text="Vista previa · obtención y precio pendientes · sin cambios de estadísticas";note.position=Vector2(35,660);note.add_theme_font_size_override("font_size",23);canvas.add_child(note)
 var textures:Array[Texture2D]=[];var materials:Array=[]
 for frame in 9:
  textures.append(load("res://art/experimental/pixellab/rider/side/frame_%02d.png"%frame))
  var row:Array=[]
  for style in SpecialFinish145.IDS:row.append(SpecialFinish145.material(style,load("res://art/experimental/pixellab_masks_review_v5/rider/side/color_%02d.png"%frame),load("res://art/experimental/pixellab_preview_uv/rider/side/frame_%02d.png"%frame)))
  materials.append(row)
 DirAccess.make_dir_recursive_absolute("/downloads/finish151-frames")
 for i in 108:
  var frame:int=(i/2)%9
  for j in 3:runners[j].texture=textures[frame];runners[j].material=materials[frame][j]
  await get_tree().process_frame;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/finish151-frames/%04d.png"%i)
 print("FINISH151_MOUNTED_VIDEO_OK");get_tree().quit()
