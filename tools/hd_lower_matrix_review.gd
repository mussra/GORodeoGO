extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var bg:=ColorRect.new();bg.color=Color("16333c");bg.size=Vector2(1280,900);root.add_child(bg)
 for i in range(6):
  var holder:=Control.new();holder.position=Vector2((i%3)*425,int(i/3)*450);holder.size=Vector2(425,450);holder.clip_contents=true;root.add_child(holder)
  var view:=TextureRect.new();view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;view.position=Vector2(-320,-530);view.size=Vector2(1150,1000);holder.add_child(view)
  HorsePortrait.apply(view,{"coat":[4,1,7][i%3],"mane":0 if i<3 else 3,"pattern":0,"finish":"normal"},"blue")
 await create_timer(.5).timeout;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/hd-lower-matrix-review.png");quit()
