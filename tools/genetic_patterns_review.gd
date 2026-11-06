extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var bg:=ColorRect.new();bg.size=Vector2(1280,1440);bg.color=Color("10252d");root.add_child(bg)
 var patterns:Array=[2,5,6,7,8,9]
 for i in range(patterns.size()):
  var col:int=i%3;var row:int=i/3;var x:float=col*426;var y:float=row*700
  var t:Dictionary={"coat":19,"pattern":patterns[i],"mane":3,"eyes":10}
  var title:=Label.new();title.text=HorseCollection.PATTERNS[patterns[i]];title.position=Vector2(x+35,y+18);title.add_theme_font_size_override("font_size",26);root.add_child(title)
  var view:=TextureRect.new();view.size=Vector2(405,425);view.position=Vector2(x+10,y+55);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;root.add_child(view);HorsePortrait.apply(view,t,"blue")
  var source:Texture2D=load("res://art/player/walk_diag_down/frame_00.png");var small:=Sprite2D.new();small.texture=HorseAppearance.texture(source,"walk_diag_down",0,t);small.position=Vector2(x+115,y+558);small.scale=Vector2.ONE*2;root.add_child(small)
  var foal:=Sprite2D.new();foal.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,t);foal.position=Vector2(x+305,y+565);foal.scale=Vector2.ONE*.42;root.add_child(foal)
 var footer:=Label.new();footer.text="CANDIDATOS · adulto / gameplay / potrillo · sin APK nueva";footer.position=Vector2(35,1405);footer.add_theme_font_size_override("font_size",22);root.add_child(footer)
 for j in range(6):await process_frame
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/rancho-genetic-patterns.png");print("PATTERNS_REVIEW_OK");quit()
