extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var bg:=ColorRect.new();bg.size=Vector2(1000,600);bg.color=Color("18333d");root.add_child(bg)
 var views:Array=[]
 for i in range(2):
  var view:=Sprite2D.new();view.position=Vector2(250+500*i,300);view.scale=Vector2(4,4);view.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;root.add_child(view);views.append(view)
  var label:=Label.new();label.text=["Galope - base aprobada","Galope - manchas / crin y cola"][i];label.position=Vector2(35+500*i,25);label.add_theme_font_size_override("font_size",23);root.add_child(label)
 for frame in range(12):
  var source:Texture2D=load("res://art/player/walk_diag_down/frame_%02d.png"%frame)
  views[0].texture=source
  views[1].texture=HorseAppearance.texture(source,"walk_diag_down",frame,{"coat":0,"mane":3,"pattern":1})
  for j in range(2):await process_frame
  await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/frontal-runtime-%02d.png"%frame)
 quit()
