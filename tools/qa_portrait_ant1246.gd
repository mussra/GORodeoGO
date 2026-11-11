extends Node2D
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,900)
 var bg=ColorRect.new();bg.size=Vector2(1280,900);bg.color=Color("183139");add_child(bg)
 var old=ImageTexture.create_from_image(Image.load_from_file("/downloads/portrait-mask-before1246.png"));var edited=ImageTexture.create_from_image(Image.load_from_file("/downloads/portrait-mask-after1246.png"))
 var ts=[{"coat":3,"pattern":0,"mane":2,"eyes":4},{"coat":1,"pattern":11,"mane":4,"eyes":3},{"coat":12,"pattern":10,"mane":0,"eyes":5}]
 for row in 3:
  for col in 2:
   var tex=TextureRect.new();tex.position=Vector2(110+col*620,70+row*270);tex.size=Vector2(420,250);tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;add_child(tex)
   HorsePortrait.apply(tex,ts[row],"blue");tex.material.set_shader_parameter("region_mask",old if col==0 else edited)
   var label=Label.new();label.position=Vector2(90+col*620,35+row*270);label.add_theme_font_size_override("font_size",23);label.text=("ANTES" if col==0 else "RETOQUE ANT")+" · "+["Azul / crin dorada","Vaca / crin roja","Jirafa / crin negra"][row];add_child(label)
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/portrait-ant1246-before-after.png");get_tree().quit()
