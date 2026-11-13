extends Node
var world:Node2D
func _ready():run.call_deferred()
func tap(control:Control):
 var point:Vector2=control.get_global_rect().get_center()
 for down in [true,false]:
  var event:=InputEventScreenTouch.new();event.position=get_viewport().get_screen_transform()*point;event.index=0;event.pressed=down;Input.parse_input_event(event);await get_tree().process_frame
 await get_tree().process_frame
func shot(name_:String):
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/photo160-"+name_+".png")
func run():
 TranslationServer.set_locale("es")
 for country in [false,true]:
  for dims in [Vector2i(1600,720),Vector2i(960,540)]:
   get_tree().root.size=dims;SaveData.save_path="user://photo160-%s-%s.dat"%[country,dims.x];SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_notes106={};SaveData.country_ledger146={};SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_places144={};SaveData.world_position=WorldNominal98.home();SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.save_progress()
   if country:
    world=CountrySession152.new();world.session_state=CountryLedger146.enter(CountryLedger146.fresh(752026,3),SaveData.world_position,752026);add_child(world);await get_tree().physics_frame;world.activate152()
   else:
    world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
    while world._loading_world:await get_tree().process_frame
   await get_tree().create_timer(1.2).timeout;world.player.set_physics_process(false);world._toggle_map();world._map_overlay._ensure_terrain();world._open_map_note106(world.player.position);await get_tree().process_frame
   var dialog:MapNoteDialog106=world._note_dialog106;assert(not dialog.photo_box.button_pressed);dialog.entry.text="Foto táctil %s"%dims.x
   await shot("%s-%s-sin-marcar"%["pais" if country else "frontera",dims.x]);await tap(dialog.photo_box);assert(dialog.photo_box.button_pressed);await shot("%s-%s-seleccion"%["pais" if country else "frontera",dims.x])
   var save:Button
   for button in dialog.find_children("*","Button",true,false):
    if button.text=="Guardar":save=button
   assert(save!=null);await tap(save);assert(world._note_dialog106==null)
   var notes:Dictionary=world.ledger.maps.water146.notes if country else SaveData.world_notes106;var note:Dictionary=WorldNotes106.nearest(notes,world.player.position,1000.);assert(not note.is_empty());assert(FileAccess.file_exists(note.photo));assert(Image.load_from_file(note.photo)!=null)
   SaveData.load_progress();var stored:Dictionary=SaveData.country_ledger146.maps.water146.notes if country else SaveData.world_notes106;assert(WorldNotes106.nearest(stored,world.player.position,1000.).photo==note.photo)
   world._open_map_note106(world.player.position);await get_tree().process_frame;assert(not world._note_dialog106.find_children("*","TextureRect",true,false).is_empty());await shot("%s-%s-reabierta"%["pais" if country else "frontera",dims.x]);world._map_notes159.close();world.queue_free();await get_tree().process_frame
   print("PHOTO160_NATIVE_TAP_SAVE_RELOAD_OK country=",country," size=",dims)
 get_tree().quit()
