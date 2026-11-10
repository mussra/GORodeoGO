extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720)
 var bg=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1280,720);add_child(bg)
 var variants=[{"coat":18,"mane":4,"pattern":3,"eyes":10,"finish":"normal"},{"coat":12,"mane":5,"pattern":4,"eyes":10,"finish":"normal"},{"coat":18,"mane":0,"pattern":0,"legs":1,"eyes":10,"finish":"normal"},{"coat":12,"mane":4,"pattern":0,"legs":0,"eyes":10,"finish":"normal"}]
 for i in variants.size():
  var x=320*i;var l=Label.new();l.text=["Celeste · patas naturales","Crema · patas naturales","Celeste · patas blancas","Crema · patas negras"][i];l.position=Vector2(x+12,10);add_child(l)
  var adult=TextureRect.new();adult.position=Vector2(x,40);adult.size=Vector2(320,350);adult.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;adult.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;HorsePortrait.apply(adult,variants[i]);add_child(adult)
  var foal=TextureRect.new();foal.position=Vector2(x+20,400);foal.size=Vector2(280,300);HorsePortrait.apply_horse(foal,{"stage":"foal","traits":variants[i]});add_child(foal)
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/foal-adult2773.png");get_tree().quit()
