extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var bg:=ColorRect.new();bg.size=Vector2(1280,720);bg.color=Color("16333c");root.add_child(bg)
 var anims=["idle","stunned","walk_side","walk_diag_down","walk_diag_up","walk_up","walk_down"]
 for i in range(7):
  var anim:String=anims[i];var path:String="res://art/player/%s/frame_%02d.png"%[anim,0]
  if anim=="stunned":path="res://art/player/stunned/frame_0.png"
  var view:=TextureRect.new();view.texture=HorseAppearance.texture(load(path),anim,0,{"coat":3,"mane":5,"pattern":0,"finish":"normal"});view.position=Vector2(i%4*320,int(i/4)*240);view.size=Vector2(320,240);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;root.add_child(view)
 await create_timer(.2).timeout;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/all-directions-mask.png");quit()
