extends Node
var canvas:SubViewport
func _ready():run.call_deferred()
func label_at(t:String,p:Vector2,w:float,fs:int=26):
 var l=Label.new();l.text=t;l.position=p;l.size.x=w;l.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;l.add_theme_font_size_override("font_size",fs);canvas.add_child(l)
func run():
 TranslationServer.set_locale("es")
 canvas=SubViewport.new();canvas.size=Vector2i(1800,1345);canvas.render_target_update_mode=SubViewport.UPDATE_ALWAYS;add_child(canvas)
 var bg=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1800,1345);canvas.add_child(bg)
 label_at("PROPUESTA · Alfa y omega · Sol + luna del maestro",Vector2(0,16),1800,34)
 label_at("Colores candidatos, no variantes desbloqueadas · Normal: un solo lavanda",Vector2(0,62),1800,24)
 var configs=[["Azul","030b20","477ce7",false],["Rosa","18031a","ed4fa6",true],["Verde","03150d","44d9ad",false],["Rojo","1a0310","ef3e55",true],["Negro","010207","65728e",false]]
 var c=HorseCollection.new();c.seed_trial();var h=c.find("original");h.traits.finish="galaxy";h.traits.emblem=HorseEmblem.DEFAULT.duplicate(true)
 for n in range(1,21):HorseMastery.record(c,h.id,n)
 var greek=OS.get_cmdline_user_args().has("greek")
 label_at("CON letras griegas" if greek else "SIN letras",Vector2(0,103),1800,23)
 for col in 5:
  label_at(configs[col][0],Vector2(col*360,132),360,30)
  for row in 3:
   var tex=TextureRect.new();tex.position=Vector2(col*360+20,175+row*380);tex.size=Vector2(320,330);HorsePortrait.apply_horse(tex,h);canvas.add_child(tex)
   tex.material.set_shader_parameter("mastery_greek_preview",greek)
   tex.material.set_shader_parameter("galaxy_dark",Color(configs[col][1]));tex.material.set_shader_parameter("galaxy_light",Color(configs[col][2]));tex.material.set_shader_parameter("galaxy_blue_mix",configs[col][3]);tex.material.set_shader_parameter("mastery_mark_scale",[.7,1.,1.4][row])
   label_at(["S · 70%","M · 100%","L · 140%"][row],Vector2(col*360,510+row*380),360,24)
 await get_tree().create_timer(.8).timeout;await RenderingServer.frame_post_draw
 canvas.get_texture().get_image().save_png("/downloads/galaxy-master-marks-greek83.png" if greek else "/downloads/galaxy-master-marks-grid83.png");get_tree().quit()
