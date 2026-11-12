extends Node
var world:CountryPreview146
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/country148-"+name_+".png")
func run():
 process_mode=Node.PROCESS_MODE_ALWAYS;get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");SaveData.save_path="user://country148-qa.dat";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=CountryPreview146.new();add_child(world);world.player.set_physics_process(false);await get_tree().create_timer(.5,true).timeout
 await shot("entrada");world.show_map();await shot("mapa-inicial");world.close_modal();await get_tree().process_frame
 # Walk actual approach/bank route for explored map evidence.
 for path in [world.data.approach,world.data.upstream]:
  for i in range(1,path.size()):
   var a:Vector2=path[i-1];var b:Vector2=path[i];var steps:int=ceili(a.distance_to(b)/100.)
   for j in range(steps+1):world.player.position=a.lerp(b,float(j)/steps);world._process(0.)
 world.camera.reset_smoothing();await shot("fuente");world.show_map();await shot("mapa-explorado")
 get_tree().root.size=Vector2i(960,540);await get_tree().process_frame;await shot("mapa-960");get_tree().root.size=Vector2i(1280,720);await get_tree().process_frame
 world.close_modal(false);world.show_sites(true);await get_tree().create_timer(.2,true).timeout;await shot("sitios");world.close_modal(false);world.choose_site("entry",true);await shot("confirmar")
 get_tree().root.size=Vector2i(960,540);await get_tree().process_frame;await shot("confirmar-960");get_tree().root.size=Vector2i(1280,720);await get_tree().process_frame
 world.close_modal(false);get_tree().create_timer(.25,true).timeout.connect(func():shot("viaje"));assert(await world.start_siesta("entry",true));world.player.set_physics_process(false);await shot("casa");print("COUNTRY148_VISUAL_OK ",world.ledger.maps.water146.visited);get_tree().quit()
