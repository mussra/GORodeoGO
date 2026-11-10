extends Node
var world
var elapsed:float=0
var ready_preview:bool=false
func _ready()->void:
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa-notices70-isolated.dat";SaveData.world_seed=7781;SaveData.world_position=Vector2(-360,400);SaveData.world_edits.clear();SaveData.world_tamed.clear();SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 for horse in world._herd_horses.values():horse.hide();horse.set_physics_process(false)
 var base={"pos":world.player.position+Vector2(240,-150),"traits":{"coat":2,"pattern":0,"mane":3,"eyes":0,"finish":"normal"}}
 var family=WorldHerd.members(base,7781,10,10)
 for i in 3:
  var horse=load("res://src/Presentation/wild_horse.gd").new();horse.setup(family[i]);horse.home=world.player.position+Vector2(200+i*30,-155+i*55);world.add_child(horse);horse.set_physics_process(false)
 world._toasts.clear();world._toast("No se fía de nuestro caballo. Tendremos que buscar uno que se le parezca.");world._toast("Un caballo de pelaje y crin parecidos ganará su confianza... o un Líder de manada.")
 ready_preview=true
func _process(delta:float)->void:
 if not ready_preview:return
 elapsed+=delta
 if elapsed>.15 and elapsed<.19:get_viewport().get_texture().get_image().save_png("/downloads/notices2770.png")
 if elapsed>12:
  get_viewport().get_texture().get_image().save_png("/downloads/notices2770-cleared.png");get_tree().quit()
