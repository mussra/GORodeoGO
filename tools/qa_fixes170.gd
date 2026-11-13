extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(label:String):
 await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/fixes170-"+label+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 var parade:=LoadingParade.new();add_child(parade)
 if not parade.prepared:await parade.preparation_finished
 parade.age=3.2;parade.set_process(false);parade._process(.01);await shot("loading");parade.free()
 var canvas:=Control.new();add_child(canvas);var bg:=ColorRect.new();bg.color=Color("12322b");bg.size=Vector2(1280,720);canvas.add_child(bg)
 for i in 3:
  var horse:Dictionary={"traits":{"coat":10,"pattern":0,"mane":1,"finish":"original"},"stage":"adult"}
  if i>0:horse.leg_adorn169=["","silver","gold"][i];horse.boot_adorn169=["","silver","gold"][i]
  var label:=Label.new();label.text=["NORMAL","PLATA","ORO"][i];label.position=Vector2(45+i*420,18);label.add_theme_font_size_override("font_size",30);canvas.add_child(label)
  var portrait:=TextureRect.new();portrait.position=Vector2(15+i*420,65);portrait.size=Vector2(400,470);canvas.add_child(portrait);HorsePortrait.apply_horse(portrait,horse)
  var spec:Dictionary=FinishPose168.specs()[0];var mounted:=TextureRect.new();mounted.texture=load(FinishPose168.paths(spec,0).source);mounted.material=HorseAdorn169.material(horse,spec,0);mounted.position=Vector2(40+i*420,535);mounted.size=Vector2(170,170);mounted.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;mounted.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;mounted.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;canvas.add_child(mounted)
 await shot("metal-comparison");canvas.free()
 SaveData.save_path="user://qa-fixes170.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.siesta_rest166=0.;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_position=Vector2(500,3000);SaveData.world_edits=[];SaveData.world_roaming139={};SaveData.country_ledger146={};SaveData.world_missions={};SaveData.world_quests={};SaveData.world_discovered=[];SaveData.world_places144={};SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_notes106={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.0).timeout
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 await shot("world-photo")
 for x in range(-1,8):
  for y in range(-1,5):
   var key:=WorldMap.chunk_key(x,y)
   if not SaveData.world_discovered.has(key):SaveData.world_discovered.append(key)
 DirAccess.make_dir_recursive_absolute("user://map-photos");var saved_image:=Image.load_from_file("/downloads/fixes170-world-photo.png");saved_image.save_png("user://map-photos/qa171.png")
 SaveData.store_note106({"id":"grass","pos":Vector2(6500,3000),"text":"Prado de la captura","photo":"user://map-photos/qa171.png"})
 world._toggle_map();world._map_overlay._ensure_terrain();world._toast("Ya estamos cerca. Este último tramo lo hacemos a caballo.");await shot("map-notice")
 get_tree().root.size=Vector2i(960,540);await get_tree().create_timer(.2).timeout;await shot("map-notice-small");get_tree().root.size=Vector2i(1280,720);await get_tree().create_timer(.2).timeout
 world._map_notes159.show_list162();await shot("notes-travel")
 var list:MapNotesList162=world._map_notes159.notes_list162;list.travel170.emit(WorldNotes106.list162(SaveData.world_notes106)[0]);await get_tree().process_frame;await shot("note-confirmation")
 world._travel144.close_confirmation();world._map_notes159.show_list162();var saved_list:MapNotesList162=world._map_notes159.notes_list162
 var touch:=InputEventScreenTouch.new();touch.pressed=true;touch.position=Vector2(20,20);saved_list.rows.get_child(0).get_child(0).gui_input.emit(touch);await shot("photo-fullscreen")
 for child in saved_list.get_children():
  if child is MapPhotoViewer171:child.close_button.pressed.emit()
 world._map_notes159.close_list162()
 print("QA170_ACTUAL_NOTE_ROUTE_START");assert(await world._travel144.start("note170:grass"));await shot("after-grass-route");print("QA170_ACTUAL_NOTE_ROUTE_OK ",world.player.position)
 world.free();get_tree().quit()
