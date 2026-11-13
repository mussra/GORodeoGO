extends GutTest
var world:CountrySession152
var previous:String
func before_each():
 previous=SaveData.save_path;SaveData.save_path="user://shared159.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_position=WorldNominal98.home();SaveData.country_ledger146={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_notes106={"0,0":[{"id":"frontier_note","pos":Vector2(100,100),"text":"Keep original world","icon":"pin","horse":"","photo":""}]};SaveData.save_progress()
 world=CountrySession152.new();world.session_state=CountryLedger146.enter(CountryLedger146.fresh(752026,3),SaveData.world_position,752026);add_child(world);await get_tree().physics_frame;world.activate152();world.player.set_physics_process(false);world.set_process(false);world._process(0.)
func after_each():
 if is_instance_valid(world):world.free()
 SaveData._load_valid=true;SaveData.country_ledger146={};SaveData.save_path=previous;DirAccess.remove_absolute("user://shared159.dat");await get_tree().process_frame
func test_frontier_alias_and_country_use_one_map_class_with_same_controls():
 var frontier=load("res://src/Presentation/frontier_world.gd");var original=frontier.DiscoveryMap.new();assert_true(original is WorldDiscoveryMap159);original.free()
 var map:=world._map_overlay;assert_true(map is WorldDiscoveryMap159);assert_false(map.expanded);assert_true(map.visible);world.show_map();map._process(.01)
 assert_eq(map._zoom_btns.size(),2);assert_true(map._zoom_slider106.visible);assert_eq(map._find108.text,"Encontrar mi caballo");assert_true(map._sites144.visible)
 map._zoom_btns[1].pressed.emit();assert_gt(map.zoom,1.);map._set_zoom(8.);map.pan=Vector2(180,-100);map._ensure_terrain();map._find108.pressed.emit();assert_true(map._map_geometry.area.has_point(map._to_map(world.player.position,map._map_geometry.data.mins,map._map_geometry.cell,map._map_geometry.origin)))
 map._close_btn.pressed.emit();assert_null(world.modal);assert_false(map.expanded);assert_true(map.visible);assert_true(world.touch_controls.visible)
func test_shared_native_long_press_country_note_save_reload_delete_and_frontier_isolation():
 var original_notes:=SaveData.world_notes106.duplicate(true);world.show_map();var map:=world._map_overlay;map._layout();map._ensure_terrain();var pos:Vector2=world.player.position
 var point:=map._to_map(pos,map._map_geometry.data.mins,map._map_geometry.cell,map._map_geometry.origin);var down:=InputEventScreenTouch.new();down.index=4;down.position=point;down.pressed=true;map._gui_input(down);map._press_time106-=.7;map._process(.01)
 assert_not_null(world._note_dialog106);down.pressed=false;map._gui_input(down);assert_true(map.expanded);world._note_dialog106.saved.emit("Mi playa del país",false);await get_tree().process_frame
 assert_eq(WorldNotes106.nearest(map.notes159(),pos,500.).text,"Mi playa del país");assert_eq(SaveData.world_notes106,original_notes);var cells:=world.visited_cells.duplicate(true);var state:=SaveData.country_ledger146.duplicate(true);SaveData.load_progress();assert_eq(SaveData.country_ledger146,state);assert_eq(SaveData.world_notes106,original_notes)
 world._open_map_note106(pos);assert_eq(world._note_dialog106.entry.text,"Mi playa del país");world._note_dialog106.deleted.emit();await get_tree().process_frame;assert_true(map.notes159().is_empty());assert_eq(SaveData.world_notes106,original_notes);assert_eq(world.visited_cells,cells)
func test_failed_note_save_retains_dialog_and_disk_then_retry_succeeds():
 world.show_map();var pos:=world.player.position;world._map_overlay._ensure_terrain();world._open_map_note106(pos);var disk:=FileAccess.get_file_as_bytes(SaveData.save_path);var ledger:=world.ledger.duplicate(true)
 SaveData._load_valid=false;world._note_dialog106.saved.emit("Retry note",false);assert_not_null(world._note_dialog106);assert_eq(world.ledger,ledger);assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),disk)
 SaveData._load_valid=true;world._note_dialog106.saved.emit("Retry note",false);await get_tree().process_frame;assert_null(world._note_dialog106);assert_eq(WorldNotes106.nearest(world._map_overlay.notes159(),pos,500.).text,"Retry note")
func test_temporary_country_notes_never_write_frontier_or_persistent_country():
 var preview:=CountryPreview146.new();add_child(preview);preview.player.set_physics_process(false);preview._process(0.);var disk:=FileAccess.get_file_as_bytes(SaveData.save_path);preview.show_map();preview._map_overlay._ensure_terrain();preview._open_map_note106(preview.player.position);preview._note_dialog106.saved.emit("Solo maqueta",false)
 assert_false(preview.ledger.maps.water146.notes.is_empty());assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),disk);preview.free();await get_tree().process_frame

