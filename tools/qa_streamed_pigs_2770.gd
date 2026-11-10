extends Node
var world
var pig
var elapsed:float=0
var active:bool=false
var thrown:bool=false
var status:Label
var points:int=0
func _ready()->void:
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa-pigs-video70.dat";SaveData.world_seed=7781;SaveData.world_position=Vector2(-360,400);SaveData.world_edits.clear();SaveData.world_tamed.clear();SaveData.world_pigs.clear();SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(true)
 pig=world._lasso_pigs()[0];world.player.position=pig.position-Vector2(160,0);pig.state.run=WorldPigs.CHASE_TIRE_SECONDS-1.2
 world._toasts.clear();status=Label.new();status.position=Vector2(20,620);status.add_theme_font_size_override("font_size",18);ToastStack.backdrop(status);world._hud.add_child(status);points=SaveData.equipment_points;active=true
func _process(delta:float)->void:
 if not active:return
 elapsed+=delta
 if is_instance_valid(pig):
  world.player.position=pig.position-Vector2(160,0)
  world._tick_pigs(delta)
  status.text="Piara generada real · huye" if not pig.state.tired else ("Lazo y captura al cansarse" if not pig.roped else "Cerdo enlazado · llenando captura")
 else:status.text="Cerdo capturado · +%d puntos · resto de piara aún en juego"%[SaveData.equipment_points-points]
 if elapsed>1.4 and not thrown and is_instance_valid(pig):
  thrown=true;world.player.lasso._release_throw(Vector2(160.0/220.0,0))
 if elapsed>2.45 and elapsed<2.49:get_viewport().get_texture().get_image().save_png("/downloads/pigs2770-roped.png")
 if elapsed>5:
  get_viewport().get_texture().get_image().save_png("/downloads/pigs2770-captured.png");get_tree().quit()
