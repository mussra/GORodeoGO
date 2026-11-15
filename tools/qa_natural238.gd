extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(936,983)
 var sub:=SubViewport.new();sub.size=Vector2i(936,983);sub.transparent_bg=true;sub.render_target_update_mode=SubViewport.UPDATE_ALWAYS;add_child(sub)
 var view:=TextureRect.new();view.size=Vector2(936,983);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;sub.add_child(view)
 var specs:Array=[[12,12,0],[13,2,0],[14,2,0],[15,12,0],[16,12,0],[17,1,0],[9,1,0],[10,12,10],[11,1,0]]
 for spec in specs:
  HorsePortrait.apply(view,{"coat":spec[1],"pattern":spec[0],"spots":spec[2],"mane":1,"finish":"normal"})
  for i in 3:await get_tree().process_frame
  await RenderingServer.frame_post_draw
  sub.get_texture().get_image().save_png("/downloads/wild238/natural-horse-%d.png"%spec[0])
 get_tree().quit()