func test_collapsing_and_resizing_invalidates_terrain_immediately_and_back_closes_note_first():
 world.show_map();var map:=world._map_overlay;map._process(.01);map._ensure_terrain();var builds:=map.terrain_rebuilds
 world.close_modal();map._process(.01);assert_gt(map.terrain_rebuilds,builds);assert_eq(map._map_geometry.area.size,map.size-Vector2(24,24));assert_false(map.expanded)
 world.show_map();map._process(.01);assert_true(map._note_help106.visible);world._open_map_note106(world.player.position)
 var back:=InputEventAction.new();back.action="ui_cancel";back.pressed=true;world._unhandled_input(back);assert_null(world._note_dialog106);assert_true(map.expanded);assert_false(world.player.is_physics_processing());world._unhandled_input(back);assert_false(map.expanded)

func test_failed_photo_then_retry_without_photo_never_persists_deleted_file():
 world.show_map();world._map_overlay._ensure_terrain();world._open_map_note106(world.player.position);world._map_notes159.photo_position=world.player.position;world._map_notes159.photo=Image.create(16,16,false,Image.FORMAT_RGBA8)
 SaveData._load_valid=false;world._note_dialog106.saved.emit("Foto fallida",true);assert_not_null(world._note_dialog106);assert_true(world._map_overlay.notes159().is_empty())
 SaveData._load_valid=true;world._note_dialog106.saved.emit("Sin foto",false);await get_tree().process_frame
 var note:Dictionary=WorldNotes106.nearest(world._map_overlay.notes159(),world.player.position,500.);assert_eq(note.photo,"");assert_eq(note.text,"Sin foto")

func test_requested_photo_without_available_capture_does_not_silently_save_text_only():
 world.show_map();world._map_overlay._ensure_terrain();world._open_map_note106(world.player.position);world._map_notes159.photo_position=world.player.position;world._map_notes159.photo=null
 var disk:=FileAccess.get_file_as_bytes(SaveData.save_path);world._note_dialog106.saved.emit("Sin captura",true)
 assert_not_null(world._note_dialog106);assert_true(world._map_overlay.notes159().is_empty());assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),disk);assert_true(world.last_error.contains("No hay captura"))
func test_shared_photo_selection_shows_live_preview_and_large_gold_icons():
 var dialog:=MapNoteDialog106.new();var image:=Image.create(32,16,false,Image.FORMAT_RGBA8);dialog.setup({},"",image);add_child(dialog)
 assert_false(dialog.photo_box.button_pressed);assert_false(dialog.photo_preview.visible);assert_eq(dialog.photo_box.get_theme_icon("unchecked").get_size(),Vector2(36,36))
 dialog.photo_box.button_pressed=true;assert_true(dialog.photo_preview.visible);assert_not_null(dialog.photo_preview.texture);assert_true(dialog.photo_status.text.contains("Guardar"));dialog.photo_box.button_pressed=false;assert_false(dialog.photo_preview.visible);dialog.free()

func test_remote_edit_blocks_photo_in_ui_and_save_preserves_original_image_and_text_edit():
 world.show_map();world._map_overlay._ensure_terrain();var point:Vector2=world.player.position;world._map_notes159.photo_position=point;world._map_notes159.photo=Image.create(32,16,false,Image.FORMAT_RGBA8)
 world._open_map_note106(point);world._note_dialog106.saved.emit("Original",true);await get_tree().process_frame
 var original:Dictionary=WorldNotes106.nearest(world._map_overlay.notes159(),point,10.).duplicate(true);var bytes:=FileAccess.get_file_as_bytes(original.photo)
 world.player.position=point+Vector2(1000,0);world._map_notes159.photo_position=world.player.position;world._open_map_note106(point)
 assert_true(world._note_dialog106.photo_box.disabled);assert_true(world._note_dialog106.photo_status.text.contains("lejos"));assert_true(world._note_dialog106.photo_preview.visible)
 world._note_dialog106.saved.emit("Wrong photo attempt",true);assert_not_null(world._note_dialog106);assert_eq(WorldNotes106.nearest(world._map_overlay.notes159(),point,10.).text,"Original");assert_eq(FileAccess.get_file_as_bytes(original.photo),bytes)
 world._note_dialog106.saved.emit("Texto editado lejos",false);await get_tree().process_frame
 var edited:Dictionary=WorldNotes106.nearest(world._map_overlay.notes159(),point,10.);assert_eq(edited.text,"Texto editado lejos");assert_eq(edited.photo,original.photo);assert_eq(FileAccess.get_file_as_bytes(edited.photo),bytes)
 world.player.position=point;world._open_map_note106(point);assert_true(world._note_dialog106.photo_box.disabled,"returning without recapturing cannot use an image of the other place");world._map_notes159.close();await get_tree().process_frame
 world._map_notes159.photo_position=point;world._open_map_note106(point);assert_false(world._note_dialog106.photo_box.disabled);world._note_dialog106.saved.emit("Nueva foto local",true);await get_tree().process_frame;assert_ne(WorldNotes106.nearest(world._map_overlay.notes159(),point,10.).photo,original.photo)
func test_new_remote_note_also_cannot_attach_photo_from_another_place():
 world.show_map();world._map_overlay._ensure_terrain();world._map_notes159.photo_position=world.player.position;world._map_notes159.photo=Image.create(32,16,false,Image.FORMAT_RGBA8)
 world._open_map_note106(world.player.position+Vector2(1000,0));assert_true(world._note_dialog106.photo_box.disabled);world._note_dialog106.saved.emit("Lejos",true);assert_true(world._map_overlay.notes159().is_empty())
