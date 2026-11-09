extends Node
var world
var cam
var pig
var goat
func _ready()->void:call_deferred("run")
func wait_frames(n:int)->void:
 for i in n:await get_tree().process_frame
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://qa-chase-video.dat";SaveData.world_seed=7781;SaveData.world_edits=[];SaveData.world_position=Vector2(-360,400)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 world._toasts.clear();world._toasts.column.visible=false;cam=get_viewport().get_camera_2d()
 goat=world._prototype_goats.get_child(0)
 var chunk=world._chunks.values()[0]
 var pen=chunk.get_node_or_null("pigs")
 if pen==null:pen=Node2D.new();pen.name="pigs";chunk.add_child(pen)
 pig=load("res://src/Presentation/wild_pig.gd").new();pig.setup({"pos":Vector2(-200,400)});pen.add_child(pig)
 for other in world._lasso_pigs():
  if other!=pig:other.visible=false
 goat.visible=false;world._prototype_goats.get_child(1).visible=false
 var title:=Label.new();title.position=Vector2(270,65);title.add_theme_font_size_override("font_size",24);world._hud.add_child(title)
 title.text="CERDO: sigue huyendo con el lazo"
 world._on_lasso_prey_captured(pig)
 for i in 120:
  world.player.position=Vector2(-360+i*2.0,400);world.player.velocity=Vector2(240,0)
  world._tick_pigs(1.0/60);cam.global_position=Vector2(-240,400)
  await wait_frames(1)
 title.text="CERDO: distancia > 240 px, cuerda rota"
 world.player.position=pig.position-Vector2(280,0);world._tick_pigs(.016)
 assert(not pig.roped);await wait_frames(70)
 pig.visible=false;goat.visible=true;goat.position=Vector2(-200,400);world.player.position=Vector2(-360,400);world.player._stun_time_remaining=0
 title.text="CABRA: enlazada, ahora persigue al jinete"
 world._on_lasso_prey_captured(goat)
 for i in 32:
  world._tick_goats(1.0/60);cam.global_position=Vector2(-240,400);await wait_frames(1)
 assert(not goat.roped);title.text="CABRA: alcanza al jinete y se libera"
 await wait_frames(70)
 world.player._stun_time_remaining=0;world.player.modulate=Color.WHITE;goat.position=Vector2(-200,400);world.player.position=Vector2(-360,400)
 title.text="CABRA: mantener distancia durante 5 segundos"
 world._on_lasso_prey_captured(goat)
 for i in 302:
  world.player.position.x-=WorldGoats.CHARGE_SPEED/60
  world._tick_goats(1.0/60);cam.global_position=world.player.position+Vector2(100,0);await wait_frames(1)
  if not is_instance_valid(goat):break
 title.text="CABRA CAPTURADA: prototipo, sin recompensa ni guardado"
 await wait_frames(70);get_tree().quit()
