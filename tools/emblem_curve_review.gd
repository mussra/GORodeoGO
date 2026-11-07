extends SceneTree
## Flat vs curved emblem, portrait + idle sprite, side by side at phone size.
func _initialize()->void:call_deferred("run")
func run()->void:
 root.size=Vector2i(1599,719)
 var bg:=ColorRect.new();bg.set_anchors_preset(Control.PRESET_FULL_RECT);bg.color=Color("16333c");root.add_child(bg)
 var traits:Dictionary={"coat":3,"mane":1,"pattern":0,"finish":"normal","emblem":HorseEmblem.DEFAULT.duplicate()}
 for i in range(2):
  HorseEmblem.warp_amount=0.0 if i==0 else 0.12
  HorseEmblem.cache.clear();HorseAppearance.cache.clear()
  var pv:=TextureRect.new();pv.position=Vector2(40+i*560,20);pv.size=Vector2(520,640)
  pv.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;pv.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  HorsePortrait.apply(pv,traits)
  root.add_child(pv)
  var lb:=Label.new();lb.text="flat" if i==0 else "curved";lb.position=Vector2(60+i*560,24);root.add_child(lb)
  var sv:=TextureRect.new()
  sv.texture=HorseAppearance.texture(load("res://art/player/idle/frame_00.png"),"idle",0,traits)
  sv.position=Vector2(1160,80+i*300);sv.size=Vector2(280,280)
  sv.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;sv.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  sv.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
  root.add_child(sv)
  var sl:=Label.new();sl.text="idle flat" if i==0 else "idle curved";sl.position=Vector2(1170,60+i*300);root.add_child(sl)
 HorseEmblem.warp_amount=0.12
 await create_timer(.3).timeout;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/emblem-curve-compare.png")
 quit()
