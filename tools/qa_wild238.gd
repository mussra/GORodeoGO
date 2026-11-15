extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,900);TranslationServer.set_locale("es")
 SaveData.save_path="user://wild238-visual.cfg";SaveData._load_valid=true;SaveData.debug_mode=true;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1280,900);add_child(bg)
 for k in 6:
  var t:Dictionary={"coat":12,"pattern":12+k,"spots":0,"mane":1,"finish":"normal","coat_style238":"rainbow" if k%2==0 else "flat","spots_style238":"rainbow" if k%2==1 else "flat"}
  var x:int=20+(k%3)*420;var y:int=20+(k/3)*440
  var label:=Label.new();label.text=HorseCollection.PATTERNS[12+k];label.position=Vector2(x,y);label.add_theme_font_size_override("font_size",24);add_child(label)
  var portrait:=TextureRect.new();portrait.position=Vector2(x,y+35);portrait.size=Vector2(260,310);portrait.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;portrait.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;add_child(portrait);HorsePortrait.apply(portrait,t)
  var foal:=TextureRect.new();foal.position=Vector2(x+265,y+60);foal.size=Vector2(140,140);foal.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;foal.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;foal.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,t);add_child(foal)
  for j in 5:
   var view:String=["side","down","up","diag_down","diag_up"][j]
   var sprite:=TextureRect.new();sprite.position=Vector2(x+j*78,y+348);sprite.size=Vector2(76,76);sprite.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;sprite.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;sprite.texture=PixelLabTrial.pose_texture("rider",view,0,t);add_child(sprite)
  var drink:=TextureRect.new();drink.position=Vector2(x+265,y+210);drink.size=Vector2(140,120);drink.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;drink.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;drink.texture=HorseDrink.texture(k%2,t,"original");add_child(drink)
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/wild238-integrated.png")
 for child in get_children():child.queue_free()
 await get_tree().process_frame
 SaveData.horse_collection.find("trial_a").traits={"coat":12,"pattern":12,"spots":0,"mane":1,"finish":"normal","coat_style238":"rainbow","spots_style238":"flat"};SaveData.horse_collection.selected="trial_a";SaveData.save_progress()
 var panel:=HatPanel.new();add_child(panel);await get_tree().process_frame;panel._color.select(21);panel._finish.select(12);panel._ink.select(0);panel._update_preview()
 for i in 3:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/wild238-hat.png")
 panel.free()
 var editor:=HorsePanel.new();editor.page="detail";editor.focus_id="trial_a";add_child(editor)
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/wild238-editor-top.png")
 for node in editor.find_children("*","ScrollContainer",true,false):node.scroll_vertical=10000
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/wild238-editor-bottom.png")
 get_tree().quit()
