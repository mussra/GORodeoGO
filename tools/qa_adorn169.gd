extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1120,1120)
 var specs:=FinishPose168.specs()
 for page in ceili(specs.size()/3.):
  var root:=Control.new();add_child(root)
  var bg:=ColorRect.new();bg.color=Color("294738");bg.size=Vector2(1120,1120);root.add_child(bg)
  for g in 3:
   var si:int=page*3+g
   if si>=specs.size():continue
   var spec:Dictionary=specs[si];var label:=Label.new();label.text=spec.title+" · fotogramas completos";label.position=Vector2(12,10+g*365);label.add_theme_font_size_override("font_size",23);root.add_child(label)
   for style in 3:
    var name_:=Label.new();name_.text=["Oro","Plata","Hielo + oro/plata"][style];name_.position=Vector2(10,70+g*365+style*102);name_.add_theme_font_size_override("font_size",16);root.add_child(name_)
    for i in spec.count:
     var tex:=TextureRect.new();tex.position=Vector2(140+i*108,48+g*365+style*102);tex.size=Vector2(96,96);tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;tex.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
     var p:=FinishPose168.paths(spec,i);tex.texture=load(p.source);tex.material=HorseAdorn169.material({"leg_adorn169":"silver" if style==1 else "gold","boot_adorn169":"gold" if style==2 else ("silver" if style==1 else "gold"),"special_finish168":"ice" if style==2 else ""},spec,i);root.add_child(tex)
  await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/adorn169-page-%d.png"%page)
  root.queue_free();await get_tree().process_frame
 print("ADORN169_ALL_133_POSES_RENDERED");get_tree().quit()
