extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var bg:=ColorRect.new();bg.color=Color("16333c");bg.size=Vector2(1280,720);root.add_child(bg)
 var coats=[10,4,1,14,7,12]
 for i in range(6):
  var view:=TextureRect.new();view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;view.position=Vector2(i%3*425,36+int(i/3)*340);view.size=Vector2(415,310);root.add_child(view)
  HorsePortrait.apply(view,{"coat":coats[i],"mane":5 if i%2==0 else i%5,"pattern":0,"finish":"normal"},["original","blue","sand"][i%3])
  var label:=Label.new();label.position=view.position+Vector2(12,-26);label.text="Coat %d / mane %d"%[coats[i],5 if i%2==0 else i%5];root.add_child(label)
 await create_timer(.5).timeout;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/hd39-variants.png");quit()
