extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(936,983)
 var sub:=SubViewport.new();sub.size=Vector2i(936,983);sub.transparent_bg=true;sub.render_target_update_mode=SubViewport.UPDATE_ALWAYS;add_child(sub)
 var view:=TextureRect.new();view.size=Vector2(936,983);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;sub.add_child(view)
 for base in [12,2,1,13,3,20]:
  var t:Dictionary={"coat":mini(base,19),"pattern":12,"spots":0,"mane":1,"finish":"normal"}
  if base==20:t.coat_style238="rainbow"
  HorsePortrait.apply(view,t)
  for i in 3:await get_tree().process_frame
  await RenderingServer.frame_post_draw
  sub.get_texture().get_image().save_png("/downloads/wild238/palette239-horse-%d.png"%base)
 var gradient:=Image.create(600,80,false,Image.FORMAT_RGBA8)
 for x in 600:
  var color:Color=HorseAppearance.soft_rainbow(float(x)/599.)
  for y in 80:gradient.set_pixel(x,y,color)
 gradient.save_png("/downloads/wild238/palette239-rainbow.png")
 get_tree().quit()
