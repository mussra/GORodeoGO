extends Node
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 for mode in ["race190","joust196"]:
  RaceCourse190.start_selected=true;RaceCourse190.selected=0
  var scene=load("res://src/Presentation/"+mode+".tscn").instantiate();add_child(scene)
  for i in 3:await get_tree().physics_frame
  scene.set_physics_process(false);scene.countdown=0.;scene.running=true
  for r in scene.riders:r.set_physics_process(false)
  var p=scene.player
  if mode=="race190":
   p.position=scene.course.at(200.);p.route_s=200.
  else:p.position=Vector2(-160,-45)
  # A regular running hold has just ended; a single re-press arms shared drawing.
  p.velocity=Vector2(200,0);p.dodge.on_move_pressed();p.dodge.move_pressed_at-=5.
  p.dodge.on_move_released(Vector2.RIGHT);p.dodge.on_move_pressed()
  print("QA204 ",mode," running_repress=",p.dodge.drawing)
  p.dodge.draw_points=PackedVector2Array([Vector2.ZERO,Vector2(100,0)])
  p.dodge.on_move_released(Vector2.RIGHT);p.dodge.path.clear();p.dodge.remaining=0.;p.velocity=Vector2.ZERO
  for value in [2.5,1.25,0.]:
   p.dodge.cooldown=value;p.queue_redraw()
   scene._physics_process(0.) if mode=="race190" else scene._refresh()
   for i in 5:await get_tree().process_frame
   await RenderingServer.frame_post_draw
   get_viewport().get_texture().get_image().save_png("/downloads/regate204-"+mode+"-"+str(value)+".png")
  scene.free()
 get_tree().quit()
