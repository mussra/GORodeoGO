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
 world.player.set_physics_process(true)
 title_text("Antes del golpe: carga del lazo activa")
 world.player.lasso._on_aim_pressed();world.player.lasso._charge_distance=170;world.player.lasso._update_charge_visual()
 world.player.queue_redraw()
 await wait_seconds(.7)
 world.player.stun(1.5)
 title_text("GOLPE: carga cancelada, sin aro atascado ni lanzamiento")
 await wait_seconds(.2)
 assert(not world.player.lasso.is_charging());assert(not world.player.lasso.is_in_flight())
 world.player.lasso._on_aim_released(Vector2.RIGHT)
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/stun2764.png")
 await wait_seconds(1.5)
 title_text("Recuperado: nueva pulsación, lazo normal (220 / 0,35 / 58)")
 world.player.lasso._on_aim_pressed();world.player.lasso._on_aim_released(Vector2.RIGHT)
 await wait_seconds(.15);assert(world.player.lasso.is_in_flight())
 world.player.stun(.8)
 title_text("Si el golpe llega después de lanzar: el vuelo sí termina")
 await wait_seconds(.3);assert(not world.player.lasso.is_in_flight())
 await wait_seconds(1)
 print("STUN_QA pass: charge cancelled, no stunned launch, fresh press works, existing flight lands")
 get_tree().quit()
