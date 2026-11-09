extends Node
func _ready()->void:call_deferred("run")
func run()->void:
 get_tree().root.size=Vector2i(1152,768)
 var bg:=ColorRect.new();bg.color=Color("10262f");bg.size=Vector2(1152,768);add_child(bg)
 for i in range(3):
  var view:=TextureRect.new();view.position=Vector2(i*384,32);view.size=Vector2(384,700);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;add_child(view)
  HorsePortrait.apply(view,{"coat":8,"mane":3,"pattern":[4,0,2][i]})
  var label:=Label.new();label.text=["Patas claras","Liso · control","Moteado · control"][i];label.position=Vector2(i*384+25,5);label.add_theme_font_size_override("font_size",24);add_child(label)
 await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png(OS.get_environment("SOCK_CAPTURE"))
 get_tree().quit()
