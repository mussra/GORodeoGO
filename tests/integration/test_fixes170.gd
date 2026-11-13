extends GutTest
var world:Node2D
var prior:String
func before_each():
 prior=SaveData.save_path;SaveData.save_path="user://fix170.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.siesta_rest166=0.;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_position=Vector2(500,3000);SaveData.world_edits=[];SaveData.world_roaming139={};SaveData.country_ledger146={};SaveData.world_missions={};SaveData.world_quests={};SaveData.world_discovered=[];SaveData.world_places144={};SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_notes106={};SaveData.world_tamed=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
func after_each():
 get_tree().paused=false;world.free();SaveData.save_path=prior;DirAccess.remove_absolute("user://fix170.dat");await get_tree().process_frame
func test_real_note_grass_route_does_not_require_generated_road_or_reveal_progress():
 for x in range(-1,8):
  for y in range(-1,5):
   var key:=WorldMap.chunk_key(x,y)
   if not SaveData.world_discovered.has(key):SaveData.world_discovered.append(key)
 var note:Dictionary={"id":"grass","pos":Vector2(6500,3000),"text":"Foto del prado","photo":"user://map-photos/test.png"};assert_true(SaveData.store_note106(note))
 var destination:Dictionary=world._travel144.destination170("note170:grass");assert_eq(destination.pos,note.pos)
 var known:=SaveData.world_discovered.duplicate();var notes:=SaveData.world_notes106.duplicate(true);var expected:=SiestaRoute163.frontier(world.player.position,note.pos)
 assert_false(expected.is_empty());assert_true(await world._travel144.start("note170:grass"));assert_lt(world.player.position.distance_to(expected.pos),100.);assert_gt(world.player.position.distance_to(note.pos),120.);assert_eq(SaveData.world_discovered,known);assert_eq(SaveData.world_notes106,notes);assert_eq(SaveData.siesta_rest166,300.)
func test_impact_miss_scatter_pig_and_goat_not_roped_or_distant():
 world.player.position=WorldNominal98.home()
 world._update_chunks()
 while not world._build_queue.is_empty():world._drain_chunk_builds();await get_tree().process_frame
 var pigs:Array=world._lasso_pigs();assert_gt(pigs.size(),0)
 if pigs.is_empty():return
 var pig=pigs[0];var goat=world._prototype_goats.get_child(0);var point:Vector2=world.player.position+Vector2(420,0)
 pig.global_position=point+Vector2(40,0);pig.state=WorldPigs.new_chase_state();goat.global_position=point+Vector2(80,0);goat.state=WorldGoats.new_state()
 var pig_before:Vector2=pig.global_position;var goat_before:Vector2=goat.global_position
 world.player.lasso.landing_resolved.emit(point,null);assert_eq(pig.state.lasso_panic170,6.);assert_eq(goat.get_meta("escape_left110"),6.)
 world._tick_pigs(.1);world._tick_goats(.1);assert_gt(pig.global_position.distance_to(pig_before),1.);assert_gt(goat.global_position.distance_to(goat_before),1.)
 pig.state=WorldPigs.new_chase_state();pig.roped=true;goat.state=WorldGoats.new_state();goat.global_position=point+Vector2(700,0)
 world._landing_panic128(point,null);assert_false(pig.state.has("lasso_panic170"));assert_false(goat.state.has("lasso_panic170"))
