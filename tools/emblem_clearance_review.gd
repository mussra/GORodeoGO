extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 root.size=Vector2i(1599,719)
 var bg:=ColorRect.new();bg.set_anchors_preset(Control.PRESET_FULL_RECT);bg.color=Color("16333c");root.add_child(bg)
 var traits:Dictionary={"coat":3,"mane":1,"pattern":0,"finish":"normal","emblem":HorseEmblem.DEFAULT.duplicate()}
 var cases=[["idle",0],["idle",3],["walk_side",0],["walk_side",6],["walk_diag_up",0],["walk_diag_up",8],["jump_side",0],["stunned",0]]
 for i in range(cases.size()):
  var anim:String=cases[i][0];var frame:int=cases[i][1]
  var fname:String="frame_%02d.png"%frame
  if anim=="stunned":fname="frame_0.png"
  var view:=TextureRect.new()
  view.texture=HorseAppearance.texture(load("res://art/player/%s/%s"%[anim,fname]),anim,frame,traits)
  view.position=Vector2(10+i*197,40);view.size=Vector2(190,570)
  view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  view.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
  # crop to the thigh half of the 96px sprite
  var atlas:=AtlasTexture.new();atlas.atlas=view.texture;atlas.region=Rect2(8,28,64,60)
  view.texture=atlas
  root.add_child(view)
  var lb:=Label.new();lb.text="%s f%02d"%[anim,frame];lb.position=Vector2(14+i*197,620);lb.add_theme_font_size_override("font_size",15);root.add_child(lb)
 await create_timer(.3).timeout;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/emblem-clearance-zoom.png")
 quit()
