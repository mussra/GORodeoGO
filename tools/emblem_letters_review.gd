extends SceneTree
## Letters preview: ALV on the emblem, Graduate vs Cinzel, portrait at phone size.
func _initialize()->void:call_deferred("run")
func run()->void:
 root.size=Vector2i(1599,719)
 var bg:=ColorRect.new();bg.set_anchors_preset(Control.PRESET_FULL_RECT);bg.color=Color("16333c");root.add_child(bg)
 for i in range(2):
  var traits:Dictionary={"coat":3,"mane":1,"pattern":0,"finish":"normal","emblem":HorseEmblem.DEFAULT.duplicate()}
  traits.emblem["letters"]="ALV";traits.emblem["letters_font"]=i
  var pv:=TextureRect.new();pv.position=Vector2(120+i*720,20);pv.size=Vector2(620,660)
  pv.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;pv.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  HorsePortrait.apply(pv,traits)
  root.add_child(pv)
  var lb:=Label.new();lb.text="Graduate" if i==0 else "Cinzel";lb.position=Vector2(140+i*720,26);lb.add_theme_font_size_override("font_size",26);root.add_child(lb)
 await create_timer(.3).timeout;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/emblem-letters-fonts.png")
 quit()
