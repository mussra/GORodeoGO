extends Node
var world
var moving
var still
var phase:int=0
var status:Label
var active:bool=false
func _ready()->void:
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa-horses71.dat";SaveData.world_seed=7781;SaveData.world_position=Vector2(-850,650);SaveData.world_edits.clear();SaveData.world_tamed.clear();SaveData.world_pigs.clear();SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false);world.player.lasso.throw_guard=func():return true
 for h in world._herd_horses.values():h.set_physics_process(false);h.hide()
 world._herd_horses.clear()
 world.player.position=Vector2(-850,650)
 moving=plant(Vector2(-740,720),0);still=plant(Vector2(-710,600),1)
 moving.wander=true;moving._wander_target=moving.position+Vector2(120,0);moving._wander_pause=0
 world._toasts.clear();status=Label.new();status.position=Vector2(20,610);status.add_theme_font_size_override("font_size",20);ToastStack.backdrop(status);world._hud.add_child(status);active=true
 status.text="Lanzar no congela ni asusta: uno camina, otro sigue quieto"
 await get_tree().create_timer(.4).timeout;world.player.lasso._release_throw(Vector2(-1,0))
 await get_tree().create_timer(1.2).timeout
 get_viewport().get_texture().get_image().save_png("/downloads/horses2771-flight.png")
 world.player.position=still.position-Vector2(95,0);phase=1;world.player.lasso._release_throw(Vector2(-1,0));status.text="Si me acerco corriendo durante el vuelo, sí huyen"
 await get_tree().create_timer(1.4).timeout
 phase=2;world.player.velocity=Vector2.ZERO;world.player.position=Vector2(-850,650);still.position=Vector2(-710,650);still.home=still.position;still.state=WorldTaming.new_state();still._flee=Vector2.ZERO;moving.wander=false;moving.position=Vector2(-720,790);moving.state=WorldTaming.new_state();moving._flee=Vector2.ZERO
 await get_tree().create_timer(3).timeout
 get_viewport().get_texture().get_image().save_png("/downloads/horses2771-no-trust.png")
 phase=3;world.player.lasso._release_throw(Vector2(140.0/220.0,0))
 await get_tree().create_timer(1).timeout
 get_viewport().get_texture().get_image().save_png("/downloads/horses2771-roped.png")
 await get_tree().create_timer(1.5).timeout
 get_viewport().get_texture().get_image().save_png("/downloads/horses2771-captured.png");get_tree().quit()
func plant(pos:Vector2,index:int):
 var h=world.WildHorseScript.new();h.setup({"pos":pos,"temperament":0.0,"traits":{"coat":10,"pattern":2,"mane":1,"eyes":0,"finish":"normal"},"stats":{"speed":260},"member_index":index,"member_id":"qa71#"+str(index)})
 h.set_meta("c",Vector2i(99,index));world.add_child(h);world._herd_horses["qa"+str(index)]=h;return h
func _process(delta:float)->void:
 if not active:return
 if phase==1:world.player.velocity=Vector2(260,0)
 if phase>0:world._tick_taming(delta)
 if phase==2:status.text="Sin lazo: confianza %.0f %% · no se captura"%(float(still.state.progress)*100)
 elif phase==3:
  status.text="Con lazo: confianza sube rápido · %.0f %%"%(float(still.state.progress)*100) if is_instance_valid(still) else "Caballo capturado con lazo · añadido a la cuadra"
