extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,900);TranslationServer.set_locale("es")
 var bg=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1280,900);add_child(bg)
 var header=Label.new();header.position=Vector2(24,16);header.text="Galaxy · estrellas y nebulosas · cinco variantes reservadas a unicornios";header.add_theme_font_size_override("font_size",23);add_child(header)
 var configs=[["Galaxy azul",Color("030b20"),Color("477ce7"),false],["Galaxy rosa + azul",Color("18031a"),Color("ed4fa6"),true],["Galaxy verde",Color("03150d"),Color("44d9ad"),false],["Galaxy rojo + azul",Color("1a0310"),Color("ef3e55"),true],["Galaxy negro",Color("010207"),Color("65728e"),false]]
 for i in configs.size():
  var c=configs[i];var origin=Vector2(20+(i%3)*420,70+int(i/3)*390)
  var title=Label.new();title.position=origin;title.text=c[0];title.add_theme_font_size_override("font_size",21);add_child(title)
  var tex=TextureRect.new();HorsePortrait.apply_horse(tex,{"traits":{"coat":3,"pattern":0,"mane":0,"finish":"galaxy"}},"original");tex.position=origin+Vector2(0,35);tex.size=Vector2(395,350);add_child(tex)
  tex.material.set_shader_parameter("galaxy_palette_preview",true);tex.material.set_shader_parameter("galaxy_dark",c[1]);tex.material.set_shader_parameter("galaxy_light",c[2]);tex.material.set_shader_parameter("galaxy_blue_mix",c[3])
 var note=Label.new();note.position=Vector2(24,865);note.text="Solo shader sobre retrato actual. No es arte final de unicornio. Sin APK ni cambios en los genes.";note.add_theme_font_size_override("font_size",18);add_child(note)
 await get_tree().create_timer(.8).timeout;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/galaxy-nebula83.png");get_tree().quit()
