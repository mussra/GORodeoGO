extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var view:=TextureRect.new();view.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,{"coat":6,"pattern":0,"mane":5,"eyes":3});view.size=Vector2(600,690);view.position=Vector2(300,10);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;root.add_child(view)
 for i in range(5):await process_frame
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/eyes-foal-integrated.png");quit()
