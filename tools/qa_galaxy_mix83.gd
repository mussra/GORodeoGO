extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,900)
 var bg=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1280,900);add_child(bg)
 var header=Label.new();header.position=Vector2(28,14);header.text="Pruebas de color Galaxy · mismo retrato y shader, sin dibujar unicornio nuevo";header.add_theme_font_size_override("font_size",23);add_child(header)
 var configs=[["Rosa puro",Color("310b27"),Color("ed4fa6"),false],["Rosa + azul",Color("310b27"),Color("ed4fa6"),true],["Rojo puro",Color("350b17"),Color("ef3e55"),false],["Rojo + azul",Color("350b17"),Color("ef3e55"),true]]
 for i in configs.size():
  var c=configs[i];var origin=Vector2(25+(i%2)*635,68+int(i/2)*390)
  var title=Label.new();title.position=origin;title.text=c[0];title.add_theme_font_size_override("font_size",26);add_child(title)
  var tex=TextureRect.new();HorsePortrait.apply_horse(tex,{"traits":{"coat":3,"pattern":0,"mane":0,"finish":"galaxy"}},"original")
  tex.position=origin+Vector2(40,28);tex.size=Vector2(500,350);add_child(tex)
  tex.material.set_shader_parameter("galaxy_palette_preview",true);tex.material.set_shader_parameter("galaxy_dark",c[1]);tex.material.set_shader_parameter("galaxy_light",c[2]);tex.material.set_shader_parameter("galaxy_blue_mix",c[3])
 var note=Label.new();note.position=Vector2(28,865);note.text="Solo comparación de paleta. No fija genes, rareza, capacidad ni aspecto final del unicornio. Sin APK.";note.add_theme_font_size_override("font_size",18);add_child(note)
 await get_tree().create_timer(1).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/galaxy-mixes83.png");get_tree().quit()
