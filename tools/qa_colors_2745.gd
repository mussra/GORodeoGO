extends Node
func _ready()->void:call_deferred("run")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1440,840)
 var stage:=Node2D.new();stage.scale=Vector2(.65,.65);add_child(stage)
 var bg:=ColorRect.new();bg.color=Color("10262f");bg.size=Vector2(1440,840);stage.add_child(bg)
 var combinations=[{"coat":10,"mane":0,"pattern":0,"legs":0},{"coat":8,"mane":3,"pattern":4,"legs":3},{"coat":2,"mane":0,"pattern":10,"spots":10},{"coat":3,"mane":1,"pattern":10,"spots":1},{"coat":1,"mane":0,"pattern":9,"spots":0},{"coat":1,"mane":0,"pattern":11,"spots":0}]
 var names=["Mustang","Patas azules","Jirafa clásica","Jirafa azul","Cebra","Vaca"]
 if OS.get_environment("PATTERN_VARIANTS")=="1":
  combinations=[{"coat":12,"mane":0,"pattern":10,"spots":10},{"coat":3,"mane":1,"pattern":10,"spots":1},{"coat":8,"mane":4,"pattern":10,"spots":6},{"coat":1,"mane":0,"pattern":11,"spots":0},{"coat":13,"mane":1,"pattern":11,"spots":12},{"coat":3,"mane":0,"pattern":11,"spots":8}]
  names=["Jirafa crema","Jirafa azul","Jirafa rosa","Vaca clásica","Vaca cobre","Vaca azul"]
 for i in range(combinations.size()):
  var t:Dictionary=combinations[i]
  var title:=Label.new();title.text=names[i];title.position=Vector2(i*288+12,10);title.add_theme_font_size_override("font_size",22);stage.add_child(title)
  var view:=TextureRect.new();view.position=Vector2(i*288,55);view.size=Vector2(288,400);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;stage.add_child(view);HorsePortrait.apply(view,t)
  for j in range(2):
   var small:=TextureRect.new();small.texture=HorseAppearance.texture(load("res://art/player/walk_diag_down/frame_%02d.png"%[j*5]),"walk_diag_down",j*5,t);small.position=Vector2(i*288+j*140,485);small.size=Vector2(140,140);small.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;stage.add_child(small)
  var foal:=TextureRect.new();foal.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,t);foal.position=Vector2(i*288,640);foal.size=Vector2(160,185);foal.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;foal.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;stage.add_child(foal)
  var wild:=TextureRect.new();wild.texture=HorseAppearance.texture(load("res://art/world/wild_base/walk_side/frame_00.png"),"wild_walk_side",0,t);wild.position=Vector2(i*288+150,670);wild.size=Vector2(140,140);wild.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;stage.add_child(wild)
 await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/patterns2745-variants.png" if OS.get_environment("PATTERN_VARIANTS")=="1" else "/downloads/colors2745.png")
 get_tree().quit()
