extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var panel:Node=load("res://src/Presentation/horse_panel.gd").new();root.add_child(panel);panel.focus_id="";panel.focus_preview={"name":"Ciruela","traits":{"coat":19,"pattern":2,"mane":3,"eyes":10},"stage":"adult"};panel.show_page("detail")
 for i in range(5):await process_frame
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/moteado-ciruela-natural.png")
 panel.hide()
 var bg:=ColorRect.new();bg.size=Vector2(1280,720);bg.color=Color("10252d");root.add_child(bg)
 for i in range(3):
  var traits:Dictionary={"coat":[19,3,10][i],"pattern":2,"mane":[3,1,2][i],"eyes":10}
  var view:=TextureRect.new();view.size=Vector2(380,410);view.position=Vector2(20+420*i,20);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;root.add_child(view);HorsePortrait.apply(view,traits,"blue")
  var source:Texture2D=load("res://art/player/walk_diag_down/frame_00.png");var small:=Sprite2D.new();small.texture=HorseAppearance.texture(source,"walk_diag_down",0,traits);small.position=Vector2(210+420*i,535);small.scale=Vector2.ONE*2;root.add_child(small)
 for i in range(5):await process_frame
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/moteado-materiales-natural.png");print("SPOTS_COUNT ",HorseAppearance.spots().size());quit()