func test_visible_notice_above_map_and_photo_viewer_close_without_save_changes():
 world._map_overlay.expanded=true;world._map_overlay._layout();world._toast("Ya estamos cerca. Este último tramo lo hacemos a caballo.")
 assert_gt(world._toasts.z_index,world._map_overlay.z_index);assert_eq(world._toasts.active[-1].label.text,"Ya estamos cerca. Este último tramo lo hacemos a caballo.")
 var image:=Image.create(1280,720,false,Image.FORMAT_RGBA8);var viewer:=MapPhotoViewer171.open(world,image);assert_not_null(viewer.picture.texture);assert_gt(viewer.layer,20);assert_eq(viewer.picture.stretch_mode,TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
 var event:=InputEventAction.new();event.action="ui_cancel";event.pressed=true;viewer._unhandled_input(event);assert_true(viewer.is_queued_for_deletion())

func test_saved_photo_thumbnail_touch_in_list_and_dialog_opens_full_image():
 var image:=Image.create(1280,720,false,Image.FORMAT_RGBA8);image.fill(Color.GREEN)
 DirAccess.make_dir_recursive_absolute("user://map-photos");var path:String="user://map-photos/fix171.png";assert_eq(image.save_png(path),OK)
 var note:Dictionary={"id":"photo171","pos":Vector2(500,3000),"text":"Mi captura","photo":path}
 var list:=MapNotesList162.new();SaveData.store_note106(note);list.notes=SaveData.world_notes106;world.add_child(list);await get_tree().process_frame
 var preview:TextureRect=list.rows.get_child(0).get_child(0);var touch:=InputEventScreenTouch.new();touch.pressed=true;touch.position=Vector2(20,20)
 preview.gui_input.emit(touch);await get_tree().process_frame
 var viewer:MapPhotoViewer171
 for child in list.get_children():
  if child is MapPhotoViewer171:viewer=child
 assert_not_null(viewer)
 if viewer!=null:assert_eq(viewer.picture.texture.get_width(),1280);assert_eq(viewer.picture.texture.get_height(),720);viewer.free()
 list.free()
 var dialog:=MapNoteDialog106.new();world.add_child(dialog);dialog.setup(note,"");dialog.photo_preview.gui_input.emit(touch);await get_tree().process_frame
 viewer=null
 for child in dialog.get_children():
  if child is MapPhotoViewer171:viewer=child
 assert_not_null(viewer)
 if viewer!=null:assert_eq(viewer.picture.texture.get_width(),1280);viewer.close_button.pressed.emit();assert_true(viewer.is_queued_for_deletion())
 dialog.queue_free();DirAccess.remove_absolute(path)

func test_navigation_has_no_obsolete_home_button_but_ranch_remains_siesta_destination():
 world._open_navigation();assert_not_null(world._navigation)
 var ids:Array=[]
 for entry in world._navigation.entries:ids.append(entry.id)
 assert_false(ids.has("home"));assert_false(ids.has("map"));assert_true(ids.has("exit"))
 assert_true(world._map_overlay.visible)
 var panel:NavigationSheet=world._navigation;world._close_navigation();panel.queue_free()
 world._travel144.record_visits();assert_false(world._travel144.destination170("ranch").is_empty());assert_false(world._travel144.active)

func test_thin_physical_wall_between_chunks_cannot_be_skipped():
 for x in range(-1,8):
  for y in range(-1,5):SaveData.world_discovered.append(WorldMap.chunk_key(x,y))
 SaveData.store_note106({"id":"wall172","pos":Vector2(6500,3000),"text":"Tras la pared","photo":""})
 var wall:=StaticBody2D.new();wall.position=Vector2(2400,3000);wall.collision_layer=world.player.collision_mask
 var shape:=CollisionShape2D.new();var rectangle:=RectangleShape2D.new();rectangle.size=Vector2(8,400);shape.shape=rectangle;wall.add_child(shape);world.add_child(wall);await get_tree().physics_frame
 var known:=SaveData.world_discovered.duplicate();assert_true(await world._travel144.start("note170:wall172"))
 assert_true(world._travel144.partial163.stopped172);assert_lt(world.player.position.x,2396.);assert_gt(world.player.position.x,2300.);assert_almost_eq(world.player.position.y,3000.,1.);assert_eq(SaveData.world_discovered,known);assert_eq(SaveData.siesta_rest166,300.)
 var disk:=ConfigFile.new();assert_eq(disk.load(SaveData.save_path),OK);assert_eq(disk.get_value("world","position"),world.player.position)
