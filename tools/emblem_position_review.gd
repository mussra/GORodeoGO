extends SceneTree
## Current emblem placement per animation + portrait, one sheet, phone window.
func _initialize()->void:call_deferred("run")
func run()->void:
 root.size=Vector2i(1599,719)
 var bg:=ColorRect.new();bg.set_anchors_preset(Control.PRESET_FULL_RECT);bg.color=Color("16333c");root.add_child(bg)
 var traits:Dictionary={"coat":3,"mane":1,"pattern":0,"finish":"normal","emblem":HorseEmblem.DEFAULT.duplicate()}
 var anims=["idle","walk_side","walk_diag_down","walk_diag_up","walk_up","walk_down","jump_side","jump_diag_down","jump_diag_up","jump_up","jump_down","stunned"]
 for i in range(anims.size()):
  var anim:String=anims[i]
  var path:String="res://art/player/%s/frame_00.png"%anim
  if anim=="stunned":path="res://art/player/stunned/frame_0.png"
  var view:=TextureRect.new()
  view.texture=HorseAppearance.texture(load(path),anim,0,traits)
  view.position=Vector2(20+i%5*240,30+int(i/5)*230);view.size=Vector2(230,220)
  view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  root.add_child(view)
  var lb:=Label.new();lb.text=anim;lb.position=view.position+Vector2(4,200);root.add_child(lb)
 var pv:=TextureRect.new();pv.position=Vector2(1220,30);pv.size=Vector2(360,660)
 pv.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;pv.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 HorsePortrait.apply(pv,traits)
 root.add_child(pv)
 var pl:=Label.new();pl.text="portrait";pl.position=Vector2(1224,690);root.add_child(pl)
 await create_timer(.3).timeout;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/emblem-position-current.png")
 quit()
