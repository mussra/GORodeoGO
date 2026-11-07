extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 root.size=Vector2i(1599,719)
 var bg:=ColorRect.new();bg.set_anchors_preset(Control.PRESET_FULL_RECT);bg.color=Color("16333c");root.add_child(bg)
 var traits:Dictionary={"coat":3,"mane":1,"pattern":0,"finish":"normal","emblem":HorseEmblem.DEFAULT.duplicate()}
 var names=["idle","walk_side","walk_diag_up"]
 for i in range(names.size()):
  var anim:String=names[i]
  var view:=TextureRect.new()
  view.texture=HorseAppearance.texture(load("res://art/player/%s/frame_00.png"%anim),anim,0,traits)
  view.position=Vector2(20+i*400,60);view.size=Vector2(390,390)
  view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  view.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
  root.add_child(view)
  var lb:=Label.new();lb.text=anim;lb.position=view.position+Vector2(4,360);root.add_child(lb)
 var pv:=TextureRect.new();pv.position=Vector2(1220,30);pv.size=Vector2(360,660)
 pv.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;pv.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 HorsePortrait.apply(pv,traits)
 root.add_child(pv)
 await create_timer(.3).timeout;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/emblem-zoom-current.png")
 quit()
