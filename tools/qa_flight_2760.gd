extends Node
var world
var horses:Array=[]
var title:Label
func title_text(t:String)->void:title.text=t
func wait_seconds(t:float)->void:await get_tree().create_timer(t).timeout
func _ready()->void:call_deferred("run")
func _physics_process(delta:float)->void:
 if is_instance_valid(world):world._tick_taming(delta)
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://qa-flight60.dat";SaveData.world_seed=7781;SaveData.world_edits=[];SaveData.world_position=Vector2(-360,400)
 SaveData.world_tamed=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 world._toasts.clear();world._toasts.column.visible=false
 for horse in world._herd_horses.values():
  if is_instance_valid(horse):horse.queue_free()
 world._herd_horses.clear()
 for i in 3:
  var h=world.WildHorseScript.new();h.setup({"pos":Vector2(-200+60*i,400+75*i),"temperament":.2,"traits":{"coat":12,"pattern":2,"mane":0,"spots":5,"finish":"matte"}})
  h.set_meta("c",Vector2i(99,99));world.add_child(h);world._herd_horses[str(i)]=h;horses.append(h)
 title=Label.new();title.position=Vector2(220,60);title.add_theme_font_size_override("font_size",24);world._hud.add_child(title)
 title_text("Mismo alcance 220 px · mismo vuelo 0,35 s · mismo radio 58 px")
 await wait_seconds(1)
 var h=horses[0];world.player.position=h.position-Vector2(160,0)
 var p:Vector2=h.position
 title_text("VUELO: manada quieta, sin esquiva ni pánico nuevo")
 world.player.lasso._release_throw(Vector2(160.0/220.0,0))
 await wait_seconds(.2)
 assert(h.position.distance_to(p)<.1)
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/flight2760-during.png")
 await wait_seconds(.2)
 assert(h.roped);assert(not h.flight_hold)
 title_text("ACIERTO: queda enlazado; sin pánico nuevo de manada")
 await wait_seconds(1.2)
 world._release_held_horse()
 for horse in horses:horse.state.spook=0;horse.set_meta("panic_left",0.0)
 world.player.position=horses[1].position-Vector2(150,0)
 title_text("FALLO: el pánico empieza después de caer, nunca antes")
 world.player.lasso._release_throw(Vector2(0,-1))
 await wait_seconds(.2)
 assert(float(horses[1].get_meta("panic_left",0.0))==0)
 await wait_seconds(.2)
 assert(float(horses[1].get_meta("panic_left",0.0))>1.0)
 await wait_seconds(1.5)
 print("FLIGHT_QA: unchanged220/.35/58, stationary midflight, capture then no panic, miss then panic")
 get_tree().quit()
