extends Node
func _ready():run.call_deferred()
func shot(id:String):
 await get_tree().create_timer(1.2).timeout
 for i in 10:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/musician206-"+id+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 RaceCourse190.start_selected=true;RaceCourse190.selected=0
 var race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race)
 for i in 4:await get_tree().physics_frame
 race.set_physics_process(false)
 print("MUSICIAN206 race ",race.get_node("GanjoMusician205").art_ready," ",race.get_node("GanjoMusician205").position)
 await shot("carreras");race.free()
 var joust=load("res://src/Presentation/joust196.tscn").instantiate();add_child(joust)
 for i in 3:await get_tree().physics_frame
 joust.set_physics_process(false)
 for r in joust.riders:r.set_physics_process(false)
 joust.player.dodge.cooldown=1.25;joust._physics_process(0.)
 await shot("boton");joust.free()
 SaveData.world_seed=424242;SaveData.world_position=Vector2(0,160);SaveData.country_ledger146["active"]="frontier"
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 for i in 600:
  await get_tree().process_frame
  if not world._loading_world:break
 var musician=world.get_node("GanjoMusician205")
 world.player.position=musician.position+Vector2(80,70)
 await shot("frontera");world.free();get_tree().quit()
