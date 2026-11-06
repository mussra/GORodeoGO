extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var bg:=ColorRect.new();bg.size=Vector2(1280,1050);bg.color=Color("10252d");root.add_child(bg)
 for i in range(2):
  var t:Dictionary={"coat":19,"pattern":2,"mane":3,"eyes":20+i}
  var title:=Label.new();title.text="Ojos "+HorseCollection.EYES[20+i];title.position=Vector2(30+640*i,18);title.add_theme_font_size_override("font_size",28);root.add_child(title)
  var view:=TextureRect.new();view.size=Vector2(600,620);view.position=Vector2(20+640*i,50);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;root.add_child(view);HorsePortrait.apply(view,t,"blue")
  var f:=Sprite2D.new();f.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,t);f.position=Vector2(170+640*i,830);f.scale=Vector2.ONE*.85;root.add_child(f)
  var joy:=TextureRect.new();joy.texture=JoystickAppearance.texture_for(t,false);joy.position=Vector2(355+640*i,735);joy.size=Vector2(190,190);root.add_child(joy)
 for j in range(6):await process_frame
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/rancho-special-eyes.png")
 var next:=ColorRect.new();next.size=Vector2(1280,1050);next.color=Color("10252d");root.add_child(next)
 var t:Dictionary={"coat":19,"pattern":0,"mane":3,"eyes":21,"finish":"galaxy"}
 var title:=Label.new();title.text="Galaxy · primera integración del estudio estático";title.position=Vector2(30,20);title.add_theme_font_size_override("font_size",28);root.add_child(title)
 var view:=TextureRect.new();view.size=Vector2(650,850);view.position=Vector2(25,90);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;root.add_child(view);HorsePortrait.apply(view,t,"blue")
 var f:=Sprite2D.new();f.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,t);f.position=Vector2(970,730);root.add_child(f)
 var sp:=Sprite2D.new();sp.texture=HorseAppearance.texture(load("res://art/player/walk_diag_down/frame_00.png"),"walk_diag_down",0,t);sp.position=Vector2(950,290);sp.scale=Vector2.ONE*4;root.add_child(sp)
 for j in range(6):await process_frame
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/rancho-galaxy-integrated.png");print("SPECIAL_EYES_OK");quit()
