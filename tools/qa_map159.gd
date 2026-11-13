extends Node
var world:CountrySession152
func _ready():run.call_deferred()
func shot(id:String):
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/map159-"+id+".png")
func run():
 get_tree().root.size=Vector2i(1600,720);TranslationServer.set_locale("es");SaveData.save_path="user://qa-map159.cfg";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.country_ledger146={};SaveData.save_progress()
 world=CountrySession152.new();world.session_state=CountryLedger146.enter(CountryLedger146.fresh(752026,3),Vector2(100,100),752026);add_child(world);await get_tree().physics_frame;world.activate152();world.player.set_physics_process(false)
 for row in [world.data.approach,world.data.upstream]:
  for i in range(1,row.size()):
   var a:Vector2=row[i-1];var b:Vector2=row[i];var steps:int=ceili(a.distance_to(b)/300.)
   for j in steps:world.player.position=a.lerp(b,float(j)/steps);world._process(0.)
 world.player.position=world.data.sites.tree;world._process(0.);world.camera.reset_smoothing();await shot("minimapa")
 world.show_map();world._map_overlay._ensure_terrain();await shot("abierto")
 world._map_overlay._set_zoom(2.);world._map_overlay._find108.pressed.emit();await shot("zoom-centrado")
 world._open_map_note106(world.player.position);world._note_dialog106.entry.text="Árbol madre · seguir el río hasta la fuente";await shot("nota-editor");world._note_dialog106.saved.emit(world._note_dialog106.entry.text,true);await get_tree().process_frame
 world._open_map_note106(world.player.position);assert(world._note_dialog106.entry.text.begins_with("Árbol madre"));await shot("nota-reabierta");world._map_notes159.close()
 get_tree().root.size=Vector2i(960,540);await shot("telefono-zoom");world._open_map_note106(world.player.position);await shot("telefono-nota");world._map_notes159.close();world.close_modal();await shot("telefono-minimapa")
 assert(world.save_now152());var notes:Dictionary=world.ledger.maps.water146.notes.duplicate(true);SaveData.load_progress();assert(SaveData.country_ledger146.maps.water146.notes==notes);print("MAP159_QA_PHOTO_SAVE_RELOAD_OK");get_tree().quit()
