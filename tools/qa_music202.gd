extends Node
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 RaceCourse190.start_selected=true;RaceCourse190.selected=0
 var scene=load("res://src/Presentation/race190.tscn").instantiate();add_child(scene)
 scene.set_physics_process(false)
 for stage in ["preparacion","salida"]:
  if stage=="preparacion":scene.countdown=2.;scene._physics_process(0.)
  else:scene.countdown=.01;scene._physics_process(.02)
  await get_tree().create_timer(.35).timeout
  var caption:=Label.new();caption.text="MÚSICA: SILENCIO DURANTE 3-2-1" if not RanchMusic.voice.playing else "MÚSICA: ARRANCA CON LA SALIDA"
  caption.position=Vector2(350,285);caption.add_theme_font_size_override("font_size",24);scene.hud.add_child(caption);ToastStack.backdrop(caption)
  for i in 3:await get_tree().process_frame
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/music202-"+stage+".png")
  print("QA202 ",stage," playing=",RanchMusic.voice.playing," context=",RanchMusic.context," running=",scene.running)
  caption.free()
 scene.free();get_tree().quit()
