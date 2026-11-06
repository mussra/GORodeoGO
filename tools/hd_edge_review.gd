extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var bg:=ColorRect.new();bg.color=Color("16333c");bg.size=Vector2(1280,720);root.add_child(bg)
 var view:=TextureRect.new();view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;view.position=Vector2(220,0);view.size=Vector2(840,720);root.add_child(view)
 HorsePortrait.apply(view,{"coat":4,"mane":5,"pattern":0,"finish":"normal"},"blue")
 await create_timer(.5).timeout;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/hd40-edge-review.png");quit()
