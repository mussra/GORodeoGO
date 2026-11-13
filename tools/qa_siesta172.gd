extends Node
func _ready():run.call_deferred()
func shot(label:String):
 await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/siesta172-"+label+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://qa172.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.country_ledger146={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var world:=CountryPreview146.new();add_child(world);world.player.set_physics_process(false)
 var center:Vector2=world.data.source+Vector2(0,500);var origin:Vector2=center+Vector2(-600,0);var goal:Vector2=center+Vector2(1800,0)
 world.player.position=origin
 for x in range(floori((center.x-1500)/512.),ceili((center.x+2500)/512.)):
  for y in range(floori((center.y-1500)/512.),ceili((center.y+1500)/512.)):world.visited_cells[Vector2i(x,y)]=true
 world.ledger.maps.water146.notes={WorldNotes106.region_key(goal):[{"id":"river172","pos":goal,"text":"Otra orilla","photo":""}]}
 world.camera.reset_smoothing();await get_tree().create_timer(.4).timeout;await shot("river-before")
 assert(await world.start_siesta("note170:river172"));world.player.set_physics_process(false);await get_tree().create_timer(.2).timeout
 await shot("river-stop");print("RIVER172_STOP ",origin," -> ",world.player.position," direct goal ",goal," stopped ",world.partial_route163.stopped172)
 world.free();get_tree().quit()
