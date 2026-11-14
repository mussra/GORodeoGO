extends Node
func _ready():run.call_deferred()
func shot(id:String):
 for i in 3:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/prestart198-"+id+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 for mode in ["joust196","race190"]:
  RaceCourse190.start_selected=true;RaceCourse190.selected=0
  var scene=load("res://src/Presentation/"+mode+".tscn").instantiate();add_child(scene)
  for i in 3:await get_tree().physics_frame
  scene.set_physics_process(false);scene.countdown=3.
  if mode=="race190":scene.selector.hide();scene._physics_process(0.)
  await get_tree().process_frame
  scene.countdown=3.
  var origin:Vector2=get_viewport().get_visible_rect().size*Vector2(.76,.78)
  var touch:=InputEventScreenTouch.new();touch.index=1;touch.position=origin;touch.pressed=true;Input.parse_input_event(touch);Input.flush_buffered_events()
  for i in 3:await get_tree().physics_frame
  var drag:=InputEventScreenDrag.new();drag.index=1;drag.position=origin+Vector2(70,0);Input.parse_input_event(drag);Input.flush_buffered_events()
  for i in 3:await get_tree().physics_frame
  print("QA198 ",mode," charge=",scene.player.lasso.is_charging())
  for number in [3,2,1]:
   scene.countdown=float(number);scene._refresh() if mode=="joust196" else scene._physics_process(0.);await shot(mode+"-"+str(number))
  scene.countdown=0.;scene.running=true;scene._refresh() if mode=="joust196" else scene._physics_process(0.);await shot(mode+"-go")
  scene.player.lasso._on_aim_released(Vector2.RIGHT*.8)
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/prestart198-"+mode+"-flight.png")
  touch.pressed=false;Input.parse_input_event(touch);Input.flush_buffered_events();scene.free()
 get_tree().quit()
