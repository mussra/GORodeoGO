extends Node
var world
var pig
var goat
var elapsed:float=0
var phase:int=0
var active:bool=false
var status:Label
var start:Vector2
func _ready()->void:
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa-chase71.dat";SaveData.world_seed=7781;SaveData.world_position=Vector2(-360,400);SaveData.world_edits.clear();SaveData.world_tamed.clear();SaveData.world_pigs.clear();SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false);world.player.lasso.throw_guard=func():return true
 for h in world._herd_horses.values():h.set_physics_process(false)
 pig=world._lasso_pigs()[0];pig.position=Vector2(-850,650);pig.home=pig.position;start=pig.position;world.player.position=pig.position-Vector2(155,0)
 world._toasts.clear();status=Label.new();status.position=Vector2(20,610);status.add_theme_font_size_override("font_size",20);ToastStack.backdrop(status);world._hud.add_child(status);active=true
 await get_tree().create_timer(.5).timeout
 world.player.lasso._release_throw(Vector2(155.0/220.0,0));await get_tree().create_timer(.4).timeout;print("PIG ROPE ",pig.roped);phase=1
 await get_tree().create_timer(7).timeout
 get_viewport().get_texture().get_image().save_png("/downloads/chase2771-captured.png")
 pig=world._lasso_pigs()[0];pig.position=start; pig.home=start;phase=0;world.player.position=pig.position-Vector2(140,0);world._toasts.clear();phase=0
 world.player.lasso._release_throw(Vector2(140.0/220.0,0));await get_tree().create_timer(.4).timeout;print("SECOND PIG ROPE ",pig.roped);phase=2
 await get_tree().create_timer(2.2).timeout
 get_viewport().get_texture().get_image().save_png("/downloads/chase2771-lost.png")
 if is_instance_valid(pig) and pig.roped:world._release_held_horse()
 goat=world._prototype_goats.get_child(0);goat.position=start+Vector2(160,0);goat.home=goat.position;world.player.position=goat.position-Vector2(180,0);phase=0
 world.player.lasso._release_throw(Vector2(180.0/220.0,0));await get_tree().create_timer(.4).timeout;print("GOAT ROPE ",goat.roped);phase=3
 await get_tree().create_timer(3).timeout
 get_viewport().get_texture().get_image().save_png("/downloads/chase2771-goat.png")
 await get_tree().create_timer(2).timeout
 get_tree().quit()
func _process(delta:float)->void:
 if not active:return
 elapsed+=delta
 if phase==1:
  if is_instance_valid(pig):
   world.player.position=pig.position-Vector2(150,0);world._tick_pigs(delta)
   status.text="Cerdo: seguir su carrera tras el lazo · %.1f / 3 s"%float(pig.state.get("rope_run",0.0)) if is_instance_valid(pig) else "Cerdo capturado · +40 puntos"
  else:status.text="Cerdo capturado · +40 puntos"
 elif phase==2:
  world._tick_pigs(delta)
  status.text="No lo sigo: se aleja y pierde el lazo" if not pig.roped else "Me quedo atrás: aumenta la distancia"
 elif phase==3:
  world.player.position+=Vector2(-195,0)*delta;world._tick_goats(delta)
  status.text=("Cabra enlazada: ella sigue al jinete" if goat.roped else "La cabra me alcanza y se libera") if is_instance_valid(goat) else "Cabra capturada tras mantener la distancia"
