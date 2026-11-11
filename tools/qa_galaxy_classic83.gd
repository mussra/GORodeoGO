extends Node
func _ready():run.call_deferred()
func run():
 var c=HorseCollection.new();c.seed_trial();var h=c.find("original");h.traits.finish="galaxy"
 var normal=OS.get_cmdline_user_args().has("normal")
 for n in range(1,20 if normal else 21):HorseMastery.record(c,h.id,n)
 var specs=[]
 for anim in ["idle","jump_side","jump_down","jump_up","jump_diag_down","jump_diag_up","stunned"]:
  var paths=DirAccess.get_files_at("res://art/player/"+anim)
  for path in paths:
   if path.ends_with(".png"):specs.append([anim,path])
 var canvas=SubViewport.new();canvas.size=Vector2i(1440,ceili(specs.size()/9.)*190+40);canvas.render_target_update_mode=SubViewport.UPDATE_ALWAYS;add_child(canvas)
 var bg=ColorRect.new();bg.color=Color("10252d");bg.size=canvas.size;canvas.add_child(bg)
 for i in specs.size():
  var a=specs[i];var frame=int(a[1].get_basename().trim_prefix("frame_"));var tex=TextureRect.new();tex.position=Vector2(i%9*160,40+int(i/9)*190);tex.size=Vector2(156,156);tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;tex.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;tex.texture=HorseAppearance.texture(load("res://art/player/%s/%s"%[a[0],a[1]]),a[0],frame,h.traits,null,null,HorseGalaxyLook.state(h));canvas.add_child(tex)
  var l=Label.new();l.text=a[0]+" "+str(frame);l.add_theme_font_size_override("font_size",14);l.position=tex.position+Vector2(0,156);canvas.add_child(l)
 await get_tree().create_timer(.5).timeout;await RenderingServer.frame_post_draw
 canvas.get_texture().get_image().save_png("/downloads/galaxy-classic-%s83.png"%("normal" if normal else "master"));print("CLASSIC frames=",specs.size());get_tree().quit()
