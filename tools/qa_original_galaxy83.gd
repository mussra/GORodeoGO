extends Node
var canvas:SubViewport
func _ready():run.call_deferred()
func label_at(t:String,p:Vector2,w:float,fs:int=26):
 var l=Label.new();l.text=t;l.position=p;l.size.x=w;l.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;l.add_theme_font_size_override("font_size",fs);canvas.add_child(l)
func run():
 TranslationServer.set_locale("es")
 canvas=SubViewport.new();canvas.size=Vector2i(1080,555);canvas.render_target_update_mode=SubViewport.UPDATE_ALWAYS;add_child(canvas)
 var bg=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1080,555);canvas.add_child(bg)
 label_at("Galaxy normal · Nebulosa en el tono del original",Vector2(0,16),1080,34)
 label_at("Nubes cálidas visibles desde 0% · Sin aura ni sol/luna",Vector2(0,62),1080,24)
 var configs=[["Original del juego","29180e","d0742f",false],["Original + Galaxy sutil","29180e","d0742f",false]]
 var c=HorseCollection.new();c.seed_trial();var h=c.find("original");h.traits.finish="galaxy";h.traits.emblem=HorseEmblem.DEFAULT.duplicate(true)
 h["completed_levels"]=[1,2,3,4];h.traits.erase("emblem")
 var greek=OS.get_cmdline_user_args().has("greek")
 label_at("CON letras griegas" if greek else "SIN letras",Vector2(0,103),1080,23)
 for col in 3:
  label_at(["0%","50%","95%"][col],Vector2(col*360,132),360,30)
  h["completed_levels"]=[]
  for n in range(1,[1,11,20][col]):h.completed_levels.append(n)
  for row in 1:
   var tex=TextureRect.new();tex.position=Vector2(col*360+20,175+row*380);tex.size=Vector2(320,330);HorsePortrait.apply_horse(tex,h);canvas.add_child(tex)
   tex.material.set_shader_parameter("mastery_greek_preview",greek)
   tex.material.set_shader_parameter("galaxy_original_base",false)
   tex.material.set_shader_parameter("original_horse",false)
   tex.material.set_shader_parameter("galaxy_quiet",Color(.58,.39,.23))
   tex.material.set_shader_parameter("galaxy_intensity",.72)
   tex.material.set_shader_parameter("galaxy_dark",Color("78401a"));tex.material.set_shader_parameter("galaxy_light",Color("f3b065"));tex.material.set_shader_parameter("galaxy_blue_mix",false);tex.material.set_shader_parameter("mastery_mark_scale",.7)
   label_at("Nebulosa + estrellas",Vector2(col*360,510+row*380),360,24)
 await get_tree().create_timer(.8).timeout;await RenderingServer.frame_post_draw
 canvas.get_texture().get_image().save_png("/downloads/galaxy-master-marks-greek83.png" if greek else "/downloads/galaxy-original-nebula-lighter283.png");get_tree().quit()
