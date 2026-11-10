extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720)
 var bg=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1280,720);add_child(bg)
 var traits:Array=[{"coat":18,"mane":4,"pattern":5,"spots":2,"eyes":10,"finish":"normal"},{"coat":10,"mane":0,"pattern":0,"legs":0,"eyes":10,"finish":"normal"},{"coat":6,"mane":1,"pattern":2,"spots":1,"legs":3,"eyes":10,"finish":"normal"},{"coat":3,"mane":5,"pattern":11,"spots":1,"legs":5,"eyes":10,"finish":"normal"}]
 for i in traits.size():
  var v=TextureRect.new();v.position=Vector2(320*i,40);v.size=Vector2(320,600);v.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;v.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;HorsePortrait.apply(v,traits[i]);add_child(v)
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/adultmask2772-palettes.png");get_tree().quit()
