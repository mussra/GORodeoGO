extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var bg:=ColorRect.new();bg.size=Vector2(1200,600);bg.color=Color("18333d");root.add_child(bg)
 for n in range(12):
  var view:=Sprite2D.new();view.position=Vector2(100+(n%6)*200,150+int(n/6)*300);view.scale=Vector2(2.5,2.5);root.add_child(view)
  var source:Texture2D=load("res://art/player/walk_diag_up/frame_%02d.png"%n);view.texture=HorseAppearance.texture(source,"walk_diag_up",n,{"coat":18,"mane":3,"pattern":1})
 for i in range(4):await process_frame
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/ascending2-masks.png");quit()
