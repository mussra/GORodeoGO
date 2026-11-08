extends SceneTree
## Visual check (Ant 8-nov-2026): new 12-frame gallop_side art through the real
## pipeline (SpriteSwap load + HorseAppearance tint + hat variants).
## Deterministic per-frame captures -> strip sheets per variant + loose frames
## for mp4 assembly outside Godot.
func _initialize()->void:call_deferred("setup")
func shot(path:String)->void:
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(path)
func setup()->void:
 var variants:Array=[
  {"label":"original","t":{},"hat":"original"},
  {"label":"capa azul + crin crema","t":{"coat":3,"mane":1,"pattern":0},"hat":"original"},
  {"label":"capa roja + crin oscura + moteado","t":{"coat":5,"mane":0,"pattern":2},"hat":"blue"},
  {"label":"capa negra + crin oscura","t":{"coat":0,"mane":0,"pattern":0},"hat":"sand"},
 ]
 var col:=0
 for v in variants:
  var stage=Node2D.new();root.add_child(stage)
  var bg=ColorRect.new();bg.color=Color("7fae6e");bg.size=Vector2(1280,240);stage.add_child(bg)
  var host=Node2D.new();host.position=Vector2(120,130);host.scale=Vector2(2.0,2.0);stage.add_child(host)
  var placeholder=Polygon2D.new();host.add_child(placeholder)
  var swap:=SpriteSwap.new(host,placeholder,HatAppearance.art_root(v.hat),["gallop_side"])
  if not (v.t as Dictionary).is_empty():HorseAppearance.apply(swap._frames,v.t)
  swap.play("gallop_side")
  swap._sprite.pause()
  for i in range(12):
   swap._sprite.frame=i
   await create_timer(0.05).timeout
   await shot("/downloads/gallop-preview-v%d-f%02d.png"%[col,i])
  stage.free()
  col+=1
 quit()
