extends Node
func _ready()->void:call_deferred("run")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 await get_tree().create_timer(1.2).timeout
 var origin:Vector2=world.player.position
 world.player.hide()
 for row in range(2):
  for col in range(3):
   var pig=load("res://src/Presentation/wild_pig.gd").new();pig.setup({"pos":origin+Vector2(-220+col*220,-180+row*170)});world.add_child(pig)
   pig._art.variant="pink" if row==0 else "brown"
   # Ensure variant set before _ready by replacing art if already initialized.
   var old:Node=pig._art;pig.remove_child(old);old.queue_free()
   pig._art=WildPigArt.new();pig._art.variant="pink" if row==0 else "brown";pig.add_child(pig._art)
   pig.state["flee"]=col==1;pig.state["tired"]=col==2
 var canvas:=CanvasLayer.new();canvas.layer=30;add_child(canvas)
 var label:=Label.new();label.text="PRUEBA DE SPRITES · reposo / carrera / cansado (quieto provisional)";label.position=Vector2(200,590);label.add_theme_font_size_override("font_size",23);canvas.add_child(label)
 for i in range(12):
  await get_tree().create_timer(.083).timeout;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/pig2747-%02d.png"%i)
 get_tree().quit()
