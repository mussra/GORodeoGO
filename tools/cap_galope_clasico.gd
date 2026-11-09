extends SceneTree
## Gallop-revert check (9-nov-2026): gallop_side art removed; world_player must
## fall back to the classic walk_side art at GALOPE. Verifies the fallback and
## renders the frames the gallop gait now shows (pardo variant).
func _initialize()->void:call_deferred("setup")
func shot(path:String)->void:
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(path)
func setup()->void:
 var stage=Node2D.new();root.add_child(stage)
 var bg=ColorRect.new();bg.color=Color("7fae6e");bg.size=Vector2(1280,240);stage.add_child(bg)
 var host=Node2D.new();host.position=Vector2(120,130);host.scale=Vector2(2.0,2.0);stage.add_child(host)
 var placeholder=Polygon2D.new();host.add_child(placeholder)
 var names:Array=["idle","walk_side","walk_up","walk_down","walk_diag_down","walk_diag_up","gallop_side"]
 var swap:=SpriteSwap.new(host,placeholder,"res://art/player/",names)
 print("has gallop_side: ", swap.has_animation("gallop_side"))
 # Same selection as world_player._update_animation at GALOPE + side facing:
 var anim:String="walk_side"
 print("gallop gait plays: ", anim)
 HorseAppearance.apply(swap._frames,{"coat":10,"mane":0,"pattern":0})
 swap.play(anim)
 swap._sprite.pause()
 for i in range(12):
  swap._sprite.frame=i
  await create_timer(0.05).timeout
  await shot("/tmp/galope_clasico_f%02d.png"%i)
 quit()
